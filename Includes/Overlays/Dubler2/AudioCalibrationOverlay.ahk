#Requires AutoHotkey v2.0

Static ASIODevices := Array()
Static AudioSettings := ""

Static ReadAudioSettings() {
    Settings := Map()

    If FileExist(A_AppData . "\Vochlea\Dubler2\audiosettings.xml") {
        Obj := ComObject("MSXML2.DOMDocument.6.0")
        Obj.Async := false
        Data := FileRead(A_AppData . "\Vochlea\Dubler2\audiosettings.xml", "UTF-8")

        Obj.LoadXML(Data)

        Node := Obj.SelectSingleNode("/DEVICESETUP")

        Settings.Set("audioDeviceInChans", Node.getAttributeNode("audioDeviceInChans").Text)
        Settings.Set("audioDeviceOutChans", Node.getAttributeNode("audioDeviceOutChans").Text)
        Settings.Set("audioDeviceRate", Float(Node.getAttributeNode("audioDeviceRate").Text))
        Settings.Set("audioInputDeviceName", Node.getAttributeNode("audioInputDeviceName").Text)
        Settings.Set("audioOutputDeviceName", Node.getAttributeNode("audioOutputDeviceName").Text)
        Settings.Set("deviceType", Node.getAttributeNode("deviceType").Text)
    } Else {
        Settings.Set("audioDeviceInChans", "")
        Settings.Set("audioDeviceOutChans", "")
        Settings.Set("audioDeviceRate", 0.0)
        Settings.Set("audioInputDeviceName", "")
        Settings.Set("audioOutputDeviceName", "")
        Settings.Set("deviceType", "")
    }
    
    Return Settings
}

Static GetASIODevices() {
    Dll := A_ScriptDir . "\bassasio" . (A_PtrSize * 8) . ".dll"
    Success := True
    I := 0
    Devices := Array()
    
    hModule := DllCall("LoadLibrary", "Str", Dll, "Ptr")
    DllCall(Dll . "\BASS_ASIO_SetUnicode", "Char", True, "Char")

    While Success {
        Success := DllCall(Dll . "\BASS_ASIO_Init", "Int", I, "Int", 0, "Char")
        I += 1
        Err := DllCall(Dll . "\BASS_ASIO_ErrorGetCode", "Int")
        If Not Success {
            If Err != 3
                Break
            Success := True
            Continue
        }
        Device := Map(
            "Name", "",
            "InputChannels", Array(),
            "OutputChannels", Array(),
            "Rate", 0.0,
        )
        Info := Buffer(64, 0)
        DllCall(Dll . "\BASS_ASIO_GetInfo", "Ptr", Info, "Int")
        Device["Name"] := StrGet(Info, "UTF-8")
        Device["Rate"] := DllCall(Dll . "\BASS_ASIO_GetRate", "Double")
        Inputs := NumGet(Info, 36, "UInt")
        Outputs := NumGet(Info, 40, "UInt")
        Loop Inputs {
            ChannelInfo := Buffer(40, 0)
            DllCall(Dll . "\BASS_ASIO_ChannelGetInfo", "Char", True, "Int", A_Index - 1, "Ptr", ChannelInfo, "Char")
            Device["InputChannels"].Push(Map("Name", StrGet(ChannelInfo.Ptr + 8, "UTF-8"), "Group", NumGet(ChannelInfo, "UInt")))
        }
        Loop Outputs {
            ChannelInfo := Buffer(40, 0)
            DllCall(Dll . "\BASS_ASIO_ChannelGetInfo", "Char", False, "Int", A_Index - 1, "Ptr", ChannelInfo, "Char")
            Device["OutputChannels"].Push(Map("Name", StrGet(ChannelInfo.Ptr + 8, "UTF-8"), "Group", NumGet(ChannelInfo, "UInt")))
        }
        DllCall(Dll . "\BASS_ASIO_Free", "Int")
        Devices.Push(Device)
    }

    DllCall("FreeLibrary", "Ptr", hModule)
    Return Devices
}

Static DetectAudioCalibrationOverlay(*) {
    Return Dubler2.AudioSettings != ""
}

Static ClickAudioCalibrationButton(*) {
    Dubler2.AudioSettings := Dubler2.ReadAudioSettings()
    Dubler2.ASIODevices := Dubler2.GetASIODevices()
    Dubler2.CloseOverlay()
}

Static SetupAudioCalibrationButton(Overlay) {
    ASettings := Dubler2.ReadAudioSettings()

    Overlay.AddControl(CustomButton("Calibrate audio device: " . (ASettings["audioInputDeviceName"] != "" ? ASettings["audioInputDeviceName"] : "Not calibrated"), ObjBindMethod(Dubler2, "FocusButton"), ObjBindMethod(Dubler2, "ClickAudioCalibrationButton")))
}

Static CloseAudioCalibrationOverlay(*) {
    Dubler2.AudioSettings := ""
    Dubler2.ASIODevices := Array()

    Dubler2.CloseOverlay()
}

Static CreateAudioCalibrationOverlay(Overlay) {

    SelectDevice(Device) {
        AudioInputChannelCtrl.ClearItems()

        For Chan in Device["InputChannels"] {
            AudioInputChannelCtrl.AddItem(Chan["Name"])
        }

        AudioOutputChannelCtrl.ClearItems()

        Groups := Map()

        Loop Device["OutputChannels"].Length {
            Group := Floor((A_Index - 1) / 2)
            If Not Groups.Has(Group)
                Groups.Set(Group, Array())
            Groups[Group].Push(Device["OutputChannels"][A_Index]["Name"])
        }

        For _, Group In Groups {
            AudioOutputChannelCtrl.AddItem(StrJoin(Group, " / "))
        }

        Dubler2.AudioSettings["audioInputDeviceName"] := Device["Name"]
        Dubler2.AudioSettings["audioOutputDeviceName"] := Device["Name"]
        Dubler2.AudioSettings["audioDeviceInChans"] := "1"
        Dubler2.AudioSettings["audioDeviceOutChans"] := ""
    }

    CreateAudioDeviceControl() {

        Ctrl := PopulatedComboBox("Audio Device")
        
        For Dev In Dubler2.ASIODevices {
            Ctrl.AddItem(Dev["Name"], SelectDevice.Bind(Dev))

            If Dubler2.AudioSettings["audioInputDeviceName"] == Dev["Name"] {
                Ctrl.SetValue(Dev["Name"])
                SelectDevice(Dev)
            }
        }

        Ctrl.SetValue(Dubler2.AudioSettings["audioInputDeviceName"])

        Return Ctrl
    }

    Overlay.AddControl(CustomButton("Back", ObjBindMethod(Dubler2, "FocusButton"), ObjBindMethod(Dubler2, "CloseAudioCalibrationOverlay")))

    AudioInputChannelCtrl := PopulatedComboBox("Input channel")
    AudioOutputChannelCtrl := PopulatedComboBox("Output Channel")
    AudioDeviceCtrl := CreateAudioDeviceControl()

    Overlay.AddControl(AudioDeviceCtrl)
    Overlay.AddControl(AudioInputChannelCtrl)
    Overlay.AddControl(AudioOutputChannelCtrl)

    Return Overlay
}
