#Requires AutoHotkey v2.0

Class Audiobro {
    
    Static __New() {
        PluginClass := SubStr(This.Prototype.__Class, 1, InStr(This.Prototype.__Class, ".") - 1)
        
        LASS3Overlay := PluginOverlay("LA Scoring Strings 3")
        LASS3Overlay.Metadata := Map("Vendor", "Audiobro", "Product", "LA Scoring Strings 3", "Image", Map("File", "Images/SampleLibraries/LAScoringStrings3/Product.png"))
        LASS3Overlay.AddPluginOverlay()
        LASS3Overlay.AddStaticText("LA Scoring Strings 3")
        LASS3Overlay.AddHotspotButton("Toggle Look Ahead On/Off", 60, 890)
        LASS3Overlay.AddOCRText("Look Ahead Readout", "Look Ahead Readout not detected", "TesseractBest", 148, 887, 304, 896)
        %PluginClass%.PluginOverlays.Push(LASS3Overlay)
    }
    
}
