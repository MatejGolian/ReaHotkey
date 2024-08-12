#Requires AutoHotkey v2.0

Class CinematicStudioSeries {
    
    Static InitClass(ClassName) {
        KontaktXOffset := 0
        KontaktYOffset := 0
        KompleteKontrolXOffset := 190
        KompleteKontrolYOffset := 111
        
        CinematicStudioStringsOverlay := AccessibilityOverlay("Cinematic Studio Strings")
        CinematicStudioStringsOverlay.Metadata := Map("Vendor", "Cinematic Studio Series", "Product", "Cinematic Studio Strings", "Image", Map("File", "Images/KontaktKompleteKontrol/CinematicStudioStrings/Product.png"))
        CinematicStudioStringsOverlay.AddAccessibilityOverlay()
        CinematicStudioStringsOverlay.AddStaticText("Cinematic Studio Strings")
        CinematicStudioStringsOverlay.AddHotspotButton("Spot 1", %ClassName%XOffset + 40, %ClassName%YOffset + 532, CompensatePluginPointCoordinates, CompensatePluginPointCoordinates)
        CinematicStudioStringsOverlay.AddHotspotButton("Spot 2", %ClassName%XOffset + 80, %ClassName%YOffset + 532, CompensatePluginPointCoordinates, CompensatePluginPointCoordinates)
        CinematicStudioStringsOverlay.AddHotspotButton("Main", %ClassName%XOffset + 120, %ClassName%YOffset + 532, CompensatePluginPointCoordinates, CompensatePluginPointCoordinates)
        CinematicStudioStringsOverlay.AddHotspotButton("Room", %ClassName%XOffset + 160, %ClassName%YOffset + 532, CompensatePluginPointCoordinates, CompensatePluginPointCoordinates)
        CinematicStudioStringsOverlay.AddGraphicalButton("Mix", %ClassName%XOffset + 196, %ClassName%YOffset + 524, %ClassName%XOffset + 228, %ClassName%YOffset + 540, "Images/KontaktKompleteKontrol/CinematicStudioStrings/MixOn.png", "Images/KontaktKompleteKontrol/CinematicStudioStrings/MixOff.png", CompensatePluginRegionCoordinates, CompensatePluginRegionCoordinates)
        %ClassName%.PluginOverlays.Push(CinematicStudioStringsOverlay)
    }
    
}
