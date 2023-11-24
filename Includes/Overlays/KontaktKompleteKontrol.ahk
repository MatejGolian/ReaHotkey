#Requires AutoHotkey v2.0

Class KontaktKompleteKontrol {
    
    Static Init() {
        
        Plugin.Register("Kontakt/Komplete Kontrol", ["^NIVSTChildWindow00007.*", "^Qt6[0-9][0-9]QWindowIcon\{[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\}1"],, True)
        Standalone.Register("Komplete Kontrol", "Komplete Kontrol ahk_class NINormalWindow* ahk_exe Komplete Kontrol.exe")
        
        KompleteKontrolPluginHeader := AccessibilityOverlay()
        KompleteKontrolPluginHeader.AddHotspotButton("File", CompensatePluginXCoordinate(24), CompensatePluginYCoordinate(41))
        KompleteKontrolPluginHeader.AddHotspotButton("Edit", CompensatePluginXCoordinate(60), CompensatePluginYCoordinate(41))
        KompleteKontrolPluginHeader.AddHotspotButton("View", CompensatePluginXCoordinate(91), CompensatePluginYCoordinate(41))
        KompleteKontrolPluginHeader.AddHotspotButton("Controller", CompensatePluginXCoordinate(146), CompensatePluginYCoordinate(41))
        KompleteKontrolPluginHeader.AddHotspotButton("Help", CompensatePluginXCoordinate(202), CompensatePluginYCoordinate(41))
        
        KompleteKontrolStandaloneHeader := AccessibilityOverlay()
        KompleteKontrolStandaloneHeader.AddHotspotButton("File", 24, 41)
        KompleteKontrolStandaloneHeader.AddHotspotButton("Edit", 60, 41)
        KompleteKontrolStandaloneHeader.AddHotspotButton("View", 91, 41)
        KompleteKontrolStandaloneHeader.AddHotspotButton("Controller", 146, 41)
        KompleteKontrolStandaloneHeader.AddHotspotButton("Help", 202, 41)
        
        KontaktHeader := AccessibilityOverlay("Kontakt Header")
        KontaktHeader.AddCustomButton("FILE",, ObjBindMethod(KontaktKompleteKontrol, "OpenKontaktFileMenu"))
        KontaktHeader.AddHotspotButton("LIBRARY", CompensatePluginXCoordinate(237), CompensatePluginYCoordinate(70))
        KontaktHeader.AddCustomButton("VIEW",, ObjBindMethod(KontaktKompleteKontrol, "OpenKontaktViewMenu"))
        KontaktHeader.AddHotspotButton("SHOP", CompensatePluginXCoordinate(828), CompensatePluginYCoordinate(70))
        
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
        
        Standalone.RegisterOverlay("Komplete Kontrol", KompleteKontrolStandaloneHeader)
        
        Plugin.SetTimer("Kontakt/Komplete Kontrol", ObjBindMethod(AutoChangePluginOverlay,, "Kontakt/Komplete Kontrol", True, True), 250)
        
    }
    
    Static OpenKontaktFileMenu(*) {
        Click CompensatePluginXCoordinate(186), CompensatePluginYCoordinate(70)
        Loop {
            ReaHotkey.TurnPluginHotkeysOff()
            ReaHotkey.TurnPluginTimersOff()
            SingleKey := KeyWaitSingle()
            Send "{" . SingleKey . "}"
            If ReaHotkey.FoundPlugin Is Plugin {
                If SingleKey = "Enter" Or SingleKey = "Escape"
                Break
            }
            Else {
                Break
            }
        }
    }
    
    Static OpenKontaktViewMenu(*) {
        Click CompensatePluginXCoordinate(298), CompensatePluginYCoordinate(70)
        Loop {
            ReaHotkey.TurnPluginHotkeysOff()
            ReaHotkey.TurnPluginTimersOff()
            SingleKey := KeyWaitSingle()
            Send "{" . SingleKey . "}"
            If ReaHotkey.FoundPlugin Is Plugin {
                If SingleKey = "Enter" Or SingleKey = "Escape"
                Break
            }
            Else {
                Break
            }
        }
    }
    
}

KontaktKompleteKontrol.Init()
