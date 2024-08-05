#Requires AutoHotkey v2.0

Class Kontakt {
    
    Static PluginHeader := Object()
    Static StandaloneHeader := Object()
    Static PluginOverlays := Array()
    Static StandaloneOverlays := Array()
    
    Static __New() {
        ClassName := "Kontakt"
        #IncludeAgain KontaktKompleteKontrol/Overlay.Definitions.ahk
        
        PluginHeader := AccessibilityOverlay("Kontakt")
        PluginHeader.AddStaticText("Kontakt 7")
        PluginHeader.AddCustomButton("FILE menu",, Kontakt.ActivatePluginHeaderButton)
        PluginHeader.AddCustomButton("LIBRARY On/Off",, Kontakt.ActivatePluginHeaderButton)
        PluginHeader.AddCustomButton("VIEW menu",, Kontakt.ActivatePluginHeaderButton)
        PluginHeader.AddCustomButton("SHOP (Opens in default web browser)",, Kontakt.ActivatePluginHeaderButton)
        PluginHeader.AddCustomButton("Previous snapshot", Kontakt.MoveToPluginSnapshotButton, Kontakt.ActivatePluginSnapshotButton)
        PluginHeader.AddCustomButton("Next snapshot", Kontakt.MoveToPluginSnapshotButton, Kontakt.ActivatePluginSnapshotButton)
        Kontakt.PluginHeader := PluginHeader
        
        StandaloneHeader := AccessibilityOverlay("Kontakt")
        StandaloneHeader.AddCustomButton("FILE menu",, Kontakt.ActivateStandaloneHeaderButton)
        StandaloneHeader.AddCustomButton("LIBRARY On/Off",, Kontakt.ActivateStandaloneHeaderButton)
        StandaloneHeader.AddCustomButton("VIEW menu",, Kontakt.ActivateStandaloneHeaderButton)
        StandaloneHeader.AddCustomButton("SHOP (Opens in default web browser)",, Kontakt.ActivateStandaloneHeaderButton)
        Kontakt.StandaloneHeader := StandaloneHeader
        
        Plugin.Register("Kontakt", "^Qt6[0-9][0-9]QWindowIcon\{[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\}1$", ObjBindMethod(Kontakt, "InitPlugin"), True, False, True, ObjBindMethod(Kontakt, "CheckPlugin"))
        
        For PluginOverlay In Kontakt.PluginOverlays
        Plugin.RegisterOverlay("Kontakt", PluginOverlay)
        
        Plugin.SetTimer("Kontakt", ObjBindMethod(Kontakt, "CheckPluginConfig"), -1)
        
        Plugin.Register("Kontakt Content Missing Dialog", "^NIChildWindow[0-9A-F]{17}$",, False, False, False, ObjBindMethod(Kontakt, "CheckPluginContentMissing"))
        Plugin.SetHotkey("Kontakt Content Missing Dialog", "!F4", ObjBindMethod(Kontakt, "ClosePluginContentMissingDialog"))
        Plugin.SetHotkey("Kontakt Content Missing Dialog", "Escape", ObjBindMethod(Kontakt, "ClosePluginContentMissingDialog"))
        
        PluginContentMissingOverlay := AccessibilityOverlay("Content Missing")
        PluginContentMissingOverlay.AddHotspotButton("Browse For Folder", 226, 372)
        Plugin.RegisterOverlay("Kontakt Content Missing Dialog", PluginContentMissingOverlay)
        
        Standalone.Register("Kontakt", "Kontakt ahk_class NINormalWindow* ahk_exe Kontakt 7.exe")
        Standalone.SetTimer("Kontakt", ObjBindMethod(Kontakt, "CheckStandaloneConfig"), -1)
        Standalone.RegisterOverlay("Kontakt", StandaloneHeader)
        
        Standalone.Register("Kontakt Content Missing Dialog", "Content Missing ahk_class #32770 ahk_exe Kontakt 7.exe")
        
        StandaloneContentMissingOverlay := AccessibilityOverlay("Content Missing")
        StandaloneContentMissingOverlay.AddHotspotButton("Browse For Folder", 226, 372)
        Standalone.RegisterOverlay("Kontakt Content Missing Dialog", StandaloneContentMissingOverlay)
    }
    
    Static CheckPlugin(*) {
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
            Try
            ControlGetPos &ControlX, &ControlY, &ControlWidth, &ControlHeight, ReaHotkey.GetPluginControl(), "A"
            Catch
            Return
            Click ControlX + ControlWidth - 296, ControlY + 141
            Kontakt.MoveToPluginSnapshotButton(SnapshotButton)
            MouseGetPos &mouseXPosition, &mouseYPosition
            If PixelGetColor(MouseXPosition, MouseYPosition, "Slow") != "0x424142" And PixelGetColor(MouseXPosition, MouseYPosition, "Slow") != "0x545454"
            AccessibilityOverlay.Speak("Snapshot switching unavailable. Make sure that you're in rack view.")
            Else
            Click
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
    
    Class MoveToPluginSnapshotButton {
        Static Call(SnapshotButton) {
            Try
            ControlGetPos &ControlX, &ControlY, &ControlWidth, &ControlHeight, ReaHotkey.GetPluginControl(), "A"
            Catch
            Return
            If SnapshotButton.Label = "Previous snapshot"
            MouseMove ControlX + ControlWidth - 397, ControlY + 169
            Else
            MouseMove ControlX + ControlWidth - 381, ControlY + 169
        }
    }
    
}
