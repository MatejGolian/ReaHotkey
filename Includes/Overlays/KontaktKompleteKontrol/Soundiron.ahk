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
        
        MimiPageLightAndShadowOverlay := PluginOverlay("Mimi Page Light & Shadow")
        MimiPageLightAndShadowOverlay.Metadata := Map("Vendor", "Soundiron", "Product", "Mimi Page Light & Shadow", "Image", Map("File", "Images/KontaktKompleteKontrol/MimiPageLightAndShadow/Product.png"))
        MimiPageLightAndShadowOverlay.AddAccessibilityOverlay()
        MimiPageLightAndShadowOverlay.AddStaticText("Mimi Page Light & Shadow")
        MimiPageLightAndShadowOverlay.AddGraphicalToggleButton("Reverb", This.%PluginClass%XOffset + 324, This.%PluginClass%YOffset + 462, This.%PluginClass%XOffset + 344, This.%PluginClass%YOffset + 502, "Images/KontaktKompleteKontrol/MimiPageLightAndShadow/ReverbOn.png", "Images/KontaktKompleteKontrol/MimiPageLightAndShadow/ReverbOff.png", ObjBindMethod(This, "ClickFXRack"),, ObjBindMethod(This, "ClickFXRack"))
        %PluginClass%.PluginOverlays.Push(MimiPageLightAndShadowOverlay)
        
        VoicesOfGaiaOverlay := PluginOverlay("Voices Of Gaia")
        VoicesOfGaiaOverlay.Metadata := Map("Vendor", "Soundiron", "Product", "Voices Of Gaia", "Image", Map("File", "Images/KontaktKompleteKontrol/VoicesOfGaia/Product.png"))
        VoicesOfGaiaOverlay.AddAccessibilityOverlay()
        VoicesOfGaiaOverlay.AddStaticText("Voices Of Gaia")
        VoicesOfGaiaOverlay.AddGraphicalToggleButton("Reverb", This.%PluginClass%XOffset + 10, This.%PluginClass%YOffset + 150, This.%PluginClass%XOffset + 30, This.%PluginClass%YOffset + 180, "Images/KontaktKompleteKontrol/VoicesOfGaia/ReverbOn.png", "Images/KontaktKompleteKontrol/VoicesOfGaia/ReverbOff.png", ObjBindMethod(This, "ClickFXRack"),, ObjBindMethod(This, "ClickFXRack"))
        %PluginClass%.PluginOverlays.Push(VoicesOfGaiaOverlay)
        
        VoicesOfWindCollectionOverlay := PluginOverlay("Voices of Wind Collection")
        VoicesOfWindCollectionOverlay.Metadata := Map("Vendor", "Soundiron", "Product", "Voices of Wind Collection", "Image", Map("File", "Images/KontaktKompleteKontrol/VoicesOfWindCollection/Product.png"))
        VoicesOfWindCollectionOverlay.AddAccessibilityOverlay()
        VoicesOfWindCollectionOverlay.AddStaticText("Voices of Wind Collection")
        VoicesOfWindCollectionOverlay.AddGraphicalToggleButton("Reverb", This.%PluginClass%XOffset + 324, This.%PluginClass%YOffset + 462, This.%PluginClass%XOffset + 344, This.%PluginClass%YOffset + 502, "Images/KontaktKompleteKontrol/VoicesOfWindCollection/ReverbOn.png", "Images/KontaktKompleteKontrol/VoicesOfWindCollection/ReverbOff.png", ObjBindMethod(This, "ClickFXRack"),, ObjBindMethod(This, "ClickFXRack"))
        %PluginClass%.PluginOverlays.Push(VoicesOfWindCollectionOverlay)
    }
    
    Static ClickFXRack(ButtonObj) {
        PluginClass := SubStr(This.Prototype.__Class, 1, InStr(This.Prototype.__Class, ".") - 1)
        OverlayObj := ButtonObj.GetMasterControl()
        Switch OverlayObj.Metadata["Product"] {
            Case "Mimi Page Light & Shadow":
            If PixelGetColor(This.%PluginClass%XOffset + CompensatePluginXCoordinate(162), This.%PluginClass%YOffset + CompensatePluginYCoordinate(652)) = "0x575757" {
                Click This.%PluginClass%XOffset + CompensatePluginXCoordinate(162), This.%PluginClass%YOffset + CompensatePluginYCoordinate(652)
                Sleep 250
            }
            Case "Voices Of Gaia":
            If PixelGetColor(This.%PluginClass%XOffset + CompensatePluginXCoordinate(155), This.%PluginClass%YOffset + CompensatePluginYCoordinate(582)) = "0x575757" {
                Click This.%PluginClass%XOffset + CompensatePluginXCoordinate(155), This.%PluginClass%YOffset + CompensatePluginYCoordinate(582)
                Sleep 250
            }
            Case "Voices of Wind Collection":
            If PixelGetColor(This.%PluginClass%XOffset + CompensatePluginXCoordinate(164), This.%PluginClass%YOffset + CompensatePluginYCoordinate(663)) = "0x565656" {
                Click This.%PluginClass%XOffset + CompensatePluginXCoordinate(164), This.%PluginClass%YOffset + CompensatePluginYCoordinate(663)
                Sleep 250
            }
        }
    }
    
}
