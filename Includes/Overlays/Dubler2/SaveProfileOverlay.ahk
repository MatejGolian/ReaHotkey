#Requires AutoHotkey v2.0

Static CreateSaveProfilePopupOverlay(Overlay) {
    Text := "Hold on! There are unsaved changes. Do you want to save your profile?"
    Overlay.AddStaticText(Text)
    Overlay.AddHotspotButton("Discard", 526, 355, ObjBindMethod(Dubler2, "FocusButton"), , ObjBindMethod(Dubler2, "CloseOverlay"))
    Overlay.AddHotspotButton("Save", 625, 349, ObjBindMethod(Dubler2, "FocusButton"), , ObjBindMethod(Dubler2, "CloseOverlay"))
    Overlay.AddHotspotButton("Close", 653, 233, ObjBindMethod(Dubler2, "FocusButton"), , ObjBindMethod(Dubler2, "CloseOverlay"))
    return Overlay
}