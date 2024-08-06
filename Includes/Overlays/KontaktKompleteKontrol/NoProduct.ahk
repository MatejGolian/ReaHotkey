Class NoProduct {
    
    Static InitClass(ClassName) {
        NoProductOverlay := AccessibilityOverlay("None")
        NoProductOverlay.Metadata := Map("Product", "None")
        NoProductOverlay.AddAccessibilityOverlay()
        %ClassName%.PluginOverlays.Push(NoProductOverlay)
    }
    
}
