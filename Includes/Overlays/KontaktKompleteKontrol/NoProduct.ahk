#Requires AutoHotkey v2.0

Class NoProduct {
    
    Static __New() {
        PluginClass := SubStr(This.Prototype.__Class, 1, InStr(This.Prototype.__Class, ".") - 1)
        
        NoProductOverlay := AccessibilityOverlay("None")
        NoProductOverlay.Metadata := Map("Product", "None")
        NoProductOverlay.AddAccessibilityOverlay()
        NoProductOverlay.AddAccessibilityOverlay()
        %PluginClass%.PluginOverlays.Push(NoProductOverlay)
    }
    
}
