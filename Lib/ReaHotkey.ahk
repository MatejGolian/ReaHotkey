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
        SetTimer This.ManageState, 200
        If This.Config.Get("CheckIfWinCovered") = 1
        SetTimer This.CheckIfWinCovered, 8000
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
        CurrentControl := ControlGetClassNN(ControlGetFocus(ReaHotkey.PluginWinCriteria))
        Catch
        CurrentControl := 0
        Try
        PluginControl := This.GetPluginControl()
        Catch
        PluginControl := 0
        If ReaHotkey.ReaperPluginNative And Not PluginControl
        Return False
        Else If PluginControl = CurrentControl
        Return False
        Else If ReaHotkey.ReaperPluginNative And Not This.InPluginControl(CurrentControl)
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
        If This.FoundPlugin Is Plugin And This.FoundPlugin.HotkeyMode = 1
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
    
    Static FocusStandaloneOverlay() {
        If This.FoundStandalone Is Standalone And This.FoundStandalone.HotkeyMode = 1 {
            Wait(500)
            If This.FoundStandalone Is Standalone {
                This.FoundStandalone.Overlay.Focus()
            }
        }
    }
    
    Static GetContext() {
        This.ManageState()
        Return This.Context
    }
    
    Static GetPluginControl() {
        If Not This.PluginWinCriteria Or Not WinActive(This.PluginWinCriteria)
        Return False
        Controls := WinGetControls(This.PluginWinCriteria)
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
    
    Static ManageWinCovered(Setting) {
        If Setting.Value
        SetTimer This.CheckIfWinCovered, 8000
        Else
        SetTimer This.CheckIfWinCovered, 0
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
        If ReaHotkey.Config.Get("PromptOnAbletonPlugin") = 1 And Not ReaHotkey.AbletonPluginTimer {
            TestPlugin := Plugin.GetByWinTitle(WinGetTitle("A"))
            If TestPlugin Is Plugin And Not TestPlugin.Name = "Unnamed Plugin" {
                ReaHotkey.AbletonPluginTimer := ObjBindMethod(ReaHotkey, "ReportAbletonPlugin", TestPlugin.Name)
                ReaHotkey.AbletonPluginTimer.Call()
                SetTimer ReaHotkey.AbletonPluginTimer, 8000
            }
        }
    }
    
    Static StopAbletonPluginTimer() {
        If ReaHotkey.AbletonPluginTimer {
            SetTimer ReaHotkey.AbletonPluginTimer, 0
            ReaHotkey.AbletonPluginTimer := False
        }
    }
    
    Static TogglePause(*) {
        A_TrayMenu.ToggleCheck("&Pause")
        Suspend -1
        If A_IsSuspended = 1 {
            SetTimer This.ManageState, 0
            SetTimer This.CheckIfWinCovered, 0
            This.StopAbletonPluginTimer()
            This.TurnPluginTimersOff()
            This.TurnPluginHotkeysOff()
            This.TurnStandaloneTimersOff()
            This.TurnStandaloneHotkeysOff()
            AccessibleMenu.CurrentMenu := False
        }
        Else {
            SetTimer This.ManageState, 200
            If This.Config.Get("CheckIfWinCovered") = 1
            SetTimer This.CheckIfWinCovered, 8000
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
                Hotkey "F6", F6HK, "on"
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
        If This.Found%Type%.HotkeyMode < 3 {
            If This.PluginWinCriteria And Type = "Plugin" {
                HotIfWinActive(This.PluginWinCriteria)
                TurnPluginOn()
                If This.Found%Type%.HotkeyMode < 2
                TurnCommonOn()
                If This.Found%Type%.HotkeyMode < 3
                TurnSpecificsOn(Type, Name)
            }
            If This.StandaloneWinCriteria And Type = "Standalone" {
                HotIfWinActive(This.StandaloneWinCriteria)
                If This.Found%Type%.HotkeyMode < 2
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
                If Timer["Period"] > 0
                SetTimer Timer["Function"], Timer["Period"], Timer["Priority"]
            }
        }
        Else {
            For Timer In %Type%.GetTimers(Name)
            If Timer["Enabled"] = False {
                Timer["Enabled"] := True
                If Timer["Period"] > 0
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
    
    Class CheckIfWinCovered {
        Static Call() {
            Thread "NoTimers"
            Try
            If ReaHotkey.PluginWinCriteria And WinActive(ReaHotkey.PluginWinCriteria) And ReaHotkey.FoundPlugin Is Plugin {
                If WinExist("Error opening devices ahk_exe reaper.exe") {
                    ReportError()
                    Return
                }
            }
            ReportError() {
                AccessibilityOverlay.Speak("Warning: Another window may be covering the interface. ReaHotkey may not work correctly.")
            }
        }
    }
    
    Class GetAbletonPlugin {
        Static Call() {
            If ReaHotkey.AbletonPluginWinCriteria
            Return True
            Return False
        }
    }
    
    Class GetAbletonPluginWinCriteria {
        Static Call() {
            For PluginWinCriteria In ReaHotkey.AbletonPluginWinCriteriaList
            If WinActive(PluginWinCriteria)
            Return PluginWinCriteria
            Return False
        }
    }
    
    Class GetAbletonPluginWinCriteriaList {
        Static Call() {
            Return ["ahk_exe Ableton Live 12(.*).exe ahk_class #32770", "ahk_exe Ableton Live 12(.*).exe ahk_class AbletonVstPlugClass", "ahk_exe Ableton Live 12(.*).exe ahk_class Vst3PlugWindow"]
        }
    }
    
    Class GetPluginWinCriteria {
        Static Call() {
            For PluginWinCriteria In ReaHotkey.PluginWinCriteriaList
            If WinActive(PluginWinCriteria)
            Return PluginWinCriteria
            Return False
        }
    }
    
    Class GetPluginWinCriteriaList {
        Static Call() {
            Return MergeArrays(ReaHotkey.AbletonPluginWinCriteriaList, ReaHotkey.reaperPluginWinCriteriaList)
        }
    }
    
    Class GetReaperPlugin {
        Static Call() {
            If Not ReaHotkey.ReaperPluginWinCriteria
            Return False
            For PluginWinCriteria In ReaHotkey.ReaperPluginWinCriteriaList
            If WinActive(PluginWinCriteria)
            Return True
            Return False
        }
    }
    
    Class GetReaperPluginBridged {
        Static Call() {
            If Not ReaHotkey.ReaperPluginWinCriteria
            Return False
            If ReaHotkey.ReaperPluginWinCriteria = "ahk_exe reaper.exe ahk_class #32770"
            Return False
            Return True
        }
    }
    
    Class GetReaperPluginNative {
        Static Call() {
            If ReaHotkey.ReaperPluginWinCriteria = "ahk_exe reaper.exe ahk_class #32770"
            Return True
            Return False
        }
    }
    
    Class GetReaperPluginWinCriteria {
        Static Call() {
            For PluginWinCriteria In ReaHotkey.reaperPluginWinCriteriaList
            If WinActive(PluginWinCriteria)
            Return PluginWinCriteria
            Return False
        }
    }
    
    Class GetReaperPluginWinCriteriaList {
        Static Call() {
            Return ["ahk_exe reaper.exe ahk_class #32770", "ahk_exe reaper_host32.exe ahk_class #32770", "ahk_exe reaper_host32.exe ahk_class REAPERb32host", "ahk_exe reaper_host64.exe ahk_class #32770", "ahk_exe reaper_host64.exe ahk_class REAPERb32host", "ahk_exe reaper_host64.exe ahk_class REAPERb32host3"]
        }
    }
    
    Class GetStandaloneWinCriteria {
        Static Call() {
            For StandaloneDefinition In Standalone.List
            For WinCriteria In StandaloneDefinition["WinCriteria"]
            If WinActive(WinCriteria)
            Return WinCriteria
            Return False
        }
    }
    
    Class GetStandaloneWinCriteriaList {
        Static Call() {
            WinCriteriaList := Array()
            For StandaloneDefinition In Standalone.List
            For WinCriteria In StandaloneDefinition["WinCriteria"]
            WinCriteriaList.Push(WinCriteria)
            Return WinCriteriaList
        }
    }
    
    Class ManageState {
        Static Call() {
            Critical
            Try {
                If ReaHotkey.PluginWinCriteria And WinActive(ReaHotkey.PluginWinCriteria) {
                    ReaHotkey.AutoFocusStandaloneOverlay := True
                    ReaHotkey.FoundStandalone := False
                    Try
                    CurrentControl := ControlGetClassNN(ControlGetFocus(ReaHotkey.PluginWinCriteria))
                    Catch
                    CurrentControl := 0
                    Try
                    PluginControl := ReaHotkey.GetPluginControl()
                    Catch
                    PluginControl := 0
                    If ReaHotkey.Config.Get("PromptOnAbletonPlugin") = 1 And PluginControl And ReaHotkey.AbletonPlugin {
                        If Not CurrentControl = PluginControl And Not ReaHotkey.InPluginControl(CurrentControl)
                        ReaHotkey.StartAbletonPluginTimer()
                        Else
                        ReaHotkey.StopAbletonPluginTimer()
                    }
                    Else {
                        ReaHotkey.StopAbletonPluginTimer()
                    }
                    If PluginControl And ReaHotkey.ReaperPluginBridged
                    If Not CurrentControl = PluginControl And Not ReaHotkey.InPluginControl(CurrentControl) {
                        ReaHotkey.FocusPluginControl()
                        Return
                    }
                    If Not PluginControl {
                        ReaHotkey.AutoFocusPluginOverlay := True
                        ReaHotkey.FoundPlugin := False
                    }
                    Else If Not CurrentControl {
                        ReaHotkey.AutoFocusPluginOverlay := True
                        ReaHotkey.FoundPlugin := False
                    }
                    Else If Not ReaHotkey.InPluginControl(CurrentControl) {
                        ReaHotkey.AutoFocusPluginOverlay := True
                        ReaHotkey.FoundPlugin := False
                    }
                    Else {
                        ReaHotkey.FoundPlugin := Plugin.GetByWinTitle(WinGetTitle("A"))
                    }
                }
                Else {
                    ReaHotkey.AutoFocusPluginOverlay := True
                    ReaHotkey.FoundPlugin := False
                    ReaHotkey.FoundStandalone := False
                    If ReaHotkey.StandaloneWinCriteria And WinActive(ReaHotkey.StandaloneWinCriteria)
                    ReaHotkey.FoundStandalone := Standalone.GetByWinID(WinGetID("A"))
                    If ReaHotkey.FoundStandalone = False
                    ReaHotkey.AutoFocusStandaloneOverlay := True
                }
            }
            Catch {
                ReaHotkey.AutoFocusPluginOverlay := True
                ReaHotkey.FoundPlugin := False
                ReaHotkey.AutoFocusStandaloneOverlay := True
                ReaHotkey.FoundStandalone := False
            }
            If ReaHotkey.PluginWinCriteria And WinActive(ReaHotkey.PluginWinCriteria) {
                ReaHotkey.Context := "Plugin"
                ReaHotkey.TurnStandaloneTimersOff()
                ReaHotkey.TurnStandaloneHotkeysOff()
                If Not ReaHotkey.FoundPlugin Is Plugin Or WinExist("ahk_class #32768") {
                    ReaHotkey.Context := False
                    ReaHotkey.PreviousPluginName := False
                    ReaHotkey.TurnPluginTimersOff()
                    ReaHotkey.TurnPluginHotkeysOff()
                    AccessibleMenu.CurrentMenu := False
                }
                Else {
                    ReaHotkey.CurrentPluginName := ReaHotkey.FoundPlugin.Name
                    If Not ReaHotkey.CurrentPluginName = ReaHotkey.PreviousPluginName
                    If ReaHotkey.PreviousPluginName {
                        ReaHotkey.TurnPluginTimersOff(ReaHotkey.PreviousPluginName)
                        ReaHotkey.TurnPluginHotkeysOff(ReaHotkey.PreviousPluginName)
                    }
                    ReaHotkey.TurnPluginTimersOn(ReaHotkey.FoundPlugin.Name)
                    ReaHotkey.TurnPluginHotkeysOn(ReaHotkey.FoundPlugin.Name)
                    If ReaHotkey.AutoFocusPluginOverlay = True {
                        ReaHotkey.FocusPluginOverlay()
                        ReaHotkey.AutoFocusPluginOverlay := False
                    }
                    ReaHotkey.PreviousPluginName := ReaHotkey.CurrentPluginName
                }
            }
            Else If ReaHotkey.StandaloneWinCriteria And WinActive(ReaHotkey.StandaloneWinCriteria) {
                ReaHotkey.Context := "Standalone"
                ReaHotkey.StopAbletonPluginTimer()
                ReaHotkey.TurnPluginTimersOff()
                ReaHotkey.TurnPluginHotkeysOff()
                If Not ReaHotkey.FoundStandalone Is Standalone Or WinExist("ahk_class #32768") {
                    ReaHotkey.Context := False
                    ReaHotkey.PreviousStandaloneName := False
                    ReaHotkey.TurnStandaloneTimersOff()
                    ReaHotkey.TurnStandaloneHotkeysOff()
                    AccessibleMenu.CurrentMenu := False
                }
                Else {
                    ReaHotkey.CurrentStandaloneName := ReaHotkey.FoundStandalone.Name
                    If Not ReaHotkey.CurrentStandaloneName = ReaHotkey.PreviousStandaloneName
                    If ReaHotkey.PreviousStandaloneName {
                        ReaHotkey.TurnStandaloneTimersOff(ReaHotkey.PreviousStandaloneName)
                        ReaHotkey.TurnStandaloneHotkeysOff(ReaHotkey.PreviousStandaloneName)
                    }
                    ReaHotkey.TurnStandaloneTimersOn(ReaHotkey.FoundStandalone.Name)
                    ReaHotkey.TurnStandaloneHotkeysOn(ReaHotkey.FoundStandalone.Name)
                    If ReaHotkey.AutoFocusStandaloneOverlay = True {
                        ReaHotkey.FocusStandaloneOverlay()
                        ReaHotkey.AutoFocusStandaloneOverlay := False
                    }
                    ReaHotkey.PreviousStandaloneName := ReaHotkey.CurrentStandaloneName
                }
            }
            Else {
                ReaHotkey.Context := False
                ReaHotkey.PreviousPluginName := False
                ReaHotkey.StopAbletonPluginTimer()
                ReaHotkey.TurnPluginTimersOff()
                ReaHotkey.TurnPluginHotkeysOff()
                ReaHotkey.PreviousStandaloneName := False
                ReaHotkey.TurnStandaloneTimersOff()
                ReaHotkey.TurnStandaloneHotkeysOff()
                AccessibleMenu.CurrentMenu := False
            }
        }
    }
    
    Class ReportAbletonPlugin {
        Static Call(Name := "") {
            If ReaHotkey.Config.Get("PromptOnAbletonPlugin") = 1 {
                If Name
                AccessibilityOverlay.Speak(Name . " detected. Press F6 to focus it.")
                Else
                AccessibilityOverlay.Speak("Supported plug-in detected. Press F6 to focus it.")
            }
            Else {
                This.StopAbletonPluginTimer()
            }
        }
    }
    
    #Include <Update>
    
}
