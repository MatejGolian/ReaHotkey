#Requires AutoHotkey v2.0

DublerCreateSaveProfilePopupOverlay(Overlay) {
    Text := "Hold on! There are unsaved changes. Do you want to save your profile?"
    Overlay.AddStaticText(Text)
    Overlay.AddHotspotButton("Discard", 534, 386, FocusButton, CloseOverlay)
    Overlay.AddHotspotButton("Save", 633, 380, FocusButton, CloseOverlay)
    Overlay.AddHotspotButton("Close", 661, 264, FocusButton, CloseOverlay)
    return Overlay
}