#Requires AutoHotkey v2.0

Class KontaktKompleteKontrol {
    
    Static Init() {
        
        Plugin.Register("Kontakt/Komplete Kontrol", "^Qt6[0-9][0-9]QWindowIcon\{[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\}1",, True)
        Standalone.Register("Komplete Kontrol", "Komplete Kontrol ahk_class NINormalWindow* ahk_exe Komplete Kontrol.exe")
        
        KompleteKontrolStandaloneHeader := AccessibilityOverlay("Komplete Kontrol")
        KompleteKontrolStandaloneHeader.AddHotspotButton("File", 24, 41)
        KompleteKontrolStandaloneHeader.AddHotspotButton("Edit", 60, 41)
        KompleteKontrolStandaloneHeader.AddHotspotButton("View", 91, 41)
        KompleteKontrolStandaloneHeader.AddHotspotButton("Controller", 146, 41)
        KompleteKontrolStandaloneHeader.AddHotspotButton("Help", 202, 41)
        
        AreiaOverlay := AccessibilityOverlay("Areia")
        AreiaOverlay.Metadata := Map("Vendor", "Audio Imperia", "Product", "Areia", "Image", Map("File", "Images/KontaktKompleteKontrol/Areia.png"))
        AreiaOverlay.AddAccessibilityOverlay()
        AreiaOverlay.AddStaticText("Areia")
        AreiaOverlay.AddCustomButton("Classic Mix",, ObjBindMethod(KontaktKompleteKontrol, "SelectAIPluginClassicMix"))
        AreiaOverlay.AddCustomButton("Modern Mix",, ObjBindMethod(KontaktKompleteKontrol, "SelectAIPluginModernMix"))
        Plugin.RegisterOverlay("Kontakt/Komplete Kontrol", AreiaOverlay)
        
        CerberusOverlay := AccessibilityOverlay("Cerberus")
        CerberusOverlay.Metadata := Map("Vendor", "Audio Imperia", "Product", "Cerberus", "Image", Map("File", "Images/KontaktKompleteKontrol/Cerberus.png"))
        CerberusOverlay.AddAccessibilityOverlay()
        CerberusOverlay.AddStaticText("Cerberus")
        CerberusOverlay.AddCustomButton("Classic Mix",, ObjBindMethod(KontaktKompleteKontrol, "SelectAIPluginClassicMix"))
        CerberusOverlay.AddCustomButton("Modern Mix",, ObjBindMethod(KontaktKompleteKontrol, "SelectAIPluginModernMix"))
        Plugin.RegisterOverlay("Kontakt/Komplete Kontrol", CerberusOverlay)
        
        ChorusOverlay := AccessibilityOverlay("Chorus")
        ChorusOverlay.Metadata := Map("Vendor", "Audio Imperia", "Product", "Chorus", "Image", Map("File", "Images/KontaktKompleteKontrol/Chorus.png"))
        ChorusOverlay.AddAccessibilityOverlay()
        ChorusOverlay.AddStaticText("Chorus")
        ChorusOverlay.AddCustomButton("Classic Mix",, ObjBindMethod(KontaktKompleteKontrol, "SelectAIPluginClassicMix"))
        ChorusOverlay.AddCustomButton("Modern Mix",, ObjBindMethod(KontaktKompleteKontrol, "SelectAIPluginModernMix"))
        Plugin.RegisterOverlay("Kontakt/Komplete Kontrol", ChorusOverlay)
        
        JaegerOverlay := AccessibilityOverlay("Jaeger")
        JaegerOverlay.Metadata := Map("Vendor", "Audio Imperia", "Product", "Jaeger", "Image", Map("File", "Images/KontaktKompleteKontrol/Jaeger.png"))
        JaegerOverlay.AddAccessibilityOverlay()
        JaegerOverlay.AddStaticText("Jaeger")
        JaegerOverlay.AddCustomButton("Classic Mix",, ObjBindMethod(KontaktKompleteKontrol, "SelectAIPluginClassicMix"))
        JaegerOverlay.AddCustomButton("Modern Mix",, ObjBindMethod(KontaktKompleteKontrol, "SelectAIPluginModernMix"))
        Plugin.RegisterOverlay("Kontakt/Komplete Kontrol", JaegerOverlay)
        
        NucleusOverlay := AccessibilityOverlay("Nucleus")
        NucleusOverlay.Metadata := Map("Vendor", "Audio Imperia", "Product", "Nucleus", "Image", Map("File", "Images/KontaktKompleteKontrol/Nucleus.png"))
        NucleusOverlay.AddAccessibilityOverlay()
        NucleusOverlay.AddStaticText("Nucleus")
        NucleusOverlay.AddCustomButton("Classic Mix",, ObjBindMethod(KontaktKompleteKontrol, "SelectAIPluginClassicMix"))
        NucleusOverlay.AddCustomButton("Modern Mix",, ObjBindMethod(KontaktKompleteKontrol, "SelectAIPluginModernMix"))
        Plugin.RegisterOverlay("Kontakt/Komplete Kontrol", NucleusOverlay)
        
        SoloOverlay := AccessibilityOverlay("Solo")
        SoloOverlay.Metadata := Map("Vendor", "Audio Imperia", "Product", "Solo", "Image", Map("File", "Images/KontaktKompleteKontrol/Solo.png"))
        SoloOverlay.AddAccessibilityOverlay()
        SoloOverlay.AddStaticText("Solo")
        SoloOverlay.AddCustomButton("Classic Mix",, ObjBindMethod(KontaktKompleteKontrol, "SelectAIPluginClassicMix"))
        SoloOverlay.AddCustomButton("Modern Mix",, ObjBindMethod(KontaktKompleteKontrol, "SelectAIPluginModernMix"))
        Plugin.RegisterOverlay("Kontakt/Komplete Kontrol", SoloOverlay)
        
        TalosOverlay := AccessibilityOverlay("Talos")
        TalosOverlay.Metadata := Map("Vendor", "Audio Imperia", "Product", "Talos", "Image", Map("File", "Images/KontaktKompleteKontrol/Talos.png"))
        TalosOverlay.AddAccessibilityOverlay()
        TalosOverlay.AddStaticText("Talos")
        TalosOverlay.AddCustomButton("Classic Mix",, ObjBindMethod(KontaktKompleteKontrol, "SelectAIPluginClassicMix"))
        TalosOverlay.AddCustomButton("Modern Mix",, ObjBindMethod(KontaktKompleteKontrol, "SelectAIPluginModernMix"))
        Plugin.RegisterOverlay("Kontakt/Komplete Kontrol", TalosOverlay)
        
        Standalone.RegisterOverlay("Komplete Kontrol", KompleteKontrolStandaloneHeader)
        
        Plugin.SetTimer("Kontakt/Komplete Kontrol", ObjBindMethod(AutoChangePluginOverlay,, "Kontakt/Komplete Kontrol", True, True), 500)
        Plugin.SetTimer("Kontakt/Komplete Kontrol", ObjBindMethod(KontaktKompleteKontrol, "DetectPlugin"), 500)
        
    }
    
    Static ActivateKontaktPluginMenuItem(ItemName, ItemNumber, KontaktMenu) {
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
            SendInput KeyCommand
            Sleep 5
        }
    }
    
    Static CloseKKPluginBrowser() {
        If PixelGetColor(CompensatePluginXCoordinate(1002), CompensatePluginYCoordinate(284)) = "0x97999A" {
            AccessibilityOverlay.Speak("Closing KK browser...")
            Click CompensatePluginXCoordinate(1002), CompensatePluginYCoordinate(284)
            Sleep 2500
            If PixelGetColor(CompensatePluginXCoordinate(1002), CompensatePluginYCoordinate(284)) != "0x181818" {
                AccessibilityOverlay.Speak("KK browser could not be closed. Some functions may not work correctly.")
                Sleep 2500
            }
        }
    }
    
    Static DetectPlugin() {
        If FindImage("Images/KontaktKompleteKontrol/KompleteKontrol.png", GetPluginXCoordinate(), GetPluginYCoordinate()) Is Array {
            KontaktKompleteKontrol.LoadPluginHeader("Komplete Kontrol")
            KontaktKompleteKontrol.CloseKKPluginBrowser()
        }
        Else If FindImage("Images/KontaktKompleteKontrol/Kontakt.png", GetPluginXCoordinate(), GetPluginYCoordinate()) Is Array {
            KontaktKompleteKontrol.LoadPluginHeader("Kontakt")
        }
        Else {
            KontaktKompleteKontrol.LoadPluginHeader("Unknown")
        }
    }
    
    Static LoadPluginHeader(PluginName) {
        KompleteKontrolPluginHeader := AccessibilityOverlay("Komplete Kontrol")
        KompleteKontrolPluginHeader.AddStaticText("Komplete Kontrol")
        KompleteKontrolPluginHeader.AddHotspotButton("Menu", CompensatePluginXCoordinate(305), CompensatePluginYCoordinate(68))
        KontaktPluginHeader := AccessibilityOverlay("Kontakt")
        KontaktPluginHeader.AddStaticText("Kontakt")
        KontaktPluginHeader.AddCustomButton("FILE",, ObjBindMethod(KontaktKompleteKontrol, "OpenKontaktPluginFileMenu"))
        KontaktPluginHeader.AddHotspotButton("LIBRARY", CompensatePluginXCoordinate(237), CompensatePluginYCoordinate(70))
        KontaktPluginHeader.AddCustomButton("VIEW",, ObjBindMethod(KontaktKompleteKontrol, "OpenKontaktPluginViewMenu"))
        KontaktPluginHeader.AddHotspotButton("SHOP", CompensatePluginXCoordinate(828), CompensatePluginYCoordinate(70))
        UnknownPluginHeader := AccessibilityOverlay("Unknown")
        UnknownPluginHeader.AddStaticText("Kontakt/Komplete Kontrol")
        UnknownPluginHeader.AddStaticText("Warning! The exact plugin could not be detected. Some functions may not work correctly.")
        If ReaHotkey.FoundPlugin.Overlay.ChildControls[1].Label != PluginName {
            If PluginName = "Komplete Kontrol"
            ReaHotkey.FoundPlugin.Overlay.ChildControls[1] := KompleteKontrolPluginHeader.Clone()
            Else If PluginName = "Kontakt"
            ReaHotkey.FoundPlugin.Overlay.ChildControls[1] := KontaktPluginHeader.Clone()
            Else
            ReaHotkey.FoundPlugin.Overlay.ChildControls[1] := UnknownPluginHeader.Clone()
        }
    }
    
    Static OpenKontaktPluginFileMenu(*) {
        KontaktPurgeThisInstanceMenu := AccessiblePluginMenu()
        KontaktPurgeThisInstanceMenu.Name := "Purge this instance"
        KontaktPurgeThisInstanceMenu.Add("Reset markers", ObjBindMethod(KontaktKompleteKontrol, "ActivateKontaktPluginMenuItem"))
        KontaktPurgeThisInstanceMenu.Add("Update sample pool", ObjBindMethod(KontaktKompleteKontrol, "ActivateKontaktPluginMenuItem"))
        KontaktPurgeThisInstanceMenu.Add("Purge all samples", ObjBindMethod(KontaktKompleteKontrol, "ActivateKontaktPluginMenuItem"))
        KontaktPurgeThisInstanceMenu.Add("Reload all samples", ObjBindMethod(KontaktKompleteKontrol, "ActivateKontaktPluginMenuItem"))
        KontaktPurgeAllInstancesMenu := AccessiblePluginMenu()
        KontaktPurgeAllInstancesMenu.Name := "Purge all instances"
        KontaktPurgeAllInstancesMenu.Add("Reset markers", ObjBindMethod(KontaktKompleteKontrol, "ActivateKontaktPluginMenuItem"))
        KontaktPurgeAllInstancesMenu.Add("Update sample pool", ObjBindMethod(KontaktKompleteKontrol, "ActivateKontaktPluginMenuItem"))
        KontaktPurgeAllInstancesMenu.Add("Purge all samples", ObjBindMethod(KontaktKompleteKontrol, "ActivateKontaktPluginMenuItem"))
        KontaktPurgeAllInstancesMenu.Add("Reload all samples", ObjBindMethod(KontaktKompleteKontrol, "ActivateKontaktPluginMenuItem"))
        KontaktHelpMenu := AccessiblePluginMenu()
        KontaktHelpMenu.Name := "Help"
        KontaktHelpMenu.Add("Launch Native Access", ObjBindMethod(KontaktKompleteKontrol, "ActivateKontaktPluginMenuItem"))
        KontaktHelpMenu.Add("Online Kontakt Documentation", ObjBindMethod(KontaktKompleteKontrol, "ActivateKontaktPluginMenuItem"))
        KontaktHelpMenu.Add("Online Kontakt Scripting Documentation", ObjBindMethod(KontaktKompleteKontrol, "ActivateKontaktPluginMenuItem"))
        KontaktHelpMenu.Add("Online Kontakt API Documentation", ObjBindMethod(KontaktKompleteKontrol, "ActivateKontaktPluginMenuItem"))
        KontaktHelpMenu.Add("Online Knowledge Base", ObjBindMethod(KontaktKompleteKontrol, "ActivateKontaktPluginMenuItem"))
        KontaktHelpMenu.Add("About Kontakt", ObjBindMethod(KontaktKompleteKontrol, "ActivateKontaktPluginMenuItem"))
        KontaktFileMenu := AccessiblePluginMenu()
        KontaktFileMenu.Name := "File"
        KontaktFileMenu.Add("Load...", ObjBindMethod(KontaktKompleteKontrol, "ActivateKontaktPluginMenuItem"))
        ;        KontaktFileMenu.Add("Load recent", ObjBindMethod(KontaktKompleteKontrol, "ActivateKontaktPluginMenuItem"))
        KontaktFileMenu.Add("Save multi as...", ObjBindMethod(KontaktKompleteKontrol, "ActivateKontaktPluginMenuItem"))
        KontaktFileMenu.Add("Reset multi", ObjBindMethod(KontaktKompleteKontrol, "ActivateKontaktPluginMenuItem"))
        KontaktFileMenu.Add("Purge this instance", KontaktPurgeThisInstanceMenu)
        KontaktFileMenu.Add("Purge all instances", KontaktPurgeAllInstancesMenu)
        KontaktFileMenu.Add("Options...", ObjBindMethod(KontaktKompleteKontrol, "ActivateKontaktPluginMenuItem"))
        KontaktFileMenu.Add("Help", KontaktHelpMenu)
        ;        KontaktFileMenu.Disable("Load recent")
        KontaktFileMenu.Show()
    }
    
    Static OpenKontaktPluginViewMenu(*) {
        KontaktViewMenu := AccessiblePluginMenu()
        KontaktViewMenu.Name := "View"
        KontaktViewMenu.Add("Rack View", ObjBindMethod(KontaktKompleteKontrol, "ActivateKontaktPluginMenuItem"))
        KontaktViewMenu.Add("Info", ObjBindMethod(KontaktKompleteKontrol, "ActivateKontaktPluginMenuItem"))
        KontaktViewMenu.Add("Keyboard", ObjBindMethod(KontaktKompleteKontrol, "ActivateKontaktPluginMenuItem"))
        KontaktViewMenu.Add("Quick-Load", ObjBindMethod(KontaktKompleteKontrol, "ActivateKontaktPluginMenuItem"))
        ;        KontaktViewMenu.Add("Zoom", ObjBindMethod(KontaktKompleteKontrol, "ActivateKontaktPluginMenuItem"))
        KontaktViewMenu.Add("Set current view as default", ObjBindMethod(KontaktKompleteKontrol, "ActivateKontaktPluginMenuItem"))
        ;        KontaktViewMenu.Disable("Zoom")
        KontaktViewMenu.Show()
    }
    
    Static ReturnPlugin() {
        If FindImage("Images/KontaktKompleteKontrol/KompleteKontrol.png", GetPluginXCoordinate(), GetPluginYCoordinate()) Is Array
        Return "Komplete Kontrol"
        Else
        If FindImage("Images/KontaktKompleteKontrol/Kontakt.png", GetPluginXCoordinate(), GetPluginYCoordinate()) Is Array
        Return "Kontakt"
        Return False
    }
    
    Static SelectAIPluginClassicMix(*) {
        Product := ""
        If ReaHotkey.FoundPlugin Is Plugin And HasProp(ReaHotkey.FoundPlugin.Overlay, "Metadata") And ReaHotkey.FoundPlugin.Overlay.Metadata.Has("Product") And ReaHotkey.FoundPlugin.Overlay.Metadata["Product"] != ""
        Product := ReaHotkey.FoundPlugin.Overlay.Metadata["Product"]
        Switch(KontaktKompleteKontrol.ReturnPlugin()) {
            Case "Komplete Kontrol":
            Switch(Product) {
                Case "Areia":
                Click CompensatePluginXCoordinate(200), CompensatePluginYCoordinate(461)
                Case "Cerberus":
                Click CompensatePluginXCoordinate(200), CompensatePluginYCoordinate(461)
                Case "Chorus":
                Click CompensatePluginXCoordinate(200), CompensatePluginYCoordinate(461)
                Case "Jaeger":
                Click CompensatePluginXCoordinate(200), CompensatePluginYCoordinate(461)
                Case "Nucleus":
                Click CompensatePluginXCoordinate(226), CompensatePluginYCoordinate(416)
                Case "Solo":
                Click CompensatePluginXCoordinate(200), CompensatePluginYCoordinate(461)
                Case "Talos":
                Click CompensatePluginXCoordinate(200), CompensatePluginYCoordinate(461)
            }
            Case "Kontakt":
            Switch(Product) {
                Case "Areia":
                Click CompensatePluginXCoordinate(100), CompensatePluginYCoordinate(361)
                Case "Cerberus":
                Click CompensatePluginXCoordinate(100), CompensatePluginYCoordinate(361)
                Case "Chorus":
                Click CompensatePluginXCoordinate(100), CompensatePluginYCoordinate(361)
                Case "Jaeger":
                Click CompensatePluginXCoordinate(100), CompensatePluginYCoordinate(361)
                Case "Nucleus":
                Click CompensatePluginXCoordinate(126), CompensatePluginYCoordinate(316)
                Case "Solo":
                Click CompensatePluginXCoordinate(100), CompensatePluginYCoordinate(361)
                Case "Talos":
                Click CompensatePluginXCoordinate(100), CompensatePluginYCoordinate(361)
            }
        }
    }
    
    Static SelectAIPluginModernMix(*) {
        Product := ""
        If ReaHotkey.FoundPlugin Is Plugin And HasProp(ReaHotkey.FoundPlugin.Overlay, "Metadata") And ReaHotkey.FoundPlugin.Overlay.Metadata.Has("Product") And ReaHotkey.FoundPlugin.Overlay.Metadata["Product"] != ""
        Product := ReaHotkey.FoundPlugin.Overlay.Metadata["Product"]
        Switch(KontaktKompleteKontrol.ReturnPlugin()) {
            Case "Komplete Kontrol":
            Switch(Product) {
                Case "Areia":
                Click CompensatePluginXCoordinate(283), CompensatePluginYCoordinate(461)
                Case "Cerberus":
                Click CompensatePluginXCoordinate(283), CompensatePluginYCoordinate(461)
                Case "Chorus":
                Click CompensatePluginXCoordinate(283), CompensatePluginYCoordinate(461)
                Case "Jaeger":
                Click CompensatePluginXCoordinate(283), CompensatePluginYCoordinate(461)
                Case "Nucleus":
                Click CompensatePluginXCoordinate(264), CompensatePluginYCoordinate(446)
                Case "Solo":
                Click CompensatePluginXCoordinate(283), CompensatePluginYCoordinate(461)
                Case "Talos":
                Click CompensatePluginXCoordinate(283), CompensatePluginYCoordinate(461)
            }
            Case "Kontakt":
            Switch(Product) {
                Case "Areia":
                Click CompensatePluginXCoordinate(183), CompensatePluginYCoordinate(361)
                Case "Cerberus":
                Click CompensatePluginXCoordinate(183), CompensatePluginYCoordinate(361)
                Case "Chorus":
                Click CompensatePluginXCoordinate(183), CompensatePluginYCoordinate(361)
                Case "Jaeger":
                Click CompensatePluginXCoordinate(183), CompensatePluginYCoordinate(361)
                Case "Nucleus":
                Click CompensatePluginXCoordinate(164), CompensatePluginYCoordinate(346)
                Case "Solo":
                Click CompensatePluginXCoordinate(183), CompensatePluginYCoordinate(361)
                Case "Talos":
                Click CompensatePluginXCoordinate(183), CompensatePluginYCoordinate(361)
            }
        }
    }
    
}

KontaktKompleteKontrol.Init()
