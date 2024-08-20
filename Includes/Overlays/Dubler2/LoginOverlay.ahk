#Requires AutoHotkey v2.0

Static CreateLoginOverlay(Overlay) {
    Overlay.AddHotspotEdit("Email address", 484, 280, ObjBindMethod(Dubler2, "FocusInput"))
    Overlay.AddHotspotEdit("Password", 474, 320, ObjBindMethod(Dubler2, "FocusInput"))
    Overlay.AddHotspotButton("Login", 541, 401, ObjBindMethod(Dubler2, "FocusButton"), , ObjBindMethod(Dubler2, "CloseOverlay"))
    ;Overlay.AddHotspotButton("Forgot password?", 522, 446, Dubler2.FocusButton)
    return Overlay
}