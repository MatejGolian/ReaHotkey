#Requires AutoHotkey v2.0

Class PluginOverlay Extends AccessibilityOverlay {
  
  PluginName := ""
  
  __New(PluginName, OverlayLabel := "") {
    Super.__New(OverlayLabel)
    This.PluginName := PluginName
  }
  
  AddControl(Control) {
    Control := Super.AddControl(Control)
    Plugin.RegisterOverlayHotkeys(This.PluginName, This)
    Return Control
  }
  
}
