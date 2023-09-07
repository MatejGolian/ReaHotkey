#Requires AutoHotkey v2.0

DublerCreateLoginOverlay(Overlay) {
    Overlay.AddHotspotEdit("Email address", 484, 280, FocusInput)
    Overlay.AddHotspotEdit("Password", 474, 320, FocusInput)
    Overlay.AddHotspotButton("Login", 541, 401, FocusButton, CloseOverlay)
    Overlay.AddHotspotButton("Forgot password?", 522, 446, FocusButton)
    return Overlay
}