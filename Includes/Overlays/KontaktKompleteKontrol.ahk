#Requires AutoHotkey v2.0

Class KontaktKompleteKontrol {
    
    Static Init() {
        
        Plugin.Register("Kontakt/Komplete Kontrol", ["^NIVSTChildWindow00007.*", "^Qt6[0-9][0-9]QWindowIcon\{[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\}1"],, True)
        
        AreiaOverlay := AccessibilityOverlay("Areia")
        AreiaOverlay.Metadata := Map("Vendor", "Audio Imperia", "Product", "Areia")
        AreiaOverlay.AddHotspotButton("Classic Mix", 468, 395, CompensatePluginPointCoordinates, CompensatePluginPointCoordinates)
        AreiaOverlay.AddHotspotButton("Modern Mix", 565, 395, CompensatePluginPointCoordinates, CompensatePluginPointCoordinates)
        Plugin.RegisterOverlay("Kontakt/Komplete Kontrol", AreiaOverlay)
        
        JaegerOverlay := AccessibilityOverlay("Jaeger")
        JaegerOverlay.Metadata := Map("Vendor", "Audio Imperia", "Product", "Jaeger")
        JaegerOverlay.AddHotspotButton("Classic Mix", 468, 395, CompensatePluginPointCoordinates, CompensatePluginPointCoordinates)
        JaegerOverlay.AddHotspotButton("Modern Mix", 565, 395, CompensatePluginPointCoordinates, CompensatePluginPointCoordinates)
        Plugin.RegisterOverlay("Kontakt/Komplete Kontrol", JaegerOverlay)
        
        NucleusOverlay := AccessibilityOverlay("Nucleus")
        NucleusOverlay.Metadata := Map("Vendor", "Audio Imperia", "Product", "Nucleus")
        NucleusOverlay.AddHotspotButton("Classic Mix", 480, 349, CompensatePluginPointCoordinates, CompensatePluginPointCoordinates)
        NucleusOverlay.AddHotspotButton("Modern Mix", 480, 379, CompensatePluginPointCoordinates, CompensatePluginPointCoordinates)
        Plugin.RegisterOverlay("Kontakt/Komplete Kontrol", NucleusOverlay)
        
        TalosOverlay := AccessibilityOverlay("Talos")
        TalosOverlay.Metadata := Map("Vendor", "Audio Imperia", "Product", "Talos")
        TalosOverlay.AddHotspotButton("Classic Mix", 468, 395, CompensatePluginPointCoordinates, CompensatePluginPointCoordinates)
        TalosOverlay.AddHotspotButton("Modern Mix", 565, 395, CompensatePluginPointCoordinates, CompensatePluginPointCoordinates)
        Plugin.RegisterOverlay("Kontakt/Komplete Kontrol", TalosOverlay)
        
        ShreddageOverlay := AccessibilityOverlay("Shreddage Series")
        ShreddageOverlay.Metadata := Map("Vendor", "Impact Soundworks", "Product", "Shreddage Series")
        ShreddageOverlay.AddHotspotButton("Guitar Number 1", 842, 471, CompensatePluginPointCoordinates, CompensatePluginPointCoordinates)
        ShreddageOverlay.AddHotspotButton("Guitar Number 2", 866, 471, CompensatePluginPointCoordinates, CompensatePluginPointCoordinates)
        ShreddageOverlay.AddHotspotButton("Guitar Number 3", 890, 471, CompensatePluginPointCoordinates, CompensatePluginPointCoordinates)
        ShreddageOverlay.AddHotspotButton("Guitar Number 4", 914, 471, CompensatePluginPointCoordinates, CompensatePluginPointCoordinates)
        Plugin.RegisterOverlay("Kontakt/Komplete Kontrol", ShreddageOverlay)
        
    }
    
}

KontaktKompleteKontrol.Init()
