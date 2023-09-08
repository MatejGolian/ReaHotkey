#Requires AutoHotkey v2.0

ReadDublerAudioSettings() {
    Obj := ComObject("MSXML2.DOMDocument.6.0")
    Obj.Async := false
    Data := FileRead(A_AppData . "\Vochlea\Dubler2\audiosettings.xml", "UTF-8")

    Obj.LoadXML(Data)

    Node := Obj.SelectSingleNode("/DEVICESETUP")

    Return Map(
        "audioDeviceInChans", Integer(Node.getAttributeNode("audioDeviceInChans").Text),
        "audioDeviceRate", Float(Node.getAttributeNode("audioDeviceRate").Text),
        "audioInputDeviceName", Node.getAttributeNode("audioInputDeviceName").Text,
        "audioOutputDeviceName", Node.getAttributeNode("audioOutputDeviceName").Text,
        "deviceType", Node.getAttributeNode("deviceType").Text,
    )
}

DublerClickAudioCalibrationButton(*) {
    CloseOverlay(ReaHotkey.FoundStandalone.Overlay.Label)

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

SetupAudioCalibrationButton(Overlay) {
    ASettings := ReadDublerAudioSettings()

    Overlay.AddControl(CustomButton("Calibrate audio device: " . ASettings["audioInputDeviceName"], FocusButton, DublerClickAudioCalibrationButton))
}

DublerCreateAudioCalibrationOverlay(Overlay) {
    Overlay.AddHotspotButton("Back", 865, 120, FocusButton, CloseOverlay)
    
    Return Overlay
}
