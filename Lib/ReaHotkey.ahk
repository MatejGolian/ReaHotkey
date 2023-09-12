#Requires AutoHotkey v2.0

Class ReaHotkey {
    
    Static AutoFocusPluginOverlay := True
    Static AutoFocusStandaloneOverlay := True
    Static FoundPlugin := False
    Static FoundStandalone := False
    Static PluginWinCriteria := "ahk_exe reaper.exe ahk_class #32770"
    Static StandaloneWinCriteria := False
    
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
        If ReaHotkey.FoundPlugin Is Plugin
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
        If ReaHotkey.FoundStandalone Is Standalone {
            ReaHotkey.Wait(500)
            If ReaHotkey.FoundStandalone Is Standalone
            ReaHotkey.FoundStandalone.Overlay.Focus()
        }
    }
    
    Static GetPluginControl() {
        If WinActive(ReaHotkey.PluginWinCriteria) {
            Controls := WinGetControls(ReaHotkey.PluginWinCriteria)
            For PluginEntry In Plugin.List {
                If PluginEntry["ControlClasses"] Is Array And PluginEntry["ControlClasses"].Length > 0
                For Control In Controls
                For ControlClass In PluginEntry["ControlClasses"]
                If RegExMatch(Control, ControlClass)
                Return Control
            }
        }
        Return False
    }
    
    Static TurnHotkeysOff() {
        If WinActive(ReaHotkey.PluginWinCriteria)
        HotIfWinActive(ReaHotkey.PluginWinCriteria)
        Else
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
        HotIfWinActive(ReaHotkey.PluginWinCriteria)
        For PluginEntry In Plugin.GetList()
        For DefinedHotkey In PluginEntry["Hotkeys"]
        If DefinedHotkey["Action"] != "Off" {
            Hotkey DefinedHotkey["KeyName"], DefinedHotkey["Action"], DefinedHotkey["Options"]
            Hotkey DefinedHotkey["KeyName"], "Off"
        }
        HotIf
        For ProgramEntry In Standalone.GetList()
        For DefinedHotkey In ProgramEntry["Hotkeys"]
        If DefinedHotkey["Action"] != "Off" {
            Hotkey DefinedHotkey["KeyName"], DefinedHotkey["Action"], DefinedHotkey["Options"]
            Hotkey DefinedHotkey["KeyName"], "Off"
        }
        If WinActive(ReaHotkey.PluginWinCriteria)
        HotIfWinActive(ReaHotkey.PluginWinCriteria)
        Else
        HotIf
    }
    
    Static TurnHotkeysOn() {
        If WinActive(ReaHotkey.PluginWinCriteria)
        HotIfWinActive(ReaHotkey.PluginWinCriteria)
        Else
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
        If ReaHotkey.FoundPlugin Is Plugin {
            HotIfWinActive(ReaHotkey.PluginWinCriteria)
            For DefinedHotkey In ReaHotkey.FoundPlugin.GetHotkeys()
            If DefinedHotkey["Action"] != "Off" {
                Hotkey DefinedHotkey["KeyName"], DefinedHotkey["Action"], DefinedHotkey["Options"]
                Hotkey DefinedHotkey["KeyName"], "On"
            }
        }
        If ReaHotkey.FoundStandalone Is Standalone {
            HotIf
            For DefinedHotkey In ReaHotkey.FoundStandalone.GetHotkeys()
            If DefinedHotkey["Action"] != "Off" {
                Hotkey DefinedHotkey["KeyName"], DefinedHotkey["Action"], DefinedHotkey["Options"]
                Hotkey DefinedHotkey["KeyName"], "On"
            }
        }
        If WinActive(ReaHotkey.PluginWinCriteria)
        HotIfWinActive(ReaHotkey.PluginWinCriteria)
        Else
        HotIf
    }
    
    Static TurnPluginTimersOff(Name := "") {
        If Name = "" {
            PluginList := Plugin.GetList()
            For PluginEntry In PluginList
            For Timer In PluginEntry["Timers"]
            If Timer["Enabled"] = True {
                Timer["Enabled"] := False
                SetTimer Timer["Function"], 0
            }
        }
        Else {
            For Timer In Plugin.GetTimers(Name)
            If Timer["Enabled"] = True {
                Timer["Enabled"] := False
                SetTimer Timer["Function"], 0
            }
        }
    }
    
    Static TurnPluginTimersOn(Name := "") {
        If Name = "" {
            PluginList := Plugin.GetList()
            For PluginEntry In PluginList
            For Timer In PluginEntry["Timers"]
            If Timer["Enabled"] = False {
                Timer["Enabled"] := True
                SetTimer Timer["Function"], Timer["Period"], Timer["Priority"]
            }
        }
        Else {
            For Timer In Plugin.GetTimers(Name)
            If Timer["Enabled"] = False {
                Timer["Enabled"] := True
                SetTimer Timer["Function"], Timer["Period"], Timer["Priority"]
            }
        }
    }
    
    Static TurnStandaloneTimersOff(Name := "") {
        If Name = "" {
            StandaloneList := Standalone.GetList()
            For StandaloneEntry In StandaloneList
            For Timer In StandaloneEntry["Timers"]
            If Timer["Enabled"] = True {
                Timer["Enabled"] := False
                SetTimer Timer["Function"], 0
            }
        }
        Else {
            For Timer In Standalone.GetTimers(Name)
            If Timer["Enabled"] = True {
                Timer["Enabled"] := False
                SetTimer Timer["Function"], 0
            }
        }
    }
    
    Static TurnStandaloneTimersOn(Name := "") {
        If Name = "" {
            StandaloneList := Standalone.GetList()
            For StandaloneEntry In StandaloneList
            For Timer In StandaloneEntry["Timers"]
            If Timer["Enabled"] = False {
                Timer["Enabled"] := True
                SetTimer Timer["Function"], Timer["Period"], Timer["Priority"]
            }
        }
        Else {
            For Timer In Standalone.GetTimers(Name)
            If Timer["Enabled"] = False {
                Timer["Enabled"] := True
                SetTimer Timer["Function"], Timer["Period"], Timer["Priority"]
            }
        }
    }
    
    Class Close {
        
        Static Call(*) {
            ExitApp
        }
        
    }
    
    Class ManageState {
        
        Static Call() {
            Try
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
                Else If !Plugin.FindClass(ControlGetClassNN(ControlGetFocus(ReaHotkey.PluginWinCriteria))) {
                    ReaHotkey.AutoFocusPluginOverlay := True
                    ReaHotkey.FoundPlugin := False
                }
                Else {
                    ReaHotkey.FoundPlugin := Plugin.GetByClass(ControlGetClassNN(ReaHotkey.GetPluginControl()))
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
            If WinActive(ReaHotkey.PluginWinCriteria) {
                ReaHotkey.TurnStandaloneTimersOff()
                If Not ReaHotkey.FoundPlugin Is Plugin Or WinExist("ahk_class #32768") {
                    ReaHotkey.TurnPluginTimersOff()
                    ReaHotkey.TurnHotkeysOff()
                }
                Else {
                    ReaHotkey.TurnPluginTimersOn(ReaHotkey.FoundPlugin.Name)
                    If ReaHotkey.AutoFocusPluginOverlay = True {
                        ReaHotkey.FocusPluginOverlay()
                        ReaHotkey.AutoFocusPluginOverlay := False
                    }
                    ReaHotkey.TurnHotkeysOn()
                }
            }
            Else If ReaHotkey.StandaloneWinCriteria != False And WinActive(ReaHotkey.StandaloneWinCriteria) {
                ReaHotkey.TurnPluginTimersOff()
                If Not ReaHotkey.FoundStandalone Is Standalone Or WinExist("ahk_class #32768") {
                    ReaHotkey.TurnStandaloneTimersOff()
                }
                Else {
                    ReaHotkey.TurnStandaloneTimersOn(ReaHotkey.FoundStandalone.Name)
                    If ReaHotkey.AutoFocusStandaloneOverlay = True {
                        ReaHotkey.FocusStandaloneOverlay()
                        ReaHotkey.AutoFocusStandaloneOverlay := False
                    }
                    ReaHotkey.TurnHotkeysOn()
                }
            }
            Else {
                ReaHotkey.TurnPluginTimersOff()
                ReaHotkey.TurnStandaloneTimersOff()
                HotIfWinActive(ReaHotkey.PluginWinCriteria)
                ReaHotkey.TurnHotkeysOff()
                HotIf
                ReaHotkey.TurnHotkeysOff()
            }
        }
        
    }
    
    Class TogglePause {
        
        Static Call(*) {
            A_TrayMenu.ToggleCheck("&Pause")
            Suspend -1
            If A_IsSuspended = 1 {
                SetTimer ReaHotkey.ManageState, 0
                HotIfWinActive(ReaHotkey.PluginWinCriteria)
                ReaHotkey.TurnPluginTimersOff()
                ReaHotkey.TurnHotkeysOff()
                HotIf
                ReaHotkey.TurnStandaloneTimersOff()
                ReaHotkey.TurnHotkeysOff()
            }
            Else {
                SetTimer ReaHotkey.ManageState, 100
            }
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
