#Requires AutoHotkey v2.0

Static CreateSaveProfilePopupOverlay(Overlay) {
    Text := "Hold on! There are unsaved changes. Do you want to save your profile?"
    Overlay.AddStaticText(Text)
    Overlay.AddHotspotButton("Discard", 534, 386, ObjBindMethod(Dubler2, "FocusButton"), ObjBindMethod(Dubler2, "CloseOverlay"))
    Overlay.AddHotspotButton("Save", 633, 380, ObjBindMethod(Dubler2, "FocusButton"), ObjBindMethod(Dubler2, "CloseOverlay"))
    Overlay.AddHotspotButton("Close", 661, 264, ObjBindMethod(Dubler2, "FocusButton"), ObjBindMethod(Dubler2, "CloseOverlay"))
    return Overlay
}