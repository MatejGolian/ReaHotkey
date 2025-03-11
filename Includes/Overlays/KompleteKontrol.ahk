#Requires AutoHotkey v2.0

Class KompleteKontrol {
    
    Static PluginHeader := Object()
    Static StandaloneHeader := Object()
    Static PluginOverlays := Array()
    Static StandaloneOverlays := Array()
    
    Static __New() {
        This.InitConfig()
        
        PluginHeader := AccessibilityOverlay("Komplete Kontrol")
        PluginHeader.AddStaticText("Komplete Kontrol")
        PluginHeader.AddHotspotButton("Menu", 297, 17, CompensatePluginCoordinates,, CompensatePluginCoordinates).SetHotkey("!M", "Alt+M")
        PluginHeader.AddCustomButton("Choose library",,, ObjBindMethod(ChoosePluginOverlay,,,, PluginHeader.FocusableControlIDs.Length + 1)).SetHotkey("!C", "Alt+C")
        This.PluginHeader := PluginHeader
        
        StandaloneHeader := AccessibilityOverlay("Komplete Kontrol")
        StandaloneHeader.AddHotspotButton("File menu", 16, -10).SetHotkey("!F", "Alt+F")
        StandaloneHeader.AddHotspotButton("Edit menu", 52, -10).SetHotkey("!E", "Alt+E")
        StandaloneHeader.AddHotspotButton("View menu", 83, -10).SetHotkey("!V", "Alt+V")
        StandaloneHeader.AddHotspotButton("Controller menu", 138, -10).SetHotkey("!C", "Alt+C")
        StandaloneHeader.AddHotspotButton("Help menu", 194, -10).SetHotkey("!H", "Alt+H")
        This.StandaloneHeader := StandaloneHeader
        
        Plugin.Register("Komplete Kontrol", "^Qt6[0-9][0-9]QWindowIcon\{[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\}1$", ObjBindMethod(This, "InitPlugin"), False, False, False, ObjBindMethod(This, "CheckPlugin"))
        
        For PluginOverlay In This.PluginOverlays {
            PluginOverlay.ChildControls[1] := This.PluginHeader.Clone()
            Plugin.RegisterOverlay("Komplete Kontrol", PluginOverlay)
        }
        
        Plugin.SetTimer("Komplete Kontrol", This.CheckPluginConfig, -1)
        Plugin.SetTimer("Komplete Kontrol", This.CheckPluginMenu, 200)
        
        Plugin.Register("Komplete Kontrol Preference Dialog", "^NIChildWindow[0-9A-F]{17}$",, False, False, True, ObjBindMethod(This, "CheckPluginPreferenceDialog"))
        
        PluginPreferenceOverlay := AccessibilityOverlay()
        PluginPreferenceTabControl := PluginPreferenceOverlay.AddTabControl()
        PluginPreferenceMIDITab := HotspotTab("MIDI", 49, 62)
        PluginPreferenceMIDITab.AddCustomButton("Close",,, ObjBindMethod(This, "ClosePluginPreferenceDialog"))
        PluginPreferenceGeneralTab := HotspotTab("General", 49, 107)
        PluginPreferenceGeneralTab.AddCustomButton("Close",,, ObjBindMethod(This, "ClosePluginPreferenceDialog"))
        PluginPreferenceLibraryTab := HotspotTab("Library", 49, 148)
        PluginPreferenceLibraryTabTabControl := PluginPreferenceLibraryTab.AddTabControl()
        PluginPreferenceLibraryFactoryTab := HotspotTab("Factory", 149, 69)
        PluginPreferenceLibraryFactoryTab.AddHotspotButton("Rescan", 539, 410)
        PluginPreferenceLibraryUserTab := HotspotTab("User", 233, 69)
        PluginPreferenceLibraryUserTab.AddHotspotButton("Add Directory", 163, 413)
        PluginPreferenceLibraryUserTab.AddHotspotCheckbox("Scan user content for changes at start-up", 412, 387, ["0xCCCCCC", "0xFFFFFF"], ["0x323232", "0x5F5F5F"])
        PluginPreferenceLibraryUserTab.AddHotspotButton("Rescan", 539, 410)
        PluginPreferenceLibraryTabTabControl.AddTabs(PluginPreferenceLibraryFactoryTab, PluginPreferenceLibraryUserTab)
        PluginPreferenceLibraryTab.AddCustomButton("Close",,, ObjBindMethod(This, "ClosePluginPreferenceDialog"))
        PluginPreferencePluginTab := HotspotTab("Plug-ins", 49, 189)
        PluginPreferencePluginTab.AddHotspotCheckbox("Always Use Latest Version Of NI Plug-ins", 406, 371, ["0xCCCCCC", "0xFFFFFF"], ["0x323232", "0x5F5F5F"])
        PluginPreferencePluginTab.AddHotspotCheckbox("Use VST3 Plug-ins", 406, 398, ["0xCCCCCC", "0xFFFFFF"], ["0x323232", "0x5F5F5F"])
        PluginPreferencePluginTab.AddHotspotCheckbox("Use VST2 Plug-ins", 406, 421, ["0xCCCCCC", "0xFFFFFF"], ["0x323232", "0x5F5F5F"])
        PluginPreferencePluginTab.AddHotspotButton("Rescan", 549, 387)
        PluginPreferencePluginTab.AddCustomButton("Close",,, ObjBindMethod(This, "ClosePluginPreferenceDialog"))
        PluginPreferenceTabControl.AddTabs(PluginPreferenceMIDITab, PluginPreferenceGeneralTab, PluginPreferenceLibraryTab, PluginPreferencePluginTab)
        Plugin.RegisterOverlay("Komplete Kontrol Preference Dialog", PluginPreferenceOverlay)
        
        Plugin.Register("Komplete Kontrol Save As Dialog", "^NIChildWindow[0-9A-F]{17}$",, False, False, True, ObjBindMethod(This, "CheckPluginSaveAsDialog"))
        
        PluginSaveAsOverlay := AccessibilityOverlay()
        PluginSaveAsOverlay.AddOCREdit("Save Preset, Name:", "UWP", 24, 72, 500, 88)
        PluginSaveAsOverlay.AddHotspotButton("Save", 219, 135)
        PluginSaveAsOverlay.AddHotspotButton("Cancel", 301, 135)
        Plugin.RegisterOverlay("Komplete Kontrol Save As Dialog", PluginSaveAsOverlay)
        
        Standalone.Register("Komplete Kontrol", "Komplete Kontrol ahk_class NINormalWindow* ahk_exe Komplete Kontrol.exe",, False, False)
        Standalone.SetTimer("Komplete Kontrol", This.CheckStandaloneConfig, -1)
        Standalone.RegisterOverlay("Komplete Kontrol", StandaloneHeader)
        
        Standalone.Register("Komplete Kontrol Preference Dialog", "Preferences ahk_class #32770 ahk_exe Komplete Kontrol.exe", ObjBindMethod(This, "FocusStandalonePreferenceTab"), False, False)
        Standalone.SetHotkey("Komplete Kontrol Preference Dialog", "^,", ObjBindMethod(This, "ManageStandalonePreferenceDialog"))
        
        StandalonePreferenceOverlay := AccessibilityOverlay()
        StandalonePreferenceTabControl := StandalonePreferenceOverlay.AddTabControl()
        StandalonePreferenceAudioTab := HotspotTab("Audio", 49, 62)
        StandalonePreferenceAudioTab.AddCustomButton("Close",,, ObjBindMethod(This, "CloseStandalonePreferenceDialog"))
        StandalonePreferenceMIDITab := HotspotTab("MIDI", 49, 107)
        StandalonePreferenceMIDITab.AddCustomButton("Close",,, ObjBindMethod(This, "CloseStandalonePreferenceDialog"))
        StandalonePreferenceGeneralTab := HotspotTab("General", 49, 148)
        StandalonePreferenceGeneralTab.AddCustomButton("Close",,, ObjBindMethod(This, "CloseStandalonePreferenceDialog"))
        StandalonePreferenceLibraryTab := HotspotTab("Library", 49, 189)
        StandalonePreferenceLibraryTabTabControl := StandalonePreferenceLibraryTab.AddTabControl()
        StandalonePreferenceLibraryFactoryTab := HotspotTab("Factory", 149, 69)
        StandalonePreferenceLibraryFactoryTab.AddHotspotButton("Rescan", 539, 410)
        StandalonePreferenceLibraryUserTab := HotspotTab("User", 233, 69)
        StandalonePreferenceLibraryUserTab.AddHotspotButton("Add Directory", 163, 413)
        StandalonePreferenceLibraryUserTab.AddHotspotCheckbox("Scan user content for changes at start-up", 412, 387, ["0xCCCCCC", "0xFFFFFF"], ["0x323232", "0x5F5F5F"])
        StandalonePreferenceLibraryUserTab.AddHotspotButton("Rescan", 539, 410)
        StandalonePreferenceLibraryTabTabControl.AddTabs(StandalonePreferenceLibraryFactoryTab, StandalonePreferenceLibraryUserTab)
        StandalonePreferenceLibraryTab.AddCustomButton("Close",,, ObjBindMethod(This, "CloseStandalonePreferenceDialog"))
        StandalonePreferencePluginTab := HotspotTab("Plug-ins", 49, 230)
        StandalonePreferencePluginTab.AddHotspotCheckbox("Always Use Latest Version Of NI Plug-ins", 406, 371, ["0xCCCCCC", "0xFFFFFF"], ["0x323232", "0x5F5F5F"])
        StandalonePreferencePluginTab.AddHotspotCheckbox("Use VST3 Plug-ins", 406, 398, ["0xCCCCCC", "0xFFFFFF"], ["0x323232", "0x5F5F5F"])
        StandalonePreferencePluginTab.AddHotspotCheckbox("Use VST2 Plug-ins", 406, 421, ["0xCCCCCC", "0xFFFFFF"], ["0x323232", "0x5F5F5F"])
        StandalonePreferencePluginTab.AddHotspotButton("Rescan", 549, 387)
        StandalonePreferencePluginTab.AddCustomButton("Close",,, ObjBindMethod(This, "CloseStandalonePreferenceDialog"))
        StandalonePreferenceTabControl.AddTabs(StandalonePreferenceAudioTab, StandalonePreferenceMIDITab, StandalonePreferenceGeneralTab, StandalonePreferenceLibraryTab, StandalonePreferencePluginTab)
        Standalone.RegisterOverlay("Komplete Kontrol Preference Dialog", StandalonePreferenceOverlay)
        
        Standalone.Register("Komplete Kontrol Save As Dialog", "ahk_class #32770 ahk_exe Komplete Kontrol.exe",, False, False, ObjBindMethod(This, "CheckStandaloneSaveAsDialog"))
        
        StandaloneSaveAsOverlay := AccessibilityOverlay()
        StandaloneSaveAsOverlay.AddOCREdit("Save Preset, Name:", "UWP", 24, 72, 500, 88)
        StandaloneSaveAsOverlay.AddHotspotButton("Save", 219, 135)
        StandaloneSaveAsOverlay.AddHotspotButton("Cancel", 301, 135)
        Standalone.RegisterOverlay("Komplete Kontrol Save As Dialog", StandaloneSaveAsOverlay)
    }
    
    Static CheckMenu(Type) {
        Thread "NoTimers"
        If Type = "Plugin"
        UIAElement := This.GetPluginUIAElement()
        Else
        UIAElement := GetUIAWindow()
        Found := False
        Try
        UIAElement := UIAElement.FindElement({Type:"Menu"})
        Catch
        UIAElement := False
        If UIAElement Is UIA.IUIAutomationElement And UIAElement.Type = 50009
        Found := True
        If Not Found
        %Type%.SetNoHotkeys("Komplete Kontrol", False)
        Else
        %Type%.SetNoHotkeys("Komplete Kontrol", True)
    }
    
    Static CheckPlugin(PluginInstance) {
        Thread "NoTimers"
        If PluginInstance Is Plugin And PluginInstance.ControlClass = GetCurrentControlClass()
        If PluginInstance.Name = "Komplete Kontrol"
        Return True
        If ReaHotkey.AbletonPlugin Or ReaHotkey.ReaperPluginNative {
            UIAElement := This.GetPluginUIAElement()
            If UIAElement
            Return True
        }
        Return False
    }
    
    Static CheckPluginPreferenceDialog(PluginInstance) {
        Thread "NoTimers"
        Static PreviousWinID := ""
        CurrentWinID := WinGetID("A")
        If WinExist(ReaHotkey.PluginWinCriteria) And WinActive(ReaHotkey.PluginWinCriteria) And WinGetTitle("A") = "Preferences" {
            If PluginInstance Is Plugin And PluginInstance.Name = "Komplete Kontrol Preference Dialog"
            If Not PreviousWinID = CurrentWinID And Not PreviousWinID = ""
            PluginInstance.Overlay.Reset()
            PreviousWinID := CurrentWinID
            Return True
        }
        Return False
    }
    
    Static CheckPluginSaveAsDialog(PluginInstance) {
        Thread "NoTimers"
        Static PreviousWinID := ""
        CurrentWinID := WinGetID("A")
        If WinExist(ReaHotkey.PluginWinCriteria) And WinActive(ReaHotkey.PluginWinCriteria) And ImageSearch(&FoundX, &FoundY, 130, 14, 230, 31, "Images/KontaktKompleteKontrol/SaveKKPreset.png") {
            If PluginInstance Is Plugin And PluginInstance.Name = "Komplete Kontrol Save As Dialog"
            If Not PreviousWinID = CurrentWinID And Not PreviousWinID = ""
            PluginInstance.Overlay.Reset()
            PreviousWinID := CurrentWinID
            Return True
        }
        Return False
    }
    
    Static CheckStandaloneSaveAsDialog(StandaloneInstance) {
        Thread "NoTimers"
        Static PreviousWinID := ""
        CurrentWinID := WinGetID("A")
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
    
    Static closeBrowser(Type) {
        Thread "NoTimers"
        If Type = "Plugin"
        UIAElement := This.GetPluginUIAElement()
        Else
        UIAElement := GetUIAWindow()
        Try
        UIAElement := UIAElement.FindElement({ClassName:"FileTypeSelector", matchmode:"Substring"})
        Catch
        UIAElement := False
        If UIAElement Is UIA.IUIAutomationElement And UIAElement.Type = 50018 {
            Try
            UIAElement.WalkTree(-1).Click("Left")
            AccessibilityOverlay.Speak("Library Browser closed.")
            Sleep 1000
        }
    }
    
    Static ClosePluginBrowser() {
        This.closeBrowser("Plugin")
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
        This.closeBrowser("Standalone")
    }
    
    Static CloseStandalonePreferenceDialog(*) {
        WinClose("Preferences ahk_class #32770 ahk_exe Komplete Kontrol.exe")
    }
    
    Static FocusStandalonePreferenceTab(KKInstance) {
        Sleep 1000
        If KKInstance.Overlay.CurrentControlID = 0
        KKInstance.Overlay.Focus()
    }
    
    Static GetPluginUIAElement() {
        Critical
        If Not ReaHotkey.PluginWinCriteria Or Not WinActive(ReaHotkey.PluginWinCriteria)
        Return False
        Try
        UIAElement := GetUIAWindow()
        Catch
        Return False
        If Not UIAElement Is UIA.IUIAutomationElement
        Return False
        If CheckElement(UIAElement)
        Return UIAElement
        Try
        UIAElement := UIAElement.FindElement({ClassName:"ni::qt::QuickWindow"})
        Catch
        Return False
        If CheckElement(UIAElement)
        Return UIAElement
        Return False
        CheckElement(UIAElement) {
            If UIAElement Is UIA.IUIAutomationElement And UIAElement.Name = "Komplete Kontrol" And UIAElement.Type = 50032
            Return True
            Return False
        }
    }
    
    Static InitConfig() {
        ReaHotkey.Config.Add("ReaHotkey.ini", "Config", "CloseKKBrowser", 1, "Automatically close library browser in Komplete Kontrol", "Kontakt / Komplete Kontrol")
        ReaHotkey.Config.Add("ReaHotkey.ini", "Config", "DetectLibsInKK", 1, "Automatically detect libraries in Komplete Kontrol plug-in")
    }
    
    Static InitPlugin(PluginInstance) {
        If PluginInstance.Overlay.ChildControls.Length = 0
        PluginInstance.Overlay.AddAccessibilityOverlay()
        PluginInstance.Overlay.ChildControls[1] := This.PluginHeader.Clone()
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
    
    Class CheckPluginConfig {
        Static Call() {
            Static PluginAutoChangeFunction := ObjBindMethod(AutoChangePluginOverlay,, "Komplete Kontrol", True, True, KompleteKontrol.PluginHeader.FocusableControlIDs.Length + 1)
            If ReaHotkey.Config.Get("CloseKKBrowser") = 1
            KompleteKontrol.ClosePluginBrowser()
            If ReaHotkey.Config.Get("DetectLibsInKK") = 1
            Plugin.SetTimer("Komplete Kontrol", PluginAutoChangeFunction, 500)
            Else
            Plugin.SetTimer("Komplete Kontrol", PluginAutoChangeFunction, 0)
        }
    }
    
    Class CheckPluginMenu {
        Static Call() {
            KompleteKontrol.CheckMenu("Plugin")
        }
    }
    
    Class CheckStandaloneConfig {
        Static Call() {
            If ReaHotkey.Config.Get("CloseKKBrowser") = 1
            KompleteKontrol.CloseStandaloneBrowser()
        }
    }
    
    #IncludeAgain KontaktKompleteKontrol/NoProduct.ahk
    #IncludeAgain KontaktKompleteKontrol/AudioImperia.ahk
    #IncludeAgain KontaktKompleteKontrol/CinematicStudioSeries.ahk
    #IncludeAgain KontaktKompleteKontrol/ImpactSoundworks.ahk
    #IncludeAgain KontaktKompleteKontrol/Soundiron.ahk
    
}
