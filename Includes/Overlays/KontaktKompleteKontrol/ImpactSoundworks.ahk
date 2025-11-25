#Requires AutoHotkey v2.0

Class ImpactSoundworks {
    
    Static __New() {
        PluginClass := SubStr(This.Prototype.__Class, 1, InStr(This.Prototype.__Class, ".") - 1)
        Kontakt7XOffset := 0
        Kontakt7YOffset := 0
        Kontakt8XOffset := 0
        Kontakt8YOffset := 29
        KompleteKontrolXOffset := 190
        KompleteKontrolYOffset := 111
        
        JuggernautBassOverlay := PluginOverlay("Juggernaut")
        JuggernautBassOverlay.Metadata := Map("Vendor", "Impact Soundworks", "Product", "Juggernaut", "Patch", "BASS Juggernaut.nki", "Image", Map("File", "Images/SampleLibraries/Juggernaut/Bass.png"))
        JuggernautBassOverlay.AddStaticText("Juggernaut Bass")
        JuggernautBassOverlay.AddOCRButton("Preset", "Unknown preset", "TesseractBest", %PluginClass%XOffset + 354, %PluginClass%YOffset + 125, %PluginClass%XOffset + 562, %PluginClass%YOffset + 175)
        %PluginClass%.PluginOverlays.Push(JuggernautBassOverlay)
        
        JuggernautDrumsAndFXOverlay := PluginOverlay("Juggernaut")
        JuggernautDrumsAndFXOverlay.Metadata := Map("Vendor", "Impact Soundworks", "Product", "Juggernaut", "Patch", "DRUMS & FX Juggernaut v1.15.nki", "Image", Map("File", "Images/SampleLibraries/Juggernaut/DrumsAndFX.png"))
        JuggernautDrumsAndFXOverlay.AddStaticText("Juggernaut Drums & FX")
        JuggernautDrumsAndFXOverlay.AddOCRButton("Preset", "Unknown preset", "TesseractBest", %PluginClass%XOffset + 150, %PluginClass%YOffset + 132, %PluginClass%XOffset + 360, %PluginClass%YOffset + 170)
        %PluginClass%.PluginOverlays.Push(JuggernautDrumsAndFXOverlay)
    }
    
}
