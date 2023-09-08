#Requires AutoHotkey v2.0

Static CreateApplyScalePopupOverlay(Overlay) {
    Text := "
(
Hold on! You havent applied your changes to the current key. Do you want to apply the Selected
full scale before you leave?
)"
    Overlay.AddStaticText(Text)
    Overlay.AddHotspotButton("Discard", 518, 379, ObjBindMethod(Dubler2, "FocusButton"), ObjBindMethod(Dubler2, "CloseOverlay"))
    Overlay.AddHotspotButton("Apply", 615, 378, ObjBindMethod(Dubler2, "FocusButton"), ObjBindMethod(Dubler2, "CloseOverlay"))
    Overlay.AddHotspotButton("Close", 643, 273, ObjBindMethod(Dubler2, "FocusButton"), ObjBindMethod(Dubler2, "CloseOverlay"))
    return Overlay
}