#Requires AutoHotkey v2.0

Class Kontakt {
    
    Static PluginHeader := Object()
    Static StandaloneHeader := Object()
    Static PluginOverlays := Array()
    Static StandaloneOverlays := Array()
    Static XOffset := 0
    Static YOffset := 0
    
    Static __New() {
        ClassName := "Kontakt"
        #IncludeAgain KontaktKompleteKontrol/Overlay.Definitions.ahk
        
        PluginHeader := AccessibilityOverlay("Kontakt Full")
        PluginHeader.AddStaticText("Kontakt 7")
        PluginHeader.AddUIAControl("15,1,2", "FILE menu button",, Kontakt.OpenPluginMenu)
        PluginHeader.AddUIAControl("15,1,3", "LIBRARY On/Off button")
        PluginHeader.AddUIAControl("15,1,4", "VIEW menu button",, Kontakt.OpenPluginMenu)
        PluginHeader.AddUIAControl("15,1,7", "SHOP (Opens in default web browser) button")
        Kontakt.PluginHeader := PluginHeader
        
        StandaloneHeader := AccessibilityOverlay("Kontakt")
        StandaloneHeader.AddUIAControl("1,2", "FILE menu button",, Kontakt.OpenStandaloneMenu)
        StandaloneHeader.AddUIAControl("1,3", "LIBRARY On/Off button")
        StandaloneHeader.AddUIAControl("1,4", "VIEW menu button",, Kontakt.OpenStandaloneMenu)
        StandaloneHeader.AddUIAControl("1,5", "SHOP (Opens in default web browser) button")
        Kontakt.StandaloneHeader := StandaloneHeader
        
        Plugin.Register("Kontakt", "^Qt6[0-9][0-9]QWindowIcon\{[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\}1$", ObjBindMethod(Kontakt, "InitPlugin"), True, False, True, ObjBindMethod(Kontakt, "CheckPlugin"))
        
        For PluginOverlay In Kontakt.PluginOverlays
        Plugin.RegisterOverlay("Kontakt", PluginOverlay)
        
        Plugin.SetTimer("Kontakt", ObjBindMethod(AutoChangePluginOverlay,, "Kontakt", True, True), 500)
        
        Plugin.Register("Kontakt Content Missing Dialog", "^NIChildWindow[0-9A-F]{17}$",, False, False, False, ObjBindMethod(Kontakt, "CheckPluginContentMissing"))
        Plugin.SetHotkey("Kontakt Content Missing Dialog", "!F4", ObjBindMethod(Kontakt, "ClosePluginContentMissingDialog"))
        Plugin.SetHotkey("Kontakt Content Missing Dialog", "Escape", ObjBindMethod(Kontakt, "ClosePluginContentMissingDialog"))
        
        PluginContentMissingOverlay := AccessibilityOverlay("Content Missing")
        PluginContentMissingOverlay.AddHotspotButton("Browse For Folder", 226, 372)
        Plugin.RegisterOverlay("Kontakt Content Missing Dialog", PluginContentMissingOverlay)
        
        Standalone.Register("Kontakt", "Kontakt ahk_class NINormalWindow* ahk_exe Kontakt 7.exe")
        Standalone.RegisterOverlay("Kontakt", StandaloneHeader)
        
        Standalone.Register("Kontakt Content Missing Dialog", "Content Missing ahk_class #32770 ahk_exe Kontakt 7.exe")
        
        StandaloneContentMissingOverlay := AccessibilityOverlay("Content Missing")
        StandaloneContentMissingOverlay.AddHotspotButton("Browse For Folder", 226, 372)
        Standalone.RegisterOverlay("Kontakt Content Missing Dialog", StandaloneContentMissingOverlay)
    }
    
    Static CheckPlugin(*) {
        ReaperPluginNames := ["VST3i: Kontakt 7 (Native Instruments) (64 out)"]
        PluginInstance := Plugin.GetInstance(GetCurrentControlClass())
        If PluginInstance Is Plugin And PluginInstance.Name = "Kontakt"
        Return True
        If IniRead("ReaHotkey.ini", "Config", "UseImageSearchForPluginDetection", 1) = 1 {
            If FindImage("Images/KontaktKompleteKontrol/KontaktFull.png", GetPluginXCoordinate(), GetPluginYCoordinate(), GetPluginXCoordinate() + 400, GetPluginYCoordinate() + 150) Is Object
            Return True
            Else
            If FindImage("Images/KontaktKompleteKontrol/KontaktPlayer.png", GetPluginXCoordinate(), GetPluginYCoordinate(), GetPluginXCoordinate() + 400, GetPluginYCoordinate() + 150) Is Object
            Return True
        }
        Else {
            Try
            ReaperListItem := ListViewGetContent("Focused", "SysListView321", ReaHotkey.PluginWinCriteria)
            Catch
            ReaperListItem := ""
            If ReaperListItem != ""
            For ReaperPluginName In ReaperPluginNames
            If ReaperListItem = ReaperPluginName
            Return True
        }
        Return False
    }
    
    Static CheckPluginContentMissing(*) {
        PluginInstance := Plugin.GetInstance(GetCurrentControlClass())
        If PluginInstance Is Plugin And PluginInstance.Name = "Kontakt Content Missing Dialog"
        Return True
        If WinExist(ReaHotkey.PluginWinCriteria) And WinActive(ReaHotkey.PluginWinCriteria) And WinGetTitle("A") = "content Missing"
        Return True
        Return False
    }
    
    Static ClosePluginBrowser() {
        UIAElement := GetUIAElement("15,1,16,Button1")
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
        UIAElement := GetUIAElement("1,14,Button1")
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
    
}
