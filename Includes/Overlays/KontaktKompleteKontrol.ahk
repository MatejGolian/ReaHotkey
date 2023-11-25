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
        KontaktPurgeThisInstanceMenu := AccessiblePluginMenu()
        KontaktPurgeThisInstanceMenu.Name := "Purge this instance"
        KontaktPurgeThisInstanceMenu.Add("Reset markers", ObjBindMethod(KontaktKompleteKontrol, "ActivateKontaktMenuItem"))
        KontaktPurgeThisInstanceMenu.Add("Update sample pool", ObjBindMethod(KontaktKompleteKontrol, "ActivateKontaktMenuItem"))
        KontaktPurgeThisInstanceMenu.Add("Purge all samples", ObjBindMethod(KontaktKompleteKontrol, "ActivateKontaktMenuItem"))
        KontaktPurgeThisInstanceMenu.Add("Reload all samples", ObjBindMethod(KontaktKompleteKontrol, "ActivateKontaktMenuItem"))
        KontaktPurgeAllInstancesMenu := AccessiblePluginMenu()
        KontaktPurgeAllInstancesMenu.Name := "Purge all instances"
        KontaktPurgeAllInstancesMenu.Add("Reset markers", ObjBindMethod(KontaktKompleteKontrol, "ActivateKontaktMenuItem"))
        KontaktPurgeAllInstancesMenu.Add("Update sample pool", ObjBindMethod(KontaktKompleteKontrol, "ActivateKontaktMenuItem"))
        KontaktPurgeAllInstancesMenu.Add("Purge all samples", ObjBindMethod(KontaktKompleteKontrol, "ActivateKontaktMenuItem"))
        KontaktPurgeAllInstancesMenu.Add("Reload all samples", ObjBindMethod(KontaktKompleteKontrol, "ActivateKontaktMenuItem"))
        KontaktHelpMenu := AccessiblePluginMenu()
        KontaktHelpMenu.Name := "Help"
        KontaktHelpMenu.Add("Launch Native Access", ObjBindMethod(KontaktKompleteKontrol, "ActivateKontaktMenuItem"))
        KontaktHelpMenu.Add("Online Kontakt Documentation", ObjBindMethod(KontaktKompleteKontrol, "ActivateKontaktMenuItem"))
        KontaktHelpMenu.Add("Online Kontakt Scripting Documentation", ObjBindMethod(KontaktKompleteKontrol, "ActivateKontaktMenuItem"))
        KontaktHelpMenu.Add("Online Kontakt API Documentation", ObjBindMethod(KontaktKompleteKontrol, "ActivateKontaktMenuItem"))
        KontaktHelpMenu.Add("Online Knowledge Base", ObjBindMethod(KontaktKompleteKontrol, "ActivateKontaktMenuItem"))
        KontaktHelpMenu.Add("About Kontakt", ObjBindMethod(KontaktKompleteKontrol, "ActivateKontaktMenuItem"))
        KontaktFileMenu := AccessiblePluginMenu()
        KontaktFileMenu.Name := "File"
        KontaktFileMenu.Add("Load...", ObjBindMethod(KontaktKompleteKontrol, "ActivateKontaktMenuItem"))
;        KontaktFileMenu.Add("Load recent", ObjBindMethod(KontaktKompleteKontrol, "ActivateKontaktMenuItem"))
        KontaktFileMenu.Add("Save multi as...", ObjBindMethod(KontaktKompleteKontrol, "ActivateKontaktMenuItem"))
        KontaktFileMenu.Add("Reset multi", ObjBindMethod(KontaktKompleteKontrol, "ActivateKontaktMenuItem"))
        KontaktFileMenu.Add("Purge this instance", KontaktPurgeThisInstanceMenu)
        KontaktFileMenu.Add("Purge all instances", KontaktPurgeAllInstancesMenu)
        KontaktFileMenu.Add("Options...", ObjBindMethod(KontaktKompleteKontrol, "ActivateKontaktMenuItem"))
        KontaktFileMenu.Add("Help", KontaktHelpMenu)
;        KontaktFileMenu.Disable("Load recent")
        KontaktFileMenu.Show()
    }
    
    Static OpenKontaktViewMenu(*) {
        KontaktViewMenu := AccessiblePluginMenu()
        KontaktViewMenu.Name := "View"
        KontaktViewMenu.Add("Rack View", ObjBindMethod(KontaktKompleteKontrol, "ActivateKontaktMenuItem"))
        KontaktViewMenu.Add("Info", ObjBindMethod(KontaktKompleteKontrol, "ActivateKontaktMenuItem"))
        KontaktViewMenu.Add("Keyboard", ObjBindMethod(KontaktKompleteKontrol, "ActivateKontaktMenuItem"))
        KontaktViewMenu.Add("Quick-Load", ObjBindMethod(KontaktKompleteKontrol, "ActivateKontaktMenuItem"))
;        KontaktViewMenu.Add("Zoom", ObjBindMethod(KontaktKompleteKontrol, "ActivateKontaktMenuItem"))
        KontaktViewMenu.Add("Set current view as default", ObjBindMethod(KontaktKompleteKontrol, "ActivateKontaktMenuItem"))
;        KontaktViewMenu.Disable("Zoom")
        KontaktViewMenu.Show()
    }
    
    Static ActivateKontaktMenuItem(ItemName, ItemNumber, KontaktMenu) {
        MenuItems := Map()
        MenuItems.Set("Purge this instance Reset markers", ["{Down}", "{Down}", "{Down}", "{Down}", "{Down}", "{Enter}", "{Enter}"])
        MenuItems.Set("Purge this instance Update sample pool", ["{Down}", "{Down}", "{Down}", "{Down}", "{Down}", "{Enter}", "{Down}", "{Enter}"])
        MenuItems.Set("Purge this instance Purge all samples", ["{Down}", "{Down}", "{Down}", "{Down}", "{Down}", "{Enter}", "{Down}", "{Down}", "{Enter}"])
        MenuItems.Set("Purge this instance Reload all samples", ["{Down}", "{Down}", "{Down}", "{Down}", "{Down}", "{Enter}", "{Down}", "{Down}", "{Down}", "{Enter}"])
        MenuItems.Set("Purge all instances Reset markers", ["{Down}", "{Down}", "{Down}", "{Down}", "{Down}", "{Down}", "{Enter}", "{Enter}"])
        MenuItems.Set("Purge all instances Update sample pool", ["{Down}", "{Down}", "{Down}", "{Down}", "{Down}", "{Down}", "{Enter}", "{Down}", "{Enter}"])
        MenuItems.Set("Purge all instances Purge all samples", ["{Down}", "{Down}", "{Down}", "{Down}", "{Down}", "{Down}", "{Enter}", "{Down}", "{Down}", "{Enter}"])
        MenuItems.Set("Purge all instances Reload all samples", ["{Down}", "{Down}", "{Down}", "{Down}", "{Down}", "{Down}", "{Enter}", "{Down}", "{Down}", "{Down}", "{Enter}"])
        MenuItems.Set("Help Launch Native Access", ["{Down}", "{Down}", "{Down}", "{Down}", "{Down}", "{Down}", "{Down}", "{Down}", "{Enter}", "{Enter}"])
        MenuItems.Set("Help Online Kontakt Documentation", ["{Down}", "{Down}", "{Down}", "{Down}", "{Down}", "{Down}", "{Down}", "{Down}", "{Enter}", "{Down}", "{Enter}"])
        MenuItems.Set("Help Online Kontakt Scripting Documentation", ["{Down}", "{Down}", "{Down}", "{Down}", "{Down}", "{Down}", "{Down}", "{Down}", "{Enter}", "{Down}", "{Down}", "{Enter}"])
        MenuItems.Set("Help Online Kontakt API Documentation", ["{Down}", "{Down}", "{Down}", "{Down}", "{Down}", "{Down}", "{Down}", "{Down}", "{Enter}", "{Down}", "{Down}", "{Down}", "{Enter}"])
        MenuItems.Set("Help Online Knowledge Base", ["{Down}", "{Down}", "{Down}", "{Down}", "{Down}", "{Down}", "{Down}", "{Down}", "{Enter}", "{Down}", "{Down}", "{Down}", "{Down}", "{Enter}"])
        MenuItems.Set("Help About Kontakt", ["{Down}", "{Down}", "{Down}", "{Down}", "{Down}", "{Down}", "{Down}", "{Down}", "{Enter}", "{Down}", "{Down}", "{Down}", "{Down}", "{Down}", "{Enter}"])
        MenuItems.Set("File Load...", ["{Down}", "{Enter}"])
        MenuItems.Set("File Save multi as...", ["{Down}", "{Down}", "{Down}", "{Enter}"])
        MenuItems.Set("File Reset multi", ["{Down}", "{Down}", "{Down}", "{Down}", "{Enter}"])
        MenuItems.Set("File Options...", ["{Down}", "{Down}", "{Down}", "{Down}", "{Down}", "{Down}", "{Down}", "{Enter}"])
        MenuItems.Set("View Rack View", ["{Down}", "{Enter}"])
        MenuItems.Set("View Info", ["{Down}", "{Down}", "{Enter}"])
        MenuItems.Set("View Keyboard", ["{Down}", "{Down}", "{Down}", "{Enter}"])
        MenuItems.Set("View Quick-Load", ["{Down}", "{Down}", "{Down}", "{Down}", "{Enter}"])
        MenuItems.Set("View Set current view as default", ["{Down}", "{Down}", "{Down}", "{Down}", "{Down}", "{Down}", "{Enter}"])
        Switch(KontaktMenu.Name) {
            Case "File":
            Click CompensatePluginXCoordinate(186), CompensatePluginYCoordinate(70)
            Case "Purge this instance":
            Click CompensatePluginXCoordinate(186), CompensatePluginYCoordinate(70)
            Case "Purge all instances":
            Click CompensatePluginXCoordinate(186), CompensatePluginYCoordinate(70)
            Case "Help":
            Click CompensatePluginXCoordinate(186), CompensatePluginYCoordinate(70)
            Case "View":
            Click CompensatePluginXCoordinate(298), CompensatePluginYCoordinate(70)
        }
        For KeyCommand In MenuItems[KontaktMenu.Name . " " . ItemName] {
            Send KeyCommand
            Sleep 5
        }
    }
    
}

KontaktKompleteKontrol.Init()
