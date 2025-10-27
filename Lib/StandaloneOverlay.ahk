#Requires AutoHotkey v2.0

Class StandaloneOverlay Extends AccessibilityOverlay {
  
  StandaloneName := ""
  
  __New(StandaloneName, OverlayLabel := "") {
    Super.__New(OverlayLabel)
    This.StandaloneName := StandaloneName
  }
  
}
