#Requires AutoHotkey v2.0

Class CinematicStudioSeries {
    
    Static __New() {
        PluginClass := SubStr(This.Prototype.__Class, 1, InStr(This.Prototype.__Class, ".") - 1)
        Kontakt7XOffset := 0
        Kontakt7YOffset := 0
        Kontakt8XOffset := 0
        Kontakt8YOffset := 29
        KompleteKontrolXOffset := 190
        KompleteKontrolYOffset := 111
        
        CinematicStudioBrassOverlay := PluginOverlay("Cinematic Studio Brass")
        CinematicStudioBrassOverlay.Metadata := Map("Vendor", "Cinematic Studio Series", "Product", "Cinematic Studio Brass", "Image", Map("File", "Images/KontaktKompleteKontrol/CinematicStudioBrass/Product.png"))
        CinematicStudioBrassOverlay.AddPluginOverlay()
        CinematicStudioBrassOverlay.AddStaticText("Cinematic Studio Brass")
        CinematicStudioBrassOverlay.AddHotspotToggleButton("Close Mic", %PluginClass%XOffset + 46, %PluginClass%YOffset + 465, "0xF6AFAC", "0x737170")
        CinematicStudioBrassOverlay.AddHotspotToggleButton("Main Mic", %PluginClass%XOffset + 96, %PluginClass%YOffset + 465, "0xF6AFAC", "0x747170")
        CinematicStudioBrassOverlay.AddHotspotToggleButton("Room Mic", %PluginClass%XOffset + 146, %PluginClass%YOffset + 465, "0xF6AFAC", "0x747170")
        CinematicStudioBrassOverlay.AddGraphicalToggleButton("Mix Position", %PluginClass%XOffset + 186, %PluginClass%YOffset + 476, %PluginClass%XOffset + 206, %PluginClass%YOffset + 488, "Images/KontaktKompleteKontrol/CinematicStudioBrass/MixOn.png", "Images/KontaktKompleteKontrol/CinematicStudioBrass/MixOff.png")
        %PluginClass%.PluginOverlays.Push(CinematicStudioBrassOverlay)
        
        CinematicStudioStringsOverlay := PluginOverlay("Cinematic Studio Strings")
        CinematicStudioStringsOverlay.Metadata := Map("Vendor", "Cinematic Studio Series", "Product", "Cinematic Studio Strings", "Image", Map("File", "Images/KontaktKompleteKontrol/CinematicStudioStrings/Product.png"))
        CinematicStudioStringsOverlay.AddPluginOverlay()
        CinematicStudioStringsOverlay.AddStaticText("Cinematic Studio Strings")
        CinematicStudioStringsOverlay.AddHotspotButton("Spot 1 Mic", %PluginClass%XOffset + 35, %PluginClass%YOffset + 481)
        CinematicStudioStringsOverlay.AddHotspotButton("Spot 2 Mic", %PluginClass%XOffset + 75, %PluginClass%YOffset + 481)
        CinematicStudioStringsOverlay.AddHotspotButton("Main Mic", %PluginClass%XOffset + 115, %PluginClass%YOffset + 481)
        CinematicStudioStringsOverlay.AddHotspotButton("Room Mic", %PluginClass%XOffset + 155, %PluginClass%YOffset + 481)
        CinematicStudioStringsOverlay.AddGraphicalToggleButton("Mix Position", %PluginClass%XOffset + 188, %PluginClass%YOffset + 473, %PluginClass%XOffset + 220, %PluginClass%YOffset + 489, "Images/KontaktKompleteKontrol/CinematicStudioStrings/MixOn.png", "Images/KontaktKompleteKontrol/CinematicStudioStrings/MixOff.png")
        %PluginClass%.PluginOverlays.Push(CinematicStudioStringsOverlay)
    }
    
}
