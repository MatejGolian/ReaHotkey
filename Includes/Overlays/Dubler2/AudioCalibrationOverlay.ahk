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

Static ActivateInputDeviceButton(Button) {

    DevsMenu := Menu()
    
    For Dev In Dubler2.ASIODevices {
        DevMenu := Menu()
        For Chan In Dev["InputChannels"] {
            DevMenu.Add(Chan["Name"], ObjBindMethod(Dubler2, "ClickInputDeviceChannelButton", Button, Dev, A_Index))
            If Dubler2.AudioSettings["audioInputDeviceName"] == Dev["Name"] And (1 << (A_Index - 1)) == ConvertBase(2, 10, Dubler2.AudioSettings["audioDeviceInChans"])
                DevMenu.Check(Chan["Name"])
        }
        DevsMenu.Add(Dev["Name"], DevMenu)
        If Dev["Name"] == Dubler2.AudioSettings["audioInputDeviceName"]
            DevsMenu.Check(Dev["Name"])
    }

    SetTimer ReaHotkey.ManageState, 0
    ReaHotkey.TurnStandaloneTimersOff()
    ReaHotkey.TurnHotkeysOff()
    DevsMenu.Show()
    ReaHotkey.TurnHotkeysOn()
    ReaHotkey.TurnStandaloneTimersOn()
    SetTimer ReaHotkey.ManageState, 100
}

Static ClickInputDeviceChannelButton(Button, Device, Channel, *) {
    Dubler2.AudioSettings["audioInputDeviceName"] := Device["Name"]
    Dubler2.AudioSettings["audioOutputDeviceName"] := Device["Name"]
    Dubler2.AudioSettings["audioDeviceInChans"] := ConvertBase(10, 2, 1 << (Channel - 1))
    Dubler2.AudioSettings["audioDeviceRate"] := Device["Rate"]

    Button.Label := "Input Device: " . Device["Name"] . ", " . Device["InputChannels"][Channel]["Name"]
}

Static CloseAudioCalibrationOverlay(*) {
    Dubler2.AudioSettings := ""
    Dubler2.ASIODevices := Array()

    Dubler2.CloseOverlay()
}

Static CreateAudioCalibrationOverlay(Overlay) {
    Overlay.AddControl(CustomButton("Back", ObjBindMethod(Dubler2, "FocusButton"), ObjBindMethod(Dubler2, "CloseAudioCalibrationOverlay")))
    
    Overlay.AddControl(CustomButton("Input Device: " . (Dubler2.AudioSettings["audioInputDeviceName"] != "" ? Dubler2.AudioSettings["audioInputDeviceName"] : "not selected"), ObjBindMethod(Dubler2, "FocusButton"), ObjBindMethod(Dubler2, "ActivateInputDeviceButton")))

    Return Overlay
}
