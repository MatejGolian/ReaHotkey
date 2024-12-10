#Requires AutoHotkey v2.0

Class Soundiron {
    
    Static Kontakt7XOffset := 0
    Static Kontakt7YOffset := 0
    Static Kontakt8XOffset := 0
    Static Kontakt8YOffset := 29
    Static KompleteKontrolXOffset := 190
    Static KompleteKontrolYOffset := 111
    
    Static __New() {
        PluginClass := SubStr(This.Prototype.__Class, 1, InStr(This.Prototype.__Class, ".") - 1)
        
        MimiPageLightAndShadowOverlay := AccessibilityOverlay("Mimi Page Light & Shadow")
        MimiPageLightAndShadowOverlay.Metadata := Map("Vendor", "Soundiron", "Product", "Mimi Page Light & Shadow", "Image", Map("File", "Images/KontaktKompleteKontrol/MimiPageLightAndShadow/Product.png"))
        MimiPageLightAndShadowOverlay.AddAccessibilityOverlay()
        MimiPageLightAndShadowOverlay.AddStaticText("Mimi Page Light & Shadow")
        MimiPageLightAndShadowOverlay.AddHotspotButton("Reverb", This.%PluginClass%XOffset + 152, This.%PluginClass%YOffset + 481, [ObjBindMethod(This, "ClickFXRack"), CompensatePluginCoordinates],, [ObjBindMethod(This, "ClickFXRack"), CompensatePluginCoordinates])
        MimiPageLightAndShadowOverlay.AddGraphicalToggleButton("Reverb", This.%PluginClass%XOffset + 188, This.%PluginClass%YOffset + 473, This.%PluginClass%XOffset + 220, This.%PluginClass%YOffset + 489, "Images/KontaktKompleteKontrol/MimiPageLightAndShadow/ReverbOn.png", "Images/KontaktKompleteKontrol/MimiPageLightAndShadow/ReverbOff.png", [ObjBindMethod(This, "ClickFXRack"), CompensatePluginCoordinates],, [ObjBindMethod(This, "ClickFXRack"), CompensatePluginCoordinates])
        %PluginClass%.PluginOverlays.Push(MimiPageLightAndShadowOverlay)
        
        VoicesOfGaiaOverlay := AccessibilityOverlay("Voices Of Gaia")
        VoicesOfGaiaOverlay.Metadata := Map("Vendor", "Soundiron", "Product", "Voices Of Gaia", "Image", Map("File", "Images/KontaktKompleteKontrol/VoicesOfGaia/Product.png"))
        VoicesOfGaiaOverlay.AddAccessibilityOverlay()
        VoicesOfGaiaOverlay.AddStaticText("Voices Of Gaia")
        VoicesOfGaiaOverlay.AddHotspotButton("Reverb", This.%PluginClass%XOffset + 152, This.%PluginClass%YOffset + 481, [ObjBindMethod(This, "ClickFXRack"), CompensatePluginCoordinates],, [ObjBindMethod(This, "ClickFXRack"), CompensatePluginCoordinates])
        VoicesOfGaiaOverlay.AddGraphicalToggleButton("Reverb", This.%PluginClass%XOffset + 188, This.%PluginClass%YOffset + 473, This.%PluginClass%XOffset + 220, This.%PluginClass%YOffset + 489, "Images/KontaktKompleteKontrol/VoicesOfGaia/ReverbOn.png", "Images/KontaktKompleteKontrol/VoicesOfGaia/ReverbOff.png", [ObjBindMethod(This, "ClickFXRack"), CompensatePluginCoordinates],, [ObjBindMethod(This, "ClickFXRack"), CompensatePluginCoordinates])
        %PluginClass%.PluginOverlays.Push(VoicesOfGaiaOverlay)
        
        VoicesOfWindCollectionOverlay := AccessibilityOverlay("Voices of Wind Collection")
        VoicesOfWindCollectionOverlay.Metadata := Map("Vendor", "Soundiron", "Product", "Voices of Wind Collection", "Image", Map("File", "Images/KontaktKompleteKontrol/VoicesOfWindCollection/Product.png"))
        VoicesOfWindCollectionOverlay.AddAccessibilityOverlay()
        VoicesOfWindCollectionOverlay.AddStaticText("Voices of Wind Collection")
        VoicesOfWindCollectionOverlay.AddHotspotButton("Reverb", This.%PluginClass%XOffset + 152, This.%PluginClass%YOffset + 481, [ObjBindMethod(This, "ClickFXRack"), CompensatePluginCoordinates],, [ObjBindMethod(This, "ClickFXRack"), CompensatePluginCoordinates])
        VoicesOfWindCollectionOverlay.AddGraphicalToggleButton("Reverb", This.%PluginClass%XOffset + 188, This.%PluginClass%YOffset + 473, This.%PluginClass%XOffset + 220, This.%PluginClass%YOffset + 489, "Images/KontaktKompleteKontrol/VoicesOfWindCollection/ReverbOn.png", "Images/KontaktKompleteKontrol/VoicesOfWindCollection/ReverbOff.png", [ObjBindMethod(This, "ClickFXRack"), CompensatePluginCoordinates],, [ObjBindMethod(This, "ClickFXRack"), CompensatePluginCoordinates])
        %PluginClass%.PluginOverlays.Push(VoicesOfWindCollectionOverlay)
    }
    
    Static ClickFXRack(ButtonObj) {
        PluginClass := SubStr(This.Prototype.__Class, 1, InStr(This.Prototype.__Class, ".") - 1)
        OverlayObj := ButtonObj.GetMasterControl()
        Image := OverlayObj.Metadata["Image"]
        If Image Is Map
        Image := Image["File"]
        If ImageSearch(&FoundXCoordinate, &FoundYCoordinate, 0, 0, A_ScreenWidth, A_ScreenHeight, Image) {
            Switch OverlayObj.Metadata["Product"] {
                Case "Mimi Page Light & Shadow":
                Case "Voices Of Gaia":
                Case "Voices of Wind Collection":
            }
        }
    }
    
}
