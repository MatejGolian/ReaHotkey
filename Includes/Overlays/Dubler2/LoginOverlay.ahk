#Requires AutoHotkey v2.0

Static CreateLoginOverlay(Overlay) {
    Overlay.AddHotspotEdit("Email address", 476, 249, ObjBindMethod(Dubler2, "FocusInput"))
    Overlay.AddHotspotEdit("Password", 466, 289, ObjBindMethod(Dubler2, "FocusInput"))
    Overlay.AddHotspotButton("Login", 533, 370, ObjBindMethod(Dubler2, "FocusButton"), , ObjBindMethod(Dubler2, "CloseOverlay"))
    ;Overlay.AddHotspotButton("Forgot password?", 522, 446, Dubler2.FocusButton)
    return Overlay
}