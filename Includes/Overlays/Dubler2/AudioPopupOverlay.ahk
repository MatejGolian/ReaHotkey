#Requires AutoHotkey v2.0

Static CreateAudioPopupOverlay(Overlay) {
    Text := "
(
Hold Up!
Your audio device has been unplugged.
Please plug-in and Select a calibrated audio device to continue using Dubler.
)"
    Overlay.AddStaticText(Text)
    Overlay.AddHotspotButton("Close", 770, 340, ObjBindMethod(Dubler2, "FocusButton"), ObjBindMethod(Dubler2, "CloseOverlay"))
    return Overlay
}