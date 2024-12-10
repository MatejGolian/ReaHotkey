#Requires AutoHotkey v2.0

Class Soundiron {
    
    Static __New() {
        PluginClass := SubStr(This.Prototype.__Class, 1, InStr(This.Prototype.__Class, ".") - 1)
        Kontakt7XOffset := 0
        Kontakt7YOffset := 0
        Kontakt8XOffset := 0
        Kontakt8YOffset := 29
        KompleteKontrolXOffset := 190
        KompleteKontrolYOffset := 111
        
        MimiPageLightAndShadowOverlay := AccessibilityOverlay("Mimi Page Light & Shadow")
        MimiPageLightAndShadowOverlay.Metadata := Map("Vendor", "Soundiron", "Product", "Mimi Page Light & Shadow", "Image", Map("File", "Images/KontaktKompleteKontrol/MimiPageLightAndShadow/Product.png"))
        MimiPageLightAndShadowOverlay.AddAccessibilityOverlay()
        MimiPageLightAndShadowOverlay.AddStaticText("Mimi Page Light & Shadow")
        MimiPageLightAndShadowOverlay.AddHotspotButton("Reverb", %PluginClass%XOffset + 152, %PluginClass%YOffset + 481, CompensatePluginCoordinates,, CompensatePluginCoordinates)
        MimiPageLightAndShadowOverlay.AddGraphicalToggleButton("Reverb", %PluginClass%XOffset + 188, %PluginClass%YOffset + 473, %PluginClass%XOffset + 220, %PluginClass%YOffset + 489, "Images/KontaktKompleteKontrol/MimiPageLightAndShadow/ReverbOn.png", "Images/KontaktKompleteKontrol/MimiPageLightAndShadow/ReverbOff.png", CompensatePluginCoordinates,, CompensatePluginCoordinates)
        %PluginClass%.PluginOverlays.Push(MimiPageLightAndShadowOverlay)
        
        VoicesOfGaiaOverlay := AccessibilityOverlay("Voices Of Gaia")
        VoicesOfGaiaOverlay.Metadata := Map("Vendor", "Soundiron", "Product", "Voices Of Gaia", "Image", Map("File", "Images/KontaktKompleteKontrol/VoicesOfGaia/Product.png"))
        VoicesOfGaiaOverlay.AddAccessibilityOverlay()
        VoicesOfGaiaOverlay.AddStaticText("Voices Of Gaia")
        VoicesOfGaiaOverlay.AddHotspotButton("Reverb", %PluginClass%XOffset + 152, %PluginClass%YOffset + 481, CompensatePluginCoordinates,, CompensatePluginCoordinates)
        VoicesOfGaiaOverlay.AddGraphicalToggleButton("Reverb", %PluginClass%XOffset + 188, %PluginClass%YOffset + 473, %PluginClass%XOffset + 220, %PluginClass%YOffset + 489, "Images/KontaktKompleteKontrol/VoicesOfGaia/ReverbOn.png", "Images/KontaktKompleteKontrol/VoicesOfGaia/ReverbOff.png", CompensatePluginCoordinates,, CompensatePluginCoordinates)
        %PluginClass%.PluginOverlays.Push(VoicesOfGaiaOverlay)
        
        VoicesOfWindCollectionOverlay := AccessibilityOverlay("Voices of Wind Collection")
        VoicesOfWindCollectionOverlay.Metadata := Map("Vendor", "Soundiron", "Product", "Voices of Wind Collection", "Image", Map("File", "Images/KontaktKompleteKontrol/VoicesOfWindCollection/Product.png"))
        VoicesOfWindCollectionOverlay.AddAccessibilityOverlay()
        VoicesOfWindCollectionOverlay.AddStaticText("Voices of Wind Collection")
        VoicesOfWindCollectionOverlay.AddHotspotButton("Reverb", %PluginClass%XOffset + 152, %PluginClass%YOffset + 481, CompensatePluginCoordinates,, CompensatePluginCoordinates)
        VoicesOfWindCollectionOverlay.AddGraphicalToggleButton("Reverb", %PluginClass%XOffset + 188, %PluginClass%YOffset + 473, %PluginClass%XOffset + 220, %PluginClass%YOffset + 489, "Images/KontaktKompleteKontrol/VoicesOfWindCollection/ReverbOn.png", "Images/KontaktKompleteKontrol/VoicesOfWindCollection/ReverbOff.png", CompensatePluginCoordinates,, CompensatePluginCoordinates)
        %PluginClass%.PluginOverlays.Push(VoicesOfWindCollectionOverlay)
    }
    
}
