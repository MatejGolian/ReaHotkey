#Requires AutoHotkey v2.0

Class KontaktKompleteKontrol {
    
    Static PluginOverlays := Array()
    Static StandaloneOverlays := Array()
    
    Static __New() {
        NoProductOverlay := AccessibilityOverlay("None")
        NoProductOverlay.Metadata := Map("Product", "None")
        NoProductOverlay.AddAccessibilityOverlay()
        KontaktKompleteKontrol.PluginOverlays.Push(NoProductOverlay)
        
        AreiaOverlay := AccessibilityOverlay("Areia")
        AreiaOverlay.Metadata := Map("Vendor", "Audio Imperia", "Product", "Areia", "Image", Map("File", "Images/KontaktKompleteKontrol/Areia.png"))
        AreiaOverlay.AddAccessibilityOverlay()
        AreiaOverlay.AddStaticText("Areia")
        AreiaOverlay.AddCustomButton("Classic Mix", ObjBindMethod(KontaktKompleteKontrol, "FocusAIPluginClassicMix"), ObjBindMethod(KontaktKompleteKontrol, "ActivateAIPluginClassicMix"))
        AreiaOverlay.AddCustomButton("Modern Mix", ObjBindMethod(KontaktKompleteKontrol, "FocusAIPluginModernMix"), ObjBindMethod(KontaktKompleteKontrol, "ActivateAIPluginModernMix"))
        KontaktKompleteKontrol.PluginOverlays.Push(AreiaOverlay)
        
        CerberusOverlay := AccessibilityOverlay("Cerberus")
        CerberusOverlay.Metadata := Map("Vendor", "Audio Imperia", "Product", "Cerberus", "Image", Map("File", "Images/KontaktKompleteKontrol/Cerberus.png"))
        CerberusOverlay.AddAccessibilityOverlay()
        CerberusOverlay.AddStaticText("Cerberus")
        CerberusComboBox := CerberusOverlay.AddCustomComboBox("Patch type:", ObjBindMethod(KontaktKompleteKontrol, "SelectAIPluginCerberusPatchType"), ObjBindMethod(KontaktKompleteKontrol, "SelectAIPluginCerberusPatchType"))
        CerberusComboBox.SetOptions(["Normal", "Epic Mix"])
        CerberusOverlay.AddAccessibilityOverlay()
        CerberusOverlay.AddCustomControl(ObjBindMethod(KontaktKompleteKontrol, "RedirectAIPluginCerberusKeyPress"))
        KontaktKompleteKontrol.PluginOverlays.Push(CerberusOverlay)
        
        ChorusOverlay := AccessibilityOverlay("Chorus")
        ChorusOverlay.Metadata := Map("Vendor", "Audio Imperia", "Product", "Chorus", "Image", Map("File", "Images/KontaktKompleteKontrol/Chorus.png"))
        ChorusOverlay.AddAccessibilityOverlay()
        ChorusOverlay.AddStaticText("Chorus")
        ChorusOverlay.AddCustomButton("Classic Mix", ObjBindMethod(KontaktKompleteKontrol, "FocusAIPluginClassicMix"), ObjBindMethod(KontaktKompleteKontrol, "ActivateAIPluginClassicMix"))
        ChorusOverlay.AddCustomButton("Modern Mix", ObjBindMethod(KontaktKompleteKontrol, "FocusAIPluginModernMix"), ObjBindMethod(KontaktKompleteKontrol, "ActivateAIPluginModernMix"))
        KontaktKompleteKontrol.PluginOverlays.Push(ChorusOverlay)
        
        JaegerOverlay := AccessibilityOverlay("Jaeger")
        JaegerOverlay.Metadata := Map("Vendor", "Audio Imperia", "Product", "Jaeger", "Image", Map("File", "Images/KontaktKompleteKontrol/Jaeger.png"))
        JaegerOverlay.AddAccessibilityOverlay()
        JaegerOverlay.AddStaticText("Jaeger")
        JaegerOverlay.AddCustomButton("Classic Mix", ObjBindMethod(KontaktKompleteKontrol, "FocusAIPluginClassicMix"), ObjBindMethod(KontaktKompleteKontrol, "ActivateAIPluginClassicMix"))
        JaegerOverlay.AddCustomButton("Modern Mix", ObjBindMethod(KontaktKompleteKontrol, "FocusAIPluginModernMix"), ObjBindMethod(KontaktKompleteKontrol, "ActivateAIPluginModernMix"))
        KontaktKompleteKontrol.PluginOverlays.Push(JaegerOverlay)
        
        NucleusOverlay := AccessibilityOverlay("Nucleus")
        NucleusOverlay.Metadata := Map("Vendor", "Audio Imperia", "Product", "Nucleus", "Image", Map("File", "Images/KontaktKompleteKontrol/Nucleus.png"))
        NucleusOverlay.AddAccessibilityOverlay()
        NucleusOverlay.AddStaticText("Nucleus")
        NucleusOverlay.AddCustomButton("Classic Mix", ObjBindMethod(KontaktKompleteKontrol, "FocusAIPluginClassicMix"), ObjBindMethod(KontaktKompleteKontrol, "ActivateAIPluginClassicMix"))
        NucleusOverlay.AddCustomButton("Modern Mix", ObjBindMethod(KontaktKompleteKontrol, "FocusAIPluginModernMix"), ObjBindMethod(KontaktKompleteKontrol, "ActivateAIPluginModernMix"))
        KontaktKompleteKontrol.PluginOverlays.Push(NucleusOverlay)
        
        SoloOverlay := AccessibilityOverlay("Solo")
        SoloOverlay.Metadata := Map("Vendor", "Audio Imperia", "Product", "Solo", "Image", Map("File", "Images/KontaktKompleteKontrol/Solo.png"))
        SoloOverlay.AddAccessibilityOverlay()
        SoloOverlay.AddStaticText("Solo")
        SoloOverlay.AddCustomButton("Classic Mix", ObjBindMethod(KontaktKompleteKontrol, "FocusAIPluginClassicMix"), ObjBindMethod(KontaktKompleteKontrol, "ActivateAIPluginClassicMix"))
        SoloOverlay.AddCustomButton("Modern Mix", ObjBindMethod(KontaktKompleteKontrol, "FocusAIPluginModernMix"), ObjBindMethod(KontaktKompleteKontrol, "ActivateAIPluginModernMix"))
        KontaktKompleteKontrol.PluginOverlays.Push(SoloOverlay)
        
        TalosOverlay := AccessibilityOverlay("Talos")
        TalosOverlay.Metadata := Map("Vendor", "Audio Imperia", "Product", "Talos", "Image", Map("File", "Images/KontaktKompleteKontrol/Talos.png"))
        TalosOverlay.AddAccessibilityOverlay()
        TalosOverlay.AddStaticText("Talos")
        TalosOverlay.AddCustomButton("Classic Mix", ObjBindMethod(KontaktKompleteKontrol, "FocusAIPluginClassicMix"), ObjBindMethod(KontaktKompleteKontrol, "ActivateAIPluginClassicMix"))
        TalosOverlay.AddCustomButton("Modern Mix", ObjBindMethod(KontaktKompleteKontrol, "FocusAIPluginModernMix"), ObjBindMethod(KontaktKompleteKontrol, "ActivateAIPluginModernMix"))
        KontaktKompleteKontrol.PluginOverlays.Push(TalosOverlay)
        
        KontaktKompleteKontrol.Kontakt.Init()
        KontaktKompleteKontrol.KompleteKontrol.Init()
        KontaktKompleteKontrol.PluginDialogs.Init()
    }
    
    Static GetPluginName() {
        Critical
        If FindImage("Images/KontaktKompleteKontrol/KompleteKontrol.png", GetPluginXCoordinate(), GetPluginYCoordinate()) Is Object
        Return "Komplete Kontrol"
        Else If FindImage("Images/KontaktKompleteKontrol/KontaktFull.png", GetPluginXCoordinate(), GetPluginYCoordinate()) Is Object
        Return "Kontakt"
        Else
        If FindImage("Images/KontaktKompleteKontrol/KontaktPlayer.png", GetPluginXCoordinate(), GetPluginYCoordinate()) Is Object
        Return "Kontakt"
        Return False
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
    
    Class Kontakt {
        
        Static PluginHeader := Object()
        Static StandaloneHeader := Object()
        
        Static Init() {
            PluginHeader := AccessibilityOverlay("Kontakt Full")
            PluginHeader.AddStaticText("Kontakt")
            PluginHeader.AddCustomButton("FILE menu", ObjBindMethod(KontaktKompleteKontrol.Kontakt, "FocusPluginMenu"), ObjBindMethod(KontaktKompleteKontrol.Kontakt, "ActivatePluginMenu"))
            PluginHeader.AddCustomButton("LIBRARY Browser On/Off", ObjBindMethod(KontaktKompleteKontrol.Kontakt, "FocusPluginMenu"), ObjBindMethod(KontaktKompleteKontrol, "ActivatePluginMenu"))
            PluginHeader.AddCustomButton("VIEW menu", ObjBindMethod(KontaktKompleteKontrol.Kontakt, "FocusPluginMenu"), ObjBindMethod(KontaktKompleteKontrol.Kontakt, "ActivatePluginMenu"))
            PluginHeader.AddCustomButton("SHOP (Opens in default web browser)", ObjBindMethod(KontaktKompleteKontrol.Kontakt, "FocusPluginMenu"), ObjBindMethod(KontaktKompleteKontrol.Kontakt, "ActivatePluginMenu"))
            KontaktKompleteKontrol.Kontakt.PluginHeader := PluginHeader
            
            StandaloneHeader := AccessibilityOverlay("Kontakt")
            StandaloneHeader.AddCustomButton("FILE menu", ObjBindMethod(KontaktKompleteKontrol.Kontakt, "FocusStandaloneMenu"), ObjBindMethod(KontaktKompleteKontrol.Kontakt, "ActivateStandaloneMenu"))
            StandaloneHeader.AddCustomButton("LIBRARY Browser On/Off", ObjBindMethod(KontaktKompleteKontrol.Kontakt, "FocusStandaloneMenu"), ObjBindMethod(KontaktKompleteKontrol.Kontakt, "ActivateStandaloneMenu"))
            StandaloneHeader.AddCustomButton("VIEW menu", ObjBindMethod(KontaktKompleteKontrol.Kontakt, "FocusStandaloneMenu"), ObjBindMethod(KontaktKompleteKontrol.Kontakt, "ActivateStandaloneMenu"))
            StandaloneHeader.AddCustomButton("SHOP (Opens in default web browser)", ObjBindMethod(KontaktKompleteKontrol.Kontakt, "FocusStandaloneMenu"), ObjBindMethod(KontaktKompleteKontrol.Kontakt, "ActivateStandaloneMenu"))
            KontaktKompleteKontrol.Kontakt.StandaloneHeader := StandaloneHeader
            
            Plugin.Register("Kontakt", "^Qt6[0-9][0-9]QWindowIcon\{[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\}1$", ObjBindMethod(KontaktKompleteKontrol.Kontakt, "InitPlugin"), True)
            
            For PluginOverlay In KontaktKompleteKontrol.PluginOverlays
            Plugin.RegisterOverlay("Kontakt", PluginOverlay)
            
            Plugin.SetTimer("Kontakt", ObjBindMethod(AutoChangePluginOverlay,, "Kontakt", True, True), 500)
            
            Standalone.Register("Kontakt", "Kontakt ahk_class NINormalWindow* ahk_exe Kontakt 7.exe")
            Standalone.RegisterOverlay("Kontakt", StandaloneHeader)
            ; Standalone.SetTimer("Kontakt", ObjBindMethod(KontaktKompleteKontrol.Kontakt, "CloseStandaloneBrowser"), 500)
            
            Standalone.Register("Kontakt Content Missing", "Content Missing ahk_class #32770 ahk_exe Kontakt 7.exe")
            
            KontaktStandaloneContentMissingOverlay := AccessibilityOverlay("Content Missing")
            KontaktStandaloneContentMissingOverlay.AddHotspotButton("Browse For Folder", 226, 372)
            Standalone.RegisterOverlay("Kontakt Content Missing", KontaktStandaloneContentMissingOverlay)
        }
        
        Static InitPlugin(PluginInstance) {
            If PluginInstance.Overlay.ChildControls.Length = 0
            PluginInstance.Overlay.AddAccessibilityOverlay()
            PluginInstance.Overlay.ChildControls[1] := KontaktKompleteKontrol.Kontakt.PluginHeader.Clone()
            If Not HasProp(PluginInstance.Overlay, "Metadata") {
                PluginInstance.Overlay.Metadata := Map("Product", "None")
                PluginInstance.Overlay.OverlayNumber := 1
            }
        }
        
        Static ActivatePluginMenu(MenuButton) {
            MenuLabel := StrSplit(MenuButton.Label, A_Space)
            MenuLabel := MenuLabel[1]
            Result := KontaktKompleteKontrol.Kontakt.MoveToOrClickMenu("Plugin", MenuLabel, "Click")
            If Result = 1 {
                If MenuLabel = "FILE" Or MenuLabel = "VIEW"
                KontaktKompleteKontrol.Kontakt.OpenPluginMenu()
            }
            Else If Result = 0 {
                AccessibilityOverlay.Speak("Item not found")
            }
            Else {
                AccessibilityOverlay.Speak("OCR not available")
            }
        }
        
        Static ActivateStandaloneMenu(MenuButton) {
            MenuLabel := StrSplit(MenuButton.Label, A_Space)
            MenuLabel := MenuLabel[1]
            Result := KontaktKompleteKontrol.Kontakt.MoveToOrClickMenu("Standalone", MenuLabel, "Click")
            If Result = 1 {
                If MenuLabel = "FILE" Or MenuLabel = "VIEW"
                KontaktKompleteKontrol.Kontakt.OpenStandaloneMenu()
            }
            Else If Result = 0 {
                AccessibilityOverlay.Speak("Item not found")
            }
            Else {
                AccessibilityOverlay.Speak("OCR not available")
            }
        }
        
        Static ClosePluginBrowser() {
            Colors := ["0x999993", "0x9A9A93"]
            For Color In Colors
            If PixelGetColor(CompensatePluginXCoordinate(997), CompensatePluginYCoordinate(125)) = Color {
                Click CompensatePluginXCoordinate(997), CompensatePluginYCoordinate(125)
                Sleep 500
                If PixelGetColor(CompensatePluginXCoordinate(997), CompensatePluginYCoordinate(125)) = Color
                AccessibilityOverlay.Speak("The Library Browser could not be closed. Some functions may not work correctly.")
                Else
                AccessibilityOverlay.Speak("Library Browser closed.")
            }
        }
        
        Static CloseStandaloneBrowser() {
            Colors := ["0x999993", "0x9A9A93"]
            For Color In Colors
            If PixelGetColor(997, 125) = Color {
                Click 997, 125
                Sleep 500
                If PixelGetColor(997, 125) = Color
                AccessibilityOverlay.Speak("The Library Browser could not be closed. Some functions may not work correctly.")
                Else
                AccessibilityOverlay.Speak("Library Browser closed.")
            }
        }
        
        Static FocusPluginMenu(MenuButton) {
            MenuLabel := StrSplit(MenuButton.Label, A_Space)
            MenuLabel := MenuLabel[1]
            KontaktKompleteKontrol.Kontakt.MoveToOrClickMenu("Plugin", MenuLabel, "MouseMove")
        }
        
        Static FocusStandaloneMenu(MenuButton) {
            MenuLabel := StrSplit(MenuButton.Label, A_Space)
            MenuLabel := MenuLabel[1]
            KontaktKompleteKontrol.Kontakt.MoveToOrClickMenu("Standalone", MenuLabel, "MouseMove")
        }
        
        Static MoveToOrClickMenu(Type, MenuLabel, MoveOrClick) {
            If Type = "Plugin" {
                CropX1 := GetPluginXCoordinate() + 80
                CropY1 := GetPluginYCoordinate()
                CropX2 := GetPluginXCoordinate() + 1200
                CropY2 := GetPluginYCoordinate() + 120
            }
            Else {
                CropX1 := 80
                CropY1 := 0
                CropX2 := 1200
                CropY2 := 120
            }
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
            OCRLanguage := False
            Else If PreferredLanguage = False
            OCRLanguage := FirstOCRLanguage
            Else
            OCRLanguage := PreferredOCRLanguage
            If OCRLanguage != False {
                OCRResult := OCR.FromWindow("A", OCRLanguage)
                OCRResult := OCRResult.Crop(CropX1, CropY1, CropX2, CropY2)
                For OCRLine In OCRResult.Lines
                If RegExMatch(OCRLine.Text, "^.*" . MenuLabel . ".*") {
                    DesiredMenu := False
                    For OCRWord In OCRLine.Words
                    If RegExMatch(OCRWord.Text, "^" . MenuLabel . ".*") {
                        DesiredMenu := OCRWord.Text
                        Break
                    }
                    If DesiredMenu != False {
                        Try
                        DesiredMenu := OCRResult.FindString(DesiredMenu)
                        Catch
                        DesiredMenu := False
                    }
                    If DesiredMenu != False {
                        %MoveOrClick%(floor(OCR.WordsBoundingRect(DesiredMenu.Words*).X + (OCR.WordsBoundingRect(DesiredMenu.Words*).W / 2)), Floor(OCR.WordsBoundingRect(DesiredMenu.Words*).Y + (OCR.WordsBoundingRect(DesiredMenu.Words*).H / 2)))
                        Return 1
                    }
                    Break
                }
            }
            MouseCoordinates := Map(
            "FILE", {X: 184, Y: 70},
            "LIBRARY", {X: 240, Y: 70},
            "VIEW", {X: 298, Y: 70},
            "SHOP", {X: 789, Y: 70})
            If MouseCoordinates.Has(MenuLabel) {
                If type = "Plugin"
                %MoveOrClick%(CompensatePluginXCoordinate(MouseCoordinates[MenuLabel].X), CompensatePluginYCoordinate(MouseCoordinates[MenuLabel].Y))
                Else
                %MoveOrClick%(MouseCoordinates[MenuLabel].X, MouseCoordinates[MenuLabel].Y)
                Return 1
            }
            Return 0
        }
        
        Static OpenMenu(Type) {
            Loop {
                If (Type = "Plugin" And WinActive(ReaHotkey.PluginWinCriteria)) Or (type = "Standalone" And WinActive("Kontakt ahk_class NINormalWindow* ahk_exe Kontakt 7.exe")) {
                    ReaHotkey.Turn%type%HotkeysOff()
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
                If type = "Plugin" And WinExist(ReaHotkey.PluginWinCriteria) And WinActive(ReaHotkey.PluginWinCriteria) And WinGetTitle("A") = "Content Missing"
                Break
                If Type = "Standalone" And WinExist("Content Missing ahk_class #32770 ahk_exe Kontakt 7.exe") And WinActive("Content Missing ahk_class #32770 ahk_exe Kontakt 7.exe")
                Break
            }
        }
        
        Static OpenPluginMenu() {
            KontaktKompleteKontrol.Kontakt.OpenMenu("Plugin")
        }
        
        Static OpenStandaloneMenu() {
            KontaktKompleteKontrol.Kontakt.OpenMenu("Standalone")
        }
        
    }
    
    Class KompleteKontrol {
        
        Static PluginHeader := Object()
        Static StandaloneHeader := Object()
        
        Static Init() {
            PluginHeader := AccessibilityOverlay("Komplete Kontrol")
            PluginHeader.AddStaticText("Komplete Kontrol")
            PluginHeader.AddHotspotButton("Menu", 305, 68, CompensatePluginPointCoordinates, CompensatePluginPointCoordinates)
            KontaktKompleteKontrol.KompleteKontrol.PluginHeader := PluginHeader
            
            StandaloneHeader := AccessibilityOverlay("Komplete Kontrol")
            StandaloneHeader.AddHotspotButton("File menu", 24, 41)
            StandaloneHeader.AddHotspotButton("Edit menu", 60, 41)
            StandaloneHeader.AddHotspotButton("View menu", 91, 41)
            StandaloneHeader.AddHotspotButton("Controller menu", 146, 41)
            StandaloneHeader.AddHotspotButton("Help menu", 202, 41)
            KontaktKompleteKontrol.KompleteKontrol.StandaloneHeader := StandaloneHeader
            
            Plugin.Register("Komplete Kontrol", "^Qt6[0-9][0-9]QWindowIcon\{[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\}1$", ObjBindMethod(KontaktKompleteKontrol.KompleteKontrol, "InitPlugin"), True)
            
            For PluginOverlay In KontaktKompleteKontrol.PluginOverlays
            Plugin.RegisterOverlay("Komplete Kontrol", PluginOverlay)
            
            Plugin.SetTimer("Komplete Kontrol", ObjBindMethod(AutoChangePluginOverlay,, "Komplete Kontrol", True, True), 500)
            
            Standalone.Register("Komplete Kontrol", "Komplete Kontrol ahk_class NINormalWindow* ahk_exe Komplete Kontrol.exe")
            Standalone.RegisterOverlay("Komplete Kontrol", StandaloneHeader)
            Standalone.SetTimer("Komplete Kontrol", ObjBindMethod(KontaktKompleteKontrol.KompleteKontrol, "CloseStandaloneBrowser"), 500)
            
            Standalone.Register("Komplete Kontrol Preferences", "Preferences ahk_class #32770 ahk_exe Komplete Kontrol.exe", ObjBindMethod(KontaktKompleteKontrol.KompleteKontrol, "FocusStandalonePreferenceTab"))
            Standalone.SetHotkey("Komplete Kontrol Preferences", "^,", ObjBindMethod(KontaktKompleteKontrol.KompleteKontrol, "ManageStandalonePreferenceWindow"))
            
            KKPreferenceOverlay := AccessibilityOverlay()
            KKPreferenceTabControl := KKPreferenceOverlay.AddTabControl()
            KKPreferenceAudioTab := HotspotTab("Audio", 56, 69)
            KKPreferenceAudioTab.AddCustomButton("Close",, ObjBindMethod(KontaktKompleteKontrol.KompleteKontrol, "CloseStandalonePreferences"))
            KKPreferenceMIDITab := HotspotTab("MIDI", 56, 114)
            KKPreferenceMIDITab.AddCustomButton("Close",, ObjBindMethod(KontaktKompleteKontrol.KompleteKontrol, "CloseStandalonePreferences"))
            KKPreferenceGeneralTab := HotspotTab("General", 56, 155)
            KKPreferenceGeneralTab.AddCustomButton("Close",, ObjBindMethod(KontaktKompleteKontrol.KompleteKontrol, "CloseStandalonePreferences"))
            KKPreferenceLibraryTab := HotspotTab("Library", 56, 196)
            KKPreferenceLibraryTabTabControl := KKPreferenceLibraryTab.AddTabControl()
            KKPreferenceLibraryFactoryTab := HotspotTab("Factory", 156, 76)
            KKPreferenceLibraryFactoryTab.AddHotspotButton("Rescan", 546, 417)
            KKPreferenceLibraryUserTab := HotspotTab("User", 240, 76)
            KKPreferenceLibraryUserTab.AddHotspotButton("Add Directory", 170, 420)
            KKPreferenceLibraryUserTab.AddHotspotCheckbox("Scan user content for changes at start-up", 419, 394, "0xC5C5C5", "0x5F5F5F")
            KKPreferenceLibraryUserTab.AddHotspotButton("Rescan", 546, 417)
            KKPreferenceLibraryTabTabControl.AddTabs(KKPreferenceLibraryFactoryTab, KKPreferenceLibraryUserTab)
            KKPreferenceLibraryTab.AddCustomButton("Close",, ObjBindMethod(KontaktKompleteKontrol.KompleteKontrol, "CloseStandalonePreferences"))
            KKPreferencePluginTab := HotspotTab("Plug-ins", 56, 237)
            KKPreferencePluginTab.AddHotspotCheckbox("Always Use Latest Version Of NI Plug-ins", 419, 394, "0xC5C5C5", "0x5F5F5F")
            KKPreferencePluginTab.AddHotspotButton("Rescan", 546, 417)
            KKPreferencePluginTab.AddCustomButton("Close",, ObjBindMethod(KontaktKompleteKontrol.KompleteKontrol, "CloseStandalonePreferences"))
            KKPreferenceTabControl.AddTabs(KKPreferenceAudioTab, KKPreferenceMIDITab, KKPreferenceGeneralTab, KKPreferenceLibraryTab, KKPreferencePluginTab)
            Standalone.RegisterOverlay("Komplete Kontrol Preferences", KKPreferenceOverlay)
        }
        
        Static InitPlugin(PluginInstance) {
            If PluginInstance.Overlay.ChildControls.Length = 0
            PluginInstance.Overlay.AddAccessibilityOverlay()
            PluginInstance.Overlay.ChildControls[1] := KontaktKompleteKontrol.KompleteKontrol.PluginHeader.Clone()
            If Not HasProp(PluginInstance.Overlay, "Metadata") {
                PluginInstance.Overlay.Metadata := Map("Product", "None")
                PluginInstance.Overlay.OverlayNumber := 1
            }
        }
        
        Static ClosePluginBrowser() {
            Colors := ["0x6E8192", "0x6F8193", "0x97999A"]
            For Color In Colors
            If PixelGetColor(CompensatePluginXCoordinate(1002), CompensatePluginYCoordinate(284)) = Color {
                Click CompensatePluginXCoordinate(1002), CompensatePluginYCoordinate(284)
                Sleep 500
                If PixelGetColor(CompensatePluginXCoordinate(1002), CompensatePluginYCoordinate(284)) = Color
                AccessibilityOverlay.Speak("The Library Browser could not be closed. Some functions may not work correctly.")
                Else
                AccessibilityOverlay.Speak("Library Browser closed.")
            }
        }
        
        Static CloseStandaloneBrowser() {
            Colors := ["0x6E8192", "0x6F8193", "0x97999A"]
            For Color In Colors
            If PixelGetColor(1002, 284) = Color {
                Click 1002, 284
                Sleep 500
                If PixelGetColor(1002, 284) = Color
                AccessibilityOverlay.Speak("The Library Browser could not be closed. Some functions may not work correctly.")
                Else
                AccessibilityOverlay.Speak("Library Browser closed.")
            }
        }
        
        Static CloseStandalonePreferences(*) {
            WinClose("Preferences ahk_class #32770 ahk_exe Komplete Kontrol.exe")
        }
        
        Static FocusStandalonePreferenceTab(KKInstance) {
            Sleep 1000
            If KKInstance.Overlay.CurrentControlID = 0
            KKInstance.Overlay.Focus()
        }
        
        Static ManageStandalonePreferenceWindow(*) {
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
        
    }
    
    Class PluginDialogs {
        
        Static Init() {
            Plugin.Register("Kontakt/Komplete Kontrol Dialogs", "^NIChildWindow[0-9A-F]{17}$",, False, False)
            Plugin.SetHotkey("Kontakt/Komplete Kontrol Dialogs", "!F4", ObjBindMethod(KontaktKompleteKontrol.PluginDialogs, "CloseDialog"))
            Plugin.SetHotkey("Kontakt/Komplete Kontrol Dialogs", "Escape", ObjBindMethod(KontaktKompleteKontrol.PluginDialogs, "CloseDialog"))
            
            KKPreferenceOverlay := AccessibilityOverlay()
            KKPreferenceTabControl := KKPreferenceOverlay.AddTabControl()
            KKPreferenceMIDITab := HotspotTab("MIDI", 56, 69)
            KKPreferenceMIDITab.AddCustomButton("Close",, ObjBindMethod(KontaktKompleteKontrol.PluginDialogs, "CloseDialog"))
            KKPreferenceGeneralTab := HotspotTab("General", 56, 114)
            KKPreferenceGeneralTab.AddCustomButton("Close",, ObjBindMethod(KontaktKompleteKontrol.PluginDialogs, "CloseDialog"))
            KKPreferenceLibraryTab := HotspotTab("Library", 56, 155)
            KKPreferenceLibraryTabTabControl := KKPreferenceLibraryTab.AddTabControl()
            KKPreferenceLibraryFactoryTab := HotspotTab("Factory", 156, 76)
            KKPreferenceLibraryFactoryTab.AddHotspotButton("Rescan", 546, 417)
            KKPreferenceLibraryUserTab := HotspotTab("User", 240, 76)
            KKPreferenceLibraryUserTab.AddHotspotButton("Add Directory", 170, 420)
            KKPreferenceLibraryUserTab.AddHotspotCheckbox("Scan user content for changes at start-up", 419, 394, "0xC5C5C5", "0x5F5F5F")
            KKPreferenceLibraryUserTab.AddHotspotButton("Rescan", 546, 417)
            KKPreferenceLibraryTabTabControl.AddTabs(KKPreferenceLibraryFactoryTab, KKPreferenceLibraryUserTab)
            KKPreferenceLibraryTab.AddCustomButton("Close",, ObjBindMethod(KontaktKompleteKontrol.PluginDialogs, "CloseDialog"))
            KKPreferencePluginTab := HotspotTab("Plug-ins", 56, 196)
            KKPreferencePluginTab.AddHotspotCheckbox("Always Use Latest Version Of NI Plug-ins", 419, 394, "0xC5C5C5", "0x5F5F5F")
            KKPreferencePluginTab.AddHotspotButton("Rescan", 546, 417)
            KKPreferencePluginTab.AddCustomButton("Close",, ObjBindMethod(KontaktKompleteKontrol.PluginDialogs, "CloseDialog"))
            KKPreferenceTabControl.AddTabs(KKPreferenceMIDITab, KKPreferenceGeneralTab, KKPreferenceLibraryTab, KKPreferencePluginTab)
            Plugin.RegisterOverlay("Kontakt/Komplete Kontrol Dialogs", KKPreferenceOverlay)
            
            KontaktPluginContentMissingOverlay := AccessibilityOverlay("Content Missing")
            KontaktPluginContentMissingOverlay.AddHotspotButton("Browse For Folder", 226, 372)
            Plugin.RegisterOverlay("Kontakt/Komplete Kontrol Dialogs", KontaktPluginContentMissingOverlay)
            
            Plugin.SetTimer("Kontakt/Komplete Kontrol Dialogs", ObjBindMethod(KontaktKompleteKontrol.PluginDialogs, "DetectDialog"), 250)
        }
        
        Static CloseDialog(*) {
            Critical
            If ReaHotkey.FoundPlugin Is Plugin And ReaHotkey.FoundPlugin.Name = "Kontakt/Komplete Kontrol Dialogs" And WinExist(ReaHotkey.PluginWinCriteria) And WinActive(ReaHotkey.PluginWinCriteria)
            If WinGetTitle("A") = "Preferences" Or WinGetTitle("A") = "content Missing" {
                ReaHotkey.FoundPlugin.Overlay.Reset()
                ReaHotkey.TurnPluginTimersOff("Kontakt/Komplete Kontrol Dialogs")
                ReaHotkey.TurnPluginHotkeysOff("Kontakt/Komplete Kontrol Dialogs")
                ReaHotkey.FoundPlugin := False
                WinClose("A")
                Sleep 500
            }
        }
        
        Static DetectDialog() {
            Critical
            If ReaHotkey.FoundPlugin Is Plugin And ReaHotkey.FoundPlugin.Name = "Kontakt/Komplete Kontrol Dialogs" And WinExist(ReaHotkey.PluginWinCriteria) And WinActive(ReaHotkey.PluginWinCriteria) And WinGetTitle("A") = "Preferences" {
                ReaHotkey.FoundPlugin.Overlay := ReaHotkey.FoundPlugin.Overlays[1]
                ReaHotkey.FoundPlugin.NoHotkeys := False
            }
            Else If ReaHotkey.FoundPlugin Is Plugin And ReaHotkey.FoundPlugin.Name = "Kontakt/Komplete Kontrol Dialogs" And WinExist(ReaHotkey.PluginWinCriteria) And WinActive(ReaHotkey.PluginWinCriteria) And WinGetTitle("A") = "content Missing" {
                ReaHotkey.FoundPlugin.Overlay := ReaHotkey.FoundPlugin.Overlays[2]
                ReaHotkey.FoundPlugin.NoHotkeys := False
            }
            Else {
                If ReaHotkey.FoundPlugin Is Plugin And ReaHotkey.FoundPlugin.Name = "Kontakt/Komplete Kontrol Dialogs" And WinExist(ReaHotkey.PluginWinCriteria) And WinActive(ReaHotkey.PluginWinCriteria) And WinGetTitle("A") != "Preferences" And ReaHotkey.FoundPlugin.NoHotkeys = False
                ReaHotkey.FoundPlugin.NoHotkeys := True
                If ReaHotkey.FoundPlugin Is Plugin And ReaHotkey.FoundPlugin.Name = "Kontakt/Komplete Kontrol Dialogs" And WinExist(ReaHotkey.PluginWinCriteria) And WinActive(ReaHotkey.PluginWinCriteria) And WinGetTitle("A") != "content Missing" And ReaHotkey.FoundPlugin.NoHotkeys = False
                ReaHotkey.FoundPlugin.NoHotkeys := True
            }
        }
        
    }
    
}
