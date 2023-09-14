#Requires AutoHotkey v2.0

Class KontaktKompleteKontrol {
    
    Static Init() {
        
        Plugin.Register("Kontakt/Komplete Kontrol", ["^NIVSTChildWindow00007.*", "^Qt6[0-9][0-9]QWindowIcon\{[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\}1"],, True)
        
        AreiaOverlay := AccessibilityOverlay("Areia")
        AreiaOverlay.Metadata := Map("Vendor", "Audio Imperia", "Product", "Areia", "Image", Map("File", "Images/KontaktKompleteKontrol/Areia.png", "X1Coordinate", 960, "Y1Coordinate", 200, "X2Coordinate", 1140, "Y2Coordinate", 280))
        AreiaOverlay.AddHotspotButton("Classic Mix", 468, 395, CompensatePluginPointCoordinates, CompensatePluginPointCoordinates)
        AreiaOverlay.AddHotspotButton("Modern Mix", 565, 395, CompensatePluginPointCoordinates, CompensatePluginPointCoordinates)
        Plugin.RegisterOverlay("Kontakt/Komplete Kontrol", AreiaOverlay)
        
        CerberusOverlay := AccessibilityOverlay("Cerberus")
        CerberusOverlay.Metadata := Map("Vendor", "Audio Imperia", "Product", "Cerberus", "Image", Map("File", "Images/KontaktKompleteKontrol/Cerberus.png", "X1Coordinate", 930, "Y1Coordinate", 200, "X2Coordinate", 1140, "Y2Coordinate", 260))
        CerberusOverlay.AddHotspotButton("Classic Mix", 468, 395, CompensatePluginPointCoordinates, CompensatePluginPointCoordinates)
        CerberusOverlay.AddHotspotButton("Modern Mix", 565, 395, CompensatePluginPointCoordinates, CompensatePluginPointCoordinates)
        Plugin.RegisterOverlay("Kontakt/Komplete Kontrol", CerberusOverlay)
        
        ChorusOverlay := AccessibilityOverlay("Chorus")
        ChorusOverlay.Metadata := Map("Vendor", "Audio Imperia", "Product", "Chorus", "Image", Map("File", "Images/KontaktKompleteKontrol/Chorus.png", "X1Coordinate", 0, "Y1Coordinate", 0, "X2Coordinate", 0, "Y2Coordinate", 0))
        ChorusOverlay.AddHotspotButton("Classic Mix", 468, 395, CompensatePluginPointCoordinates, CompensatePluginPointCoordinates)
        ChorusOverlay.AddHotspotButton("Modern Mix", 565, 395, CompensatePluginPointCoordinates, CompensatePluginPointCoordinates)
        Plugin.RegisterOverlay("Kontakt/Komplete Kontrol", ChorusOverlay)
        
                JaegerOverlay := AccessibilityOverlay("Jaeger")
        JaegerOverlay.Metadata := Map("Vendor", "Audio Imperia", "Product", "Jaeger", "Image", Map("File", "Images/KontaktKompleteKontrol/Jaeger.png", "X1Coordinate", 960, "Y1Coordinate", 200, "X2Coordinate", 1140, "Y2Coordinate", 270))
        JaegerOverlay.AddHotspotButton("Classic Mix", 468, 395, CompensatePluginPointCoordinates, CompensatePluginPointCoordinates)
        JaegerOverlay.AddHotspotButton("Modern Mix", 565, 395, CompensatePluginPointCoordinates, CompensatePluginPointCoordinates)
        Plugin.RegisterOverlay("Kontakt/Komplete Kontrol", JaegerOverlay)
        
        NucleusOverlay := AccessibilityOverlay("Nucleus")
        NucleusOverlay.Metadata := Map("Vendor", "Audio Imperia", "Product", "Nucleus", "Image", Map("File", "Images/KontaktKompleteKontrol/Nucleus.png", "X1Coordinate", 930, "Y1Coordinate", 200, "X2Coordinate", 1160, "Y2Coordinate", 280))
        NucleusOverlay.AddHotspotButton("Classic Mix", 480, 349, CompensatePluginPointCoordinates, CompensatePluginPointCoordinates)
        NucleusOverlay.AddHotspotButton("Modern Mix", 480, 379, CompensatePluginPointCoordinates, CompensatePluginPointCoordinates)
        Plugin.RegisterOverlay("Kontakt/Komplete Kontrol", NucleusOverlay)
        
        SoloOverlay := AccessibilityOverlay("Solo")
        SoloOverlay.Metadata := Map("Vendor", "Audio Imperia", "Product", "Solo", "Image", Map("File", "Images/KontaktKompleteKontrol/Solo.png", "X1Coordinate", 0, "Y1Coordinate", 0, "X2Coordinate", 0, "Y2Coordinate", 0))
        SoloOverlay.AddHotspotButton("Classic Mix", 468, 395, CompensatePluginPointCoordinates, CompensatePluginPointCoordinates)
        SoloOverlay.AddHotspotButton("Modern Mix", 565, 395, CompensatePluginPointCoordinates, CompensatePluginPointCoordinates)
        Plugin.RegisterOverlay("Kontakt/Komplete Kontrol", SoloOverlay)
        
        TalosOverlay := AccessibilityOverlay("Talos")
        TalosOverlay.Metadata := Map("Vendor", "Audio Imperia", "Product", "Talos", "Image", Map("File", "Images/KontaktKompleteKontrol/Talos.png", "X1Coordinate", 950, "Y1Coordinate", 200, "X2Coordinate", 1140, "Y2Coordinate", 280))
        TalosOverlay.AddHotspotButton("Classic Mix", 468, 395, CompensatePluginPointCoordinates, CompensatePluginPointCoordinates)
        TalosOverlay.AddHotspotButton("Modern Mix", 565, 395, CompensatePluginPointCoordinates, CompensatePluginPointCoordinates)
        Plugin.RegisterOverlay("Kontakt/Komplete Kontrol", TalosOverlay)
        
        Shreddage3Overlay := AccessibilityOverlay("Shreddage 3 Series")
        Shreddage3Overlay.Metadata := Map("Vendor", "Impact Soundworks", "Product", "Shreddage 3 Series", "Image", Map("File", "Images/KontaktKompleteKontrol/Shreddage3.png", "X1Coordinate", 820, "Y1Coordinate", 380, "X2Coordinate", 1060, "Y2Coordinate", 440))
        Shreddage3Overlay.AddHotspotButton("Guitar Number 1", 842, 471, CompensatePluginPointCoordinates, CompensatePluginPointCoordinates)
        Shreddage3Overlay.AddHotspotButton("Guitar Number 2", 866, 471, CompensatePluginPointCoordinates, CompensatePluginPointCoordinates)
        Shreddage3Overlay.AddHotspotButton("Guitar Number 3", 890, 471, CompensatePluginPointCoordinates, CompensatePluginPointCoordinates)
        Shreddage3Overlay.AddHotspotButton("Guitar Number 4", 914, 471, CompensatePluginPointCoordinates, CompensatePluginPointCoordinates)
        Plugin.RegisterOverlay("Kontakt/Komplete Kontrol", Shreddage3Overlay)
        
        Plugin.SetTimer("Kontakt/Komplete Kontrol", ObjBindMethod(AutoChangePluginOverlay,, "Kontakt/Komplete Kontrol", True, True), 200)
        
    }
    
}

KontaktKompleteKontrol.Init()
