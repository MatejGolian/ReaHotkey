#Requires AutoHotkey v2.0

Class StandaloneOverlay Extends AccessibilityOverlay {
    
    OverlayNumber := 0
    StandaloneName := ""
    
    __New(OverlayLabel := "", StandaloneName := "") {
        Super.__New(OverlayLabel)
        If StandaloneName = ""
        StandaloneName := Standalone.UnnamedStandaloneName
        This.StandaloneName := StandaloneName
        StandaloneNumber := Standalone.FindName(StandaloneName)
        If StandaloneNumber > 0 {
            OverlayNumber := Standalone.List[StandaloneNumber]["Overlays"].Length + 1
            This.OverlayNumber := OverlayNumber
            Standalone.List[StandaloneNumber]["Overlays"].Push(This)
        }
    }
    
    AddControl(Control) {
        Control := Super.AddControl(Control)
        Return Control
    }
    
    RegisterHotkey(Command) {
        Standalone.SetHotkey(This.StandaloneName, Command)
    }
    
}
