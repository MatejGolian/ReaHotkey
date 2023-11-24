#Requires AutoHotkey v2.0

Class KontaktKompleteKontrol {

    Static Init() {
        
        Plugin.Register("Kontakt/Komplete Kontrol", ["^NIVSTChildWindow00007.*", "^Qt6[0-9][0-9]QWindowIcon\{[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\}1"],, True)
        
        KontaktHeader := AccessibilityOverlay("Kontakt Header")
        KontaktHeader.AddCustomButton("File",, ObjBindMethod(KontaktKompleteKontrol, "OpenKontaktFileMenu"))

        AreiaOverlay := AccessibilityOverlay("Areia")
        AreiaOverlay.Metadata := Map("Vendor", "Audio Imperia", "Product", "Areia", "Image", Map("File", "Images/KontaktKompleteKontrol/Areia.png", "X1Coordinate", 960, "Y1Coordinate", 200, "X2Coordinate", 1140, "Y2Coordinate", 280))
        AreiaOverlay.AddHotspotButton("Classic Mix", 468, 395, CompensatePluginPointCoordinates, CompensatePluginPointCoordinates)
        AreiaOverlay.AddHotspotButton("Modern Mix", 565, 395, CompensatePluginPointCoordinates, CompensatePluginPointCoordinates)
        AreiaOverlay.AddControlAt(1, KontaktHeader)
        Plugin.RegisterOverlay("Kontakt/Komplete Kontrol", AreiaOverlay)
        
        CerberusOverlay := AccessibilityOverlay("Cerberus")
        CerberusOverlay.Metadata := Map("Vendor", "Audio Imperia", "Product", "Cerberus", "Image", Map("File", "Images/KontaktKompleteKontrol/Cerberus.png", "X1Coordinate", 930, "Y1Coordinate", 200, "X2Coordinate", 1140, "Y2Coordinate", 260))
        CerberusOverlay.AddHotspotButton("Classic Mix", 468, 395, CompensatePluginPointCoordinates, CompensatePluginPointCoordinates)
        CerberusOverlay.AddHotspotButton("Modern Mix", 565, 395, CompensatePluginPointCoordinates, CompensatePluginPointCoordinates)
        CerberusOverlay.AddControlAt(1, KontaktHeader)
        Plugin.RegisterOverlay("Kontakt/Komplete Kontrol", CerberusOverlay)
        
        ChorusOverlay := AccessibilityOverlay("Chorus")
        ChorusOverlay.Metadata := Map("Vendor", "Audio Imperia", "Product", "Chorus", "Image", Map("File", "Images/KontaktKompleteKontrol/Chorus.png", "X1Coordinate", 0, "Y1Coordinate", 0, "X2Coordinate", 0, "Y2Coordinate", 0))
        ChorusOverlay.AddHotspotButton("Classic Mix", 468, 395, CompensatePluginPointCoordinates, CompensatePluginPointCoordinates)
        ChorusOverlay.AddHotspotButton("Modern Mix", 565, 395, CompensatePluginPointCoordinates, CompensatePluginPointCoordinates)
        ChorusOverlay.AddControlAt(1, KontaktHeader)
        Plugin.RegisterOverlay("Kontakt/Komplete Kontrol", ChorusOverlay)
        
        JaegerOverlay := AccessibilityOverlay("Jaeger")
        JaegerOverlay.Metadata := Map("Vendor", "Audio Imperia", "Product", "Jaeger", "Image", Map("File", "Images/KontaktKompleteKontrol/Jaeger.png", "X1Coordinate", 960, "Y1Coordinate", 200, "X2Coordinate", 1140, "Y2Coordinate", 270))
        JaegerOverlay.AddHotspotButton("Classic Mix", 468, 395, CompensatePluginPointCoordinates, CompensatePluginPointCoordinates)
        JaegerOverlay.AddHotspotButton("Modern Mix", 565, 395, CompensatePluginPointCoordinates, CompensatePluginPointCoordinates)
        JaegerOverlay.AddControlAt(1, KontaktHeader)
        Plugin.RegisterOverlay("Kontakt/Komplete Kontrol", JaegerOverlay)
        
        NucleusOverlay := AccessibilityOverlay("Nucleus")
        NucleusOverlay.Metadata := Map("Vendor", "Audio Imperia", "Product", "Nucleus", "Image", Map("File", "Images/KontaktKompleteKontrol/Nucleus.png", "X1Coordinate", 930, "Y1Coordinate", 200, "X2Coordinate", 1160, "Y2Coordinate", 280))
        NucleusOverlay.AddHotspotButton("Classic Mix", 480, 349, CompensatePluginPointCoordinates, CompensatePluginPointCoordinates)
        NucleusOverlay.AddHotspotButton("Modern Mix", 480, 379, CompensatePluginPointCoordinates, CompensatePluginPointCoordinates)
        NucleusOverlay.AddControlAt(1, KontaktHeader)
        Plugin.RegisterOverlay("Kontakt/Komplete Kontrol", NucleusOverlay)
        
        SoloOverlay := AccessibilityOverlay("Solo")
        SoloOverlay.Metadata := Map("Vendor", "Audio Imperia", "Product", "Solo", "Image", Map("File", "Images/KontaktKompleteKontrol/Solo.png", "X1Coordinate", 0, "Y1Coordinate", 0, "X2Coordinate", 0, "Y2Coordinate", 0))
        SoloOverlay.AddHotspotButton("Classic Mix", 468, 395, CompensatePluginPointCoordinates, CompensatePluginPointCoordinates)
        SoloOverlay.AddHotspotButton("Modern Mix", 565, 395, CompensatePluginPointCoordinates, CompensatePluginPointCoordinates)
        SoloOverlay.AddControlAt(1, KontaktHeader)
        Plugin.RegisterOverlay("Kontakt/Komplete Kontrol", SoloOverlay)
        
        TalosOverlay := AccessibilityOverlay("Talos")
        TalosOverlay.Metadata := Map("Vendor", "Audio Imperia", "Product", "Talos", "Image", Map("File", "Images/KontaktKompleteKontrol/Talos.png", "X1Coordinate", 950, "Y1Coordinate", 200, "X2Coordinate", 1140, "Y2Coordinate", 280))
        TalosOverlay.AddHotspotButton("Classic Mix", 468, 395, CompensatePluginPointCoordinates, CompensatePluginPointCoordinates)
        TalosOverlay.AddHotspotButton("Modern Mix", 565, 395, CompensatePluginPointCoordinates, CompensatePluginPointCoordinates)
        TalosOverlay.AddControlAt(1, KontaktHeader)
        Plugin.RegisterOverlay("Kontakt/Komplete Kontrol", TalosOverlay)
        
        Plugin.SetTimer("Kontakt/Komplete Kontrol", ObjBindMethod(AutoChangePluginOverlay,, "Kontakt/Komplete Kontrol", True, True), 250)
        
    }

Static ActivateKontaktMenuItem(ItemName, ItemNumber, KontaktMenu) {
            Hotkey "Down", "Off"
            Hotkey "Enter", "Off"
                    Click CompensatePluginXCoordinate(186), CompensatePluginYCoordinate(70)
                    Loop ItemNumber {
                    Send "{Down}"
                    Sleep 100
                    }
Send "{Enter}"
Hotkey "Down", "On"
            Hotkey "Enter", "On"
}

Static OpenKontaktFileMenu(*) {
    KontaktFileMenu := AccessiblePluginMenu()
                KontaktFileMenu.Add("Load...", ObjBindMethod(KontaktKompleteKontrol, "ActivateKontaktMenuItem"))
            KontaktFileMenu.Add("Load recent", ObjBindMethod(KontaktKompleteKontrol, "ActivateKontaktMenuItem"))
            KontaktFileMenu.Add("Save multi as...", ObjBindMethod(KontaktKompleteKontrol, "ActivateKontaktMenuItem"))
            KontaktFileMenu.Add("Reset multi", ObjBindMethod(KontaktKompleteKontrol, "ActivateKontaktMenuItem"))
            KontaktFileMenu.Add("Purge this instance", ObjBindMethod(KontaktKompleteKontrol, "ActivateKontaktMenuItem"))
            KontaktFileMenu.Add("Purge all instances", ObjBindMethod(KontaktKompleteKontrol, "ActivateKontaktMenuItem"))
            KontaktFileMenu.Add("Options...", ObjBindMethod(KontaktKompleteKontrol, "ActivateKontaktMenuItem"))
            KontaktFileMenu.Add("Help", ObjBindMethod(KontaktKompleteKontrol, "ActivateKontaktMenuItem"))
                        KontaktFileMenu.Disable("Load recent")
            KontaktFileMenu.Disable("Purge this instance")
            KontaktFileMenu.Disable("Purge all instances")
                KontaktFileMenu.Show()
}

}

KontaktKompleteKontrol.Init()
