#Requires AutoHotkey v2.0

Class NoLibraryProduct {
    
    Static __New() {
        PluginClass := SubStr(This.Prototype.__Class, 1, InStr(This.Prototype.__Class, ".") - 1)
        
        NoLibraryProductOverlay := AccessibilityOverlay("None")
        NoLibraryProductOverlay.Metadata := Map("Product", "None")
        NoLibraryProductOverlay.AddAccessibilityOverlay()
        NoLibraryProductOverlay.AddAccessibilityOverlay()
        %PluginClass%.PluginOverlays.Push(NoLibraryProductOverlay)
    }
    
}
