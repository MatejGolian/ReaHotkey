#Requires AutoHotkey v2.0

Static ASIODevices := Array()
Static AudioSettings := ""
Static ASIO_DLL := ""

Static ReadAudioSettings() {

    Read(K) {
        Attr := Node.GetAttributeNode(K)

        Try {
            Return Attr.Text
        } Catch {
            Return ""
        }
    }

    Settings := Map()

    If FileExist(A_AppData . "\Vochlea\Dubler2\audiosettings.xml") {
        Obj := ComObject("MSXML2.DOMDocument.6.0")
        Obj.Async := false
        Data := FileRead(A_AppData . "\Vochlea\Dubler2\audiosettings.xml", "UTF-8")

        Obj.LoadXML(Data)

        Node := Obj.SelectSingleNode("/DEVICESETUP")

        Settings.Set("audioDeviceInChans", Read("audioDeviceInChans"))
        Settings.Set("audioDeviceOutChans", Read("audioDeviceOutChans"))
        Settings.Set("audioDeviceRate", Float(Read("audioDeviceRate")))
        Settings.Set("audioInputDeviceName", Read("audioInputDeviceName"))
        Settings.Set("audioOutputDeviceName", Read("audioOutputDeviceName"))
        Settings.Set("deviceType", Read("deviceType"))
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

Static SaveAudioSettings(*) {

    Write(K, V) {
        If V == ""
            Return
        Attr := Obj.CreateAttribute(K)
        Attr.Value := V
        Node.SetAttributeNode(Attr)
    }

    Obj := ComObject("MSXML2.DOMDocument.6.0")
    Obj.Async := false

    Inst := Obj.CreateProcessingInstruction("xml", "version=`"1.0`" encoding=`"UTF-8`"")
    Obj.AppendChild(Inst)

    Node := Obj.CreateNode(1, "DEVICESETUP", "")

    For K, V In Dubler2.AudioSettings {
        Write(K, V)
    }

    Obj.DocumentElement := Node
    Obj.Save(A_AppData . "\Vochlea\Dubler2\audiosettings.xml")
    Dubler2.AudioSettings := ""
    Dubler2.CloseOverlay()
    Dubler2.Sync()
}

Static GetASIODevices() {
    Dll := A_ScriptDir . "\bassasio" . (A_PtrSize * 8) . ".dll"
    Success := True
    I := 0
    Devices := Array()
    
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

    Return Devices
}

Static DetectAudioCalibrationOverlay(*) {
    Return Dubler2.AudioSettings != ""
}

Static ClickAudioCalibrationButton(*) {
    Dubler2.ASIO_DLL := DllCall("LoadLibrary", "Str", A_ScriptDir . "\bassasio" . (A_PtrSize * 8) . ".dll", "Ptr")
    Dubler2.AudioSettings := Dubler2.ReadAudioSettings()
    Dubler2.ASIODevices := Dubler2.GetASIODevices()
    Dubler2.CloseOverlay()
}

Static SetupAudioCalibrationButton(Overlay) {
    ASettings := Dubler2.ReadAudioSettings()

    Overlay.AddControl(CustomButton("Calibrate audio device: " . (ASettings["audioInputDeviceName"] != "" ? ASettings["audioInputDeviceName"] : "Not calibrated"), ObjBindMethod(Dubler2, "FocusButton"), , ObjBindMethod(Dubler2, "ClickAudioCalibrationButton")))
}

Static CloseAudioCalibrationOverlay(*) {
    Dubler2.AudioSettings := ""
    Dubler2.ASIODevices := Array()
    DllCall("FreeLibrary", "Ptr", Dubler2.ASIO_DLL)
    Dubler2.ASIO_DLL := ""

    Dubler2.CloseOverlay()
}

Static CreateAudioCalibrationOverlay(Overlay) {

    CheckValid() {

        Dev := AudioDeviceCtrl.GetValue()
        
        For Device in Dubler2.ASIODevices
            If Device["Name"] == Dev
                Return True

        Return False
    }

    StartReadingGain(*) {
        If Not CheckValid()
            Return

        Dubler2.ShowReadingGainOverlay := True

        Dubler2.CloseOverlay()
    }

    SelectInputChannel(Chan) {
        Dubler2.AudioSettings["audioDeviceInChans"] := ConvertBase(10, 2, 1 << (Chan - 1))
        Dubler2.SelectComboBoxItem()
    }

    SelectOutputChannels(Group, Amount) {
        Dubler2.SelectComboBoxItem()

        If Group == 1 {
            Dubler2.AudioSettings["audioDeviceOutChans"] := ""
            Return
        }

        DC := 0

        Loop Amount {
            DC |= 1 << ((Group - 1) * 2 + A_Index - 1)
        }

        Dubler2.AudioSettings["audioDeviceOutChans"] := ConvertBase(10, 2, DC)
    }

    SelectDevice(Device, Init := False) {
        AudioInputChannelCtrl.ClearItems()

        For Chan in Device["InputChannels"] {
            AudioInputChannelCtrl.AddItem(Chan["Name"], SelectInputChannel.Bind(A_Index))

            If Init And ConvertBase(10, 2, 1 << (A_Index - 1)) == Dubler2.AudioSettings["audioDeviceInChans"]
                AudioInputChannelCtrl.SetValue(Chan["Name"])
        }

        AudioOutputChannelCtrl.ClearItems()

        Groups := Map()

        Loop Device["OutputChannels"].Length {
            Group := Floor((A_Index - 1) / 2)
            If Not Groups.Has(Group)
                Groups.Set(Group, Map("Channels", Array(), "Selected", Array()))
            Groups[Group]["Channels"].Push(Device["OutputChannels"][A_Index]["Name"])

            If Integer(ConvertBase(2, 10, Dubler2.AudioSettings["audioDeviceOutChans"])) & (1 << (A_Index - 1)) == (1 << (A_Index - 1))
                Groups[Group]["Selected"].Push(Device["OutputChannels"][A_Index]["Name"])
        }

        For _, Group In Groups {
            AudioOutputChannelCtrl.AddItem(StrJoin(Group["Channels"], " / "), SelectOutputChannels.Bind(A_Index, Group["Channels"].Length))

            If Init And Group["Channels"].Length == Group["Selected"].Length
                AudioOutputChannelCtrl.SetValue(StrJoin(Group["Channels"], " / "))
        }

        Dubler2.AudioSettings["audioInputDeviceName"] := Device["Name"]
        Dubler2.AudioSettings["audioOutputDeviceName"] := Device["Name"]

        If Not Init {
            Dubler2.AudioSettings["audioDeviceInChans"] := "1"
            Dubler2.AudioSettings["audioDeviceOutChans"] := ""
            ReadingGainButton.Label := "Read Gain"
            Dubler2.SelectComboBoxItem()
        }
    }

    CreateAudioDeviceControl() {

        Ctrl := PopulatedComboBox("Audio Device", ObjBindMethod(Dubler2, "FocusComboBox"))
        
        For Dev In Dubler2.ASIODevices {
            Ctrl.AddItem(Dev["Name"], SelectDevice.Bind(Dev))

            If Dubler2.AudioSettings["audioInputDeviceName"] == Dev["Name"] {
                Ctrl.SetValue(Dev["Name"])
                SelectDevice(Dev, True)
            }
        }

        Ctrl.SetValue(Dubler2.AudioSettings["audioInputDeviceName"])

        Return Ctrl
    }

    Overlay.AddControl(CustomButton("Back", ObjBindMethod(Dubler2, "FocusButton"), , ObjBindMethod(Dubler2, "CloseAudioCalibrationOverlay")))

    AudioInputChannelCtrl := PopulatedComboBox("Input channel", ObjBindMethod(Dubler2, "FocusComboBox"))
    ReadingGainButton := CustomButton("Read Gain" . (CheckValid ? "" : "not available"), ObjBindMethod(Dubler2, "FocusButton"), , StartReadingGain)
    AudioOutputChannelCtrl := PopulatedComboBox("Output Channel", ObjBindMethod(Dubler2, "FocusComboBox"))
    AudioDeviceCtrl := CreateAudioDeviceControl()

    Overlay.AddControl(AudioDeviceCtrl)
    Overlay.AddControl(AudioInputChannelCtrl)
    Overlay.AddControl(ReadingGainButton)
    Overlay.AddControl(AudioOutputChannelCtrl)

    Overlay.AddControl(CustomButton("Save", ObjBindMethod(Dubler2, "FocusButton"), , ObjBindMethod(Dubler2, "SaveAudioSettings")))

    Return Overlay
}
