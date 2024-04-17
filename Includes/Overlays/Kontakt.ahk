#Requires AutoHotkey v2.0

Class Kontakt {
    
    Static PluginHeader := Object()
    Static StandaloneHeader := Object()
    Static PluginOverlays := Array()
    Static StandaloneOverlays := Array()
    
    Static __New() {
        #Include Kontakt/OverlayDefinitions.ahk
        
        PluginHeader := AccessibilityOverlay("Kontakt Full")
        PluginHeader.AddStaticText("Kontakt")
        PluginHeader.AddCustomButton("FILE menu", ObjBindMethod(Kontakt, "FocusPluginMenu"), ObjBindMethod(Kontakt, "ActivatePluginMenu"))
        PluginHeader.AddCustomButton("LIBRARY Browser On/Off", ObjBindMethod(Kontakt, "FocusPluginMenu"), ObjBindMethod(Kontakt, "ActivatePluginMenu"))
        PluginHeader.AddCustomButton("VIEW menu", ObjBindMethod(Kontakt, "FocusPluginMenu"), ObjBindMethod(Kontakt, "ActivatePluginMenu"))
        PluginHeader.AddCustomButton("SHOP (Opens in default web browser)", ObjBindMethod(Kontakt, "FocusPluginMenu"), ObjBindMethod(Kontakt, "ActivatePluginMenu"))
        Kontakt.PluginHeader := PluginHeader
        
        StandaloneHeader := AccessibilityOverlay("Kontakt")
        StandaloneHeader.AddCustomButton("FILE menu", ObjBindMethod(Kontakt, "FocusStandaloneMenu"), ObjBindMethod(Kontakt, "ActivateStandaloneMenu"))
        StandaloneHeader.AddCustomButton("LIBRARY Browser On/Off", ObjBindMethod(Kontakt, "FocusStandaloneMenu"), ObjBindMethod(Kontakt, "ActivateStandaloneMenu"))
        StandaloneHeader.AddCustomButton("VIEW menu", ObjBindMethod(Kontakt, "FocusStandaloneMenu"), ObjBindMethod(Kontakt, "ActivateStandaloneMenu"))
        StandaloneHeader.AddCustomButton("SHOP (Opens in default web browser)", ObjBindMethod(Kontakt, "FocusStandaloneMenu"), ObjBindMethod(Kontakt, "ActivateStandaloneMenu"))
        Kontakt.StandaloneHeader := StandaloneHeader
        
        Plugin.Register("Kontakt", "^Qt6[0-9][0-9]QWindowIcon\{[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\}1$", ObjBindMethod(Kontakt, "InitPlugin"), True, True, False, ObjBindMethod(Kontakt, "CheckPlugin"))
        
        For PluginOverlay In Kontakt.PluginOverlays
        Plugin.RegisterOverlay("Kontakt", PluginOverlay)
        
        ;Plugin.SetTimer("Kontakt", ObjBindMethod(Kontakt, "ClosePluginBrowser"), 500)
        Plugin.SetTimer("Kontakt", ObjBindMethod(AutoChangePluginOverlay,, "Kontakt", True, True), 500)
        
        Plugin.Register("Kontakt Content Missing Dialog", "^NIChildWindow[0-9A-F]{17}$",, False, False, False, ObjBindMethod(Kontakt, "CheckPluginContentMissing"))
        Plugin.SetHotkey("Kontakt Content Missing Dialog", "!F4", ObjBindMethod(Kontakt, "ClosePluginContentMissingDialog"))
        Plugin.SetHotkey("Kontakt Content Missing Dialog", "Escape", ObjBindMethod(Kontakt, "ClosePluginContentMissingDialog"))
        
        PluginContentMissingOverlay := AccessibilityOverlay("Content Missing")
        PluginContentMissingOverlay.AddHotspotButton("Browse For Folder", 226, 372)
        Plugin.RegisterOverlay("Kontakt Content Missing Dialog", PluginContentMissingOverlay)
        
        Standalone.Register("Kontakt", "Kontakt ahk_class NINormalWindow* ahk_exe Kontakt 7.exe")
        Standalone.RegisterOverlay("Kontakt", StandaloneHeader)
        ;Standalone.SetTimer("Kontakt", ObjBindMethod(Kontakt, "CloseStandaloneBrowser"), 500)
        
        Standalone.Register("Kontakt Content Missing Dialog", "Content Missing ahk_class #32770 ahk_exe Kontakt 7.exe")
        
        StandaloneContentMissingOverlay := AccessibilityOverlay("Content Missing")
        StandaloneContentMissingOverlay.AddHotspotButton("Browse For Folder", 226, 372)
        Standalone.RegisterOverlay("Kontakt Content Missing Dialog", StandaloneContentMissingOverlay)
    }
    
    Static ActivatePluginMenu(MenuButton) {
        MenuLabel := StrSplit(MenuButton.Label, A_Space)
        MenuLabel := MenuLabel[1]
        Result := Kontakt.MoveToOrClickMenu("Plugin", MenuLabel, "Click")
        If Result = 1 {
            If MenuLabel = "FILE" Or MenuLabel = "VIEW"
            Kontakt.OpenPluginMenu()
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
        Result := Kontakt.MoveToOrClickMenu("Standalone", MenuLabel, "Click")
        If Result = 1 {
            If MenuLabel = "FILE" Or MenuLabel = "VIEW"
            Kontakt.OpenStandaloneMenu()
        }
        Else If Result = 0 {
            AccessibilityOverlay.Speak("Item not found")
        }
        Else {
            AccessibilityOverlay.Speak("OCR not available")
        }
    }
    
    Static CheckPlugin(*) {
        If Plugin.GetInstance(GetCurrentControlClass()) Is Plugin
        Return True
        If FindImage("Images/KontaktKompleteKontrol/KontaktFull.png", GetPluginXCoordinate(), GetPluginYCoordinate(), GetPluginXCoordinate() + 400, GetPluginYCoordinate() + 150) Is Object
        Return True
        Else
        If FindImage("Images/KontaktKompleteKontrol/KontaktPlayer.png", GetPluginXCoordinate(), GetPluginYCoordinate(), GetPluginXCoordinate() + 400, GetPluginYCoordinate() + 150) Is Object
        Return True
        Return False
    }
    
    Static CheckPluginContentMissing(*) {
        If Plugin.GetInstance(GetCurrentControlClass()) Is Plugin
        Return True
        If WinExist(ReaHotkey.PluginWinCriteria) And WinActive(ReaHotkey.PluginWinCriteria) And WinGetTitle("A") = "content Missing"
        Return True
        Return False
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
    
    Static ClosePluginContentMissingDialog(*) {
        Critical
        If ReaHotkey.FoundPlugin Is Plugin And WinExist(ReaHotkey.PluginWinCriteria) And WinActive(ReaHotkey.PluginWinCriteria)
        If ReaHotkey.FoundPlugin.Name = "Kontakt Content Missing Dialog" And WinGetTitle("A") = "content Missing" {
            ReaHotkey.FoundPlugin.Overlay.Reset()
            WinClose("A")
            Sleep 500
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
        Kontakt.MoveToOrClickMenu("Plugin", MenuLabel, "MouseMove")
    }
    
    Static FocusStandaloneMenu(MenuButton) {
        MenuLabel := StrSplit(MenuButton.Label, A_Space)
        MenuLabel := MenuLabel[1]
        Kontakt.MoveToOrClickMenu("Standalone", MenuLabel, "MouseMove")
    }
    
    Static InitPlugin(PluginInstance) {
        If PluginInstance.Overlay.ChildControls.Length = 0
        PluginInstance.Overlay.AddAccessibilityOverlay()
        PluginInstance.Overlay.ChildControls[1] := Kontakt.PluginHeader.Clone()
        If Not HasProp(PluginInstance.Overlay, "Metadata") {
            PluginInstance.Overlay.Metadata := Map("Product", "None")
            PluginInstance.Overlay.OverlayNumber := 1
        }
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
        Kontakt.OpenMenu("Plugin")
    }
    
    Static OpenStandaloneMenu() {
        Kontakt.OpenMenu("Standalone")
    }
    
}
