#Requires AutoHotkey v2.0

Class RSDrums {
    
    Static __New() {
        PluginClass := SubStr(This.Prototype.__Class, 1, InStr(This.Prototype.__Class, ".") - 1)
        Kontakt7XOffset := 0
        Kontakt7YOffset := 0
        Kontakt8XOffset := 0
        Kontakt8YOffset := 0
        KompleteKontrolXOffset := 0
        KompleteKontrolYOffset := 0
        
        FairviewOverlay := AccessibilityOverlay("Fairview")
        FairviewOverlay.Metadata := Map("Vendor", "RS Drums", "Product", "Fairview", "Image", Map("File", "Images/KontaktKompleteKontrol/Fairview/Product.png"))
        FairviewOverlay.AddAccessibilityOverlay()
        FairviewOverlay.AddStaticText("Fairview")
        FairviewOverlay.AddHotspotButton("Snare selector", %PluginClass%XOffset + 476, %PluginClass%YOffset + 454, CompensatePluginCoordinates,, CompensatePluginCoordinates)
        %PluginClass%.PluginOverlays.Push(FairviewOverlay)
    }
    
}
