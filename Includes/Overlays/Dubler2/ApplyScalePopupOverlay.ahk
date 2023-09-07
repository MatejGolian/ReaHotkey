#Requires AutoHotkey v2.0

DublerCreateApplyScalePopupOverlay(Overlay) {
    Text := "
(
Hold on! You havent applied your changes to the current key. Do you want to apply the Selected
full scale before you leave?
)"
    Overlay.AddStaticText(Text)
    Overlay.AddHotspotButton("Discard", 518, 379, FocusButton, CloseOverlay)
    Overlay.AddHotspotButton("Apply", 615, 378, FocusButton, CloseOverlay)
    Overlay.AddHotspotButton("Close", 643, 273, FocusButton, CloseOverlay)
    return Overlay
}