#Requires AutoHotkey v2.0

Class KompleteKontrol {
    
    Static PluginHeader := Object()
    Static StandaloneHeader := Object()
    Static PluginOverlays := Array()
    Static StandaloneOverlays := Array()
    Static PluginSearchOverlay := Object()
    Static PluginNoSearchOverlay := Object()
    
    Static __New() {
        This.InitConfig()
        
        PluginSearchOverlay := PluginOverlay("Search")
        PluginSearchOverlay.AddCustomButton("Close library browser",,,, ObjBindMethod(This, "ActivatePluginLibBrowserCloser")).SetHotkey("!L", "Alt+L")
        PluginSearchOverlay.AddCustomEdit("Search", ObjBindMethod(This, "FocusPluginSearchField")).SetHotkey("!S", "Alt+S")
        PluginSearchOverlay.AddCustomButton("Clear search",,,, ObjBindMethod(This, "ActivatePluginClearSearch")).SetHotkey("!X", "Alt+X")
        This.PluginSearchOverlay := PluginSearchOverlay
        
        PluginNoSearchOverlay := PluginOverlay("No Search")
        This.PluginNoSearchOverlay := PluginNoSearchOverlay
        
        PluginHeader := PluginOverlay("Komplete Kontrol")
        PluginHeader.AddStaticText("Komplete Kontrol")
        PluginHeader.AddHotspotButton("Menu", 297, 17).SetHotkey("!M", "Alt+M")
        PluginHeader.AddControl(This.PluginSearchOverlay)
        PluginHeader.AddCustomButton("Choose library",,, ObjBindMethod(ChoosePluginOverlay,,,, "L", "Choose library")).SetHotkey("!C", "Alt+C")
        This.PluginHeader := PluginHeader
        
        StandaloneHeader := StandaloneOverlay("Komplete Kontrol")
        StandaloneHeader.AddHotspotButton("File menu", 16, -10).SetHotkey("!F", "Alt+F")
        StandaloneHeader.AddHotspotButton("Edit menu", 52, -10).SetHotkey("!E", "Alt+E")
        StandaloneHeader.AddHotspotButton("View menu", 83, -10).SetHotkey("!V", "Alt+V")
        StandaloneHeader.AddHotspotButton("Controller menu", 138, -10).SetHotkey("!C", "Alt+C")
        StandaloneHeader.AddHotspotButton("Help menu", 194, -10).SetHotkey("!H", "Alt+H")
        This.StandaloneHeader := StandaloneHeader
        
        Plugin.Register("Komplete Kontrol", ["^Qt6[0-9][0-9]QWindowIcon\{[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\}1$", "^Qt6[0-9][0-9]NI_6_[0-9]_[0-9]_R[0-9]QWindowIcon\{[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\}1$"], ObjBindMethod(This, "InitPlugin"), False, 1, False, ObjBindMethod(This, "CheckPlugin"))
        
        For KKPluginOverlay In This.PluginOverlays {
            KKPluginOverlay.AddControlAt(1, This.PluginHeader)
            Plugin.RegisterOverlay("Komplete Kontrol", KKPluginOverlay)
        }
        
        Plugin.SetTimer("Komplete Kontrol", This.CheckPluginConfig, -1)
        Plugin.SetTimer("Komplete Kontrol", This.CheckPluginMenu, 250)
        Plugin.SetTimer("Komplete Kontrol", This.TogglePluginSearchVisible, 500)
        Plugin.SetTimer("Komplete Kontrol", This.ManageLoadedPlugin, 250)
        
        Plugin.Register("Komplete Kontrol Preference Dialog", "^NIChildWindow[0-9A-F]{17}$",, False, 1, True, ObjBindMethod(This, "CheckPluginPreferenceDialog"))
        
        PluginPreferenceOverlay := PluginOverlay()
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
        
        Plugin.Register("Komplete Kontrol Save As Dialog", "^NIChildWindow[0-9A-F]{17}$",, False, 1, True, ObjBindMethod(This, "CheckPluginSaveAsDialog"))
        
        PluginSaveAsOverlay := PluginOverlay()
        PluginSaveAsOverlay.AddOCREdit("Save Preset, Name:", "UWP", 24, 72, 500, 88)
        PluginSaveAsOverlay.AddHotspotButton("Save", 219, 135)
        PluginSaveAsOverlay.AddHotspotButton("Cancel", 301, 135)
        Plugin.RegisterOverlay("Komplete Kontrol Save As Dialog", PluginSaveAsOverlay)
        
        Standalone.Register("Komplete Kontrol", "Komplete Kontrol ahk_class NINormalWindow* ahk_exe Komplete Kontrol.exe", False, False, 1)
        Standalone.SetTimer("Komplete Kontrol", This.CheckStandaloneConfig, -1)
        Standalone.RegisterOverlay("Komplete Kontrol", StandaloneHeader)
        
        Standalone.Register("Komplete Kontrol Preference Dialog", "Preferences ahk_class #32770 ahk_exe Komplete Kontrol.exe", ObjBindMethod(This, "FocusStandalonePreferenceTab"), False, False, 1)
        Standalone.SetHotkey("Komplete Kontrol Preference Dialog", "^,", ObjBindMethod(This, "ManageStandalonePreferenceDialog"))
        
        StandalonePreferenceOverlay := StandaloneOverlay()
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
        
        Standalone.Register("Komplete Kontrol Save As Dialog", "ahk_class #32770 ahk_exe Komplete Kontrol.exe", False, False, 1, ObjBindMethod(This, "CheckStandaloneSaveAsDialog"))
        
        StandaloneSaveAsOverlay := StandaloneOverlay()
        StandaloneSaveAsOverlay.AddOCREdit("Save Preset, Name:", "UWP", 24, 72, 500, 88)
        StandaloneSaveAsOverlay.AddHotspotButton("Save", 219, 135)
        StandaloneSaveAsOverlay.AddHotspotButton("Cancel", 301, 135)
        Standalone.RegisterOverlay("Komplete Kontrol Save As Dialog", StandaloneSaveAsOverlay)
    }
    
    Static __Get(Name, Params) {
        Try
        Return This.Get%Name%(Params*)
        Catch As ErrorMessage
        Throw ErrorMessage
    }
    
    Static ActivatePluginClearSearch(ClearSearchButton) {
        SearchEditValue := ""
        UIAElement := This.GetPluginUIAElement()
        If UIAElement Is UIA.IUIAutomationElement {
            Try
            UIAElement := UIAElement.FindElement({Type: "Edit"})
            Catch
            Return
            If UIAElement Is UIA.IUIAutomationElement And UIAElement.Type = 50004
            SearchEditValue := UIAElement.Value
        }
        If SearchEditValue
        UIAElement.WalkTree(+1).Click("Left")
        ReaHotkey.FoundPlugin.Overlay.FocusPreviousControl()
    }
    
    Static ActivatePluginLibBrowserCloser(LibBrowserCloserButton) {
        This.ClosePluginBrowser()
        This.TogglePluginSearchVisible()
    }
    
    Static CheckMenu(Type) {
        Thread "NoTimers"
        If Type = "Plugin"
        UIAElement := This.GetPluginUIAElement()
        Else
        UIAElement := AccessibilityOverlay.Helpers.GetUIAWindow()
        Found := False
        Try
        UIAElement := UIAElement.FindElement({Type: "Menu"})
        Catch
        UIAElement := False
        If UIAElement Is UIA.IUIAutomationElement And UIAElement.Type = 50009
        Found := True
        If Not Found
        %Type%.SetHotkeyMode("Komplete Kontrol", 1)
        Else
        %Type%.SetHotkeyMode("Komplete Kontrol", 0)
    }
    
    Static CheckPlugin(PluginInstance) {
        Thread "NoTimers"
        If PluginInstance Is Plugin And PluginInstance.ControlClass = ReaHotkey.GetPluginControl()
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
        Try
        CurrentWinID := WinGetID("A")
        Catch
        Return False
        Try
        CurrentWinTitle := WinGetTitle("A")
        Catch
        Return False
        If WinExist(ReaHotkey.PluginWinCriteria) And WinActive(ReaHotkey.PluginWinCriteria) And CurrentWinTitle = "Preferences" {
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
        Try
        CurrentWinID := WinGetID("A")
        Catch
        Return False
        If WinExist(ReaHotkey.PluginWinCriteria) And WinActive(ReaHotkey.PluginWinCriteria) And ImageSearch(&FoundX, &FoundY, 130, 14, 230, 31, "Images/KompleteKontrol/SavePreset.png") {
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
        Try
        CurrentWinID := WinGetID("A")
        Catch
        Return False
        If StandaloneInstance Is Standalone And StandaloneInstance.Name = "Komplete Kontrol Save As Dialog" {
            If Not PreviousWinID = CurrentWinID
            Send "{Tab}"
            PreviousWinID := CurrentWinID
            Return True
        }
        If WinExist("ahk_class #32770 ahk_exe Komplete Kontrol.exe") And WinActive("ahk_class #32770 ahk_exe Komplete Kontrol.exe") And ImageSearch(&FoundX, &FoundY, 130, 14, 230, 31, "Images/KompleteKontrol/SavePreset.png")
        Return True
        Return False
    }
    
    Static CloseBrowser(Type) {
        Thread "NoTimers"
        UIAElement := This.GetBrowser(Type)
        If UIAElement Is UIA.IUIAutomationElement {
            Try
            UIAElement.WalkTree(-1).Click("Left")
            LastMessage := AccessibilityOverlay.LastMessage
            AccessibilityOverlay.AddToSpeechQueue("Library Browser closed.")
            AccessibilityOverlay.AddToSpeechQueue(LastMessage)
            AccessibilityOverlay.ClearLastMessage()
            AccessibilityOverlay.Speak()
        }
    }
    
    Static ClosePluginBrowser() {
        This.CloseBrowser("Plugin")
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
        This.CloseBrowser("Standalone")
    }
    
    Static CloseStandalonePreferenceDialog(*) {
        WinClose("Preferences ahk_class #32770 ahk_exe Komplete Kontrol.exe")
    }
    
    Static FocusPluginSearchField(SearchEdit) {
        Critical
        SearchEdit.Value := ""
        UIAElement := This.GetPluginUIAElement()
        If UIAElement Is UIA.IUIAutomationElement {
            Try
            UIAElement := UIAElement.FindElement({Type: "Edit"})
            Catch
            Return
            If UIAElement Is UIA.IUIAutomationElement And UIAElement.Type = 50004 {
                UIAElement.SetFocus()
                SearchEdit.Value := UIAElement.Value
            }
        }
    }
    
    Static FocusStandalonePreferenceTab(KKInstance) {
        AccessibilityOverlay.AddToSpeechQueue(GetCurrentWindowTitle() . ",")
        KKInstance.Overlay.Focus()
    }
    
    Static GetBrowser(Type) {
        Thread "NoTimers"
        Static Criteria := [{ClassName: "FileTypeSelector", MatchMode: "Substring"}, {ClassName: "TagCloudAccordionWithBrands", MatchMode: "Substring"}]
        If Type = "Plugin"
        UIAElement := This.GetPluginUIAElement()
        Else
        UIAElement := AccessibilityOverlay.Helpers.GetUIAWindow()
        If UIAElement Is UIA.IUIAutomationElement
        Loop Criteria.Length {
            Try
            UIAElement := UIAElement.FindElement(Criteria[A_Index])
            Catch
            UIAElement := False
            If UIAElement Is UIA.IUIAutomationElement And UIAElement.Type = (A_Index = 1 ? 50018 : 50033)
            Return UIAElement
        }
        Return False
    }
    
    Static GetPluginControl() {
        Static CachedControl := False
        Static TestPluginInstance := Plugin("", "", "")
        PluginWinCriteria := ReaHotkey.PluginWinCriteria
        If Not PluginWinCriteria Or Not WinActive(PluginWinCriteria)
        Return False
        MainPluginControl := False
        If Not ReaHotkey.FoundPlugin Is Plugin Or Not ReaHotkey.FoundPlugin.Name = "Komplete Kontrol"
        Return False
        Else
        MainPluginControl := ReaHotkey.FoundPlugin.ControlClass
        If Not MainPluginControl
        Return False
        Controls := WinGetControls(PluginWinCriteria)
        If Controls.Length = 0 Or Controls[Controls.Length] = MainPluginControl
        Return False
        WinTitle := WinGetTitle("A")
        MainPluginControlPos := InArray(MainPluginControl, Controls)
        LoopCount := Controls.Length - MainPluginControlPos
        Index := Controls.Length
        Loop LoopCount {
            For PluginEntry In Plugin.List
            If Not PluginEntry["Name"] = "Komplete Kontrol"
            If PluginEntry["ControlClasses"] Is Array And PluginEntry["ControlClasses"].Length > 0
            For ControlClass In PluginEntry["ControlClasses"]
            If RegExMatch(Controls[Index], ControlClass) {
                If Controls[Index] = CachedControl
                Return Controls[Index]
                CheckResult := PluginEntry["CheckerFunction"].Call(TestPluginInstance)
                If CheckResult = True {
                    PluginInstance := Plugin(PluginEntry["Name"], Controls[Index], WinTitle)
                    CachedControl := Controls[Index]
                    Return Controls[Index]
                }
            }
            Index--
        }
        Return False
    }
    
    Static GetPluginBrowser() {
        Return This.GetBrowser("Plugin")
    }
    
    Static GetPluginUIAElement() {
        Critical
        Static Criteria := [{ClassName: "ni::qt::QuickWindow"}, {ClassName: "QWindowIcon", MatchMode: "Substring"}]
        If Not ReaHotkey.PluginWinCriteria Or Not WinActive(ReaHotkey.PluginWinCriteria)
        Return False
        Try
        UIAElement := AccessibilityOverlay.Helpers.GetUIAWindow()
        Catch
        Return False
        If Not UIAElement Is UIA.IUIAutomationElement
        Return False
        Try
        If CheckElement(UIAElement)
        Return UIAElement
        Loop Criteria.Length {
            Try
            UIAElements := UIAElement.FindElements(Criteria[A_Index])
            Catch
            UIAElements := Array()
            Try
            For UIAElement In UIAElements
            If CheckElement(UIAElement)
            Return UIAElement
        }
        Return False
        CheckElement(UIAElement) {
            If UIAElement Is UIA.IUIAutomationElement And UIAElement.Name = "Komplete Kontrol"
            If UIAElement.Type = 50032 Or UIAElement.Type = 50033
            Return True
            Return False
        }
    }
    
    Static GetStandaloneBrowser() {
        Return This.GetBrowser("Standalone")
    }
    
    Static InitConfig() {
        ReaHotkey.Config.Add("ReaHotkey.ini", "Config", "CloseKKBrowser", 0, "Automatically close the library browser in Komplete Kontrol", "Kontakt / Komplete Kontrol")
        ReaHotkey.Config.Add("ReaHotkey.ini", "Config", "DetectLibsInKK", 1, "Automatically detect libraries in the Komplete Kontrol plug-in")
    }
    
    Static InitPlugin(PluginInstance) {
        If Not HasProp(PluginInstance.Overlay, "Metadata") {
            PluginInstance.Overlay.Metadata := Map("Product", "None")
            PluginInstance.Overlay.OverlayNumber := 1
        }
    }
    
    Static IsK7OrK8PluginBrowser(Browser) {
        If Not Browser Is UIA.IUIAutomationElement
        Return False
        PluginControl := This.GetPluginControl()
        If Not PluginControl
        Return False
        LoadedPlugin := Plugin.GetByClass(PluginControl)
        If LoadedPlugin Is Plugin
        If LoadedPlugin.Name = "Kontakt 7" Or LoadedPlugin.Name = "Kontakt 8" {
            Window := AccessibilityOverlay.Helpers.GetUIAWindow()
            If Not Window
            Return False
            KClassName := "Kontakt7"
            If LoadedPlugin.Name = "Kontakt 8"
            KClassName := "Kontakt8"
            BrowserPath := Window.GetNumericPath(Browser)
            KPath := Window.GetNumericPath(%KClassName%.GetPluginUIAElement())
            If Not BrowserPath Or Not KPath
            Return False
            If KPath.Length < BrowserPath.Length
            Return True
        }
        Return False
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
            ParentClass := SubStr(This.Prototype.__Class, 1, InStr(This.Prototype.__Class, ".") - 1)
            Static PluginAutoChangeFunction := ObjBindMethod(AutoChangePluginOverlay,, "Komplete Kontrol", True, True, "C", 2)
            If ReaHotkey.Config.Get("CloseKKBrowser") = 1
            %ParentClass%.ClosePluginBrowser()
            If ReaHotkey.Config.Get("DetectLibsInKK") = 1
            Plugin.SetTimer("Komplete Kontrol", PluginAutoChangeFunction, 500)
            Else
            Plugin.SetTimer("Komplete Kontrol", PluginAutoChangeFunction, 0)
        }
    }
    
    Class CheckPluginMenu {
        Static Call() {
            ParentClass := SubStr(This.Prototype.__Class, 1, InStr(This.Prototype.__Class, ".") - 1)
            If ReaHotkey.PluginWinCriteria And WinActive(ReaHotkey.PluginWinCriteria)
            %ParentClass%.CheckMenu("Plugin")
        }
    }
    
    Class CheckStandaloneConfig {
        Static Call() {
            ParentClass := SubStr(This.Prototype.__Class, 1, InStr(This.Prototype.__Class, ".") - 1)
            If ReaHotkey.Config.Get("CloseKKBrowser") = 1
            %ParentClass%.CloseStandaloneBrowser()
        }
    }
    
    Class ClickPluginCoordinates {
        Static Call(XCoordinate, YCoordinate) {
            ParentClass := SubStr(This.Prototype.__Class, 1, InStr(This.Prototype.__Class, ".") - 1)
            Click %ParentClass%.CompensatePluginXCoordinate(XCoordinate), %ParentClass%.CompensatePluginYCoordinate(YCoordinate)
        }
    }
    
    Class CompensatePluginCoordinates {
        Static Call(PluginControl) {
            ParentClass := SubStr(This.Prototype.__Class, 1, InStr(This.Prototype.__Class, ".") - 1)
            PluginControl := CompensatePluginCoordinates(PluginControl)
            If Not ReaHotkey.FoundPlugin Is Plugin Or Not ReaHotkey.FoundPlugin.Name = "Komplete Kontrol"
            Return PluginControl
            PluginControlPos := %ParentClass%.GetPluginControlPos()
            If PluginControlPos.X = 0 And PluginControlPos.Y = 0
            Return PluginControl
            If PluginControl Is GraphicalHorizontalSlider {
                If PluginControl.HasProp("OriginalStart")
                PluginControl.Start := PluginControlPos.X + PluginControl.OriginalStart
                If PluginControl.HasProp("OriginalEnd")
                PluginControl.End := PluginControlPos.X + PluginControl.OriginalEnd
            }
            If PluginControl Is GraphicalVerticalSlider {
                If PluginControl.HasProp("OriginalStart")
                PluginControl.Start := PluginControlPos.Y + PluginControl.OriginalStart
                If PluginControl.HasProp("OriginalEnd")
                PluginControl.End := PluginControlPos.Y + PluginControl.OriginalEnd
            }
            If PluginControl.HasProp("OriginalXCoordinate")
            PluginControl.XCoordinate := PluginControlPos.X + PluginControl.OriginalXCoordinate
            If PluginControl.HasProp("OriginalYCoordinate")
            PluginControl.YCoordinate := PluginControlPos.Y + PluginControl.OriginalYCoordinate
            If PluginControl.HasProp("OriginalX1Coordinate")
            PluginControl.X1Coordinate := PluginControlPos.X + PluginControl.OriginalX1Coordinate
            If PluginControl.HasProp("OriginalY1Coordinate")
            PluginControl.Y1Coordinate := PluginControlPos.Y + PluginControl.OriginalY1Coordinate
            If PluginControl.HasProp("OriginalX2Coordinate")
            PluginControl.X2Coordinate := PluginControlPos.X + PluginControl.OriginalX2Coordinate
            If PluginControl.HasProp("OriginalY2Coordinate")
            PluginControl.Y2Coordinate := PluginControlPos.Y + PluginControl.OriginalY2Coordinate
            Return PluginControl
        }
    }
    
    Class CompensatePluginXCoordinate {
        Static Call(PluginXCoordinate) {
            ParentClass := SubStr(This.Prototype.__Class, 1, InStr(This.Prototype.__Class, ".") - 1)
            PluginXCoordinate := CompensatePluginXCoordinate(PluginXCoordinate)
            If Not ReaHotkey.FoundPlugin Is Plugin Or Not ReaHotkey.FoundPlugin.Name = "Komplete Kontrol"
            Return PluginXCoordinate
            PluginControlPos := %ParentClass%.GetPluginControlPos()
            If PluginControlPos.X = 0 And PluginControlPos.Y = 0
            Return PluginXCoordinate
            PluginXCoordinate := PluginControlPos.X + PluginXCoordinate
            Return PluginXCoordinate
        }
    }
    
    Class CompensatePluginYCoordinate {
        Static Call(PluginYCoordinate) {
            ParentClass := SubStr(This.Prototype.__Class, 1, InStr(This.Prototype.__Class, ".") - 1)
            PluginYCoordinate := CompensatePluginYCoordinate(PluginYCoordinate)
            If Not ReaHotkey.FoundPlugin Is Plugin Or Not ReaHotkey.FoundPlugin.Name = "Komplete Kontrol"
            Return PluginYCoordinate
            PluginControlPos := %ParentClass%.GetPluginControlPos()
            If PluginControlPos.X = 0 And PluginControlPos.Y = 0
            Return PluginYCoordinate
            PluginYCoordinate := PluginControlPos.Y + PluginYCoordinate
            Return PluginYCoordinate
        }
    }
    
    Class GetFoundPlugin {
        Static Call() {
            ParentClass := SubStr(This.Prototype.__Class, 1, InStr(This.Prototype.__Class, ".") - 1)
            If Not ReaHotkey.FoundPlugin Is Plugin Or Not ReaHotkey.FoundPlugin.Name = "Komplete Kontrol"
            Return False
            PluginBrowser := %ParentClass%.GetPluginBrowser()
            IsK7OrK8PluginBrowser := %ParentClass%.IsK7OrK8PluginBrowser(PluginBrowser)
            If PluginBrowser And Not IsK7OrK8PluginBrowser
            Return False
            PluginControl := %ParentClass%.GetPluginControl()
            If Not PluginControl
            Return False
            FoundPlugin := Plugin.GetByClass(PluginControl)
            If FoundPlugin Is Plugin
            Return FoundPlugin
            Return False
        }
    }
    
    Class GetPluginControlPos {
        Static Call() {
            ParentClass := SubStr(This.Prototype.__Class, 1, InStr(This.Prototype.__Class, ".") - 1)
            PluginControlX := 0
            PluginControlY := 0
            PluginControlW := 0
            PluginControlH := 0
            Try
            ControlGetPos &PluginControlX, &PluginControlY, &PluginControlW, &PluginControlH, %ParentClass%.GetPluginControl(), ReaHotkey.PluginWinCriteria
            Catch
            Return GetPluginControlPos()
            Return {X: PluginControlX, Y: PluginControlY, W: PluginControlW, H: PluginControlH}
        }
    }
    
    Class GetPluginHeight {
        Static Call() {
            ParentClass := SubStr(This.Prototype.__Class, 1, InStr(This.Prototype.__Class, ".") - 1)
            %ParentClass%.Return GetPluginControlPos().H
        }
    }
    
    Class GetPluginWidth {
        Static Call() {
            ParentClass := SubStr(This.Prototype.__Class, 1, InStr(This.Prototype.__Class, ".") - 1)
            Return %ParentClass%.GetPluginControlPos().W
        }
    }
    
    Class GetPluginXCoordinate {
        Static Call() {
            ParentClass := SubStr(This.Prototype.__Class, 1, InStr(This.Prototype.__Class, ".") - 1)
            Return %ParentClass%.GetPluginControlPos().X
        }
    }
    
    Class GetPluginYCoordinate {
        Static Call() {
            ParentClass := SubStr(This.Prototype.__Class, 1, InStr(This.Prototype.__Class, ".") - 1)
            Return %ParentClass%.GetPluginControlPos().Y
        }
    }
    
    Class ManageLoadedPlugin {
        Static Call() {
            ParentClass := SubStr(This.Prototype.__Class, 1, InStr(This.Prototype.__Class, ".") - 1)
            Critical
            Static ExemptPlugins := Array("Dubler 2 MIDI Capture", "Komplete Kontrol", "Kontakt 7", "Kontakt 8", "Raum"), FirstRun := True, KKHotkeys := Array(), KKPluginNumber := 0, KKTimers := Array(), LastFoundPlugin := False
            If FirstRun {
                KKPluginNumber := Plugin.FindName("Komplete Kontrol")
                KKHotkeys := Plugin.List[KKPluginNumber]["Hotkeys"]
                KKTimers := Plugin.List[KKPluginNumber]["Timers"]
                FirstRun := False
            }
            PluginBrowser := %ParentClass%.GetPluginBrowser()
            IsK7OrK8PluginBrowser := %ParentClass%.IsK7OrK8PluginBrowser(PluginBrowser)
            If Not PluginBrowser Or Not IsK7OrK8PluginBrowser {
                PluginControl := %ParentClass%.GetPluginControl()
                If PluginControl {
                    PluginToLoad := Plugin.GetByClass(PluginControl)
                    If PluginToLoad Is Plugin And Not InArray(PluginToLoad.Name, ExemptPlugins)
                    If Not LastFoundPlugin = PluginToLoad {
                        If LastFoundPlugin Is Plugin
                        UnloadPlugin(LastFoundPlugin, KKPluginNumber, KKHotkeys, KKTimers)
                        LastFoundPlugin := LoadPlugin(PluginToLoad, KKPluginNumber, KKHotkeys, KKTimers)
                    }
                    Else {
                        If LastFoundPlugin Is Plugin
                        If Not ReaHotkey.FoundPlugin.Overlay.OverlayNumber = 1
                        LastFoundPlugin := LoadPlugin(PluginToLoad, KKPluginNumber, KKHotkeys, KKTimers)
                    }
                }
                Else {
                    If LastFoundPlugin Is Plugin And Not InArray(LastFoundPlugin.Name, ExemptPlugins)
                    LastFoundPlugin := UnloadPlugin(LastFoundPlugin, KKPluginNumber, KKHotkeys, KKTimers)
                }
            }
            Else {
                If LastFoundPlugin Is Plugin And Not InArray(LastFoundPlugin.Name, ExemptPlugins)
                LastFoundPlugin := UnloadPlugin(LastFoundPlugin, KKPluginNumber, KKHotkeys, KKTimers)
            }
            LoadPlugin(PluginToLoad, KKPluginNumber, KKHotkeys, KKTimers) {
                If Not ReaHotkey.FoundPlugin Is Plugin Or Not ReaHotkey.FoundPlugin.Name = "Komplete Kontrol"
                Return PluginToLoad
                ReaHotkey.FoundPlugin.Overlay := %ParentClass%.PluginOverlays[1]
                ReaHotkey.FoundPlugin.Overlay.ReplaceControlAt(2, PluginToLoad.Overlay)
                %ParentClass%.TogglePluginSearchVisible()
                ReaHotkey.TurnPluginTimersOff("Komplete Kontrol")
                ReaHotkey.TurnPluginHotkeysOff("Komplete Kontrol")
                HotkeysToLoad := Plugin.List[PluginToLoad.PluginNumber]["Hotkeys"]
                TimersToLoad := Plugin.List[PluginToLoad.PluginNumber]["Timers"]
                Plugin.List[KKPluginNumber]["Hotkeys"] := MergeArrays(KKHotkeys, HotkeysToLoad)
                Plugin.List[KKPluginNumber]["Timers"] := MergeArrays(KKTimers, TimersToLoad)
                ReaHotkey.TurnPluginTimersOn("Komplete Kontrol")
                ReaHotkey.TurnPluginHotkeysOn("Komplete Kontrol")
                Return PluginToLoad
            }
            UnloadPlugin(PluginToUnload, KKPluginNumber, KKHotkeys, KKTimers) {
                Static NoLibraryProductOverlay := %ParentClass%.PluginOverlays[1].Clone()
                If Not ReaHotkey.FoundPlugin Is Plugin Or Not ReaHotkey.FoundPlugin.Name = "Komplete Kontrol"
                Return PluginToUnload
                If NoLibraryProductOverlay.ChildControls[2].ChildControls.Length > 0
                NoLibraryProductOverlay.ReplaceControlAt(2,  PluginOverlay())
                ReaHotkey.FoundPlugin.Overlay := NoLibraryProductOverlay
                %ParentClass%.TogglePluginSearchVisible()
                ReaHotkey.TurnPluginTimersOff("Komplete Kontrol")
                ReaHotkey.TurnPluginHotkeysOff("Komplete Kontrol")
                Plugin.List[KKPluginNumber]["Hotkeys"] := KKHotkeys
                Plugin.List[KKPluginNumber]["Timers"] := KKTimers
                ReaHotkey.TurnPluginTimersOn("Komplete Kontrol")
                ReaHotkey.TurnPluginHotkeysOn("Komplete Kontrol")
                Return False
            }
        }
    }
    
    Class MoveToPluginCoordinates {
        Static Call(XCoordinate, YCoordinate) {
            ParentClass := SubStr(This.Prototype.__Class, 1, InStr(This.Prototype.__Class, ".") - 1)
            MouseMove %ParentClass%.CompensatePluginXCoordinate(XCoordinate), %ParentClass%.CompensatePluginYCoordinate(YCoordinate)
        }
    }
    
    Class PluginSerialClick {
        Static Call(Coordinates*) {
            ParentClass := SubStr(This.Prototype.__Class, 1, InStr(This.Prototype.__Class, ".") - 1)
            ClickFunc := Object()
            ClickFunc.DefineProp("Coordinates", {Value: Coordinates})
            ClickFunc.DefineProp("ParentClass", {Value: ParentClass})
            ClickFunc.DefineProp("Call", {call: CallClickFunc})
            Return ClickFunc
            CallClickFunc(This, OverlayObj) {
                Coordinates := This.Coordinates.Clone()
                If Coordinates.Length < 2
                Return
                If Mod(Coordinates.Length, 2) > 0
                Coordinates.Pop()
                XIndex := 1
                YIndex := 2
                Loop Coordinates.Length / 2 {
                    %This.ParentClass%.ClickPluginCoordinates(Coordinates[XIndex], Coordinates[YIndex])
                    XIndex += 2
                    YIndex += 2
                }
            }
        }
    }
    
    Class TogglePluginSearchVisible {
        Static Call() {
            ParentClass := SubStr(This.Prototype.__Class, 1, InStr(This.Prototype.__Class, ".") - 1)
            If Not ReaHotkey.FoundPlugin Is Plugin Or Not ReaHotkey.FoundPlugin.Name = "Komplete Kontrol"
            Return
            If %ParentClass%.GetPluginBrowser() {
                If Not ReaHotkey.FoundPlugin.Overlay.ChildControls[1].ChildControls[3].Label = "Search"
                ReaHotkey.FoundPlugin.Overlay.ChildControls[1].ReplaceControlAt(3, %ParentClass%.PluginSearchOverlay)
            }
            Else {
                If Not ReaHotkey.FoundPlugin.Overlay.ChildControls[1].ChildControls[3].Label = "No Search"
                ReaHotkey.FoundPlugin.Overlay.ChildControls[1].ReplaceControlAt(3, %ParentClass%.PluginNoSearchOverlay)
            }
        }
    }
    
    #IncludeAgain KontaktKompleteKontrol/NoLibraryProduct.ahk
    #IncludeAgain KontaktKompleteKontrol/Audiobro.ahk
    #IncludeAgain KontaktKompleteKontrol/AudioImperia.ahk
    #IncludeAgain KontaktKompleteKontrol/CinematicStudioSeries.ahk
    #IncludeAgain KontaktKompleteKontrol/ImpactSoundworks.ahk
    #IncludeAgain KontaktKompleteKontrol/Soundiron.ahk
    
}
