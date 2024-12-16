#Requires AutoHotkey v2.0

Class KompleteKontrol {
    
    Static PluginHeader := Object()
    Static StandaloneHeader := Object()
    Static PluginOverlays := Array()
    Static StandaloneOverlays := Array()
    
    Static __New() {
        KompleteKontrol.InitConfig()
        
        PluginHeader := AccessibilityOverlay("Komplete Kontrol")
        PluginHeader.AddStaticText("Komplete Kontrol")
        PluginHeader.AddHotspotButton("Menu", 297, 17, CompensatePluginCoordinates,, CompensatePluginCoordinates).SetHotkey("!M", "Alt+M")
        KompleteKontrol.PluginHeader := PluginHeader
        
        StandaloneHeader := AccessibilityOverlay("Komplete Kontrol")
        StandaloneHeader.AddHotspotButton("File menu", 16, -10).SetHotkey("!F", "Alt+F")
        StandaloneHeader.AddHotspotButton("Edit menu", 52, -10).SetHotkey("!E", "Alt+E")
        StandaloneHeader.AddHotspotButton("View menu", 83, -10).SetHotkey("!V", "Alt+V")
        StandaloneHeader.AddHotspotButton("Controller menu", 138, -10).SetHotkey("!C", "Alt+C")
        StandaloneHeader.AddHotspotButton("Help menu", 194, -10).SetHotkey("!H", "Alt+H")
        KompleteKontrol.StandaloneHeader := StandaloneHeader
        
        Plugin.Register("Komplete Kontrol", "^Qt6[0-9][0-9]QWindowIcon\{[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\}1$", ObjBindMethod(KompleteKontrol, "InitPlugin"), True, False, False, ObjBindMethod(KompleteKontrol, "CheckPlugin"))
        
        For PluginOverlay In KompleteKontrol.PluginOverlays
        Plugin.RegisterOverlay("Komplete Kontrol", PluginOverlay)
        Plugin.RegisterOverlayHotkeys("Komplete Kontrol", PluginHeader)
        
        Plugin.SetTimer("Komplete Kontrol", ObjBindMethod(KompleteKontrol, "CheckPluginConfig"), -1)
        
        Plugin.Register("Komplete Kontrol Preference Dialog", "^NIChildWindow[0-9A-F]{17}$",, False, False, True, ObjBindMethod(KompleteKontrol, "CheckPluginPreferenceDialog"))
        
        PluginPreferenceOverlay := AccessibilityOverlay()
        PluginPreferenceTabControl := PluginPreferenceOverlay.AddTabControl()
        PluginPreferenceMIDITab := HotspotTab("MIDI", 49, 62)
        PluginPreferenceMIDITab.AddCustomButton("Close",,, ObjBindMethod(KompleteKontrol, "ClosePluginPreferenceDialog"))
        PluginPreferenceGeneralTab := HotspotTab("General", 49, 107)
        PluginPreferenceGeneralTab.AddCustomButton("Close",,, ObjBindMethod(KompleteKontrol, "ClosePluginPreferenceDialog"))
        PluginPreferenceLibraryTab := HotspotTab("Library", 49, 148)
        PluginPreferenceLibraryTabTabControl := PluginPreferenceLibraryTab.AddTabControl()
        PluginPreferenceLibraryFactoryTab := HotspotTab("Factory", 149, 69)
        PluginPreferenceLibraryFactoryTab.AddHotspotButton("Rescan", 539, 410)
        PluginPreferenceLibraryUserTab := HotspotTab("User", 233, 69)
        PluginPreferenceLibraryUserTab.AddHotspotButton("Add Directory", 163, 413)
        PluginPreferenceLibraryUserTab.AddHotspotCheckbox("Scan user content for changes at start-up", 412, 387, ["0xCCCCCC", "0xFFFFFF"], ["0x323232", "0x5F5F5F"])
        PluginPreferenceLibraryUserTab.AddHotspotButton("Rescan", 539, 410)
        PluginPreferenceLibraryTabTabControl.AddTabs(PluginPreferenceLibraryFactoryTab, PluginPreferenceLibraryUserTab)
        PluginPreferenceLibraryTab.AddCustomButton("Close",,, ObjBindMethod(KompleteKontrol, "ClosePluginPreferenceDialog"))
        PluginPreferencePluginTab := HotspotTab("Plug-ins", 49, 189)
        PluginPreferencePluginTab.AddHotspotCheckbox("Always Use Latest Version Of NI Plug-ins", 412, 391, ["0xCCCCCC", "0xFFFFFF"], ["0x323232", "0x5F5F5F"])
        PluginPreferencePluginTab.AddHotspotButton("Rescan", 546, 417)
        PluginPreferencePluginTab.AddCustomButton("Close",,, ObjBindMethod(KompleteKontrol, "ClosePluginPreferenceDialog"))
        PluginPreferenceTabControl.AddTabs(PluginPreferenceMIDITab, PluginPreferenceGeneralTab, PluginPreferenceLibraryTab, PluginPreferencePluginTab)
        Plugin.RegisterOverlay("Komplete Kontrol Preference Dialog", PluginPreferenceOverlay)
        
        Plugin.Register("Komplete Kontrol Save As Dialog", "^NIChildWindow[0-9A-F]{17}$",, False, False, True, ObjBindMethod(KompleteKontrol, "CheckPluginSaveAsDialog"))
        
        PluginSaveAsOverlay := AccessibilityOverlay()
        PluginSaveAsOverlay.AddOCREdit("Save Preset, Name:", 24, 72, 500, 88)
        PluginSaveAsOverlay.AddHotspotButton("Save", 219, 135)
        PluginSaveAsOverlay.AddHotspotButton("Cancel", 301, 135)
        Plugin.RegisterOverlay("Komplete Kontrol Save As Dialog", PluginSaveAsOverlay)
        
        Standalone.Register("Komplete Kontrol", "Komplete Kontrol ahk_class NINormalWindow* ahk_exe Komplete Kontrol.exe",, False, False)
        Standalone.SetTimer("Komplete Kontrol", ObjBindMethod(KompleteKontrol, "CheckStandaloneConfig"), -1)
        Standalone.RegisterOverlay("Komplete Kontrol", StandaloneHeader)
        
        Standalone.Register("Komplete Kontrol Preference Dialog", "Preferences ahk_class #32770 ahk_exe Komplete Kontrol.exe", ObjBindMethod(KompleteKontrol, "FocusStandalonePreferenceTab"), False, False)
        Standalone.SetHotkey("Komplete Kontrol Preference Dialog", "^,", ObjBindMethod(KompleteKontrol, "ManageStandalonePreferenceDialog"))
        
        StandalonePreferenceOverlay := AccessibilityOverlay()
        StandalonePreferenceTabControl := StandalonePreferenceOverlay.AddTabControl()
        StandalonePreferenceAudioTab := HotspotTab("Audio", 49, 62)
        StandalonePreferenceAudioTab.AddCustomButton("Close",,, ObjBindMethod(KompleteKontrol, "CloseStandalonePreferenceDialog"))
        StandalonePreferenceMIDITab := HotspotTab("MIDI", 49, 107)
        StandalonePreferenceMIDITab.AddCustomButton("Close",,, ObjBindMethod(KompleteKontrol, "CloseStandalonePreferenceDialog"))
        StandalonePreferenceGeneralTab := HotspotTab("General", 49, 148)
        StandalonePreferenceGeneralTab.AddCustomButton("Close",,, ObjBindMethod(KompleteKontrol, "CloseStandalonePreferenceDialog"))
        StandalonePreferenceLibraryTab := HotspotTab("Library", 49, 189)
        StandalonePreferenceLibraryTabTabControl := StandalonePreferenceLibraryTab.AddTabControl()
        StandalonePreferenceLibraryFactoryTab := HotspotTab("Factory", 149, 69)
        StandalonePreferenceLibraryFactoryTab.AddHotspotButton("Rescan", 539, 410)
        StandalonePreferenceLibraryUserTab := HotspotTab("User", 233, 69)
        StandalonePreferenceLibraryUserTab.AddHotspotButton("Add Directory", 163, 413)
        StandalonePreferenceLibraryUserTab.AddHotspotCheckbox("Scan user content for changes at start-up", 412, 387, ["0xCCCCCC", "0xFFFFFF"], ["0x323232", "0x5F5F5F"])
        StandalonePreferenceLibraryUserTab.AddHotspotButton("Rescan", 539, 410)
        StandalonePreferenceLibraryTabTabControl.AddTabs(StandalonePreferenceLibraryFactoryTab, StandalonePreferenceLibraryUserTab)
        StandalonePreferenceLibraryTab.AddCustomButton("Close",,, ObjBindMethod(KompleteKontrol, "CloseStandalonePreferenceDialog"))
        StandalonePreferencePluginTab := HotspotTab("Plug-ins", 49, 230)
        StandalonePreferencePluginTab.AddHotspotCheckbox("Always Use Latest Version Of NI Plug-ins", 412, 391, ["0xCCCCCC", "0xFFFFFF"], ["0x323232", "0x5F5F5F"])
        StandalonePreferencePluginTab.AddHotspotButton("Rescan", 539, 410)
        StandalonePreferencePluginTab.AddCustomButton("Close",,, ObjBindMethod(KompleteKontrol, "CloseStandalonePreferenceDialog"))
        StandalonePreferenceTabControl.AddTabs(StandalonePreferenceAudioTab, StandalonePreferenceMIDITab, StandalonePreferenceGeneralTab, StandalonePreferenceLibraryTab, StandalonePreferencePluginTab)
        Standalone.RegisterOverlay("Komplete Kontrol Preference Dialog", StandalonePreferenceOverlay)
        
        Standalone.Register("Komplete Kontrol Save As Dialog", "ahk_class #32770 ahk_exe Komplete Kontrol.exe",, False, False, ObjBindMethod(KompleteKontrol, "CheckStandaloneSaveAsDialog"))
        
        StandaloneSaveAsOverlay := AccessibilityOverlay()
        StandaloneSaveAsOverlay.AddOCREdit("Save Preset, Name:", 24, 72, 500, 88)
        StandaloneSaveAsOverlay.AddHotspotButton("Save", 219, 135)
        StandaloneSaveAsOverlay.AddHotspotButton("Cancel", 301, 135)
        Standalone.RegisterOverlay("Komplete Kontrol Save As Dialog", StandaloneSaveAsOverlay)
    }
    
    Static CheckPlugin(*) {
        Thread "NoTimers"
        PluginInstance := Plugin.GetInstance(GetCurrentControlClass())
        If PluginInstance Is Plugin And PluginInstance.Name = "Komplete Kontrol"
        Return True
        If ReaHotkey.PluginNative {
            StartingPath := KompleteKontrol.GetPluginStartingPath()
            If StartingPath
            Return True
        }
        Return False
    }
    
    Static CheckPluginConfig() {
        Static PluginAutoChangeFunction := ObjBindMethod(AutoChangePluginOverlay,, "Komplete Kontrol", True, True)
        If ReaHotkey.Config.Get("CloseKKBrowser") = 1
        KompleteKontrol.ClosePluginBrowser()
        If ReaHotkey.Config.Get("DetectLibsInKK") = 1
        Plugin.SetTimer("Komplete Kontrol", PluginAutoChangeFunction, 500)
        Else
        Plugin.SetTimer("Komplete Kontrol", PluginAutoChangeFunction, 0)
    }
    
    Static CheckPluginPreferenceDialog(PluginData) {
        Thread "NoTimers"
        Static PreviousWinID := ""
        CurrentWinID := WinGetID("A")
        If WinExist(ReaHotkey.PluginWinCriteria) And WinActive(ReaHotkey.PluginWinCriteria) And WinGetTitle("A") = "Preferences" {
            If PluginData Is Map And PluginData["Name"] = "Komplete Kontrol Preference Dialog"
            Return True
            Else
            If PluginData Is Plugin And PluginData.Name = "Komplete Kontrol Preference Dialog" {
                If Not PreviousWinID = CurrentWinID And Not PreviousWinID = ""
                PluginData.Overlay.Reset()
                PreviousWinID := CurrentWinID
                Return True
            }
        }
        Return False
    }
    
    Static CheckPluginSaveAsDialog(PluginData) {
        Thread "NoTimers"
        Static PreviousWinID := ""
        CurrentWinID := WinGetID("A")
        If WinExist(ReaHotkey.PluginWinCriteria) And WinActive(ReaHotkey.PluginWinCriteria) And ImageSearch(&FoundX, &FoundY, 130, 14, 230, 31, "Images/KontaktKompleteKontrol/SaveKKPreset.png") {
            If PluginData Is Map And PluginData["Name"] = "Komplete Kontrol Save As Dialog"
            Return True
            Else
            If PluginData Is Plugin And PluginData.Name = "Komplete Kontrol Save As Dialog" {
                If Not PreviousWinID = CurrentWinID And Not PreviousWinID = ""
                PluginData.Overlay.Reset()
                PreviousWinID := CurrentWinID
                Return True
            }
        }
        Return False
    }
    
    Static CheckStandaloneConfig() {
        If ReaHotkey.Config.Get("CloseKKBrowser") = 1
        KompleteKontrol.CloseStandaloneBrowser()
    }
    
    Static CheckStandaloneSaveAsDialog(*) {
        Thread "NoTimers"
        Static PreviousWinID := ""
        CurrentWinID := WinGetID("A")
        StandaloneInstance := Standalone.GetInstance(CurrentWinID)
        If StandaloneInstance Is Standalone And StandaloneInstance.Name = "Komplete Kontrol Save As Dialog" {
            If Not PreviousWinID = CurrentWinID
            Send "{Tab}"
            PreviousWinID := CurrentWinID
            Return True
        }
        If WinExist("ahk_class #32770 ahk_exe Komplete Kontrol.exe") And WinActive("ahk_class #32770 ahk_exe Komplete Kontrol.exe") And ImageSearch(&FoundX, &FoundY, 130, 14, 230, 31, "Images/KontaktKompleteKontrol/SaveKKPreset.png")
        Return True
        Return False
    }
    
    Static ClosePluginBrowser() {
        StartingPath := KompleteKontrol.GetPluginStartingPath()
        UIAElement := GetUIAElement(StartingPath . ",3")
        If Not UIAElement = False And RegExMatch(UIAElement.ClassName, "^LumenButton_QMLTYPE_[0-9]+$") {
            UIAElement.Click()
            AccessibilityOverlay.Speak("Library Browser closed.")
            Sleep 1000
        }
    }
    
    Static ClosePluginPreferenceDialog(*) {
        Thread "NoTimers"
        If ReaHotkey.FoundPlugin Is Plugin And WinExist(ReaHotkey.PluginWinCriteria) And WinActive(ReaHotkey.PluginWinCriteria)
        If ReaHotkey.FoundPlugin.Name = "Komplete Kontrol Preference Dialog" And WinGetTitle("A") = "Preferences" {
            WinClose("A")
            Sleep 500
        }
    }
    
    Static CloseStandaloneBrowser() {
        UIAElement := GetUIAElement("1,3")
        If Not UIAElement = False And RegExMatch(UIAElement.ClassName, "^LumenButton_QMLTYPE_[0-9]+$") {
            UIAElement.Click()
            AccessibilityOverlay.Speak("Library Browser closed.")
            Sleep 1000
        }
    }
    
    Static CloseStandalonePreferenceDialog(*) {
        WinClose("Preferences ahk_class #32770 ahk_exe Komplete Kontrol.exe")
    }
    
    Static FocusStandalonePreferenceTab(KKInstance) {
        Sleep 1000
        If KKInstance.Overlay.CurrentControlID = 0
        KKInstance.Overlay.Focus()
    }
    
    Static GetPluginStartingPath() {
        Try {
            UIAElement := UIA.ElementFromHandle("ahk_id " . WinGetID("A"))
            For Index, ChildElement In UIAElement.Children {
                UIAPaths := [Index, Index . ",1"]
                For UIAPath In UIAPaths {
                    Try
                    TestElement := UIAElement.ElementFromPath(UIAPath)
                    Catch
                    TestElement := False
                    If TestElement And TestElement.Name = "Komplete Kontrol" And TestElement.ClassName = "ni::qt::QuickWindow"
                    Return UIAPath
                }
            }
        }
        Return ""
    }
    
    Static InitConfig() {
        ReaHotkey.Config.Add("ReaHotkey.ini", "Config", "CloseKKBrowser", 1, "Automatically close library browser in Komplete Kontrol", "Kontakt / Komplete Kontrol")
        ReaHotkey.Config.Add("ReaHotkey.ini", "Config", "DetectLibsInKK", 1, "Automatically detect libraries in Komplete Kontrol plug-in")
    }
    
    Static InitPlugin(PluginInstance) {
        If PluginInstance.Overlay.ChildControls.Length = 0
        PluginInstance.Overlay.AddAccessibilityOverlay()
        PluginInstance.Overlay.ChildControls[1] := KompleteKontrol.PluginHeader.Clone()
        If Not HasProp(PluginInstance.Overlay, "Metadata") {
            PluginInstance.Overlay.Metadata := Map("Product", "None")
            PluginInstance.Overlay.OverlayNumber := 1
        }
        Plugin.RegisterOverlayHotkeys("Komplete Kontrol", PluginInstance.Overlay)
    }
    
    Static ManageStandalonePreferenceDialog(*) {
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
    
    #IncludeAgain KontaktKompleteKontrol/NoProduct.ahk
    #IncludeAgain KontaktKompleteKontrol/AudioImperia.ahk
    #IncludeAgain KontaktKompleteKontrol/CinematicStudioSeries.ahk
    #IncludeAgain KontaktKompleteKontrol/Soundiron.ahk
    
}
