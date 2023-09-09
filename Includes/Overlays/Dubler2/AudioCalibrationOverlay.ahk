#Requires AutoHotkey v2.0

Static ReadDublerAudioSettings() {
    Settings := Map()

    If FileExist(A_AppData . "\Vochlea\Dubler2\audiosettings.xml") {
        Obj := ComObject("MSXML2.DOMDocument.6.0")
        Obj.Async := false
        Data := FileRead(A_AppData . "\Vochlea\Dubler2\audiosettings.xml", "UTF-8")

        Obj.LoadXML(Data)

        Node := Obj.SelectSingleNode("/DEVICESETUP")

        Settings.Set("audioDeviceInChans", Integer(Node.getAttributeNode("audioDeviceInChans").Text))
        Settings.Set("audioDeviceRate", Float(Node.getAttributeNode("audioDeviceRate").Text))
        Settings.Set("audioInputDeviceName", Node.getAttributeNode("audioInputDeviceName").Text)
        Settings.Set("audioOutputDeviceName", Node.getAttributeNode("audioOutputDeviceName").Text)
        Settings.Set("deviceType", Node.getAttributeNode("deviceType").Text)
    } Else {
        Settings.Set("audioDeviceInChans", 0)
        Settings.Set("audioDeviceRate", 0.0)
        Settings.Set("audioInputDeviceName", "")
        Settings.Set("audioOutputDeviceName", "")
        Settings.Set("deviceType", "")
    }
    
    Return Settings
}

Static ClickAudioCalibrationButton(*) {
    Dubler2.CloseOverlay(ReaHotkey.FoundStandalone.Overlay.Label)

    ; audio device settings button
    Click(863, 55)
    Sleep 300
    
    ; setup audio button
    Click(671, 568)
    Sleep 300
    
    ; my own audio device button
    Click(268, 369)
    Sleep 300
    
    ; take me to the calibration button
    Click(756, 444)
    Sleep 300
    
    ; continue button
    Click(830, 538)
    Sleep 300
    
    Click(801, 363)
    
    ReaHotkey.FoundStandalone.Overlay.Label := ""
}

Static SetupAudioCalibrationButton(Overlay) {
    ASettings := Dubler2.ReadDublerAudioSettings()

    Overlay.AddControl(CustomButton("Calibrate audio device: " . (ASettings["audioInputDeviceName"] != "" ? ASettings["audioInputDeviceName"] : "Not calibrated"), ObjBindMethod(Dubler2, "FocusButton"), ObjBindMethod(Dubler2, "ClickAudioCalibrationButton")))
}

Static CreateAudioCalibrationOverlay(Overlay) {
    Overlay.AddHotspotButton("Back", 865, 120, ObjBindMethod(Dubler2, "FocusButton"), ObjBindMethod(Dubler2, "CloseOverlay"))
    
    Return Overlay
}
