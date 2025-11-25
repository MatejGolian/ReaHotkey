#Requires AutoHotkey v2.0

Class Audiobro {
    
    Static Kontakt7XOffset := 0
    Static Kontakt7YOffset := 0
    Static Kontakt8XOffset := 0
    Static Kontakt8YOffset := 29
    Static KompleteKontrolXOffset := 18
    Static KompleteKontrolYOffset := 111
    
    Static __New() {
        PluginClass := SubStr(This.Prototype.__Class, 1, InStr(This.Prototype.__Class, ".") - 1)
        
        LASS3Overlay := PluginOverlay("LA Scoring Strings 3")
        LASS3Overlay.Metadata := Map("Vendor", "Audiobro", "Product", "LA Scoring Strings 3", "Image", Map("File", "Images/SampleLibraries/LAScoringStrings3/Product.png"))
        LASS3Overlay.AddStaticText("LA Scoring Strings 3")
        LASS3Overlay.AddHotspotButton("Toggle Look Ahead On/Off", This.%PluginClass%XOffset + 42, This.%PluginClass%YOffset + 779)
        LASS3Overlay.AddOCRText("Look Ahead Readout", "Look Ahead Readout not detected", "TesseractBest", This.%PluginClass%XOffset + 130, This.%PluginClass%YOffset + 776, This.%PluginClass%XOffset + 286, This.%PluginClass%YOffset + 785)
        %PluginClass%.PluginOverlays.Push(LASS3Overlay)
    }
    
}
