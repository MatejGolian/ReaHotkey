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
    
    Static TurnHotkeysOff(Type) {
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
            For HotkeyEntry In %Type%.GetList()
            For DefinedHotkey In HotkeyEntry["Hotkeys"]
            If DefinedHotkey["Action"] != "Off" {
                Hotkey DefinedHotkey["KeyName"], DefinedHotkey["Action"], DefinedHotkey["Options"]
                Hotkey DefinedHotkey["KeyName"], "Off"
            }
            If WinActive(ReaHotkey.PluginWinCriteria)
            HotIfWinActive(ReaHotkey.PluginWinCriteria)
            Else
            HotIf
        }
    }
    
    Static TurnHotkeysOn(Type) {
        If Type = "Plugin" Or Type = "Standalone" {
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
            If ReaHotkey.Found%Type% Is %Type% {
                For DefinedHotkey In ReaHotkey.Found%Type%.GetHotkeys()
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
    }
    
    Static TurnPluginHotkeysOff() {
        ReaHotkey.TurnHotkeysOff("Plugin")
    }
    
    Static TurnPluginHotkeysOn() {
        ReaHotkey.TurnHotkeysOn("Plugin")
    }
    
    Static TurnPluginTimersOff(Name := "") {
        ReaHotkey.TurnTimersOff("Plugin", Name)
    }
    
    Static TurnPluginTimersOn(Name := "") {
        ReaHotkey.TurnTimersOn("Plugin", Name)
    }
    
    Static TurnStandaloneHotkeysOff() {
        ReaHotkey.TurnHotkeysOff("Standalone")
    }
    
    Static TurnStandaloneHotkeysOn() {
        ReaHotkey.TurnHotkeysOn("Standalone")
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
    
    Class Close {
        
        Static Call(*) {
            ExitApp
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
                ReaHotkey.TurnStandaloneHotkeysOff()
                If Not ReaHotkey.FoundPlugin Is Plugin Or WinExist("ahk_class #32768") {
                    ReaHotkey.TurnPluginTimersOff()
                    ReaHotkey.TurnPluginHotkeysOff()
                    AccessibleMenu.CurrentMenu := False
                }
                Else {
                    ReaHotkey.TurnPluginTimersOn(ReaHotkey.FoundPlugin.Name)
                    Sleep 250
                    If ReaHotkey.AutoFocusPluginOverlay = True {
                        ReaHotkey.FocusPluginOverlay()
                        ReaHotkey.AutoFocusPluginOverlay := False
                    }
                    ReaHotkey.TurnPluginHotkeysOn()
                }
            }
            Else If ReaHotkey.StandaloneWinCriteria != False And WinActive(ReaHotkey.StandaloneWinCriteria) {
                ReaHotkey.TurnPluginTimersOff()
                ReaHotkey.TurnPluginHotkeysOff()
                If Not ReaHotkey.FoundStandalone Is Standalone Or WinExist("ahk_class #32768") {
                    ReaHotkey.TurnStandaloneTimersOff()
                    ReaHotkey.TurnStandaloneHotkeysOff()
                    AccessibleMenu.CurrentMenu := False
                }
                Else {
                    ReaHotkey.TurnStandaloneTimersOn(ReaHotkey.FoundStandalone.Name)
                    Sleep 250
                    If ReaHotkey.AutoFocusStandaloneOverlay = True {
                        ReaHotkey.FocusStandaloneOverlay()
                        ReaHotkey.AutoFocusStandaloneOverlay := False
                    }
                    ReaHotkey.TurnStandaloneHotkeysOn()
                }
            }
            Else {
                ReaHotkey.TurnPluginTimersOff()
                ReaHotkey.TurnPluginHotkeysOff()
                ReaHotkey.TurnStandaloneTimersOff()
                ReaHotkey.TurnStandaloneHotkeysOff()
                AccessibleMenu.CurrentMenu := False
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
