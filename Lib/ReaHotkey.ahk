#Requires AutoHotkey v2.0

Class ReaHotkey {
    
    Static AbletonPluginTimer := False
    Static AutoFocusPluginOverlay := True
    Static AutoFocusStandaloneOverlay := True
    Static Context := False
    Static CurrentPluginName := False
    Static CurrentStandaloneName := False
    Static FoundPlugin := False
    Static FoundStandalone := False
    Static PreviousPluginName := False
    Static PreviousStandaloneName := False
    Static RequiredScreenWidth := 1920
    Static RequiredScreenHeight := 1080
    Static RequiredWinBuild := 10240
    Static RequiredWinVer := 10
    Static StateManagementTimer := False
    Static WinCoveredTimer := False
    
    Static __New() {
        Critical
        This.TurnPluginHotkeysOff()
        This.TurnStandaloneHotkeysOff()
        This.InitConfig()
        OnError ObjBindMethod(This, "HandleError")
        ScriptReloaded := False
        For Arg In A_Args
        If Arg = "Reload" {
            ScriptReloaded := True
            Break
        }
        If Not ScriptReloaded {
            AccessibilityOverlay.Speak("ReaHotkey ready")
            If This.Config.Get("CheckWinVer") = 1
            This.CheckWinVer()
            If This.Config.Get("CheckScreenResolution") = 1
            This.CheckResolution()
            If This.Config.Get("CheckUpdate") = 1
            This.CheckForUpdates()
        }
        Else {
            AccessibilityOverlay.Speak("Reloaded ReaHotkey")
        }
        AccessibilityOverlay.ClearLastMessage()
        This.StateManagementTimer := ObjBindMethod(This, "ManageState")
        This.WinCoveredTimer := ObjBindMethod(This, "CheckIfWinCovered")
        SetTimer This.StateManagementTimer, 200
        If This.Config.Get("CheckIfWinCovered") = 1
        SetTimer This.WinCoveredTimer, 8000
    }
    
    Static __Get(Name, Params) {
        Try
        Return This.Get%Name%()
        Catch As ErrorMessage
        Throw ErrorMessage
    }
    
    Static CheckForUpdates(Params*) {
        Static DialogOpen := False
        If Not DialogOpen {
            If Params.Length > 0
            This.Update.Check(True)
            Else
            This.Update.Check(False)
        }
    }
    
    Static CheckIfWinCovered() {
        Thread "NoTimers"
        Try
        If This.PluginWinCriteria And WinActive(This.PluginWinCriteria) And This.FoundPlugin Is Plugin {
            If WinExist("Error opening devices ahk_exe reaper.exe") {
                ReportError()
                Return
            }
        }
        ReportError() {
            AccessibilityOverlay.Speak("Warning: Another window may be covering the interface. ReaHotkey may not work correctly.")
        }
    }
    
    Static CheckResolution() {
        If Not A_ScreenWidth = This.RequiredScreenWidth And Not A_ScreenHeight = This.RequiredScreenHeight {
            MsgBox "Your resolution is not set to " . This.RequiredScreenWidth . " × " . This.RequiredScreenHeight . ".`nReaHotkey may not operate properly.", "ReaHotkey"
            Sleep 500
        }
    }
    
    Static CheckWinVer() {
        If Not SubStr(A_OSVersion, 1, InStr(A_OSVersion, ".")) >= This.RequiredWinVer {
            MsgBox "ReaHotkey requires Windows " . This.RequiredWinVer . " or higher.`nSome functions may not operate properly.", "ReaHotkey"
            Sleep 500
        }
        Else {
            WinBuildNumber := StrSplit(A_OSVersion, ".")
            WinBuildNumber := WinBuildNumber[3]
            If SubStr(A_OSVersion, 1, InStr(A_OSVersion, ".")) = This.RequiredWinVer And Not WinBuildNumber >= This.RequiredWinBuild {
                MsgBox "ReaHotkey requires Windows " . This.RequiredWinVer . " build " . This.RequiredWinBuild . ".0 or later.`nSome functions may not operate properly.", "ReaHotkey"
                Sleep 500
            }
        }
    }
    
    Static FocusPluginControl() {
        Try
        CurrentControl := ControlGetClassNN(ControlGetFocus(This.PluginWinCriteria))
        Catch
        CurrentControl := 0
        Try
        PluginControl := This.GetPluginControl()
        Catch
        PluginControl := 0
        If This.ReaperPluginNative And Not PluginControl
        Return False
        Else If PluginControl = CurrentControl
        Return False
        Else If This.ReaperPluginNative And Not This.InPluginControl(CurrentControl)
        Return False
        Else
        Return AttemptFocus(PluginControl)
        AttemptFocus(PluginControl) {
            Try {
                ControlFocus PluginControl, This.PluginWinCriteria
                Return True
            }
            Catch {
                Return False
            }
        }
    }
    
    Static FocusPluginOverlay() {
        If This.FoundPlugin Is Plugin And (This.FoundPlugin.HotkeyMode = 1 Or This.FoundPlugin.HotkeyMode = 3) {
            WindowTitle := GetCurrentWindowTitle()
            If WindowTitle
            AccessibilityOverlay.AddToSpeechQueue(WindowTitle . ",")
            If This.FoundPlugin.Overlay.ChildControls.Length > 0 And This.FoundPlugin.Overlay.GetFocusableControlIDs().Length > 0 {
                This.FoundPlugin.Overlay.Focus()
            }
            Else {
                If HasProp(This.FoundPlugin.Overlay, "Metadata") And This.FoundPlugin.Overlay.Metadata.Has("Product") And Not This.FoundPlugin.Overlay.Metadata["Product"] = ""
                AccessibilityOverlay.Speak(This.FoundPlugin.Overlay.Metadata["Product"] . " overlay active")
                Else If This.FoundPlugin.Overlay.Label = ""
                AccessibilityOverlay.Speak(This.FoundPlugin.Name . " overlay active")
                Else
                AccessibilityOverlay.Speak(This.FoundPlugin.Overlay.Label . " overlay active")
            }
        }
    }
    
    Static FocusStandaloneOverlay() {
        If This.FoundStandalone Is Standalone And (This.FoundStandalone.HotkeyMode = 1 Or This.FoundStandalone.HotkeyMode = 3) {
            WindowTitle := GetCurrentWindowTitle()
            If WindowTitle
            AccessibilityOverlay.AddToSpeechQueue(WindowTitle . ",")
            If This.FoundStandalone Is Standalone {
                This.FoundStandalone.Overlay.Focus()
            }
        }
    }
    
    Static GetAbletonPlugin() {
        If This.AbletonPluginWinCriteria
        Return True
        Return False
    }
    
    Static GetAbletonPluginWinCriteria() {
        For PluginWinCriteria In This.AbletonPluginWinCriteriaList
        If WinActive(PluginWinCriteria)
        Return PluginWinCriteria
        Return False
    }
    
    Static GetAbletonPluginWinCriteriaList() {
        Return ["ahk_exe Ableton Live 12(.*).exe ahk_class #32770", "ahk_exe Ableton Live 12(.*).exe ahk_class AbletonVstPlugClass", "ahk_exe Ableton Live 12(.*).exe ahk_class Vst3PlugWindow"]
    }
    
    Static GetContext() {
        This.ManageState()
        Return This.Context
    }
    
    Static GetPluginControl() {
        PluginWinCriteria := This.PluginWinCriteria
        If Not PluginWinCriteria Or Not WinActive(PluginWinCriteria)
        Return False
        Controls := WinGetControls(PluginWinCriteria)
        If This.AbletonPlugin {
            If Controls.Length > 0
            For PluginEntry In Plugin.List
            If PluginEntry["ControlClasses"] Is Array And PluginEntry["ControlClasses"].Length > 0
            For ControlClass In PluginEntry["ControlClasses"]
            If RegExMatch(Controls[1], ControlClass)
            Return Controls[1]
        }
        If This.ReaperPlugin {
            ReaperControlPatterns := ["^#327701$", "^Button[0-9]+$", "^ComboBox[0-9]+$", "^Edit[0-9]+$", "^REAPERknob[0-9]+$", "^reaperPluginHostWrapProc[0-9]+$", "^Static[0-9]+$", "^SysHeader321$", "^SysListView321$", "^SysTreeView321$"]
            For Index, Control In Controls
            If Control = "reaperPluginHostWrapProc1" And Index < Controls.Length {
                PluginControl := Controls[Index + 1]
                For ReaperControlPattern In ReaperControlPatterns
                If RegExMatch(PluginControl, ReaperControlPattern)
                Return False
                For PluginEntry In Plugin.List
                If PluginEntry["ControlClasses"] Is Array And PluginEntry["ControlClasses"].Length > 0
                For ControlClass In PluginEntry["ControlClasses"]
                If RegExMatch(PluginControl, ControlClass)
                Return PluginControl
                Break
            }
            If Controls.Length > 0 {
                For ReaperControlPattern In ReaperControlPatterns
                If RegExMatch(Controls[1], ReaperControlPattern)
                Return False
                For PluginEntry In Plugin.List
                If PluginEntry["ControlClasses"] Is Array And PluginEntry["ControlClasses"].Length > 0
                For ControlClass In PluginEntry["ControlClasses"]
                If RegExMatch(Controls[1], ControlClass)
                Return Controls[1]
            }
        }
        Return False
    }
    
    Static GetPluginWinCriteria() {
        For PluginWinCriteria In This.PluginWinCriteriaList
        If WinActive(PluginWinCriteria)
        Return PluginWinCriteria
        Return False
    }
    
    Static GetPluginWinCriteriaList() {
        Return AccessibilityOverlay.MergeArrays(This.AbletonPluginWinCriteriaList, This.reaperPluginWinCriteriaList)
    }
    
    Static GetReaperPlugin() {
        If Not This.ReaperPluginWinCriteria
        Return False
        For PluginWinCriteria In This.ReaperPluginWinCriteriaList
        If WinActive(PluginWinCriteria)
        Return True
        Return False
    }
    
    Static GetReaperPluginBridged() {
        If Not This.ReaperPluginWinCriteria
        Return False
        If This.ReaperPluginWinCriteria = "ahk_exe reaper.exe ahk_class #32770"
        Return False
        Return True
    }
    
    Static GetReaperPluginNative() {
        If This.ReaperPluginWinCriteria = "ahk_exe reaper.exe ahk_class #32770"
        Return True
        Return False
    }
    
    Static GetReaperPluginWinCriteria() {
        For PluginWinCriteria In This.reaperPluginWinCriteriaList
        If WinActive(PluginWinCriteria)
        Return PluginWinCriteria
        Return False
    }
    
    Static GetReaperPluginWinCriteriaList() {
        Return ["ahk_exe reaper.exe ahk_class #32770", "ahk_exe reaper_host32.exe ahk_class #32770", "ahk_exe reaper_host32.exe ahk_class REAPERb32host", "ahk_exe reaper_host64.exe ahk_class #32770", "ahk_exe reaper_host64.exe ahk_class REAPERb32host", "ahk_exe reaper_host64.exe ahk_class REAPERb32host3"]
    }
    
    Static GetStandaloneWinCriteria() {
        For StandaloneDefinition In Standalone.List
        For WinCriteria In StandaloneDefinition["WinCriteria"]
        If WinActive(WinCriteria)
        Return WinCriteria
        Return False
    }
    
    Static GetStandaloneWinCriteriaList() {
        WinCriteriaList := Array()
        For StandaloneDefinition In Standalone.List
        For WinCriteria In StandaloneDefinition["WinCriteria"]
        WinCriteriaList.Push(WinCriteria)
        Return WinCriteriaList
    }
    
    Static HandleError(Exception, Mode) {
        This.TurnPluginHotkeysOff()
        This.TurnStandaloneHotkeysOff()
    }
    
    Static InitConfig() {
        This.Config := Configuration("ReaHotkey Configuration")
        This.Config.Add("ReaHotkey.ini", "Config", "CheckWinVer", 1, "Check Windows version on startup")
        This.Config.Add("ReaHotkey.ini", "Config", "CheckScreenResolution", 1, "Check screen resolution on startup")
        This.Config.Add("ReaHotkey.ini", "Config", "CheckUpdate", 1, "Check for updates on startup")
        This.Config.Add("ReaHotkey.ini", "Config", "CheckIfWinCovered", 1, "Warn if another window may be covering the interface in specific cases",, ObjBindMethod(This, "ManageWinCovered"))
        This.Config.Add("ReaHotkey.ini", "Config", "PromptOnAbletonPlugin", 1, "Prompt if a compatible plug-in is detected but does not have focus", "Ableton Live", ObjBindMethod(This, "ManageAbletonPluginPrompt"))
    }
    
    Static InPluginControl(ControlToCheck) {
        If This.PluginWinCriteria And WinActive(This.PluginWinCriteria) {
            PluginControl := This.GetPluginControl()
            If Not PluginControl
            Return False
            Controls := WinGetControls(This.PluginWinCriteria)
            CurrentControl := 0
            PluginPosition := 0
            For Index, Control In Controls
            If Control = PluginControl {
                CurrentControl := Control
                PluginPosition := Index
                Break
            }
            CheckPosition := 0
            For Index, Control In Controls
            If Control = ControlToCheck {
                CheckPosition := Index
                Break
            }
            If Not PluginPosition > 0 Or Not CheckPosition > 0 Or Not PluginPosition <= CheckPosition
            Return False
            If This.AbletonPlugin {
                AdjustFocus(CurrentControl, PluginControl)
                Return True
            }
            If This.ReaperPlugin {
                ReaperControlPatterns := ["^#327701$", "^Button[0-9]+$", "^ComboBox[0-9]+$", "^Edit[0-9]+$", "^REAPERknob[0-9]+$", "^reaperPluginHostWrapProc[0-9]+$", "^Static[0-9]+$", "^SysHeader321$", "^SysListView321$", "^SysTreeView321$"]
                For ReaperControlPattern In ReaperControlPatterns
                If RegExMatch(ControlToCheck, ReaperControlPattern)
                Return False
                AdjustFocus(CurrentControl, PluginControl)
                Return True
            }
        }
        Return False
        AdjustFocus(CurrentControl, PluginControl) {
            If CurrentControl And PluginControl
            If Not CurrentControl = PluginControl {
                Try
                ControlFocus PluginControl, This.PluginWinCriteria
            }
        }
    }
    
    Static ManageAbletonPluginPrompt(Setting) {
        If Not Setting.Value
        This.StopAbletonPluginTimer()
    }
    
    Static ManageState() {
        Critical
        Try {
            Loop
            CurrentWinID := GetCurrentWindowID()
            Until CurrentWinID
            If This.PluginWinCriteria And WinActive(This.PluginWinCriteria) {
                This.AutoFocusStandaloneOverlay := True
                This.FoundStandalone := False
                Try
                CurrentControl := ControlGetClassNN(ControlGetFocus(This.PluginWinCriteria))
                Catch
                CurrentControl := 0
                Try
                PluginControl := This.GetPluginControl()
                Catch
                PluginControl := 0
                If This.Config.Get("PromptOnAbletonPlugin") = 1 And PluginControl And This.AbletonPlugin {
                    If Not CurrentControl = PluginControl And Not This.InPluginControl(CurrentControl)
                    This.StartAbletonPluginTimer()
                    Else
                    This.StopAbletonPluginTimer()
                }
                Else {
                    This.StopAbletonPluginTimer()
                }
                If PluginControl And This.ReaperPluginBridged
                If Not CurrentControl = PluginControl And Not This.InPluginControl(CurrentControl) {
                    This.FocusPluginControl()
                    Return
                }
                If Not PluginControl {
                    This.AutoFocusPluginOverlay := True
                    This.FoundPlugin := False
                }
                Else If Not CurrentControl {
                    This.AutoFocusPluginOverlay := True
                    This.FoundPlugin := False
                }
                Else If Not This.InPluginControl(CurrentControl) {
                    This.AutoFocusPluginOverlay := True
                    This.FoundPlugin := False
                }
                Else {
                    This.FoundPlugin := Plugin.GetByWinTitle(WinGetTitle("A"))
                }
            }
            Else {
                This.AutoFocusPluginOverlay := True
                This.FoundPlugin := False
                This.FoundStandalone := False
                If This.StandaloneWinCriteria And WinActive(This.StandaloneWinCriteria)
                This.FoundStandalone := Standalone.GetByWinID(WinGetID("A"))
                If This.FoundStandalone = False
                This.AutoFocusStandaloneOverlay := True
            }
        }
        Catch {
            This.AutoFocusPluginOverlay := True
            This.FoundPlugin := False
            This.AutoFocusStandaloneOverlay := True
            This.FoundStandalone := False
        }
        If This.PluginWinCriteria And WinActive(This.PluginWinCriteria) {
            This.Context := "Plugin"
            This.TurnStandaloneTimersOff()
            This.TurnStandaloneHotkeysOff()
            If Not This.FoundPlugin Is Plugin Or WinExist("ahk_class #32768") {
                This.Context := False
                This.PreviousPluginName := False
                This.TurnPluginTimersOff()
                This.TurnPluginHotkeysOff()
                AccessibleMenu.CurrentMenu := False
            }
            Else {
                This.CurrentPluginName := This.FoundPlugin.Name
                If Not This.CurrentPluginName = This.PreviousPluginName
                If This.PreviousPluginName {
                    This.TurnPluginTimersOff(This.PreviousPluginName)
                    This.TurnPluginHotkeysOff(This.PreviousPluginName)
                }
                This.TurnPluginTimersOn(This.FoundPlugin.Name)
                This.TurnPluginHotkeysOn(This.FoundPlugin.Name)
                If This.AutoFocusPluginOverlay = True {
                    This.FocusPluginOverlay()
                    This.AutoFocusPluginOverlay := False
                }
                This.PreviousPluginName := This.CurrentPluginName
            }
        }
        Else If This.StandaloneWinCriteria And WinActive(This.StandaloneWinCriteria) {
            This.Context := "Standalone"
            This.StopAbletonPluginTimer()
            This.TurnPluginTimersOff()
            This.TurnPluginHotkeysOff()
            If Not This.FoundStandalone Is Standalone Or WinExist("ahk_class #32768") {
                This.Context := False
                This.PreviousStandaloneName := False
                This.TurnStandaloneTimersOff()
                This.TurnStandaloneHotkeysOff()
                AccessibleMenu.CurrentMenu := False
            }
            Else {
                This.CurrentStandaloneName := This.FoundStandalone.Name
                If Not This.CurrentStandaloneName = This.PreviousStandaloneName
                If This.PreviousStandaloneName {
                    This.TurnStandaloneTimersOff(This.PreviousStandaloneName)
                    This.TurnStandaloneHotkeysOff(This.PreviousStandaloneName)
                }
                This.TurnStandaloneTimersOn(This.FoundStandalone.Name)
                This.TurnStandaloneHotkeysOn(This.FoundStandalone.Name)
                If This.AutoFocusStandaloneOverlay = True {
                    This.FocusStandaloneOverlay()
                    This.AutoFocusStandaloneOverlay := False
                }
                This.PreviousStandaloneName := This.CurrentStandaloneName
            }
        }
        Else {
            This.Context := False
            This.PreviousPluginName := False
            This.StopAbletonPluginTimer()
            This.TurnPluginTimersOff()
            This.TurnPluginHotkeysOff()
            This.PreviousStandaloneName := False
            This.TurnStandaloneTimersOff()
            This.TurnStandaloneHotkeysOff()
            AccessibleMenu.CurrentMenu := False
            AccessibilityOverlay.ClearLastMessage()
            AccessibilityOverlay.ClearSpeechQueue()
        }
    }
    
    Static ManageWinCovered(Setting) {
        If Setting.Value
        SetTimer This.WinCoveredTimer, 8000
        Else
        SetTimer This.WinCoveredTimer, 0
    }
    
    Static Quit(*) {
        ExitApp
    }
    
    Static Reload(*) {
        If A_IsCompiled = 0
        Run A_AhkPath . " /restart " . A_ScriptFullPath . " Reload"
        Else
        Run A_ScriptFullPath . " /restart Reload"
    }
    
    Static ReportAbletonPlugin(Name := "") {
        If This.Config.Get("PromptOnAbletonPlugin") = 1 {
            If Name
            AccessibilityOverlay.Speak(Name . " detected. Press F6 to focus it.")
            Else
            AccessibilityOverlay.Speak("Supported plug-in detected. Press F6 to focus it.")
        }
        Else {
            This.StopAbletonPluginTimer()
        }
    }
    
    Static ShowAboutBox(*) {
        Static AboutBox := False
        If AboutBox = False {
            AboutBox := Gui(, "About ReaHotkey")
            AboutBox.AddEdit("ReadOnly", "Version " . GetVersion())
            AboutBox.AddLink("XS", 'ReaHotkey on <a href="https://github.com/MatejGolian/ReaHotkey">GitHub</a>')
            AboutBox.AddButton("Default Section XS", "OK").OnEvent("Click", CloseAboutBox)
            AboutBox.OnEvent("Close", CloseAboutBox)
            AboutBox.OnEvent("Escape", CloseAboutBox)
            AboutBox.Show()
        }
        Else {
            AboutBox.Show()
        }
        CloseAboutBox(*) {
            AboutBox.Destroy()
            AboutBox := False
        }
    }
    
    Static ShowConfigBox(*) {
        This.Config.ShowBox()
    }
    
    Static StartAbletonPluginTimer() {
        If This.Config.Get("PromptOnAbletonPlugin") = 1 And Not This.AbletonPluginTimer {
            TestPlugin := Plugin.GetByWinTitle(WinGetTitle("A"))
            If TestPlugin Is Plugin And Not TestPlugin.Name = "Unnamed Plugin" {
                This.AbletonPluginTimer := ObjBindMethod(This, "ReportAbletonPlugin", TestPlugin.Name)
                This.AbletonPluginTimer.Call()
                SetTimer This.AbletonPluginTimer, 8000
            }
        }
    }
    
    Static StopAbletonPluginTimer() {
        If This.AbletonPluginTimer {
            SetTimer This.AbletonPluginTimer, 0
            This.AbletonPluginTimer := False
        }
    }
    
    Static TogglePause(*) {
        A_TrayMenu.ToggleCheck("&Pause")
        Suspend -1
        If A_IsSuspended = 1 {
            SetTimer This.StateManagementTimer, 0
            SetTimer This.WinCoveredTimer, 0
            This.StopAbletonPluginTimer()
            This.TurnPluginTimersOff()
            This.TurnPluginHotkeysOff()
            This.TurnStandaloneTimersOff()
            This.TurnStandaloneHotkeysOff()
            AccessibleMenu.CurrentMenu := False
        }
        Else {
            SetTimer This.StateManagementTimer, 200
            If This.Config.Get("CheckIfWinCovered") = 1
            SetTimer This.WinCoveredTimer, 8000
        }
    }
    
    Static TurnHotkeysOff(Type, Name := "") {
        Thread "NoTimers"
        If Type = "Plugin" Or Type = "Standalone" {
            If Type = "Plugin"
            For PluginWinCriteria In This.PluginWinCriteriaList {
                HotIfWinActive(PluginWinCriteria)
                TurnCommonOff()
                TurnSpecificsOff(Type, Name)
                TurnPluginOn()
            }
            If Type = "Standalone"
            For StandaloneWinCriteria In This.StandaloneWinCriteriaList {
                HotIfWinActive(StandaloneWinCriteria)
                TurnCommonOff()
                TurnSpecificsOff(Type, Name)
            }
            If This.PluginWinCriteria And WinActive(This.PluginWinCriteria)
            HotIfWinActive(This.PluginWinCriteria)
            Else If This.StandaloneWinCriteria And WinActive(This.StandaloneWinCriteria)
            HotIfWinActive(This.StandaloneWinCriteria)
            Else
            HotIf
        }
        TurnCommonOff() {
            Hotkey "Tab", "Off"
            Hotkey "+Tab", "Off"
            Hotkey "^Tab", "Off"
            Hotkey "^+Tab", "Off"
            Hotkey "Left", "Off"
            Hotkey "Right", "Off"
            Hotkey "Up", "Off"
            Hotkey "Down", "Off"
            Hotkey "Enter", "Off"
            Hotkey "Space", "Off"
        }
        TurnPluginOn() {
            Hotkey "F6", F6HK, "On"
        }
        TurnSpecificsOff(Type, Name) {
            If Name = "" {
                For HotkeyEntry In %Type%.GetList()
                For DefinedHotkey In HotkeyEntry["Hotkeys"]
                If Not DefinedHotkey["State"] = "Off"
                Hotkey DefinedHotkey["KeyName"], DefinedHotkey["Action"], "Off"
            }
            Else {
                For DefinedHotkey In %Type%.GetHotkeys(Name)
                If Not DefinedHotkey["State"] = "Off"
                Hotkey DefinedHotkey["KeyName"], DefinedHotkey["Action"], "Off"
            }
        }
    }
    
    Static TurnHotkeysOn(Type, Name := "") {
        Thread "NoTimers"
        If Type = "Plugin" Or Type = "Standalone"
        If This.Found%Type% Is %Type%
        If This.Found%Type%.HotkeyMode > 0 And This.Found%Type%.HotkeyMode < 4 {
            If This.PluginWinCriteria And Type = "Plugin" {
                HotIfWinActive(This.PluginWinCriteria)
                TurnPluginOn()
                If This.Found%Type%.HotkeyMode = 1 Or This.Found%Type%.HotkeyMode = 3
                TurnCommonOn()
                If This.Found%Type%.HotkeyMode < 3
                TurnSpecificsOn(Type, Name)
            }
            If This.StandaloneWinCriteria And Type = "Standalone" {
                HotIfWinActive(This.StandaloneWinCriteria)
                If This.Found%Type%.HotkeyMode = 1 Or This.Found%Type%.HotkeyMode = 3
                TurnCommonOn()
                If This.Found%Type%.HotkeyMode < 3
                TurnSpecificsOn(Type, Name)
            }
            If This.PluginWinCriteria And WinActive(This.PluginWinCriteria)
            HotIfWinActive(This.PluginWinCriteria)
            Else If This.StandaloneWinCriteria And WinActive(This.StandaloneWinCriteria)
            HotIfWinActive(This.StandaloneWinCriteria)
            Else
            HotIf
        }
        TurnCommonOn() {
            Hotkey "Tab", TabHK, "On"
            Hotkey "+Tab", ShiftTabHK, "On"
            Hotkey "^Tab", ControlTabHK, "On"
            Hotkey "^+Tab", ControlShiftTabHK, "On"
            Hotkey "Left", LeftRightHK, "On"
            Hotkey "Right", LeftRightHK, "On"
            Hotkey "Up", UpDownHK, "On"
            Hotkey "Down", UpDownHK, "On"
            Hotkey "Enter", EnterSpaceHK, "On"
            Hotkey "Space", EnterSpaceHK, "On"
        }
        TurnPluginOn() {
            Hotkey "F6", F6HK, "On"
        }
        TurnSpecificsOn(Type, Name) {
            If Name = "" {
                If This.Found%Type% Is %Type% {
                    For DefinedHotkey In This.Found%Type%.GetHotkeys()
                    If Not DefinedHotkey["State"] = "Off"
                    Hotkey DefinedHotkey["KeyName"], DefinedHotkey["Action"], DefinedHotkey["Options"]
                }
            }
            Else {
                For DefinedHotkey In %Type%.GetHotkeys(Name)
                If Not DefinedHotkey["State"] = "Off"
                Hotkey DefinedHotkey["KeyName"], DefinedHotkey["Action"], DefinedHotkey["Options"]
            }
        }
    }
    
    Static TurnPluginHotkeysOff(Name := "") {
        This.TurnHotkeysOff("Plugin", Name)
    }
    
    Static TurnPluginHotkeysOn(Name := "") {
        This.TurnHotkeysOn("Plugin", Name)
    }
    
    Static TurnPluginTimersOff(Name := "") {
        This.TurnTimersOff("Plugin", Name)
    }
    
    Static TurnPluginTimersOn(Name := "") {
        This.TurnTimersOn("Plugin", Name)
    }
    
    Static TurnStandaloneHotkeysOff(Name := "") {
        This.TurnHotkeysOff("Standalone", Name)
    }
    
    Static TurnStandaloneHotkeysOn(Name := "") {
        This.TurnHotkeysOn("Standalone", Name)
    }
    
    Static TurnStandaloneTimersOff(Name := "") {
        This.TurnTimersOff("Standalone", Name)
    }
    
    Static TurnStandaloneTimersOn(Name := "") {
        This.TurnTimersOn("Standalone", Name)
    }
    
    Static TurnTimersOff(Type, Name := "") {
        If Name = "" {
            TimerList := %Type%.GetList()
            For TimerEntry In TimerList
            For Timer In TimerEntry["Timers"]
            If Timer["Enabled"] = True {
                Timer["Enabled"] := False
                SetTimer Timer["Function"], 0
            }
        }
        Else {
            For Timer In %Type%.GetTimers(Name)
            If Timer["Enabled"] = True {
                Timer["Enabled"] := False
                SetTimer Timer["Function"], 0
            }
        }
    }
    
    Static TurnTimersOn(Type, Name := "") {
        If Name = "" {
            TimerList := %Type%.GetList()
            For TimerEntry In TimerList
            For Timer In TimerEntry["Timers"]
            If Timer["Enabled"] = False {
                Timer["Enabled"] := True
                If Not Timer["Period"] = 0
                SetTimer Timer["Function"], Timer["Period"], Timer["Priority"]
            }
        }
        Else {
            For Timer In %Type%.GetTimers(Name)
            If Timer["Enabled"] = False {
                Timer["Enabled"] := True
                If Not Timer["Period"] = 0
                SetTimer Timer["Function"], Timer["Period"], Timer["Priority"]
            }
        }
    }
    
    Static ViewReadme(*) {
        Static DialogOpen := False
        If FileExist("README.html") And Not InStr(FileExist("README.html"), "D") {
            Run "README.html"
            Return
        }
        If Not DialogOpen {
            DialogOpen := True
            SoundPlay "*16"
            MsgBox "Readme file not Found.", "Error"
            DialogOpen := False
        }
    }
    
    #Include <Update>
    
}
