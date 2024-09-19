#Requires AutoHotkey v2.0

Class CinematicStudioSeries {
    
    Static __New() {
        PluginClass := SubStr(This.Prototype.__Class, 1, InStr(This.Prototype.__Class, ".") - 1)
        Kontakt7XOffset := 0
        Kontakt7YOffset := 0
        KompleteKontrolXOffset := 190
        KompleteKontrolYOffset := 111
        
        CinematicStudioStringsOverlay := AccessibilityOverlay("Cinematic Studio Strings")
        CinematicStudioStringsOverlay.Metadata := Map("Vendor", "Cinematic Studio Series", "Product", "Cinematic Studio Strings", "Image", Map("File", "Images/KontaktKompleteKontrol/CinematicStudioStrings/Product.png"))
        CinematicStudioStringsOverlay.AddAccessibilityOverlay()
        CinematicStudioStringsOverlay.AddStaticText("Cinematic Studio Strings")
        CinematicStudioStringsOverlay.AddHotspotButton("Spot 1", %PluginClass%XOffset + 40, %PluginClass%YOffset + 532, CompensatePluginCoordinates,, CompensatePluginCoordinates)
        CinematicStudioStringsOverlay.AddHotspotButton("Spot 2", %PluginClass%XOffset + 80, %PluginClass%YOffset + 532, CompensatePluginCoordinates,, CompensatePluginCoordinates)
        CinematicStudioStringsOverlay.AddHotspotButton("Main", %PluginClass%XOffset + 120, %PluginClass%YOffset + 532, CompensatePluginCoordinates,, CompensatePluginCoordinates)
        CinematicStudioStringsOverlay.AddHotspotButton("Room", %PluginClass%XOffset + 160, %PluginClass%YOffset + 532, CompensatePluginCoordinates,, CompensatePluginCoordinates)
        CinematicStudioStringsOverlay.AddGraphicalToggleButton("Mix", %PluginClass%XOffset + 196, %PluginClass%YOffset + 524, %PluginClass%XOffset + 228, %PluginClass%YOffset + 540, "Images/KontaktKompleteKontrol/CinematicStudioStrings/MixOn.png", "Images/KontaktKompleteKontrol/CinematicStudioStrings/MixOff.png", CompensatePluginCoordinates,, CompensatePluginCoordinates)
        %PluginClass%.PluginOverlays.Push(CinematicStudioStringsOverlay)
    }
    
}
