#Requires AutoHotkey v2.0

Class StandaloneOverlay Extends AccessibilityOverlay {
    
    OverlayNumber := 0
    StandaloneName := ""
    
    __New(StandaloneName, OverlayLabel := "") {
        Super.__New(OverlayLabel)
        This.StandaloneName := StandaloneName
        StandaloneNumber := Standalone.FindName(StandaloneName)
        If StandaloneNumber > 0 {
            OverlayNumber := This.List[StandaloneNumber]["Overlays"].Length + 1
            This.OverlayNumber := OverlayNumber
            Standalone.List[StandaloneNumber]["Overlays"].Push(This)
        }
    }
    
    AddControl(Control) {
        Control := Super.AddControl(Control)
        Standalone.RegisterOverlayHotkeys(This.StandaloneName, This)
        Return Control
    }
    
}
