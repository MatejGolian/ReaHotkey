#Requires AutoHotkey v2.0

Class ReaHotkey {
    
    Static AutoFocusPluginOverlay := True
    Static AutoFocusStandaloneOverlay := True
    Static Context := False
    Static FoundPlugin := False
    Static FoundStandalone := False
    Static PluginHotkeyOverrides := Array()
    Static PluginWinCriteria := "ahk_exe reaper.exe ahk_class #32770"
    Static RequiredScreenWidth := 1920
    Static RequiredScreenHeight := 1080
    Static StandaloneHotkeyOverrides := Array()
    Static StandaloneWinCriteria := False
    
    Static __New() {
        OnError ReaHotkey.HandleError
        ReaHotkey.TurnPluginHotkeysOff()
        ReaHotkey.TurnStandaloneHotkeysOff()
        ReaHotkey.InitConfig()
        If IniRead("ReaHotkey.ini", "Config", "CheckScreenResolutionOnStartup", 1) = 1
        ReaHotkey.CheckResolution()
    }
    
    Static CheckResolution() {
        If A_ScreenWidth != ReaHotkey.RequiredScreenWidth And A_ScreenHeight != ReaHotkey.RequiredScreenHeight {
            MsgBox "Your resolution is not set to " . ReaHotkey.RequiredScreenWidth . " × " . ReaHotkey.RequiredScreenHeight . ".`nReaHotkey may not operate properly.", "ReaHotkey"
            Sleep 500
        }
    }
    
    Static FindHotkey(Type, PluginOrProgramName := "", KeyName := "") {
        NameParam := "Name"
        If PluginOrProgramName != "" {
            If Type = "Plugin"
            NameParam := "PluginName"
            If Type = "Standalone"
            NameParam := "ProgramName"
        }
        If KeyName != ""
        For HotkeyNumber, HotkeyParams In ReaHotkey.%Type%HotkeyOverrides
        If HotkeyParams.Has(NameParam) And HotkeyParams[NameParam] = PluginOrProgramName And HotkeyParams["KeyName"] = KeyName
        Return HotkeyNumber
        Return 0
    }
    
    Static FocusNextTab(Overlay) {
        If Overlay Is AccessibilityOverlay And Overlay.ChildControls.Length > 0 {
            CurrentControl := Overlay.GetCurrentControl()
            If CurrentControl Is TabControl
            Overlay.FocusNextTab()
            Else
            If CurrentControl Is Object {
                SuperordinateControl := CurrentControl.GetSuperordinateControl()
                Loop AccessibilityOverlay.TotalNumberOfControls {
                    If SuperordinateControl = 0
                    Break
                    If SuperordinateControl Is TabControl {
                        Overlay.SetCurrentControlID(SuperordinateControl.ControlID)
                        If SuperordinateControl.CurrentTab < SuperordinateControl.Tabs.Length
                        SuperordinateControl.CurrentTab++
                        Else
                        SuperordinateControl.CurrentTab := 1
                        SuperordinateControl.Focus()
                        Break
                    }
                    SuperordinateControl := SuperordinateControl.GetSuperordinateControl()
                }
            }
        }
    }
    
    Static FocusPluginOverlay() {
        If ReaHotkey.FoundPlugin Is Plugin And ReaHotkey.FoundPlugin.NoHotkeys = False
        If ReaHotkey.FoundPlugin.Overlay.ChildControls.Length > 0 And ReaHotkey.FoundPlugin.Overlay.GetFocusableControlIDs().Length > 0 {
            ReaHotkey.FoundPlugin.Overlay.Focus()
        }
        Else {
            If HasProp(ReaHotkey.FoundPlugin.Overlay, "Metadata") And ReaHotkey.FoundPlugin.Overlay.Metadata.Has("Product") And ReaHotkey.FoundPlugin.Overlay.Metadata["Product"] != ""
            AccessibilityOverlay.Speak(ReaHotkey.FoundPlugin.Overlay.Metadata["Product"] . " overlay active")
            Else If ReaHotkey.FoundPlugin.Overlay.Label = ""
            AccessibilityOverlay.Speak(ReaHotkey.FoundPlugin.Name . " overlay active")
            Else
            AccessibilityOverlay.Speak(ReaHotkey.FoundPlugin.Overlay.Label . " overlay active")
        }
    }
    
    Static FocusPreviousTab(Overlay) {
        If Overlay Is AccessibilityOverlay And Overlay.ChildControls.Length > 0 {
            CurrentControl := Overlay.GetCurrentControl()
            If CurrentControl Is TabControl
            Overlay.FocusPreviousTab()
            Else
            If CurrentControl Is Object {
                SuperordinateControl := CurrentControl.GetSuperordinateControl()
                Loop AccessibilityOverlay.TotalNumberOfControls {
                    If SuperordinateControl = 0
                    Break
                    If SuperordinateControl Is TabControl {
                        Overlay.SetCurrentControlID(SuperordinateControl.ControlID)
                        If SuperordinateControl.CurrentTab <= 1
                        SuperordinateControl.CurrentTab := SuperordinateControl.Tabs.Length
                        Else
                        SuperordinateControl.CurrentTab--
                        SuperordinateControl.Focus()
                        Break
                    }
                    SuperordinateControl := SuperordinateControl.GetSuperordinateControl()
                }
            }
        }
    }
    
    Static FocusStandaloneOverlay() {
        If ReaHotkey.FoundStandalone Is Standalone And ReaHotkey.FoundStandalone.NoHotkeys = False {
            ReaHotkey.Wait(500)
            If ReaHotkey.FoundStandalone Is Standalone
            ReaHotkey.FoundStandalone.Overlay.Focus()
        }
    }
    
    Static GetPluginControl() {
        If WinActive(ReaHotkey.PluginWinCriteria) {
            ReaperControlPatterns := ["^#327701$", "^Button[0-9]+$", "^ComboBox[0-9]+$", "^Edit[0-9]+$", "^REAPERknob[0-9]+$", "^reaperPluginHostWrapProc[0-9]+$", "^Static[0-9]+$", "^SysHeader321$", "^SysListView321$", "^SysTreeView321$"]
            Controls := WinGetControls(ReaHotkey.PluginWinCriteria)
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
    
    Static InitConfig() {
        Value := IniRead("ReaHotkey.ini", "Config", "CheckScreenResolutionOnStartup", 1)
        IniWrite(Value, "ReaHotkey.ini", "Config", "CheckScreenResolutionOnStartup")
        Value := IniRead("ReaHotkey.ini", "Config", "UseImageSearchForEngine2PluginDetection", 1)
        IniWrite(Value, "ReaHotkey.ini", "Config", "UseImageSearchForEngine2PluginDetection")
        Value := IniRead("ReaHotkey.ini", "Config", "AutomaticallyCloseLibrariBrowsersInKontaktAndKKPlugins", 1)
        IniWrite(Value, "ReaHotkey.ini", "Config", "AutomaticallyCloseLibrariBrowsersInKontaktAndKKPlugins")
        Value := IniRead("ReaHotkey.ini", "Config", "AutomaticallyCloseLibrariBrowsersInKontaktAndKKStandalones", 1)
        IniWrite(Value, "ReaHotkey.ini", "Config", "AutomaticallyCloseLibrariBrowsersInKontaktAndKKStandalones")
        Value := IniRead("ReaHotkey.ini", "Config", "AutomaticallyDetectLibrariesInKontaktAndKKPlugins", 1)
        IniWrite(Value, "ReaHotkey.ini", "Config", "AutomaticallyDetectLibrariesInKontaktAndKKPlugins")
    }
    
    Static InPluginControl(ControlToCheck) {
        If WinActive(ReaHotkey.PluginWinCriteria) {
            PluginControl := ReaHotkey.GetPluginControl()
            If PluginControl != False {
                Controls := WinGetControls(ReaHotkey.PluginWinCriteria)
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
                If PluginPosition > 0 And CheckPosition > 0 And PluginPosition <= CheckPosition {
                    ReaperControlPatterns := ["^#327701$", "^Button[0-9]+$", "^ComboBox[0-9]+$", "^Edit[0-9]+$", "^REAPERknob[0-9]+$", "^reaperPluginHostWrapProc[0-9]+$", "^Static[0-9]+$", "^SysHeader321$", "^SysListView321$", "^SysTreeView321$"]
                    For ReaperControlPattern In ReaperControlPatterns
                    If RegExMatch(ControlToCheck, ReaperControlPattern)
                    Return False
                    Return True
                }
            }
        }
        Return False
    }
    
    Static OverrideHotkey(Type, PluginOrProgramName := "", KeyName := "", Action := "", Options := "") {
        If Type = "Plugin" Or Type = "Standalone" {
            NameParam := "Name"
            If PluginOrProgramName != "" {
                If Type = "Plugin"
                NameParam := "PluginName"
                If Type = "Standalone"
                NameParam := "ProgramName"
            }
            HotkeyNumber := ReaHotkey.FindHotkey(Type, PluginOrProgramName, KeyName)
            If HotkeyNumber = 0 {
                If Not Action Is Object
                Options := Action . " " . Options
                GetOptions()
                If Not Action Is Object
                Action := ReaHotkey.TriggerOverrideHotkey
                ReaHotkey.%Type%HotkeyOverrides.Push(Map(NameParam, PluginOrProgramName, "KeyName", KeyName, "Action", Action, "Options", Options.String, "State", Options.OnOff))
            }
            Else {
                If HotkeyNumber > 0 {
                    CurrentAction := ReaHotkey.%Type%HotkeyOverrides[HotkeyNumber]["Action"]
                    CurrentOptions := ReaHotkey.%Type%HotkeyOverrides[HotkeyNumber]["Options"]
                    If Not Action Is Object
                    Options := Action . " " . Options
                    Options := Options . " " . CurrentOptions
                    GetOptions()
                    If Not Action Is Object
                    Action := CurrentAction
                    ReaHotkey.%Type%HotkeyOverrides[HotkeyNumber]["Action"] := Action
                    ReaHotkey.%Type%HotkeyOverrides[HotkeyNumber]["Options"] := Options.String
                    ReaHotkey.%Type%HotkeyOverrides[HotkeyNumber]["State"] := Options.OnOff
                }
            }
            If Type = "Plugin"
            HotIfWinActive(ReaHotkey.PluginWinCriteria)
            If Type = "Standalone"
            HotIf
            If PluginOrProgramName = "" And ReaHotkey.Found%Type% Is %Type%
            Hotkey KeyName, Action, Options.String
            Else
            If ReaHotkey.Found%Type% Is %Type% And ReaHotkey.Found%Type%.Name = PluginOrProgramName
            Hotkey KeyName, Action, Options.String
            If WinActive(ReaHotkey.PluginWinCriteria)
            HotIfWinActive(ReaHotkey.PluginWinCriteria)
            Else
            HotIf
        }
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
            If OnOff != "On" And OnOff != "Off"
            OnOff := "On"
            Options := {OnOff: OnOff, B: B, P: P, S: S, T: T, I: I, String: Trim(OnOff . " " . B . " " . P . " " . S . " " . T . " " . I)}
        }
    }
    
    Static OverridePluginHotkey(PluginName, KeyName, Action := "", Options := "") {
        ReaHotkey.OverrideHotkey("Plugin", PluginName, KeyName, Action, Options)
    }
    
    Static OverrideStandaloneHotkey(ProgramName, KeyName, Action := "", Options := "") {
        ReaHotkey.OverrideHotkey("Standalone", ProgramName, KeyName, Action, Options)
    }
    
    Static TurnHotkeysOff(Type, Name := "") {
        If Type = "Plugin" Or Type = "Standalone" {
            If Type = "Plugin"
            HotIfWinActive(ReaHotkey.PluginWinCriteria)
            If Type = "Standalone"
            HotIf
            Hotkey "Tab", "Off"
            Hotkey "+Tab", "Off"
            Hotkey "^Tab", "Off"
            Hotkey "^+Tab", "Off"
            Hotkey "Right", "Off"
            Hotkey "Left", "Off"
            Hotkey "Up", "Off"
            Hotkey "Down", "Off"
            Hotkey "Enter", "Off"
            Hotkey "Space", "Off"
            Hotkey "Ctrl", "Off"
            If Name = "" {
                For HotkeyEntry In %Type%.GetList()
                For DefinedHotkey In HotkeyEntry["Hotkeys"]
                If DefinedHotkey["State"] != "Off"
                Hotkey DefinedHotkey["KeyName"], DefinedHotkey["Action"], "Off"
            }
            Else {
                For DefinedHotkey In %Type%.GetHotkeys(Name)
                If DefinedHotkey["State"] != "Off"
                Hotkey DefinedHotkey["KeyName"], DefinedHotkey["Action"], "Off"
            }
            If WinActive(ReaHotkey.PluginWinCriteria)
            HotIfWinActive(ReaHotkey.PluginWinCriteria)
            Else
            HotIf
        }
        If Type = "Plugin" Or Type = "Standalone" {
            NameParam := "Name"
            If Type = "Plugin"
            NameParam := "PluginName"
            If Type = "Standalone"
            NameParam := "ProgramName"
            If Type = "Plugin"
            HotIfWinActive(ReaHotkey.PluginWinCriteria)
            If Type = "Standalone"
            HotIf
            For DefinedHotkey In ReaHotkey.%Type%HotkeyOverrides
            If DefinedHotkey.Has("Name") And DefinedHotkey["Name"] = "" And DefinedHotkey["State"] != "Off"
            Hotkey DefinedHotkey["KeyName"], DefinedHotkey["Action"], "Off"
            If Name != "" {
                For DefinedHotkey In ReaHotkey.%Type%HotkeyOverrides
                If DefinedHotkey.Has(NameParam) And DefinedHotkey[NameParam] = Name And DefinedHotkey["State"] != "Off"
                Hotkey DefinedHotkey["KeyName"], DefinedHotkey["Action"], "Off"
            }
            If WinActive(ReaHotkey.PluginWinCriteria)
            HotIfWinActive(ReaHotkey.PluginWinCriteria)
            Else
            HotIf
        }
    }
    
    Static TurnHotkeysOn(Type, Name := "") {
        If Type = "Plugin" Or Type = "Standalone"
        If ReaHotkey.Found%Type% Is %Type% And ReaHotkey.Found%Type%.NoHotkeys = False {
            If Type = "Plugin"
            HotIfWinActive(ReaHotkey.PluginWinCriteria)
            If Type = "Standalone"
            HotIf
            Hotkey "Tab", "On"
            Hotkey "+Tab", "On"
            Hotkey "^Tab", "On"
            Hotkey "^+Tab", "On"
            Hotkey "Left", "On"
            Hotkey "Right", "On"
            Hotkey "Up", "On"
            Hotkey "Down", "On"
            Hotkey "Enter", "On"
            Hotkey "Space", "On"
            Hotkey "Ctrl", "On"
            If Name = "" {
                If ReaHotkey.Found%Type% Is %Type% {
                    For DefinedHotkey In ReaHotkey.Found%Type%.GetHotkeys()
                    If DefinedHotkey["State"] != "Off"
                    Hotkey DefinedHotkey["KeyName"], DefinedHotkey["Action"], DefinedHotkey["Options"]
                }
            }
            Else {
                For DefinedHotkey In %Type%.GetHotkeys(Name)
                If DefinedHotkey["State"] != "Off"
                Hotkey DefinedHotkey["KeyName"], DefinedHotkey["Action"], DefinedHotkey["Options"]
            }
            If WinActive(ReaHotkey.PluginWinCriteria)
            HotIfWinActive(ReaHotkey.PluginWinCriteria)
            Else
            HotIf
        }
        If Type = "Plugin" Or Type = "Standalone" {
            NameParam := "Name"
            If Type = "Plugin"
            NameParam := "PluginName"
            If Type = "Standalone"
            NameParam := "ProgramName"
            If Type = "Plugin"
            HotIfWinActive(ReaHotkey.PluginWinCriteria)
            If Type = "Standalone"
            HotIf
            For DefinedHotkey In ReaHotkey.%Type%HotkeyOverrides
            If DefinedHotkey.Has("Name") And DefinedHotkey["Name"] = "" And DefinedHotkey["State"] != "Off"
            Hotkey DefinedHotkey["KeyName"], DefinedHotkey["Action"], DefinedHotkey["Options"]
            If Name != "" {
                For DefinedHotkey In ReaHotkey.%Type%HotkeyOverrides
                If DefinedHotkey.Has(NameParam) And DefinedHotkey[NameParam] = Name And DefinedHotkey["State"] != "Off"
                Hotkey DefinedHotkey["KeyName"], DefinedHotkey["Action"], DefinedHotkey["Options"]
            }
            If WinActive(ReaHotkey.PluginWinCriteria)
            HotIfWinActive(ReaHotkey.PluginWinCriteria)
            Else
            HotIf
        }
    }
    
    Static TurnPluginHotkeysOff(Name := "") {
        ReaHotkey.TurnHotkeysOff("Plugin", Name)
    }
    
    Static TurnPluginHotkeysOn(Name := "") {
        ReaHotkey.TurnHotkeysOn("Plugin", Name)
    }
    
    Static TurnPluginTimersOff(Name := "") {
        ReaHotkey.TurnTimersOff("Plugin", Name)
    }
    
    Static TurnPluginTimersOn(Name := "") {
        ReaHotkey.TurnTimersOn("Plugin", Name)
    }
    
    Static TurnStandaloneHotkeysOff(Name := "") {
        ReaHotkey.TurnHotkeysOff("Standalone", Name)
    }
    
    Static TurnStandaloneHotkeysOn(Name := "") {
        ReaHotkey.TurnHotkeysOn("Standalone", Name)
    }
    
    Static TurnStandaloneTimersOff(Name := "") {
        ReaHotkey.TurnTimersOff("Standalone", Name)
    }
    
    Static TurnStandaloneTimersOn(Name := "") {
        ReaHotkey.TurnTimersOn("Standalone", Name)
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
    
    Class HandleError {
        Static Call(Exception, Mode) {
            ReaHotkey.TurnPluginHotkeysOff()
            ReaHotkey.TurnStandaloneHotkeysOff()
        }
    }
    
    Class ManageState {
        Static Call() {
            Static CurrentPluginName := False, PreviousPluginName := False, CurrentStandaloneName := False, PreviousStandaloneName := False
            Critical
            Try {
                If WinActive(ReaHotkey.PluginWinCriteria) {
                    ReaHotkey.AutoFocusStandaloneOverlay := True
                    ReaHotkey.FoundStandalone := False
                    ReaHotkey.StandaloneWinCriteria := False
                    If !ReaHotkey.GetPluginControl() {
                        ReaHotkey.AutoFocusPluginOverlay := True
                        ReaHotkey.FoundPlugin := False
                    }
                    Else If !ControlGetFocus(ReaHotkey.PluginWinCriteria) {
                        ReaHotkey.AutoFocusPluginOverlay := True
                        ReaHotkey.FoundPlugin := False
                    }
                    Else If !ReaHotkey.InPluginControl(ControlGetClassNN(ControlGetFocus(ReaHotkey.PluginWinCriteria))) {
                        ReaHotkey.AutoFocusPluginOverlay := True
                        ReaHotkey.FoundPlugin := False
                    }
                    Else {
                        ReaHotkey.FoundPlugin := Plugin.GetByClass(ReaHotkey.GetPluginControl())
                    }
                }
                Else {
                    ReaHotkey.AutoFocusPluginOverlay := True
                    ReaHotkey.FoundPlugin := False
                    ReaHotkey.FoundStandalone := False
                    ReaHotkey.StandaloneWinCriteria := False
                    For Program In Standalone.List
                    For WinCriterion In Program["WinCriteria"]
                    If WinActive(WinCriterion) {
                        ReaHotkey.FoundStandalone := Standalone.GetByWindowID(WinGetID("A"))
                        ReaHotkey.StandaloneWinCriteria := WinCriterion
                        Break 2
                    }
                    If ReaHotkey.FoundStandalone = False
                    ReaHotkey.AutoFocusStandaloneOverlay := True
                }
            }
            Catch {
                ReaHotkey.AutoFocusPluginOverlay := True
                ReaHotkey.FoundPlugin := False
                ReaHotkey.AutoFocusStandaloneOverlay := True
                ReaHotkey.FoundStandalone := False
                ReaHotkey.StandaloneWinCriteria := False
            }
            Critical "Off"
            If WinActive(ReaHotkey.PluginWinCriteria) {
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
                    If CurrentPluginName != PreviousPluginName {
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
            Else If ReaHotkey.StandaloneWinCriteria != False And WinActive(ReaHotkey.StandaloneWinCriteria) {
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
                    If CurrentStandaloneName != PreviousStandaloneName {
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
    
    Class Quit {
        Static Call(*) {
            ExitApp
        }
    }
    
    Class Reload {
        Static Call(*) {
            Reload()
        }
    }
    
    Class ShowAboutBox {
        Static Call(*) {
            Static AboutBox := False
            If AboutBox = False {
                AboutBox := Gui(, "About ReaHotkey")
                AboutBox.Add("Edit", "ReadOnly", "Version " . GetVersion())
                AboutBox.Add("Link",, 'ReaHotkey on <a href="https://github.com/MatejGolian/ReaHotkey">GitHub</a>')
                AboutBox.Add("Button", "Default", "OK").OnEvent("Click", CloseAboutBox)
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
    }
    
    Class ShowConfigBox {
        Static Call(*) {
            Static ConfigBox := False, ConfigBoxWinID := ""
            If ConfigBox = False {
                ConfigBox := Gui(, "ReaHotkey Configuration")
                Checked := ""
                If IniRead("ReaHotkey.ini", "Config", "CheckScreenResolutionOnStartup", 1) = 1
                Checked := "Checked"
                ScreenResolutionBox := ConfigBox.AddCheckBox(Checked, "Check screen resolution on startup")
                Checked := ""
                If IniRead("ReaHotkey.ini", "Config", "UseImageSearchForEngine2PluginDetection", 1) = 1
                Checked := "Checked"
                Engine2PluginImageSearchBox := ConfigBox.AddCheckBox("XS " . Checked, "Use image search for Engine 2 plug-in detection")
                Checked := ""
                If IniRead("ReaHotkey.ini", "Config", "AutomaticallyCloseLibrariBrowsersInKontaktAndKKPlugins", 1) = 1
                Checked := "Checked"
                KontaktKKPluginBrowserBox := ConfigBox.AddCheckBox("XS " . Checked, "Automatically close library browsers in Kontakt and Komplete Kontrol plug-ins")
                Checked := ""
                If IniRead("ReaHotkey.ini", "Config", "AutomaticallyCloseLibrariBrowsersInKontaktAndKKStandalones", 1) = 1
                Checked := "Checked"
                KontaktKKStandaloneBrowserBox := ConfigBox.AddCheckBox("XS " . Checked, "Automatically close library browsers in Kontakt and Komplete Kontrol standalone applications")
                Checked := ""
                If IniRead("ReaHotkey.ini", "Config", "AutomaticallyDetectLibrariesInKontaktAndKKPlugins", 1) = 1
                Checked := "Checked"
                KontaktKKPluginLibraryDetectionBox := ConfigBox.AddCheckBox("XS " . Checked, "Automatically detect libraries in Kontakt and Komplete Kontrol plug-ins")
                ConfigBox.AddButton("Section Default", "OK").OnEvent("Click", SaveConfig)
                ConfigBox.AddButton("YS", "Cancel").OnEvent("Click", CloseConfigBox)
                ConfigBox.OnEvent("Close", CloseConfigBox)
                ConfigBox.OnEvent("Escape", CloseConfigBox)
                ConfigBox.Show()
                ConfigBoxWinID := WinGetID("A")
            }
            Else {
                WinActivate(ConfigBoxWinID)
            }
            CloseConfigBox(*) {
                ConfigBox.Destroy()
                ConfigBox := False
                ConfigBoxWinID := ""
            }
            SaveConfig(*) {
                IniWrite(ScreenResolutionBox.Value, "ReaHotkey.ini", "Config", "CheckScreenResolutionOnStartup")
                IniWrite(Engine2PluginImageSearchBox.Value, "ReaHotkey.ini", "Config", "UseImageSearchForEngine2PluginDetection")
                IniWrite(KontaktKKPluginBrowserBox.Value, "ReaHotkey.ini", "Config", "AutomaticallyCloseLibrariBrowsersInKontaktAndKKPlugins")
                IniWrite(KontaktKKStandaloneBrowserBox.Value, "ReaHotkey.ini", "Config", "AutomaticallyCloseLibrariBrowsersInKontaktAndKKStandalones")
                IniWrite(KontaktKKPluginLibraryDetectionBox.Value, "ReaHotkey.ini", "Config", "AutomaticallyDetectLibrariesInKontaktAndKKPlugins")
                CloseConfigBox()
            }
        }
    }
    
    Class TogglePause {
        Static Call(*) {
            A_TrayMenu.ToggleCheck("&Pause")
            Suspend -1
            If A_IsSuspended = 1 {
                SetTimer ReaHotkey.ManageState, 0
                ReaHotkey.TurnPluginTimersOff()
                ReaHotkey.TurnPluginHotkeysOff()
                ReaHotkey.TurnStandaloneTimersOff()
                ReaHotkey.TurnStandaloneHotkeysOff()
                AccessibleMenu.CurrentMenu := False
            }
            Else {
                SetTimer ReaHotkey.ManageState, 100
            }
        }
    }
    
    Class TriggerOverrideHotkey {
        Static Call(ThisHotkey) {
            Match := RegExMatch(ThisHotkey, "[a-zA-Z]")
            If Match > 0 {
                Modifiers := SubStr(ThisHotkey, 1, Match - 1)
                KeyName := SubStr(ThisHotkey, Match)
                If StrLen(KeyName) > 1
                KeyName := "{" . KeyName . "}"
                Hotkey ThisHotkey, "Off"
                Send Modifiers . KeyName
                Hotkey ThisHotkey, "On"
            }
        }
    }
    
    Class ViewReadme {
        Static Call(*) {
            If FileExist("README.html") And Not InStr(FileExist("README.html"), "D")
            Run "README.html"
        }
    }
    
    Class Wait {
        Static Call(Period) {
            If IsInteger(Period) And Period > 0 And Period <= 4294967295 {
                PeriodEnd := A_TickCount + Period
                Loop {
                    If A_TickCount > PeriodEnd
                    Break
                }
            }
        }
    }
    
}
