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
            For StandaloneInstance In Standalone.Instances
            If StandaloneName = StandaloneInstance.Name
            StandaloneInstance.Overlays.Push(This.Clone())
        }
    }
    
    AddControl(Control) {
        Control := Super.AddControl(Control)
        Standalone.RegisterOverlayHotkeys(This.StandaloneName, This)
        For StandaloneInstance In Standalone.Instances
        If This.StandaloneName = StandaloneInstance.Name
        For StandaloneOverlay In StandaloneInstance.Overlays
        If StandaloneOverlay.HasOwnProp("OverlayNumber") And StandaloneOverlay.OverlayNumber = This.OverlayNumber
        StandaloneOverlay.AddControl(Control)
        Return Control
    }
    
}
