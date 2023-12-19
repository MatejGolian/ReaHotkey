#Requires AutoHotkey v2.0

Class KontaktKompleteKontrol {
    
    Static Init() {
        
        Plugin.Register("Kontakt/Komplete Kontrol", "^Qt6[0-9][0-9]QWindowIcon\{[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\}1$",, True, True)
        Standalone.Register("Komplete Kontrol", "Komplete Kontrol ahk_class NINormalWindow* ahk_exe Komplete Kontrol.exe")
        Standalone.Register("Komplete Kontrol Preferences", "Preferences ahk_class #32770 ahk_exe Komplete Kontrol.exe", ObjBindMethod(KontaktKompleteKontrol, "FocusKKStandalonePreferenceTab"))
        Standalone.Register("Kontakt", "Kontakt ahk_class NINormalWindow* ahk_exe Kontakt 7.exe")
        
        KKStandaloneHeader := AccessibilityOverlay("Komplete Kontrol")
        KKStandaloneHeader.AddHotspotButton("File menu", 24, 41)
        KKStandaloneHeader.AddHotspotButton("Edit menu", 60, 41)
        KKStandaloneHeader.AddHotspotButton("View menu", 91, 41)
        KKStandaloneHeader.AddHotspotButton("Controller menu", 146, 41)
        KKStandaloneHeader.AddHotspotButton("Help menu", 202, 41)
        
        KKPreferenceOverlay := AccessibilityOverlay()
        KKPreferenceTabControl := KKPreferenceOverlay.AddTabControl()
        KKPreferenceAudioTab := HotspotTab("Audio", 56, 69)
        KKPreferenceAudioTab.AddCustomButton("Close",, ObjBindMethod(KontaktKompleteKontrol, "CloseKKStandalonePreferences"))
        KKPreferenceMIDITab := HotspotTab("MIDI", 56, 114)
        KKPreferenceMIDITab.AddCustomButton("Close",, ObjBindMethod(KontaktKompleteKontrol, "CloseKKStandalonePreferences"))
        KKPreferenceGeneralTab := HotspotTab("General", 56, 155)
        KKPreferenceGeneralTab.AddCustomButton("Close",, ObjBindMethod(KontaktKompleteKontrol, "CloseKKStandalonePreferences"))
        KKPreferenceLibraryTab := HotspotTab("Library", 56, 196)
        KKPreferenceLibraryTabTabControl := KKPreferenceLibraryTab.AddTabControl()
        KKPreferenceLibraryFactoryTab := HotspotTab("Factory", 156, 76)
        KKPreferenceLibraryFactoryTab.AddHotspotButton("Rescan", 546, 417)
        KKPreferenceLibraryUserTab := HotspotTab("User", 240, 76)
        KKPreferenceLibraryUserTab.AddHotspotButton("Add Directory", 170, 420)
        KKPreferenceLibraryUserTab.AddHotspotCheckbox("Scan user content for changes at start-up", 419, 394, "0xC5C5C5", "0x5F5F5F")
        KKPreferenceLibraryUserTab.AddHotspotButton("Rescan", 546, 417)
        KKPreferenceLibraryTabTabControl.AddTabs(KKPreferenceLibraryFactoryTab, KKPreferenceLibraryUserTab)
        KKPreferenceLibraryTab.AddCustomButton("Close",, ObjBindMethod(KontaktKompleteKontrol, "CloseKKStandalonePreferences"))
        KKPreferencePluginTab := HotspotTab("Plug-ins", 56, 237)
        KKPreferencePluginTab.AddHotspotCheckbox("Always Use Latest Version Of NI Plug-ins", 419, 394, "0xC5C5C5", "0x5F5F5F")
        KKPreferencePluginTab.AddHotspotButton("Rescan", 546, 417)
        KKPreferencePluginTab.AddCustomButton("Close",, ObjBindMethod(KontaktKompleteKontrol, "CloseKKStandalonePreferences"))
        KKPreferenceTabControl.AddTabs(KKPreferenceAudioTab, KKPreferenceMIDITab, KKPreferenceGeneralTab, KKPreferenceLibraryTab, KKPreferencePluginTab)
        
        KontaktStandaloneHeader := AccessibilityOverlay("Kontakt")
        KontaktStandaloneHeader.AddCustomButton("FILE menu", ObjBindMethod(KontaktKompleteKontrol, "FocusKontaktStandaloneMenu"), ObjBindMethod(KontaktKompleteKontrol, "ActivateKontaktStandaloneMenu"))
        ; Removed because further investigation of usefulness is needed: KontaktStandaloneHeader.AddCustomButton("LIBRARY menu", ObjBindMethod(KontaktKompleteKontrol, "FocusKontaktStandaloneMenu"), ObjBindMethod(KontaktKompleteKontrol, "ActivateKontaktStandaloneMenu"))
        KontaktStandaloneHeader.AddCustomButton("VIEW menu", ObjBindMethod(KontaktKompleteKontrol, "FocusKontaktStandaloneMenu"), ObjBindMethod(KontaktKompleteKontrol, "ActivateKontaktStandaloneMenu"))
        KontaktStandaloneHeader.AddCustomButton("SHOP (Opens in default web browser)", ObjBindMethod(KontaktKompleteKontrol, "FocusKontaktStandaloneMenu"), ObjBindMethod(KontaktKompleteKontrol, "ActivateKontaktStandaloneMenu"))
        
        NoProductOverlay := AccessibilityOverlay("None")
        NoProductOverlay.Metadata := Map("Product", "None")
        NoProductOverlay.AddAccessibilityOverlay()
        Plugin.RegisterOverlay("Kontakt/Komplete Kontrol", NoProductOverlay)
        
        AreiaOverlay := AccessibilityOverlay("Areia")
        AreiaOverlay.Metadata := Map("Vendor", "Audio Imperia", "Product", "Areia", "Image", Map("File", "Images/KontaktKompleteKontrol/Areia.png"))
        AreiaOverlay.AddAccessibilityOverlay()
        AreiaOverlay.AddStaticText("Areia")
        AreiaOverlay.AddCustomButton("Classic Mix", ObjBindMethod(KontaktKompleteKontrol, "FocusAIPluginClassicMix"), ObjBindMethod(KontaktKompleteKontrol, "ActivateAIPluginClassicMix"))
        AreiaOverlay.AddCustomButton("Modern Mix", ObjBindMethod(KontaktKompleteKontrol, "FocusAIPluginModernMix"), ObjBindMethod(KontaktKompleteKontrol, "ActivateAIPluginModernMix"))
        Plugin.RegisterOverlay("Kontakt/Komplete Kontrol", AreiaOverlay)
        
        CerberusOverlay := AccessibilityOverlay("Cerberus")
        CerberusOverlay.Metadata := Map("Vendor", "Audio Imperia", "Product", "Cerberus", "Image", Map("File", "Images/KontaktKompleteKontrol/Cerberus.png"))
        CerberusOverlay.AddAccessibilityOverlay()
        CerberusOverlay.AddStaticText("Cerberus")
        CerberusComboBox := CerberusOverlay.AddCustomComboBox("Patch type:", ObjBindMethod(KontaktKompleteKontrol, "SelectAIPluginCerberusPatchType"), ObjBindMethod(KontaktKompleteKontrol, "SelectAIPluginCerberusPatchType"))
        CerberusComboBox.SetOptions(["Normal", "Epic Mix"])
        CerberusOverlay.AddAccessibilityOverlay()
        CerberusOverlay.AddCustomControl(ObjBindMethod(KontaktKompleteKontrol, "RedirectAIPluginCerberusKeyPress"))
        Plugin.RegisterOverlay("Kontakt/Komplete Kontrol", CerberusOverlay)
        
        ChorusOverlay := AccessibilityOverlay("Chorus")
        ChorusOverlay.Metadata := Map("Vendor", "Audio Imperia", "Product", "Chorus", "Image", Map("File", "Images/KontaktKompleteKontrol/Chorus.png"))
        ChorusOverlay.AddAccessibilityOverlay()
        ChorusOverlay.AddStaticText("Chorus")
        ChorusOverlay.AddCustomButton("Classic Mix", ObjBindMethod(KontaktKompleteKontrol, "FocusAIPluginClassicMix"), ObjBindMethod(KontaktKompleteKontrol, "ActivateAIPluginClassicMix"))
        ChorusOverlay.AddCustomButton("Modern Mix", ObjBindMethod(KontaktKompleteKontrol, "FocusAIPluginModernMix"), ObjBindMethod(KontaktKompleteKontrol, "ActivateAIPluginModernMix"))
        Plugin.RegisterOverlay("Kontakt/Komplete Kontrol", ChorusOverlay)
        
        JaegerOverlay := AccessibilityOverlay("Jaeger")
        JaegerOverlay.Metadata := Map("Vendor", "Audio Imperia", "Product", "Jaeger", "Image", Map("File", "Images/KontaktKompleteKontrol/Jaeger.png"))
        JaegerOverlay.AddAccessibilityOverlay()
        JaegerOverlay.AddStaticText("Jaeger")
        JaegerOverlay.AddCustomButton("Classic Mix", ObjBindMethod(KontaktKompleteKontrol, "FocusAIPluginClassicMix"), ObjBindMethod(KontaktKompleteKontrol, "ActivateAIPluginClassicMix"))
        JaegerOverlay.AddCustomButton("Modern Mix", ObjBindMethod(KontaktKompleteKontrol, "FocusAIPluginModernMix"), ObjBindMethod(KontaktKompleteKontrol, "ActivateAIPluginModernMix"))
        Plugin.RegisterOverlay("Kontakt/Komplete Kontrol", JaegerOverlay)
        
        NucleusOverlay := AccessibilityOverlay("Nucleus")
        NucleusOverlay.Metadata := Map("Vendor", "Audio Imperia", "Product", "Nucleus", "Image", Map("File", "Images/KontaktKompleteKontrol/Nucleus.png"))
        NucleusOverlay.AddAccessibilityOverlay()
        NucleusOverlay.AddStaticText("Nucleus")
        NucleusOverlay.AddCustomButton("Classic Mix", ObjBindMethod(KontaktKompleteKontrol, "FocusAIPluginClassicMix"), ObjBindMethod(KontaktKompleteKontrol, "ActivateAIPluginClassicMix"))
        NucleusOverlay.AddCustomButton("Modern Mix", ObjBindMethod(KontaktKompleteKontrol, "FocusAIPluginModernMix"), ObjBindMethod(KontaktKompleteKontrol, "ActivateAIPluginModernMix"))
        Plugin.RegisterOverlay("Kontakt/Komplete Kontrol", NucleusOverlay)
        
        SoloOverlay := AccessibilityOverlay("Solo")
        SoloOverlay.Metadata := Map("Vendor", "Audio Imperia", "Product", "Solo", "Image", Map("File", "Images/KontaktKompleteKontrol/Solo.png"))
        SoloOverlay.AddAccessibilityOverlay()
        SoloOverlay.AddStaticText("Solo")
        SoloOverlay.AddCustomButton("Classic Mix", ObjBindMethod(KontaktKompleteKontrol, "FocusAIPluginClassicMix"), ObjBindMethod(KontaktKompleteKontrol, "ActivateAIPluginClassicMix"))
        SoloOverlay.AddCustomButton("Modern Mix", ObjBindMethod(KontaktKompleteKontrol, "FocusAIPluginModernMix"), ObjBindMethod(KontaktKompleteKontrol, "ActivateAIPluginModernMix"))
        Plugin.RegisterOverlay("Kontakt/Komplete Kontrol", SoloOverlay)
        
        TalosOverlay := AccessibilityOverlay("Talos")
        TalosOverlay.Metadata := Map("Vendor", "Audio Imperia", "Product", "Talos", "Image", Map("File", "Images/KontaktKompleteKontrol/Talos.png"))
        TalosOverlay.AddAccessibilityOverlay()
        TalosOverlay.AddStaticText("Talos")
        TalosOverlay.AddCustomButton("Classic Mix", ObjBindMethod(KontaktKompleteKontrol, "FocusAIPluginClassicMix"), ObjBindMethod(KontaktKompleteKontrol, "ActivateAIPluginClassicMix"))
        TalosOverlay.AddCustomButton("Modern Mix", ObjBindMethod(KontaktKompleteKontrol, "FocusAIPluginModernMix"), ObjBindMethod(KontaktKompleteKontrol, "ActivateAIPluginModernMix"))
        Plugin.RegisterOverlay("Kontakt/Komplete Kontrol", TalosOverlay)
        
        Plugin.SetTimer("Kontakt/Komplete Kontrol", ObjBindMethod(KontaktKompleteKontrol, "DetectPlugin"), 500)
        Plugin.SetTimer("Kontakt/Komplete Kontrol", ObjBindMethod(AutoChangePluginOverlay,, "Kontakt/Komplete Kontrol", True, True), 500)
        
        Standalone.RegisterOverlay("Komplete Kontrol", KKStandaloneHeader)
        Standalone.RegisterOverlay("Komplete Kontrol Preferences", KKPreferenceOverlay)
        Standalone.RegisterOverlay("Kontakt", KontaktStandaloneHeader)
        
        Standalone.SetHotkey("Komplete Kontrol Preferences", "^,", ObjBindMethod(KontaktKompleteKontrol, "ManageKKStandalonePreferenceWindow"))
        
    }
    
    Static ActivateAIPluginClassicMix(MixButton) {
        Product := ""
        ParentOverlay := MixButton.GetSuperordinateControl()
        If HasProp(ParentOverlay, "Metadata") And ParentOverlay.Metadata.Has("Product") And ParentOverlay.Metadata["Product"] != ""
        Product := ParentOverlay.Metadata["Product"]
        KontaktKompleteKontrol.MoveToOrClickAIPluginClassicMix(Product, "Click")
    }
    
    Static ActivateAIPluginModernMix(MixButton) {
        Product := ""
        ParentOverlay := MixButton.GetSuperordinateControl()
        If HasProp(ParentOverlay, "Metadata") And ParentOverlay.Metadata.Has("Product") And ParentOverlay.Metadata["Product"] != ""
        Product := ParentOverlay.Metadata["Product"]
        KontaktKompleteKontrol.MoveToOrClickAIPluginModernMix(Product, "Click")
    }
    
    Static ActivateKontaktPluginMenu(MenuButton) {
        MenuLabel := StrSplit(MenuButton.Label, A_Space)
        MenuLabel := MenuLabel[1]
        KontaktKompleteKontrol.MoveToOrClickKontaktMenu("LIBRARY", GetPluginXCoordinate() + 80, GetPluginYCoordinate(), GetPluginXCoordinate() + 1200, GetPluginYCoordinate() + 120, "MouseMove")
        Result := KontaktKompleteKontrol.MoveToOrClickKontaktMenu(MenuLabel, GetPluginXCoordinate() + 80, GetPluginYCoordinate(), GetPluginXCoordinate() + 1200, GetPluginYCoordinate() + 120, "Click")
        If Result = 1 {
            If MenuLabel = "FILE" Or MenuLabel = "VIEW"
            KontaktKompleteKontrol.OpenKontaktPluginMenu()
        }
        Else If Result = 0 {
            AccessibilityOverlay.Speak("Item not found")
        }
        Else {
            AccessibilityOverlay.Speak("OCR not available")
        }
    }
    
    Static ActivateKontaktStandaloneMenu(MenuButton) {
        MenuLabel := StrSplit(MenuButton.Label, A_Space)
        MenuLabel := MenuLabel[1]
        Result := KontaktKompleteKontrol.MoveToOrClickKontaktMenu(MenuLabel, 80, 0, 1200, 120, "Click")
        If Result = 1 {
            If MenuLabel = "FILE" Or MenuLabel = "VIEW"
            KontaktKompleteKontrol.OpenKontaktStandaloneMenu()
        }
        Else If Result = 0 {
            AccessibilityOverlay.Speak("Item not found")
        }
        Else {
            AccessibilityOverlay.Speak("OCR not available")
        }
    }
    
    Static CloseKKPluginBrowser() {
        If PixelGetColor(CompensatePluginXCoordinate(1002), CompensatePluginYCoordinate(284)) = "0x97999A" Or PixelGetColor(CompensatePluginXCoordinate(1002), CompensatePluginYCoordinate(284)) = "0x6E8192" {
            Click CompensatePluginXCoordinate(1002), CompensatePluginYCoordinate(284)
            Sleep 2500
            If PixelGetColor(CompensatePluginXCoordinate(1002), CompensatePluginYCoordinate(284)) != "0x181818" {
                AccessibilityOverlay.Speak("KK browser could not be closed. Some functions may not work correctly.")
                Sleep 2500
            }
            Else {
                AccessibilityOverlay.Speak("KK browser closed.")
                Sleep 2500
            }
        }
    }
    
    Static CloseKKStandalonePreferences(*) {
        WinClose("Preferences ahk_class #32770 ahk_exe Komplete Kontrol.exe")
    }
    
    Static DetectPlugin() {
        SetTimer ReaHotkey.ManageState, 0
        If FindImage("Images/KontaktKompleteKontrol/KompleteKontrol.png", GetPluginXCoordinate(), GetPluginYCoordinate()) Is Array {
            KontaktKompleteKontrol.LoadPluginHeader("Komplete Kontrol")
            KontaktKompleteKontrol.CloseKKPluginBrowser()
        }
        Else If FindImage("Images/KontaktKompleteKontrol/Kontakt.png", GetPluginXCoordinate(), GetPluginYCoordinate()) Is Array {
            KontaktKompleteKontrol.LoadPluginHeader("Kontakt")
        }
        Else If FindImage("Images/KontaktKompleteKontrol/KontaktPlayer.png", GetPluginXCoordinate(), GetPluginYCoordinate()) Is Array {
            KontaktKompleteKontrol.LoadPluginHeader("Kontakt Player")
        }
        Else {
            KontaktKompleteKontrol.LoadPluginHeader("Unknown")
        }
        SetTimer ReaHotkey.ManageState, 100
    }
    
    Static FocusAIPluginClassicMix(MixButton) {
        Product := ""
        ParentOverlay := MixButton.GetSuperordinateControl()
        If HasProp(ParentOverlay, "Metadata") And ParentOverlay.Metadata.Has("Product") And ParentOverlay.Metadata["Product"] != ""
        Product := ParentOverlay.Metadata["Product"]
        KontaktKompleteKontrol.MoveToOrClickAIPluginClassicMix(Product, "MouseMove")
    }
    
    Static FocusAIPluginModernMix(MixButton) {
        Product := ""
        ParentOverlay := MixButton.GetSuperordinateControl()
        If HasProp(ParentOverlay, "Metadata") And ParentOverlay.Metadata.Has("Product") And ParentOverlay.Metadata["Product"] != ""
        Product := ParentOverlay.Metadata["Product"]
        KontaktKompleteKontrol.MoveToOrClickAIPluginModernMix(Product, "MouseMove")
    }
    
    Static FocusKKStandalonePreferenceTab(KKInstance) {
        Sleep 1000
        If KKInstance.Overlay.CurrentControlID = 0
        KKInstance.Overlay.Focus()
    }
    
    Static FocusKontaktPluginMenu(MenuButton) {
        MenuLabel := StrSplit(MenuButton.Label, A_Space)
        MenuLabel := MenuLabel[1]
        KontaktKompleteKontrol.MoveToOrClickKontaktMenu("LIBRARY", GetPluginXCoordinate() + 80, GetPluginYCoordinate(), GetPluginXCoordinate() + 1200, GetPluginYCoordinate() + 120, "MouseMove")
        KontaktKompleteKontrol.MoveToOrClickKontaktMenu(MenuLabel, GetPluginXCoordinate() + 80, GetPluginYCoordinate(), GetPluginXCoordinate() + 1200, GetPluginYCoordinate() + 120, "MouseMove")
    }
    
    Static FocusKontaktStandaloneMenu(MenuButton) {
        MenuLabel := StrSplit(MenuButton.Label, A_Space)
        MenuLabel := MenuLabel[1]
        KontaktKompleteKontrol.MoveToOrClickKontaktMenu(MenuLabel, 80, 0, 1200, 120, "MouseMove")
    }
    
    Static GetPluginName() {
        If FindImage("Images/KontaktKompleteKontrol/KompleteKontrol.png", GetPluginXCoordinate(), GetPluginYCoordinate()) Is Array
        Return "Komplete Kontrol"
        Else If FindImage("Images/KontaktKompleteKontrol/Kontakt.png", GetPluginXCoordinate(), GetPluginYCoordinate()) Is Array
        Return "Kontakt"
        Else
        If FindImage("Images/KontaktKompleteKontrol/KontaktPlayer.png", GetPluginXCoordinate(), GetPluginYCoordinate()) Is Array
        Return "Kontakt"
        Return False
    }
    
    Static LoadPluginHeader(HeaderLabel) {
        KKPluginHeader := AccessibilityOverlay("Komplete Kontrol")
        KKPluginHeader.AddStaticText("Komplete Kontrol")
        KKPluginHeader.AddHotspotButton("Menu", 305, 68, CompensatePluginPointCoordinates, CompensatePluginPointCoordinates)
        KontaktPluginHeader := AccessibilityOverlay("Kontakt")
        KontaktPluginHeader.AddStaticText("Kontakt")
        KontaktPluginHeader.AddCustomButton("FILE menu", ObjBindMethod(KontaktKompleteKontrol, "FocusKontaktPluginMenu"), ObjBindMethod(KontaktKompleteKontrol, "ActivateKontaktPluginMenu"))
        ; Removed because further investigation of usefulness is needed: KontaktPluginHeader.AddCustomButton("LIBRARY menu", ObjBindMethod(KontaktKompleteKontrol, "FocusKontaktPluginMenu"), ObjBindMethod(KontaktKompleteKontrol, "ActivateKontaktPluginMenu"))
        KontaktPluginHeader.AddCustomButton("VIEW menu", ObjBindMethod(KontaktKompleteKontrol, "FocusKontaktPluginMenu"), ObjBindMethod(KontaktKompleteKontrol, "ActivateKontaktPluginMenu"))
        KontaktPluginHeader.AddCustomButton("SHOP (Opens in default web browser)", ObjBindMethod(KontaktKompleteKontrol, "FocusKontaktPluginMenu"), ObjBindMethod(KontaktKompleteKontrol, "ActivateKontaktPluginMenu"))
        KontaktPlayerPluginHeader := AccessibilityOverlay("Kontakt Player")
        KontaktPlayerPluginHeader.AddStaticText("Kontakt Player")
        KontaktPlayerPluginHeader.AddCustomButton("FILE menu", ObjBindMethod(KontaktKompleteKontrol, "FocusKontaktPluginMenu"), ObjBindMethod(KontaktKompleteKontrol, "ActivateKontaktPluginMenu"))
        ; Removed because further investigation of usefulness is needed: KontaktPlayerPluginHeader.AddCustomButton("LIBRARY menu", ObjBindMethod(KontaktKompleteKontrol, "FocusKontaktPluginMenu"), ObjBindMethod(KontaktKompleteKontrol, "ActivateKontaktPluginMenu"))
        KontaktPlayerPluginHeader.AddCustomButton("VIEW menu", ObjBindMethod(KontaktKompleteKontrol, "FocusKontaktPluginMenu"), ObjBindMethod(KontaktKompleteKontrol, "ActivateKontaktPluginMenu"))
        KontaktPlayerPluginHeader.AddCustomButton("SHOP (Opens in default web browser)", ObjBindMethod(KontaktKompleteKontrol, "FocusKontaktPluginMenu"), ObjBindMethod(KontaktKompleteKontrol, "ActivateKontaktPluginMenu"))
        UnknownPluginHeader := AccessibilityOverlay("Unknown")
        UnknownPluginHeader.AddStaticText("Kontakt/Komplete Kontrol")
        UnknownPluginHeader.AddStaticText("Warning! The exact plugin could not be detected. Some functions may not work correctly.")
        If ReaHotkey.FoundPlugin Is Plugin And Not HasProp(ReaHotkey.FoundPlugin.Overlay, "Metadata") {
            ReaHotkey.FoundPlugin.Overlay.Metadata := Map("Product", "None")
            ReaHotkey.FoundPlugin.Overlay.OverlayNumber := 1
        }
        If ReaHotkey.FoundPlugin Is Plugin And ReaHotkey.FoundPlugin.Overlay.ChildControls[1].Label != HeaderLabel {
            If HeaderLabel = "Komplete Kontrol"
            ReaHotkey.FoundPlugin.Overlay.ChildControls[1] := KKPluginHeader.Clone()
            Else If HeaderLabel = "Kontakt"
            ReaHotkey.FoundPlugin.Overlay.ChildControls[1] := KontaktPluginHeader.Clone()
            Else If HeaderLabel = "Kontakt Player"
            ReaHotkey.FoundPlugin.Overlay.ChildControls[1] := KontaktPlayerPluginHeader.Clone()
            Else
            ReaHotkey.FoundPlugin.Overlay.ChildControls[1] := UnknownPluginHeader.Clone()
        }
    }
    
    Static ManageKKStandalonePreferenceWindow(*) {
        If WinActive("Preferences ahk_class #32770 ahk_exe Komplete Kontrol.exe") {
            WinClose("Preferences ahk_class #32770 ahk_exe Komplete Kontrol.exe")
        }
        Else If WinActive("Komplete Kontrol ahk_class NINormalWindow* ahk_exe Komplete Kontrol.exe") And Not WinExist("Preferences ahk_class #32770 ahk_exe Komplete Kontrol.exe") {
            Hotkey "^,", "Off"
            Send "^,"
        }
        Else {
            If WinExist("Preferences ahk_class #32770 ahk_exe Komplete Kontrol.exe") And Not WinActive("Preferences ahk_class #32770 ahk_exe Komplete Kontrol.exe")
            WinActivate("Preferences ahk_class #32770 ahk_exe Komplete Kontrol.exe")
        }
    }
    
    Static MoveToOrClickAIPluginClassicMix(Product, MoveOrClick) {
        Switch(KontaktKompleteKontrol.GetPluginName()) {
            Case "Komplete Kontrol":
            Switch(Product) {
                Case "Areia":
                %MoveOrClick%(CompensatePluginXCoordinate(200), CompensatePluginYCoordinate(461))
                Case "Chorus":
                %MoveOrClick%(CompensatePluginXCoordinate(200), CompensatePluginYCoordinate(461))
                Case "Jaeger":
                %MoveOrClick%(CompensatePluginXCoordinate(200), CompensatePluginYCoordinate(461))
                Case "Nucleus":
                %MoveOrClick%(CompensatePluginXCoordinate(226), CompensatePluginYCoordinate(416))
                Case "Solo":
                %MoveOrClick%(CompensatePluginXCoordinate(200), CompensatePluginYCoordinate(461))
                Case "Talos":
                %MoveOrClick%(CompensatePluginXCoordinate(200), CompensatePluginYCoordinate(461))
            }
            Case "Kontakt":
            Switch(Product) {
                Case "Areia":
                %MoveOrClick%(CompensatePluginXCoordinate(100), CompensatePluginYCoordinate(361))
                Case "Chorus":
                %MoveOrClick%(CompensatePluginXCoordinate(100), CompensatePluginYCoordinate(361))
                Case "Jaeger":
                %MoveOrClick%(CompensatePluginXCoordinate(100), CompensatePluginYCoordinate(361))
                Case "Nucleus":
                %MoveOrClick%(CompensatePluginXCoordinate(126), CompensatePluginYCoordinate(316))
                Case "Solo":
                %MoveOrClick%(CompensatePluginXCoordinate(100), CompensatePluginYCoordinate(361))
                Case "Talos":
                %MoveOrClick%(CompensatePluginXCoordinate(100), CompensatePluginYCoordinate(361))
            }
        }
    }
    
    Static MoveToOrClickAIPluginModernMix(Product, MoveOrClick) {
        Switch(KontaktKompleteKontrol.GetPluginName()) {
            Case "Komplete Kontrol":
            Switch(Product) {
                Case "Areia":
                %MoveOrClick%(CompensatePluginXCoordinate(283), CompensatePluginYCoordinate(461))
                Case "Chorus":
                %MoveOrClick%(CompensatePluginXCoordinate(283), CompensatePluginYCoordinate(461))
                Case "Jaeger":
                %MoveOrClick%(CompensatePluginXCoordinate(283), CompensatePluginYCoordinate(461))
                Case "Nucleus":
                %MoveOrClick%(CompensatePluginXCoordinate(264), CompensatePluginYCoordinate(446))
                Case "Solo":
                %MoveOrClick%(CompensatePluginXCoordinate(283), CompensatePluginYCoordinate(461))
                Case "Talos":
                %MoveOrClick%(CompensatePluginXCoordinate(283), CompensatePluginYCoordinate(461))
            }
            Case "Kontakt":
            Switch(Product) {
                Case "Areia":
                %MoveOrClick%(CompensatePluginXCoordinate(183), CompensatePluginYCoordinate(361))
                Case "Chorus":
                %MoveOrClick%(CompensatePluginXCoordinate(183), CompensatePluginYCoordinate(361))
                Case "Jaeger":
                %MoveOrClick%(CompensatePluginXCoordinate(183), CompensatePluginYCoordinate(361))
                Case "Nucleus":
                %MoveOrClick%(CompensatePluginXCoordinate(164), CompensatePluginYCoordinate(346))
                Case "Solo":
                %MoveOrClick%(CompensatePluginXCoordinate(183), CompensatePluginYCoordinate(361))
                Case "Talos":
                %MoveOrClick%(CompensatePluginXCoordinate(183), CompensatePluginYCoordinate(361))
            }
        }
    }
    
    Static MoveToOrClickKontaktMenu(MenuLabel, CropX1, CropY1, CropX2, CropY2, MoveOrClick) {
        AvailableLanguages := OCR.GetAvailableLanguages()
        FirstAvailableLanguage := False
        FirstOCRLanguage := False
        PreferredLanguage := False
        PreferredOCRLanguage := ""
        Loop Parse, AvailableLanguages, "`n" {
            If A_Index = 1 And A_LoopField != "" {
                FirstAvailableLanguage := True
                FirstOCRLanguage := A_LoopField
            }
            If SubStr(A_LoopField, 1, 3) = "en-" {
                PreferredLanguage := True
                PreferredOCRLanguage := A_LoopField
                Break
            }
        }
        If FirstAvailableLanguage = False And PreferredLanguage = False
        Return -1
        Else If PreferredLanguage = False
        OCRLanguage := FirstOCRLanguage
        Else
        OCRLanguage := PreferredOCRLanguage
        OCRResult := OCR.FromWindow("A", OCRLanguage)
        OCRResult := OCRResult.Crop(CropX1, CropY1, CropX2, CropY2)
        For OCRLine In OCRResult.Lines
        If RegExMatch(OCRLine.Text, "^(.*)(" . MenuLabel . ")(.*)$") {
            LineWidth := 0
            For OCRWord In OCRLine.Words
            LineWidth += OCRWord.BoundingRect.W
            %MoveOrClick%(floor(OCRLine.Words[1].BoundingRect.X + (LineWidth / 2)), Floor(OCRLine.Words[1].BoundingRect.Y + (OCRLine.Words[1].BoundingRect.H / 2)))
            Return 1
        }
        Return 0
    }
    
    Static OpenKontaktMenu() {
        Loop {
            KeyCombo := KeyWaitCombo()
            If KeyCombo = "+Tab" {
                SendInput "+{Tab}"
            }
            Else If KeyCombo = "!F4" {
                SendInput "{Escape}"
                SendInput "!{F4}"
                Break
            }
            Else {
                SingleKey := KeyWaitSingle()
                If GetKeyState("Shift") And SingleKey = "Tab" {
                    SendInput "+{Tab}"
                }
                Else If GetKeyState("Alt") And SingleKey = "F4" {
                    SendInput "{Escape}"
                    SendInput "!{F4}"
                    Break
                }
                Else {
                    If SingleKey != "Left" And SingleKey != "Right" And SingleKey != "Up" And SingleKey != "Down" {
                        SendInput "{" . SingleKey . "}"
                    }
                }
                If SingleKey = "Escape"
                Break
            }
        }
    }
    
    Static OpenKontaktPluginMenu() {
        SetTimer ReaHotkey.ManageState, 0
        ReaHotkey.TurnPluginHotkeysOff()
        ReaHotkey.TurnPluginTimersOff("Kontakt/Komplete Kontrol")
        KontaktKompleteKontrol.OpenKontaktMenu()
        SetTimer ReaHotkey.ManageState, 100
    }
    
    Static OpenKontaktStandaloneMenu() {
        SetTimer ReaHotkey.ManageState, 0
        ReaHotkey.TurnStandaloneHotkeysOff()
        ReaHotkey.TurnStandaloneTimersOff("Kontakt")
        KontaktKompleteKontrol.OpenKontaktMenu()
        SetTimer ReaHotkey.ManageState, 100
    }
    
    Static RedirectAIPluginCerberusKeyPress(OverlayControl) {
        ParentOverlay := OverlayControl.GetSuperordinateControl()
        MasterOverlay := ParentOverlay.GetSuperordinateControl()
        If A_PriorHotkey = "+Tab" {
            TypeCombo := ParentOverlay.ChildControls[3]
            KontaktKompleteKontrol.SelectAIPluginCerberusPatchType(TypeCombo)
            MasterOverlay.FocusPreviousControl()
        }
        Else If GetKeyState("Shift") And A_PriorHotkey = "Tab" {
            TypeCombo := ParentOverlay.ChildControls[3]
            KontaktKompleteKontrol.SelectAIPluginCerberusPatchType(TypeCombo)
            MasterOverlay.FocusPreviousControl()
        }
        Else {
            If A_PriorHotkey = "Tab" {
                MasterOverlay.FocusNextControl()
            }
        }
    }
    
    Static SelectAIPluginCerberusPatchType(TypeCombo) {
        ParentOverlay := TypeCombo.GetSuperordinateControl()
        If TypeCombo.GetValue() = "Normal" {
            ChildOverlay := AccessibilityOverlay()
            If KontaktKompleteKontrol.GetPluginName() = "Komplete Kontrol" {
                ChildOverlay.AddHotspotButton("C", 326, 464, CompensatePluginPointCoordinates, CompensatePluginPointCoordinates)
                ChildOverlay.AddHotspotButton("M", 335, 464, CompensatePluginPointCoordinates, CompensatePluginPointCoordinates)
            }
            Else If KontaktKompleteKontrol.GetPluginName() = "Kontakt" {
                ChildOverlay.AddHotspotButton("C", 216, 364, CompensatePluginPointCoordinates, CompensatePluginPointCoordinates)
                ChildOverlay.AddHotspotButton("M", 235, 364, CompensatePluginPointCoordinates, CompensatePluginPointCoordinates)
            }
            Else {
                ChildOverlay.AddStaticText("Mix choices not available")
            }
            ParentOverlay.ChildControls[4] := ChildOverlay
        }
        Else If TypeCombo.GetValue() = "Epic Mix" {
            ChildOverlay := AccessibilityOverlay()
            If KontaktKompleteKontrol.GetPluginName() = "Komplete Kontrol" {
                ChildOverlay.AddHotspotButton("C", 221, 464, CompensatePluginPointCoordinates, CompensatePluginPointCoordinates)
                ChildOverlay.AddHotspotButton("F", 251, 464, CompensatePluginPointCoordinates, CompensatePluginPointCoordinates)
                ChildOverlay.AddHotspotButton("R", 281, 464, CompensatePluginPointCoordinates, CompensatePluginPointCoordinates)
            }
            Else If KontaktKompleteKontrol.GetPluginName() = "Kontakt" {
                ChildOverlay.AddHotspotButton("C", 121, 364, CompensatePluginPointCoordinates, CompensatePluginPointCoordinates)
                ChildOverlay.AddHotspotButton("F", 151, 364, CompensatePluginPointCoordinates, CompensatePluginPointCoordinates)
                ChildOverlay.AddHotspotButton("R", 181, 364, CompensatePluginPointCoordinates, CompensatePluginPointCoordinates)
            }
            Else {
                ChildOverlay.AddStaticText("Mix choices not available")
            }
            ParentOverlay.ChildControls[4] := ChildOverlay
        }
        Else {
            ChildOverlay := AccessibilityOverlay()
            ChildOverlay.AddStaticText("Invalid patch type")
            ParentOverlay.ChildControls[4] := ChildOverlay
        }
    }
    
}

KontaktKompleteKontrol.Init()
