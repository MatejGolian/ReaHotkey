#Requires AutoHotkey v2.0

DublerCreateAudioPopupOverlay(Overlay) {
    Text := "
(
Hold Up!
Your audio device has been unplugged.
Please plug-in and Select a calibrated audio device to continue using Dubler.
)"
    Overlay.AddStaticText(Text)
    Overlay.AddHotspotButton("Close", 770, 340, FocusButton, CloseOverlay)
    return Overlay
}