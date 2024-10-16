#Requires AutoHotkey v2.0

Class Kontakt8 {
    
    Static PluginHeader := Object()
    Static StandaloneHeader := Object()
    Static PluginOverlays := Array()
    Static StandaloneOverlays := Array()
    
    Static __New() {
        PluginHeader := AccessibilityOverlay("Kontakt 8")
        PluginHeader.AddStaticText("Kontakt 8")
        PluginHeader.AddCustomButton("FILE menu",,, Kontakt8.ActivatePluginHeaderButton).SetHotkey("!F", "Alt+F")
        PluginHeader.AddCustomButton("LIBRARY On/Off",,, Kontakt8.ActivatePluginHeaderButton).SetHotkey("!L", "Alt+L")
        PluginHeader.AddCustomButton("VIEW menu",,, Kontakt8.ActivatePluginHeaderButton).SetHotkey("!V", "Alt+V")
        PluginHeader.AddCustomButton("SHOP (Opens in default web browser)",,, Kontakt8.ActivatePluginHeaderButton).SetHotkey("!S", "Alt+S")
        PluginHeader.AddCustomButton("Snapshot menu", Kontakt8.MoveToPluginSnapshotButton,,, Kontakt8.ActivatePluginSnapshotButton).SetHotkey("!M", "Alt+M")
        PluginHeader.AddCustomButton("Previous snapshot", Kontakt8.MoveToPluginSnapshotButton,,, Kontakt8.ActivatePluginSnapshotButton).SetHotkey("!P", "Alt+P")
        PluginHeader.AddCustomButton("Next snapshot", Kontakt8.MoveToPluginSnapshotButton,,, Kontakt8.ActivatePluginSnapshotButton).SetHotkey("!N", "Alt+N")
        Kontakt8.PluginHeader := PluginHeader
        
        StandaloneHeader := AccessibilityOverlay("Kontakt 8")
        StandaloneHeader.AddCustomButton("FILE menu",,, Kontakt8.ActivateStandaloneHeaderButton).SetHotkey("!F", "Alt+F")
        StandaloneHeader.AddCustomButton("LIBRARY On/Off",,, Kontakt8.ActivateStandaloneHeaderButton).SetHotkey("!L", "Alt+L")
        StandaloneHeader.AddCustomButton("VIEW menu",,, Kontakt8.ActivateStandaloneHeaderButton).SetHotkey("!V", "Alt+V")
        StandaloneHeader.AddCustomButton("SHOP (Opens in default web browser)",,, Kontakt8.ActivateStandaloneHeaderButton).SetHotkey("!S", "Alt+S")
        Kontakt8.StandaloneHeader := StandaloneHeader
        
        Plugin.Register("Kontakt 8", "^Qt6[0-9][0-9]QWindowIcon\{[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\}1$", ObjBindMethod(Kontakt8, "InitPlugin"), True, False, False, ObjBindMethod(Kontakt8, "CheckPlugin"))
        
        For PluginOverlay In Kontakt8.PluginOverlays
        Plugin.RegisterOverlay("Kontakt 8", PluginOverlay)
        Plugin.RegisterOverlayHotkeys("Kontakt 8", PluginHeader)
        
        Plugin.SetTimer("Kontakt 8", ObjBindMethod(Kontakt8, "CheckPluginConfig"), -1)
        Plugin.SetTimer("Kontakt 8", ObjBindMethod(Kontakt8, "CheckPluginMenu"), 200)
        
        Plugin.Register("Kontakt 8 Content Missing Dialog", "^NIChildWindow[0-9A-F]{17}$",, False, False, True, ObjBindMethod(Kontakt8, "CheckPluginContentMissing"))
        Plugin.SetHotkey("Kontakt 8 Content Missing Dialog", "!F4", ObjBindMethod(Kontakt8, "ClosePluginContentMissingDialog"))
        Plugin.SetHotkey("Kontakt 8 Content Missing Dialog", "Escape", ObjBindMethod(Kontakt8, "ClosePluginContentMissingDialog"))
        
        PluginContentMissingOverlay := AccessibilityOverlay("Content Missing")
        PluginContentMissingOverlay.AddHotspotButton("Browse For Folder", 226, 372).SetHotkey("!B", "Alt+B")
        Plugin.RegisterOverlay("Kontakt 8 Content Missing Dialog", PluginContentMissingOverlay)
        
        Standalone.Register("Kontakt 8", "Kontakt ahk_class NINormalWindow* ahk_exe Kontakt 8.exe", False, False)
        Standalone.SetTimer("Kontakt 8", ObjBindMethod(Kontakt8, "CheckStandaloneConfig"), -1)
        Standalone.SetTimer("Kontakt 8", ObjBindMethod(Kontakt8, "CheckStandaloneMenu"), 200)
        Standalone.RegisterOverlay("Kontakt 8", StandaloneHeader)
        
        Standalone.Register("Kontakt 8 Content Missing Dialog", "Content Missing ahk_class #32770 ahk_exe Kontakt 8.exe", False, False)
        
        StandaloneContentMissingOverlay := AccessibilityOverlay("Content Missing")
        StandaloneContentMissingOverlay.AddHotspotButton("Browse For Folder", 226, 372).SetHotkey("!B", "Alt+B")
        Standalone.RegisterOverlay("Kontakt 8 Content Missing Dialog", StandaloneContentMissingOverlay)
    }
    
    Static CheckMenu(Type) {
        UIAPath := "15,1"
        If Type = "Standalone"
        UIAPath := 1
        Try {
            UIAElement := GetUIAElement(UIAPath)
            UIAElement.FindElement({Type:"Menu"})
            %Type%.SetNoHotkeys("Kontakt 8", True)
        }
        Catch {
            %Type%.SetNoHotkeys("Kontakt 8", False)
        }
    }
    
    Static CheckPlugin(*) {
        Thread "NoTimers"
        PluginInstance := Plugin.GetInstance(GetCurrentControlClass())
        If PluginInstance Is Plugin And PluginInstance.Name = "Kontakt 8"
        Return True
        UIAElement := GetUIAElement("15,1")
        Try
        If Not UIAElement = False And UIAElement.Name = "Kontakt 8" And UIAElement.ClassName = "ni::qt::QuickWindow"
        Return True
        Return False
    }
    
    Static CheckPluginConfig() {
        Static PluginAutoChangeFunction := ObjBindMethod(AutoChangePluginOverlay,, "Kontakt 8", True, True)
        If IniRead("ReaHotkey.ini", "Config", "AutomaticallyCloseLibrariBrowsersInKontaktAndKKPlugins", 1) = 1
        Kontakt8.ClosePluginBrowser()
        If IniRead("ReaHotkey.ini", "Config", "AutomaticallyDetectLibrariesInKontaktAndKKPlugins", 1) = 1
        Plugin.SetTimer("Kontakt 8", PluginAutoChangeFunction, 500)
        Else
        Plugin.SetTimer("Kontakt 8", PluginAutoChangeFunction, 0)
    }
    
    Static CheckPluginContentMissing(*) {
        Thread "NoTimers"
        PluginInstance := Plugin.GetInstance(GetCurrentControlClass())
        If PluginInstance Is Plugin And PluginInstance.Name = "Kontakt 8 Content Missing Dialog"
        Return True
        If WinExist(ReaHotkey.PluginWinCriteria) And WinActive(ReaHotkey.PluginWinCriteria) And WinGetTitle("A") = "content Missing"
        Return True
        Return False
    }
    
    Static CheckPluginMenu(*) {
        Kontakt8.CheckMenu("Plugin")
    }
    
    Static CheckStandaloneConfig() {
        If IniRead("ReaHotkey.ini", "Config", "AutomaticallyCloseLibrariBrowsersInKontaktAndKKStandalones", 1) = 1
        Kontakt8.CloseStandaloneBrowser()
    }
    
    Static CheckStandaloneMenu(*) {
        Kontakt8.CheckMenu("Standalone")
    }
    
    Static ClosePluginBrowser() {
        UIAElement := GetUIAElement("15,1,14,3")
        If Not UIAElement = False And RegExMatch(UIAElement.ClassName, "^LumenButton_QMLTYPE_[0-9]+$") {
            UIAElement.Click()
            AccessibilityOverlay.Speak("Library Browser closed.")
            Sleep 1000
        }
        UIAElement := GetUIAElement("15,1,16,3")
        If Not UIAElement = False And RegExMatch(UIAElement.ClassName, "^LumenButton_QMLTYPE_[0-9]+$") {
            UIAElement.Click()
            AccessibilityOverlay.Speak("Library Browser closed.")
            Sleep 1000
        }
    }
    
    Static ClosePluginContentMissingDialog(*) {
        Critical
        If ReaHotkey.FoundPlugin Is Plugin And WinExist(ReaHotkey.PluginWinCriteria) And WinActive(ReaHotkey.PluginWinCriteria)
        If ReaHotkey.FoundPlugin.Name = "Kontakt 8 Content Missing Dialog" And WinGetTitle("A") = "content Missing" {
            ReaHotkey.FoundPlugin.Overlay.Reset()
            WinClose("A")
            Sleep 500
        }
    }
    
    Static CloseStandaloneBrowser() {
        UIAElement := GetUIAElement("1,14,3")
        If Not UIAElement = False And RegExMatch(UIAElement.ClassName, "^LumenButton_QMLTYPE_[0-9]+$") {
            UIAElement.Click()
            AccessibilityOverlay.Speak("Library Browser closed.")
            Sleep 1000
        }
        UIAElement := GetUIAElement("1,16,3")
        If Not UIAElement = False And RegExMatch(UIAElement.ClassName, "^LumenButton_QMLTYPE_[0-9]+$") {
            UIAElement.Click()
            AccessibilityOverlay.Speak("Library Browser closed.")
            Sleep 1000
        }
    }
    
    Static InitPlugin(PluginInstance) {
        If PluginInstance.Overlay.ChildControls.Length = 0
        PluginInstance.Overlay.AddAccessibilityOverlay()
        PluginInstance.Overlay.ChildControls[1] := Kontakt8.PluginHeader.Clone()
        If Not HasProp(PluginInstance.Overlay, "Metadata") {
            PluginInstance.Overlay.Metadata := Map("Product", "None")
            PluginInstance.Overlay.OverlayNumber := 1
        }
        Plugin.RegisterOverlayHotkeys("Kontakt 8", PluginInstance.Overlay)
    }
    
    Class  ActivatePluginHeaderButton {
        Static Call(HeaderButton) {
            UIAElement := False
            Switch HeaderButton.Label {
                Case "FILE menu":
                UIAElement := GetUIAElement("15,1,2")
                Case "LIBRARY On/Off":
                UIAElement := GetUIAElement("15,1,3")
                Case "VIEW menu":
                UIAElement := GetUIAElement("15,1,4")
                Case "SHOP (Opens in default web browser)":
                UIAElement := GetUIAElement("15,1,5")
                If UIAElement = False Or Not UIAElement.Name = "SHOP"
                UIAElement := GetUIAElement("15,1,7")
            }
            If Not UIAElement = False
            Switch HeaderButton.Label {
                Case "FILE menu":
                UIAElement.Click("Left")
                Case "LIBRARY On/Off":
                UIAElement.Click("Left")
                Case "VIEW menu":
                UIAElement.Click("Left")
                Case "SHOP (Opens in default web browser)":
                UIAElement.Click("Left")
            }
            Else
            AccessibilityOverlay.Speak(HeaderButton.Label . " button not found")
        }
    }
    
    Class ActivatePluginSnapshotButton {
        Static Call(SnapshotButton) {
            UIAElement := GetUIAElement("15,1,5")
            If Not UIAElement = False And UIAElement.Name = "SHOP" {
                Try
                ControlGetPos &ControlX, &ControlY, &ControlWidth, &ControlHeight, ReaHotkey.GetPluginControl(), "A"
                Catch
                Return
                Click ControlX + ControlWidth - 296, ControlY + 141
                Sleep 10
                Kontakt8.MoveToPluginSnapshotButton("Previous snapshot")
                If CheckColor()
                If InStr(SnapshotButton.Label, "Snapshot", True) {
                    Kontakt8.MoveToPluginSnapshotButton(SnapshotButton)
                    Click
                    Return
                }
                Else {
                    Kontakt8.MoveToPluginSnapshotButton(SnapshotButton)
                    Click
                    Return
                }
            }
            AccessibilityOverlay.Speak("Snapshot switching unavailable. Make sure that an instrument is loaded and that you're in classic view.")
            CheckColor() {
                MouseGetPos &mouseXPosition, &mouseYPosition
                If PixelGetColor(MouseXPosition, MouseYPosition, "Slow") = "0x424142" Or PixelGetColor(MouseXPosition, MouseYPosition, "Slow") = "0x545454"
                Return True
                Return False
            }
        }
    }
    
    Class  ActivateStandaloneHeaderButton {
        Static Call(HeaderButton) {
            UIAElement := False
            Switch HeaderButton.Label {
                Case "FILE menu":
                UIAElement := GetUIAElement("1,2")
                Case "LIBRARY On/Off":
                UIAElement := GetUIAElement("1,3")
                Case "VIEW menu":
                UIAElement := GetUIAElement("1,4")
                Case "SHOP (Opens in default web browser)":
                UIAElement := GetUIAElement("1,5")
                If UIAElement = False Or Not UIAElement.Name = "SHOP"
                UIAElement := GetUIAElement("1,7")
            }
            If Not UIAElement = False
            Switch HeaderButton.Label {
                Case "FILE menu":
                UIAElement.Click("Left")
                Case "LIBRARY On/Off":
                UIAElement.Click("Left")
                Case "VIEW menu":
                UIAElement.Click("Left")
                Case "SHOP (Opens in default web browser)":
                UIAElement.Click("Left")
            }
            Else
            AccessibilityOverlay.Speak(HeaderButton.Label . " button not found")
        }
    }
    
    Class MoveToPluginSnapshotButton {
        Static Call(SnapshotButton) {
            If SnapshotButton Is Object And InStr(SnapshotButton.Label, "Snapshot", True)
            SnapshotButton.Label := "Snapshot menu"
            Label := SnapshotButton
            If SnapshotButton Is Object
            Label := SnapshotButton.Label
            UIAElement := GetUIAElement("15,1,5")
            If Not UIAElement = False And UIAElement.Name = "SHOP" {
                Try
                ControlGetPos &ControlX, &ControlY, &ControlWidth, &ControlHeight, ReaHotkey.GetPluginControl(), "A"
                Catch
                Return
                If SnapshotButton Is Object And InStr(SnapshotButton.Label, "Snapshot", True) {
                    OCRResult := AccessibilityOverlay.Ocr(ControlX + ControlWidth - 580, ControlY + 160, ControlX + ControlWidth - 580 + 200, ControlY + 180)
                    If Not OCRResult = ""
                    SnapshotButton.Label := "Snapshot " . OcrResult
                }
                If InStr(Label, "Snapshot", True)
                MouseMove ControlX + ControlWidth - 580, ControlY + 169
                Else If InStr(Label, "Previous snapshot", True)
                MouseMove ControlX + ControlWidth - 397, ControlY + 169
                Else
                MouseMove ControlX + ControlWidth - 381, ControlY + 169
            }
        }
    }
    
    #IncludeAgain KontaktKompleteKontrol/NoProduct.ahk
    #IncludeAgain KontaktKompleteKontrol/AudioImperia.ahk
    #IncludeAgain KontaktKompleteKontrol/CinematicStudioSeries.ahk
    
}
