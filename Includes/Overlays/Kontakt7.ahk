﻿#Requires AutoHotkey v2.0

Class Kontakt7 {
    
    Static PluginHeader := Object()
    Static StandaloneHeader := Object()
    Static PluginOverlays := Array()
    Static StandaloneOverlays := Array()
    
    Static __New() {
        PluginHeader := AccessibilityOverlay("Kontakt 7")
        PluginHeader.AddStaticText("Kontakt 7")
        PluginHeader.AddCustomButton("FILE menu",,, Kontakt7.ActivatePluginHeaderButton).SetHotkey("!F", "Alt+F")
        PluginHeader.AddCustomButton("LIBRARY On/Off",,, Kontakt7.ActivatePluginHeaderButton).SetHotkey("!L", "Alt+L")
        PluginHeader.AddCustomButton("VIEW menu",,, Kontakt7.ActivatePluginHeaderButton).SetHotkey("!V", "Alt+V")
        PluginHeader.AddCustomButton("SHOP (Opens in default web browser)",,, Kontakt7.ActivatePluginHeaderButton).SetHotkey("!S", "Alt+S")
        PluginHeader.AddCustomButton("Snapshot menu", Kontakt7.MoveToPluginSnapshotButton,,, Kontakt7.ActivatePluginSnapshotButton).SetHotkey("!M", "Alt+M")
        PluginHeader.AddCustomButton("Previous snapshot", Kontakt7.MoveToPluginSnapshotButton,,, Kontakt7.ActivatePluginSnapshotButton).SetHotkey("!P", "Alt+P")
        PluginHeader.AddCustomButton("Next snapshot", Kontakt7.MoveToPluginSnapshotButton,,, Kontakt7.ActivatePluginSnapshotButton).SetHotkey("!N", "Alt+N")
        Kontakt7.PluginHeader := PluginHeader
        
        StandaloneHeader := AccessibilityOverlay("Kontakt 7")
        StandaloneHeader.AddCustomButton("FILE menu",,, Kontakt7.ActivateStandaloneHeaderButton).SetHotkey("!F", "Alt+F")
        StandaloneHeader.AddCustomButton("LIBRARY On/Off",,, Kontakt7.ActivateStandaloneHeaderButton).SetHotkey("!L", "Alt+L")
        StandaloneHeader.AddCustomButton("VIEW menu",,, Kontakt7.ActivateStandaloneHeaderButton).SetHotkey("!V", "Alt+V")
        StandaloneHeader.AddCustomButton("SHOP (Opens in default web browser)",,, Kontakt7.ActivateStandaloneHeaderButton).SetHotkey("!S", "Alt+S")
        Kontakt7.StandaloneHeader := StandaloneHeader
        
        Plugin.Register("Kontakt 7", "^Qt6[0-9][0-9]QWindowIcon\{[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\}1$", ObjBindMethod(Kontakt7, "InitPlugin"), True, False, False, ObjBindMethod(Kontakt7, "CheckPlugin"))
        
        For PluginOverlay In Kontakt7.PluginOverlays
        Plugin.RegisterOverlay("Kontakt 7", PluginOverlay)
        Plugin.RegisterOverlayHotkeys("Kontakt 7", PluginHeader)
        
        Plugin.SetTimer("Kontakt 7", ObjBindMethod(Kontakt7, "CheckPluginConfig"), -1)
        
        Plugin.Register("Kontakt 7 Content Missing Dialog", "^NIChildWindow[0-9A-F]{17}$",, False, False, True, ObjBindMethod(Kontakt7, "CheckPluginContentMissing"))
        Plugin.SetHotkey("Kontakt 7 Content Missing Dialog", "!F4", ObjBindMethod(Kontakt7, "ClosePluginContentMissingDialog"))
        Plugin.SetHotkey("Kontakt 7 Content Missing Dialog", "Escape", ObjBindMethod(Kontakt7, "ClosePluginContentMissingDialog"))
        
        PluginContentMissingOverlay := AccessibilityOverlay("Content Missing")
        PluginContentMissingOverlay.AddHotspotButton("Browse For Folder", 226, 372).SetHotkey("!B", "Alt+B")
        Plugin.RegisterOverlay("Kontakt 7 Content Missing Dialog", PluginContentMissingOverlay)
        
        Standalone.Register("Kontakt 7", "Kontakt ahk_class NINormalWindow* ahk_exe Kontakt 7.exe", False, False)
        Standalone.SetTimer("Kontakt 7", ObjBindMethod(Kontakt7, "CheckStandaloneConfig"), -1)
        Standalone.RegisterOverlay("Kontakt 7", StandaloneHeader)
        
        Standalone.Register("Kontakt 7 Content Missing Dialog", "Content Missing ahk_class #32770 ahk_exe Kontakt 7.exe", False, False)
        
        StandaloneContentMissingOverlay := AccessibilityOverlay("Content Missing")
        StandaloneContentMissingOverlay.AddHotspotButton("Browse For Folder", 226, 372).SetHotkey("!B", "Alt+B")
        Standalone.RegisterOverlay("Kontakt 7 Content Missing Dialog", StandaloneContentMissingOverlay)
    }
    
    Static CheckPlugin(*) {
        Thread "NoTimers"
        PluginInstance := Plugin.GetInstance(GetCurrentControlClass())
        If PluginInstance Is Plugin And PluginInstance.Name = "Kontakt 7"
        Return True
        UIAElement := GetUIAElement("15,1")
        Try
        If Not UIAElement = False And UIAElement.Name = "Kontakt 7" And UIAElement.ClassName = "ni::qt::QuickWindow"
        Return True
        Return False
    }
    
    Static CheckPluginConfig() {
        Static PluginAutoChangeFunction := ObjBindMethod(AutoChangePluginOverlay,, "Kontakt 7", True, True)
        If IniRead("ReaHotkey.ini", "Config", "AutomaticallyCloseLibrariBrowsersInKontaktAndKKPlugins", 1) = 1
        Kontakt7.ClosePluginBrowser()
        If IniRead("ReaHotkey.ini", "Config", "AutomaticallyDetectLibrariesInKontaktAndKKPlugins", 1) = 1
        Plugin.SetTimer("Kontakt 7", PluginAutoChangeFunction, 500)
        Else
        Plugin.SetTimer("Kontakt 7", PluginAutoChangeFunction, 0)
    }
    
    Static CheckPluginContentMissing(*) {
        Thread "NoTimers"
        PluginInstance := Plugin.GetInstance(GetCurrentControlClass())
        If PluginInstance Is Plugin And PluginInstance.Name = "Kontakt 7 Content Missing Dialog"
        Return True
        If WinExist(ReaHotkey.PluginWinCriteria) And WinActive(ReaHotkey.PluginWinCriteria) And WinGetTitle("A") = "content Missing"
        Return True
        Return False
    }
    
    Static CheckStandaloneConfig() {
        If IniRead("ReaHotkey.ini", "Config", "AutomaticallyCloseLibrariBrowsersInKontaktAndKKStandalones", 1) = 1
        Kontakt7.CloseStandaloneBrowser()
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
        If ReaHotkey.FoundPlugin.Name = "Kontakt 7 Content Missing Dialog" And WinGetTitle("A") = "content Missing" {
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
        PluginInstance.Overlay.ChildControls[1] := Kontakt7.PluginHeader.Clone()
        If Not HasProp(PluginInstance.Overlay, "Metadata") {
            PluginInstance.Overlay.Metadata := Map("Product", "None")
            PluginInstance.Overlay.OverlayNumber := 1
        }
        Plugin.RegisterOverlayHotkeys("Kontakt 7", PluginInstance.Overlay)
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
                Kontakt7.OpenMenu("Plugin")
                Case "LIBRARY On/Off":
                UIAElement.Click("Left")
                Case "VIEW menu":
                UIAElement.Click("Left")
                Kontakt7.OpenMenu("Plugin")
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
                Kontakt7.MoveToPluginSnapshotButton("Previous snapshot")
                If CheckColor()
                If InStr(SnapshotButton.Label, "Snapshot", True) {
                    Kontakt7.MoveToPluginSnapshotButton(SnapshotButton)
                    Click
                    Kontakt7.OpenPluginMenu()
                    Return
                }
                Else {
                    Kontakt7.MoveToPluginSnapshotButton(SnapshotButton)
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
                If UIAElement = False Or Not UIAElement.Name = "SHOP"
                UIAElement := GetUIAElement("1,7")
            }
            If Not UIAElement = False
            Switch HeaderButton.Label {
                Case "FILE menu":
                UIAElement.Click("Left")
                Kontakt7.OpenMenu("Standalone")
                Case "LIBRARY On/Off":
                UIAElement.Click("Left")
                Case "VIEW menu":
                UIAElement.Click("Left")
                Kontakt7.OpenMenu("Standalone")
                Case "SHOP (Opens in default web browser)":
                UIAElement.Click("Left")
            }
            Else
            AccessibilityOverlay.Speak(HeaderButton.Label . " button not found")
        }
    }
    
    Class CloseMenu {
        Static Call(Type, ThisHotkey) {
        Thread "NoTimers"
            SendCommand := ""
            If ThisHotkey = "Escape"
            SendCommand := "{Escape}"
            If ThisHotkey = "!F4"
            SendCommand := "!{F4}"
            If Type = "Plugin"
            HotIfWinActive(ReaHotkey.PluginWinCriteria)
            If Type = "Standalone"
            HotIf
            If Type = "Plugin" And ReaHotkey.FoundPlugin Is Plugin And ReaHotkey.FoundPlugin.Name = "Kontakt 7" And ReaHotkey.FoundPlugin.NoHotkeys = True {
                ReaHotkey.FoundPlugin.SetNoHotkeys(False)
                TurnHotkeysOff()
                If Not SendCommand = ""
                Send SendCommand
            }
            Else If Type = "Plugin" And ReaHotkey.FoundPlugin Is Plugin And ReaHotkey.FoundPlugin.Name = "Kontakt 7 Content Missing Dialog" {
                Plugin.SetNoHotkeys("Kontakt 7", False)
                TurnHotkeysOff()
                If Not SendCommand = ""
                Send SendCommand
            }
            Else If Type = "Standalone" And ReaHotkey.foundStandalone Is Standalone And ReaHotkey.foundStandalone.Name = "Kontakt 7" And ReaHotkey.FoundStandalone.NoHotkeys = True {
                ReaHotkey.foundStandalone.SetNoHotkeys(False)
                TurnHotkeysOff()
                If Not SendCommand = ""
                Send SendCommand
            }
            Else If Type = "Standalone" And ReaHotkey.foundStandalone Is Standalone And ReaHotkey.foundStandalone.Name = "Kontakt 7 Content Missing Dialog" {
                Standalone.SetNoHotkeys("Kontakt 7", False)
                TurnHotkeysOff()
                If Not SendCommand = ""
                Send SendCommand
            }
            Else {
                TurnHotkeysOff()
                If Not SendCommand = ""
                Send SendCommand
                TurnHotkeysOn()
            }
            TurnHotkeysOff() {
                ReaHotkey.Override%Type%Hotkey("Kontakt 7", "Escape", "Off")
                ReaHotkey.Override%Type%Hotkey("Kontakt 7", "!F4", "Off")
                ReaHotkey.Override%Type%Hotkey("Kontakt 7 Content Missing Dialog", "Escape", "Off")
                ReaHotkey.Override%Type%Hotkey("Kontakt 7 Content Missing Dialog", "!F4", "Off")
            }
            TurnHotkeysOn() {
                ReaHotkey.Override%Type%Hotkey("Kontakt 7", "Escape", "On")
                ReaHotkey.Override%Type%Hotkey("Kontakt 7", "!F4", "On")
                ReaHotkey.Override%Type%Hotkey("Kontakt 7 Content Missing Dialog", "Escape", "On")
                ReaHotkey.Override%Type%Hotkey("Kontakt 7 Content Missing Dialog", "!F4", "On")
            }
        }
    }
    
    Class ClosePluginMenu {
        Static Call(ThisHotkey) {
            Kontakt7.CloseMenu("Plugin", ThisHotkey)
        }
    }
    
    Class CloseStandaloneMenu {
        Static Call(ThisHotkey) {
            Kontakt7.CloseMenu("Standalone", ThisHotkey)
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
    
    Class OpenMenu {
        Static Call(Type) {
            If ReaHotkey.Found%Type% Is %Type%
            ReaHotkey.Found%Type%.SetNoHotkeys(True)
            If Type = "Plugin"
            HotIfWinActive(ReaHotkey.PluginWinCriteria)
            If Type = "Standalone"
            HotIf
            ReaHotkey.Override%Type%Hotkey("Kontakt 7", "Escape", Kontakt7.Close%Type%Menu, "On")
            ReaHotkey.Override%Type%Hotkey("Kontakt 7", "!F4", Kontakt7.Close%Type%Menu, "On")
            ReaHotkey.Override%Type%Hotkey("Kontakt 7 Content Missing Dialog", "Escape", Kontakt7.Close%Type%Menu, "On")
            ReaHotkey.Override%Type%Hotkey("Kontakt 7 Content Missing Dialog", "!F4", Kontakt7.Close%Type%Menu, "On")
        }
    }
    
    Class OpenPluginMenu {
        Static Call(*) {
            Kontakt7.OpenMenu("Plugin")
        }
    }
    
    Class OpenStandaloneMenu {
        Static Call(*) {
            Kontakt7.OpenMenu("Standalone")
        }
    }
    
    #IncludeAgain KontaktKompleteKontrol/NoProduct.ahk
    #IncludeAgain KontaktKompleteKontrol/AudioImperia.ahk
    #IncludeAgain KontaktKompleteKontrol/CinematicStudioSeries.ahk
    
}
