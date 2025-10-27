#Requires AutoHotkey v2.0

Class StandaloneOverlay Extends AccessibilityOverlay {
  
  StandaloneName := ""
  
  __New(StandaloneName, OverlayLabel := "") {
    Super.__New(OverlayLabel)
    This.StandaloneName := StandaloneName
  }
  
  AddControl(Control) {
    Control := Super.AddControl(Control)
    Standalone.RegisterOverlayHotkeys(This.StandaloneName, This)
    Return Control
  }
  
}
