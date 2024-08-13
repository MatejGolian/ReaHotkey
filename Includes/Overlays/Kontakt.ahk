#Requires AutoHotkey v2.0

Class Kontakt {
    
    Static PluginHeader := Object()
    Static StandaloneHeader := Object()
    Static PluginOverlays := Array()
    Static StandaloneOverlays := Array()
    
    Static __New() {
        PluginHeader := AccessibilityOverlay("Kontakt")
        PluginHeader.AddStaticText("Kontakt 7")
        PluginHeader.AddCustomButton("FILE menu",, Kontakt.ActivatePluginHeaderButton).SetHotkey("!F", "Alt+F")
        PluginHeader.AddCustomButton("LIBRARY On/Off",, Kontakt.ActivatePluginHeaderButton).SetHotkey("!L", "Alt+L")
        PluginHeader.AddCustomButton("VIEW menu",, Kontakt.ActivatePluginHeaderButton).SetHotkey("!V", "Alt+V")
        PluginHeader.AddCustomButton("SHOP (Opens in default web browser)",, Kontakt.ActivatePluginHeaderButton).SetHotkey("!S", "Alt+S")
        PluginHeader.AddCustomButton("Snapshot menu", Kontakt.MoveToPluginSnapshotButton, Kontakt.ActivatePluginSnapshotButton).SetHotkey("!M", "Alt+M")
        PluginHeader.AddCustomButton("Previous snapshot", Kontakt.MoveToPluginSnapshotButton, Kontakt.ActivatePluginSnapshotButton).SetHotkey("!P", "Alt+P")
        PluginHeader.AddCustomButton("Next snapshot", Kontakt.MoveToPluginSnapshotButton, Kontakt.ActivatePluginSnapshotButton).SetHotkey("!N", "Alt+N")
        Kontakt.PluginHeader := PluginHeader
        
        StandaloneHeader := AccessibilityOverlay("Kontakt")
        StandaloneHeader.AddCustomButton("FILE menu",, Kontakt.ActivateStandaloneHeaderButton).SetHotkey("!F", "Alt+F")
        StandaloneHeader.AddCustomButton("LIBRARY On/Off",, Kontakt.ActivateStandaloneHeaderButton).SetHotkey("!L", "Alt+L")
        StandaloneHeader.AddCustomButton("VIEW menu",, Kontakt.ActivateStandaloneHeaderButton).SetHotkey("!V", "Alt+V")
        StandaloneHeader.AddCustomButton("SHOP (Opens in default web browser)",, Kontakt.ActivateStandaloneHeaderButton).SetHotkey("!S", "Alt+S")
        Kontakt.StandaloneHeader := StandaloneHeader
        
        Plugin.Register("Kontakt", "^Qt6[0-9][0-9]QWindowIcon\{[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\}1$", ObjBindMethod(Kontakt, "InitPlugin"), True, False, False, ObjBindMethod(Kontakt, "CheckPlugin"))
        
        For PluginOverlay In Kontakt.PluginOverlays
        Plugin.RegisterOverlay("Kontakt", PluginOverlay)
        Plugin.RegisterOverlayHotkeys("Kontakt", PluginHeader)
        
        Plugin.SetTimer("Kontakt", ObjBindMethod(Kontakt, "CheckPluginConfig"), -1)
        
        Plugin.Register("Kontakt Content Missing Dialog", "^NIChildWindow[0-9A-F]{17}$",, False, False, True, ObjBindMethod(Kontakt, "CheckPluginContentMissing"))
        Plugin.SetHotkey("Kontakt Content Missing Dialog", "!F4", ObjBindMethod(Kontakt, "ClosePluginContentMissingDialog"))
        Plugin.SetHotkey("Kontakt Content Missing Dialog", "Escape", ObjBindMethod(Kontakt, "ClosePluginContentMissingDialog"))
        
        PluginContentMissingOverlay := AccessibilityOverlay("Content Missing")
        PluginContentMissingOverlay.AddHotspotButton("Browse For Folder", 226, 372).SetHotkey("!B", "Alt+B")
        Plugin.RegisterOverlay("Kontakt Content Missing Dialog", PluginContentMissingOverlay)
        
        Standalone.Register("Kontakt", "Kontakt ahk_class NINormalWindow* ahk_exe Kontakt 7.exe", False, False)
        Standalone.SetTimer("Kontakt", ObjBindMethod(Kontakt, "CheckStandaloneConfig"), -1)
        Standalone.RegisterOverlay("Kontakt", StandaloneHeader)
        
        Standalone.Register("Kontakt Content Missing Dialog", "Content Missing ahk_class #32770 ahk_exe Kontakt 7.exe", False, False)
        
        StandaloneContentMissingOverlay := AccessibilityOverlay("Content Missing")
        StandaloneContentMissingOverlay.AddHotspotButton("Browse For Folder", 226, 372).SetHotkey("!B", "Alt+B")
        Standalone.RegisterOverlay("Kontakt Content Missing Dialog", StandaloneContentMissingOverlay)
    }
    
    Static CheckPlugin(*) {
    Thread "NoTimers"
        PluginInstance := Plugin.GetInstance(GetCurrentControlClass())
        If PluginInstance Is Plugin And PluginInstance.Name = "Kontakt"
        Return True
        UIAElement := GetUIAElement("15,1")
        Try
        If UIAElement != False And UIAElement.Name = "Kontakt 7" And UIAElement.ClassName = "ni::qt::QuickWindow"
        Return True
        Return False
    }
    
    Static CheckPluginConfig() {
        Static PluginAutoChangeFunction := ObjBindMethod(AutoChangePluginOverlay,, "Kontakt", True, True)
        If IniRead("ReaHotkey.ini", "Config", "AutomaticallyCloseLibrariBrowsersInKontaktAndKKPlugins", 1) = 1
        Kontakt.ClosePluginBrowser()
        If IniRead("ReaHotkey.ini", "Config", "AutomaticallyDetectLibrariesInKontaktAndKKPlugins", 1) = 1
        Plugin.SetTimer("Kontakt", PluginAutoChangeFunction, 500)
        Else
        Plugin.SetTimer("Kontakt", PluginAutoChangeFunction, 0)
    }
    
    Static CheckPluginContentMissing(*) {
    Thread "NoTimers"
        PluginInstance := Plugin.GetInstance(GetCurrentControlClass())
        If PluginInstance Is Plugin And PluginInstance.Name = "Kontakt Content Missing Dialog"
        Return True
        If WinExist(ReaHotkey.PluginWinCriteria) And WinActive(ReaHotkey.PluginWinCriteria) And WinGetTitle("A") = "content Missing"
        Return True
        Return False
    }
    
    Static CheckStandaloneConfig() {
        If IniRead("ReaHotkey.ini", "Config", "AutomaticallyCloseLibrariBrowsersInKontaktAndKKStandalones", 1) = 1
        Kontakt.CloseStandaloneBrowser()
    }
    
    Static ClosePluginBrowser() {
        UIAElement := GetUIAElement("15,1,14,3")
        If UIAElement != False And RegExMatch(UIAElement.ClassName, "^LumenButton_QMLTYPE_[0-9]+$") {
            UIAElement.Click()
            AccessibilityOverlay.Speak("Library Browser closed.")
            Sleep 1000
        }
        UIAElement := GetUIAElement("15,1,16,3")
        If UIAElement != False And RegExMatch(UIAElement.ClassName, "^LumenButton_QMLTYPE_[0-9]+$") {
            UIAElement.Click()
            AccessibilityOverlay.Speak("Library Browser closed.")
            Sleep 1000
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
        UIAElement := GetUIAElement("1,14,3")
        If UIAElement != False And RegExMatch(UIAElement.ClassName, "^LumenButton_QMLTYPE_[0-9]+$") {
            UIAElement.Click()
            AccessibilityOverlay.Speak("Library Browser closed.")
            Sleep 1000
        }
        UIAElement := GetUIAElement("1,16,3")
        If UIAElement != False And RegExMatch(UIAElement.ClassName, "^LumenButton_QMLTYPE_[0-9]+$") {
            UIAElement.Click()
            AccessibilityOverlay.Speak("Library Browser closed.")
            Sleep 1000
        }
    }
    
    Static InitPlugin(PluginInstance) {
        If PluginInstance.Overlay.ChildControls.Length = 0
        PluginInstance.Overlay.AddAccessibilityOverlay()
        PluginInstance.Overlay.ChildControls[1] := Kontakt.PluginHeader.Clone()
        If Not HasProp(PluginInstance.Overlay, "Metadata") {
            PluginInstance.Overlay.Metadata := Map("Product", "None")
            PluginInstance.Overlay.OverlayNumber := 1
        }
        Plugin.RegisterOverlayHotkeys("Kontakt", PluginInstance.Overlay)
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
                If UIAElement = False Or UIAElement.Name != "SHOP"
                UIAElement := GetUIAElement("15,1,7")
            }
            If UIAElement != False
            Switch HeaderButton.Label {
                Case "FILE menu":
                UIAElement.Click("Left")
                Kontakt.OpenMenu("Plugin")
                Case "LIBRARY On/Off":
                UIAElement.Click("Left")
                Case "VIEW menu":
                UIAElement.Click("Left")
                Kontakt.OpenMenu("Plugin")
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
            If UIAElement != False And UIAElement.Name = "SHOP" {
                Try
                ControlGetPos &ControlX, &ControlY, &ControlWidth, &ControlHeight, ReaHotkey.GetPluginControl(), "A"
                Catch
                Return
                Click ControlX + ControlWidth - 296, ControlY + 141
                Sleep 10
                Kontakt.MoveToPluginSnapshotButton("Previous snapshot")
                If CheckColor()
                If InStr(SnapshotButton.Label, "Snapshot", True) {
                    Kontakt.MoveToPluginSnapshotButton(SnapshotButton)
                    Click
                    Kontakt.OpenPluginMenu()
                    Return
                }
                Else {
                    Kontakt.MoveToPluginSnapshotButton(SnapshotButton)
                    Click
                    Return
                }
            }
            AccessibilityOverlay.Speak("Snapshot switching unavailable. Make sure that an instrument is loaded and that you're in rack view.")
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
                If UIAElement = False Or UIAElement.Name != "SHOP"
                UIAElement := GetUIAElement("1,7")
            }
            If UIAElement != False
            Switch HeaderButton.Label {
                Case "FILE menu":
                UIAElement.Click("Left")
                Kontakt.OpenMenu("Standalone")
                Case "LIBRARY On/Off":
                UIAElement.Click("Left")
                Case "VIEW menu":
                UIAElement.Click("Left")
                Kontakt.OpenMenu("Standalone")
                Case "SHOP (Opens in default web browser)":
                UIAElement.Click("Left")
            }
            Else
            AccessibilityOverlay.Speak(HeaderButton.Label . " button not found")
        }
    }
    
    Class CloseMenu {
        Static Call(Type, ThisHotkey) {
            SendCommand := ""
            If ThisHotkey = "Escape"
            SendCommand := "{Escape}"
            If ThisHotkey = "!F4"
            SendCommand := "!{F4}"
            If Type = "Plugin"
            HotIfWinActive(ReaHotkey.PluginWinCriteria)
            If Type = "Standalone"
            HotIf
            If (Type = "Plugin" And WinActive(ReaHotkey.PluginWinCriteria) And ReaHotkey.FoundPlugin Is Plugin And ReaHotkey.FoundPlugin.Name = "Kontakt") Or (Type = "Standalone" And WinActive("Kontakt ahk_class NINormalWindow* ahk_exe Kontakt 7.exe")) {
                %Type%.SetNoHotkeys("Kontakt", False)
                ReaHotkey.Override%Type%Hotkey("", "Escape", "Off")
                ReaHotkey.Override%Type%Hotkey("", "!F4", "Off")
                If SendCommand != ""
                Send SendCommand
            }
            Else If type = "Plugin" And WinExist(ReaHotkey.PluginWinCriteria) And WinActive(ReaHotkey.PluginWinCriteria) And WinGetTitle("A") = "Content Missing" {
                %Type%.SetNoHotkeys("Kontakt", False)
                ReaHotkey.Override%Type%Hotkey("", "Escape", "Off")
                ReaHotkey.Override%Type%Hotkey("", "!F4", "Off")
                If SendCommand != ""
                Send SendCommand
            }
            Else If Type = "Standalone" And WinExist("Content Missing ahk_class #32770 ahk_exe Kontakt 7.exe") And WinActive("Content Missing ahk_class #32770 ahk_exe Kontakt 7.exe") {
                %Type%.SetNoHotkeys("Kontakt", False)
                ReaHotkey.Override%Type%Hotkey("", "Escape", "Off")
                ReaHotkey.Override%Type%Hotkey("", "!F4", "Off")
                If SendCommand != ""
                Send SendCommand
            }
            Else {
                ReaHotkey.Override%Type%Hotkey("", "Escape", "Off")
                ReaHotkey.Override%Type%Hotkey("", "!F4", "Off")
                If SendCommand != ""
                Send SendCommand
                ReaHotkey.Override%Type%Hotkey("", "Escape", "On")
                ReaHotkey.Override%Type%Hotkey("", "!F4", "On")
            }
        }
    }
    
    Class ClosePluginMenu {
        Static Call(ThisHotkey) {
            Kontakt.CloseMenu("Plugin", ThisHotkey)
        }
    }
    
    Class CloseStandaloneMenu {
        Static Call(ThisHotkey) {
            Kontakt.CloseMenu("Standalone", ThisHotkey)
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
            If UIAElement != False And UIAElement.Name = "SHOP" {
                Try
                ControlGetPos &ControlX, &ControlY, &ControlWidth, &ControlHeight, ReaHotkey.GetPluginControl(), "A"
                Catch
                Return
                If SnapshotButton Is Object And InStr(SnapshotButton.Label, "Snapshot", True) {
                    OCRResult := AccessibilityOverlay.Ocr(ControlX + ControlWidth - 580, ControlY + 160, ControlX + ControlWidth - 580 + 200, ControlY + 180)
                    If OCRResult != ""
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
    
    Class OpenMenu {
        Static Call(Type) {
            If ReaHotkey.Found%Type% Is %Type%
            ReaHotkey.Found%Type%.SetNoHotkeys(True)
            If Type = "Plugin"
            HotIfWinActive(ReaHotkey.PluginWinCriteria)
            If Type = "Standalone"
            HotIf
            ReaHotkey.Override%Type%Hotkey("", "Escape", Kontakt.Close%Type%Menu, "On")
            ReaHotkey.Override%Type%Hotkey("", "!F4", Kontakt.Close%Type%Menu, "On")
        }
    }
    
    Class OpenPluginMenu {
        Static Call(*) {
            Kontakt.OpenMenu("Plugin")
        }
    }
    
    Class OpenStandaloneMenu {
        Static Call(*) {
            Kontakt.OpenMenu("Standalone")
        }
    }
    
    #IncludeAgain KontaktKompleteKontrol/NoProduct.ahk
    #IncludeAgain KontaktKompleteKontrol/AudioImperia.ahk
    #IncludeAgain KontaktKompleteKontrol/CinematicStudioSeries.ahk
    
}
