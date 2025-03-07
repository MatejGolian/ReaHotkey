#Requires AutoHotkey v2.0

Class ReaHotkey {
    
    Static AutoFocusPluginOverlay := True
    Static AutoFocusStandaloneOverlay := True
    Static Context := False
    Static FoundPlugin := False
    Static FoundStandalone := False
    Static NonRemappableHotkeys := Array("^+#F1", "^+#F5", "Control", "Ctrl", "LCtrl", "RCtrl", "^+#A", "^+#C", "^+#P", "^+#Q", "^+#R")
    Static PluginHotkeyOverrides := Array()
    Static RequiredScreenWidth := 1920
    Static RequiredScreenHeight := 1080
    Static RequiredWinBuild := 10240
    Static RequiredWinVer := 10
    Static StandaloneHotkeyOverrides := Array()
    
    Static __New() {
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
        SetTimer This.ManageState, 100
        If This.Config.Get("CheckIfWinCovered") = 1
        SetTimer This.CheckIfWinCovered, 10000
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
    
    Static FindOverrideHotkey(Type, Name, KeyName) {
        If Not %Type%.FindName(Name)
        Return 0
        If KeyName
        For HotkeyNumber, HotkeyParams In This.%Type%HotkeyOverrides
        If HotkeyParams["Name"] = Name And HotkeyParams["KeyName"] = KeyName
        Return HotkeyNumber
        Return 0
    }
    
    Static FocusPluginOverlay() {
        If This.FoundPlugin Is Plugin And This.FoundPlugin.NoHotkeys = False
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
        If This.FoundStandalone Is Standalone And This.FoundStandalone.NoHotkeys = False {
            Wait(500)
            If This.FoundStandalone Is Standalone {
                This.FoundStandalone.Overlay.Focus()
            }
        }
    }
    
    Static GetContext() {
        If Not This.Context = False
        Try
        If This.Context = "Plugin"
        This.FoundPlugin := Plugin.GetByWinTitle(WinGetTitle("A"))
        Else
        This.FoundStandalone := Standalone.GetByWinID(WinGetID("A"))
        Catch
        This.Found%ReaHotkey.Context% := False
        If Not This.Context = False And This.Found%This.Context% Is %This.Context%
        Return This.Context
        Return False
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
    }
    
    Static InPluginControl(ControlToCheck) {
        If This.PluginWinCriteria And WinActive(This.PluginWinCriteria) {
            PluginControl := This.GetPluginControl()
            If Not PluginControl
            Return False
            Controls := WinGetControls(This.PluginWinCriteria)
            PluginPosition := 0
            For Index, Control In Controls
            If Control = PluginControl {
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
            If This.AbletonPlugin
            Return True
            If This.ReaperPlugin {
                ReaperControlPatterns := ["^#327701$", "^Button[0-9]+$", "^ComboBox[0-9]+$", "^Edit[0-9]+$", "^REAPERknob[0-9]+$", "^reaperPluginHostWrapProc[0-9]+$", "^Static[0-9]+$", "^SysHeader321$", "^SysListView321$", "^SysTreeView321$"]
                For ReaperControlPattern In ReaperControlPatterns
                If RegExMatch(ControlToCheck, ReaperControlPattern)
                Return False
                Return True
            }
        }
        Return False
    }
    
    Static ManageWinCovered(Setting) {
        If Setting.Value
        SetTimer This.CheckIfWinCovered, 10000
        Else
        SetTimer This.CheckIfWinCovered, 0
    }
    
    Static OverrideHotkey(Type, Name, KeyName, Action := "", Options := "") {
        If Type = "Plugin" Or Type = "Standalone" {
            If Not %Type%.FindName(Name)
            Return False
            For NonRemappableHotkey In This.NonRemappableHotkeys
            If KeyName = NonRemappableHotkey
            Return False
            HotkeyNumber := This.FindOverrideHotkey(Type, Name, KeyName)
            If HotkeyNumber = 0 {
                If Not Action Is Object
                Options := Action . " " . Options
                GetOptions()
                If Not Action Is Object
                Action := PassThroughHotkey
                This.%Type%HotkeyOverrides.Push(Map("Name", Name, "KeyName", KeyName, "Action", Action, "Options", Options.String, "State", Options.OnOff))
            }
            Else If HotkeyNumber > 0 {
                CurrentAction := This.%Type%HotkeyOverrides[HotkeyNumber]["Action"]
                CurrentOptions := This.%Type%HotkeyOverrides[HotkeyNumber]["Options"]
                If Not Action Is Object
                Options := Action . " " . Options
                Options := Options . " " . CurrentOptions
                GetOptions()
                If Not Action Is Object
                Action := CurrentAction
                This.%Type%HotkeyOverrides[HotkeyNumber]["Action"] := Action
                This.%Type%HotkeyOverrides[HotkeyNumber]["Options"] := Options.String
                This.%Type%HotkeyOverrides[HotkeyNumber]["State"] := Options.OnOff
            }
            Else {
                Return False
            }
            If This.PluginWinCriteria And Type = "Plugin"
            HotIfWinActive(This.PluginWinCriteria)
            If Type = "Standalone"
            HotIf
            If This.Found%Type% Is %Type% And This.Found%Type%.Name = Name
            Hotkey KeyName, Action, Options.String
            If This.PluginWinCriteria And WinActive(This.PluginWinCriteria)
            HotIfWinActive(This.PluginWinCriteria)
            Else
            HotIf
            Return True
        }
        Return False
        GetOptions() {
            OnOff := ""
            B := ""
            P := ""
            S := ""
            T := ""
            I := ""
            Options := StrSplit(Options, [A_Space, A_Tab])
            Match := ""
            For Option In Options {
                If OnOff = "" And RegexMatch(Option, "i)^((On)|(Off))$", &Match)
                OnOff := Match[0]
                If B = "" And RegexMatch(Option, "i)^(B0?)$", &Match)
                B := Match[0]
                If P = "" And RegexMatch(Option, "i)^((P[1-9][0-9]*)|(P0?))$", &Match)
                P := Match[0]
                If S = "" And RegexMatch(Option, "i)^(S0?)$", &Match)
                S := Match[0]
                If T = "" And RegexMatch(Option, "i)^(T([1-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5]))$", &Match)
                T := Match[0]
                If I = "" And RegexMatch(Option, "i)^(I([0-9]|[1-9][0-9]|100))$", &Match)
                I := Match[0]
            }
            If Not OnOff = "On" And Not OnOff = "Off"
            OnOff := "On"
            Options := {OnOff: OnOff, B: B, P: P, S: S, T: T, I: I, String: Trim(OnOff . " " . B . " " . P . " " . S . " " . T . " " . I)}
        }
    }
    
    Static OverridePluginHotkey(PluginName, KeyName, Action := "", Options := "") {
        This.OverrideHotkey("Plugin", PluginName, KeyName, Action, Options)
    }
    
    Static OverrideStandaloneHotkey(StandaloneName, KeyName, Action := "", Options := "") {
        This.OverrideHotkey("Standalone", StandaloneName, KeyName, Action, Options)
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
    
    Static TogglePause(*) {
        A_TrayMenu.ToggleCheck("&Pause")
        Suspend -1
        If A_IsSuspended = 1 {
            SetTimer This.ManageState, 0
            SetTimer This.CheckIfWinCovered, 0
            This.TurnPluginTimersOff()
            This.TurnPluginHotkeysOff()
            This.TurnStandaloneTimersOff()
            This.TurnStandaloneHotkeysOff()
            AccessibleMenu.CurrentMenu := False
        }
        Else {
            SetTimer This.ManageState, 100
            If This.Config.Get("CheckIfWinCovered") = 1
            SetTimer This.CheckIfWinCovered, 10000
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
                TurnOverridesOff(Type, Name)
            }
            If Type = "Standalone" {
                HotIf
                TurnCommonOff()
                TurnSpecificsOff(Type, Name)
                TurnOverridesOff(Type, Name)
            }
            If This.PluginWinCriteria And WinActive(This.PluginWinCriteria)
            HotIfWinActive(This.PluginWinCriteria)
            Else
            HotIf
        }
        TurnCommonOff() {
            Try
            Hotkey("F6")
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
        TurnOverridesOff(Type, Name) {
            If Name = "" {
                For DefinedHotkey In This.%Type%HotkeyOverrides
                If Not DefinedHotkey["State"] = "Off"
                Hotkey DefinedHotkey["KeyName"], DefinedHotkey["Action"], "Off"
            }
            Else {
                For DefinedHotkey In This.%Type%HotkeyOverrides
                If DefinedHotkey["Name"] = Name And Not DefinedHotkey["State"] = "Off"
                Hotkey DefinedHotkey["KeyName"], DefinedHotkey["Action"], "Off"
            }
        }
    }
    
    Static TurnHotkeysOn(Type, Name := "") {
        Thread "NoTimers"
        If Type = "Plugin" Or Type = "Standalone"
        If This.Found%Type% Is %Type%
        If This.Found%Type%.NoHotkeys = False {
            If This.PluginWinCriteria And Type = "Plugin" {
                HotIfWinActive(This.PluginWinCriteria)
                TurnCommonOn()
                TurnSpecificsOn(Type, Name)
                TurnOverridesOn(Type, Name)
            }
            If This.StandaloneWinCriteria And Type = "Standalone" {
                HotIf
                TurnCommonOn()
                TurnSpecificsOn(Type, Name)
                TurnOverridesOn(Type, Name)
            }
            If This.PluginWinCriteria And WinActive(This.PluginWinCriteria)
            HotIfWinActive(This.PluginWinCriteria)
            Else
            HotIf
        }
        Else {
            If This.PluginWinCriteria And Type = "Plugin" {
                HotIfWinActive(This.PluginWinCriteria)
                TurnOverridesOn(Type, Name)
            }
            If This.StandaloneWinCriteria And Type = "Standalone" {
                HotIf
                TurnOverridesOn(Type, Name)
            }
            If This.PluginWinCriteria And WinActive(This.PluginWinCriteria)
            HotIfWinActive(This.PluginWinCriteria)
            Else
            HotIf
        }
        TurnCommonOn() {
            Try {
                Hotkey("F6")
                Hotkey "F6", "F6HK", "On"
            }
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
        TurnOverridesOn(Type, Name) {
            For DefinedHotkey In This.%Type%HotkeyOverrides
            If DefinedHotkey["Name"] = Name And Not DefinedHotkey["State"] = "Off"
            Hotkey DefinedHotkey["KeyName"], DefinedHotkey["Action"], DefinedHotkey["Options"]
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
                SetTimer Timer["Function"], Timer["Period"], Timer["Priority"]
            }
        }
        Else {
            For Timer In %Type%.GetTimers(Name)
            If Timer["Enabled"] = False {
                Timer["Enabled"] := True
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
            Static CurrentPluginName := False, PreviousPluginName := False, CurrentStandaloneName := False, PreviousStandaloneName := False
            Critical
            Try {
                If ReaHotkey.PluginWinCriteria And WinActive(ReaHotkey.PluginWinCriteria) {
                    ReaHotkey.AutoFocusStandaloneOverlay := True
                    ReaHotkey.FoundStandalone := False
                    If Not ReaHotkey.GetPluginControl() {
                        ReaHotkey.AutoFocusPluginOverlay := True
                        ReaHotkey.FoundPlugin := False
                    }
                    Else If Not ControlGetFocus(ReaHotkey.PluginWinCriteria) {
                        ReaHotkey.AutoFocusPluginOverlay := True
                        ReaHotkey.FoundPlugin := False
                    }
                    Else If Not ReaHotkey.InPluginControl(ControlGetClassNN(ControlGetFocus(ReaHotkey.PluginWinCriteria))) {
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
            Critical "Off"
            If ReaHotkey.PluginWinCriteria And WinActive(ReaHotkey.PluginWinCriteria) {
                ReaHotkey.Context := "Plugin"
                ReaHotkey.TurnStandaloneTimersOff()
                ReaHotkey.TurnStandaloneHotkeysOff()
                If Not ReaHotkey.FoundPlugin Is Plugin Or WinExist("ahk_class #32768") {
                    PreviousPluginName := False
                    ReaHotkey.TurnPluginTimersOff()
                    ReaHotkey.TurnPluginHotkeysOff()
                    AccessibleMenu.CurrentMenu := False
                }
                Else {
                    CurrentPluginName := ReaHotkey.FoundPlugin.Name
                    If PreviousPluginName = False
                    PreviousPluginName := CurrentPluginName
                    If Not CurrentPluginName = PreviousPluginName {
                        ReaHotkey.TurnPluginTimersOff(PreviousPluginName)
                        ReaHotkey.TurnPluginHotkeysOff(PreviousPluginName)
                        Sleep 250
                    }
                    PreviousPluginName := CurrentPluginName
                    ReaHotkey.TurnPluginTimersOn(ReaHotkey.FoundPlugin.Name)
                    Sleep 250
                    If ReaHotkey.AutoFocusPluginOverlay = True {
                        ReaHotkey.FocusPluginOverlay()
                        ReaHotkey.AutoFocusPluginOverlay := False
                    }
                    ReaHotkey.TurnPluginHotkeysOn(ReaHotkey.FoundPlugin.Name)
                }
            }
            Else If ReaHotkey.StandaloneWinCriteria And WinActive(ReaHotkey.StandaloneWinCriteria) {
                ReaHotkey.Context := "Standalone"
                ReaHotkey.TurnPluginTimersOff()
                ReaHotkey.TurnPluginHotkeysOff()
                If Not ReaHotkey.FoundStandalone Is Standalone Or WinExist("ahk_class #32768") {
                    PreviousStandaloneName := False
                    ReaHotkey.TurnStandaloneTimersOff()
                    ReaHotkey.TurnStandaloneHotkeysOff()
                    AccessibleMenu.CurrentMenu := False
                }
                Else {
                    CurrentStandaloneName := ReaHotkey.FoundStandalone.Name
                    If PreviousStandaloneName = False
                    PreviousStandaloneName := CurrentStandaloneName
                    If Not CurrentStandaloneName = PreviousStandaloneName {
                        ReaHotkey.TurnStandaloneTimersOff(PreviousStandaloneName)
                        ReaHotkey.TurnStandaloneHotkeysOff(PreviousStandaloneName)
                        Sleep 250
                    }
                    PreviousStandaloneName := CurrentStandaloneName
                    ReaHotkey.TurnStandaloneTimersOn(ReaHotkey.FoundStandalone.Name)
                    Sleep 250
                    If ReaHotkey.AutoFocusStandaloneOverlay = True {
                        ReaHotkey.FocusStandaloneOverlay()
                        ReaHotkey.AutoFocusStandaloneOverlay := False
                    }
                    ReaHotkey.TurnStandaloneHotkeysOn(ReaHotkey.FoundStandalone.Name)
                }
            }
            Else {
                ReaHotkey.Context := False
                PreviousPluginName := False
                ReaHotkey.TurnPluginTimersOff()
                ReaHotkey.TurnPluginHotkeysOff()
                PreviousStandaloneName := False
                ReaHotkey.TurnStandaloneTimersOff()
                ReaHotkey.TurnStandaloneHotkeysOff()
                AccessibleMenu.CurrentMenu := False
            }
        }
    }
    
    #Include <Update>
    
}
