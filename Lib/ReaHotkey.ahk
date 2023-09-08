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
                SuperordinateControl := AccessibilityOverlay.GetControl(CurrentControl.SuperordinateControlID)
                Loop AccessibilityOverlay.TotalNumberOfControls {
                    If SuperordinateControl == 0
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
                    SuperordinateControl := AccessibilityOverlay.GetControl(SuperordinateControl.SuperordinateControlID)
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
            Else If ReaHotkey.FoundPlugin.Overlay.Label == ""
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
                SuperordinateControl := AccessibilityOverlay.GetControl(CurrentControl.SuperordinateControlID)
                Loop AccessibilityOverlay.TotalNumberOfControls {
                    If SuperordinateControl == 0
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
                    SuperordinateControl := AccessibilityOverlay.GetControl(SuperordinateControl.SuperordinateControlID)
                }
            }
        }
    }
    
    Static FocusStandaloneOverlay() {
        If ReaHotkey.FoundStandalone Is Standalone {
            Sleep 500
            If ReaHotkey.FoundStandalone Is Standalone
            ReaHotkey.FoundStandalone.Overlay.Focus()
        }
    }
    
    Static GetPluginControl() {
        If WinActive(ReaHotkey.PluginWinCriteria) {
            Controls := WinGetControls(ReaHotkey.PluginWinCriteria)
            For PluginEntry In Plugin.List {
                If PluginEntry["ControlClasses"] Is Array And PluginEntry["ControlClasses"].Length > 0
                For ControlClass In PluginEntry["ControlClasses"]
                For Control In Controls
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
        Hotkey "~Right", "Off"
        Hotkey "~Left", "Off"
        Hotkey "~Up", "Off"
        Hotkey "~Down", "Off"
        Hotkey "~Enter", "Off"
        Hotkey "~Space", "Off"
        Hotkey "~Ctrl", "Off"
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
        Hotkey "~Left", "On"
        Hotkey "~Right", "On"
        Hotkey "~Up", "On"
        Hotkey "~Down", "On"
        Hotkey "~Enter", "On"
        Hotkey "~Space", "On"
        Hotkey "~Ctrl", "On"
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
        If Name == "" {
            PluginList := Plugin.GetList()
            For PluginEntry In PluginList
            For Timer In PluginEntry["Timers"]
            If Timer["Enabled"] == True {
                Timer["Enabled"] := False
                SetTimer Timer["Function"], 0
            }
        }
        Else {
            For Timer In Plugin.GetTimers(Name)
            If Timer["Enabled"] == True {
                Timer["Enabled"] := False
                SetTimer Timer["Function"], 0
            }
        }
    }
    
    Static TurnPluginTimersOn(Name := "") {
        If Name == "" {
            PluginList := Plugin.GetList()
            For PluginEntry In PluginList
            For Timer In PluginEntry["Timers"]
            If Timer["Enabled"] == False {
                Timer["Enabled"] := True
                SetTimer Timer["Function"], Timer["Period"], Timer["Priority"]
            }
        }
        Else {
            For Timer In Plugin.GetTimers(Name)
            If Timer["Enabled"] == False {
                Timer["Enabled"] := True
                SetTimer Timer["Function"], Timer["Period"], Timer["Priority"]
            }
        }
    }
    
    Static TurnStandaloneTimersOff(Name := "") {
        If Name == "" {
            StandaloneList := Standalone.GetList()
            For StandaloneEntry In StandaloneList
            For Timer In StandaloneEntry["Timers"]
            If Timer["Enabled"] == True {
                Timer["Enabled"] := False
                SetTimer Timer["Function"], 0
            }
        }
        Else {
            For Timer In Standalone.GetTimers(Name)
            If Timer["Enabled"] == True {
                Timer["Enabled"] := False
                SetTimer Timer["Function"], 0
            }
        }
    }
    
    Static TurnStandaloneTimersOn(Name := "") {
        If Name == "" {
            StandaloneList := Standalone.GetList()
            For StandaloneEntry In StandaloneList
            For Timer In StandaloneEntry["Timers"]
            If Timer["Enabled"] == False {
                Timer["Enabled"] := True
                SetTimer Timer["Function"], Timer["Period"], Timer["Priority"]
            }
        }
        Else {
            For Timer In Standalone.GetTimers(Name)
            If Timer["Enabled"] == False {
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
    
    Class ManageInput {
        
        Static Call() {
            If WinActive(ReaHotkey.PluginWinCriteria)
            HotIfWinActive(ReaHotkey.PluginWinCriteria)
            Else
            HotIf
            Try {
                If WinActive(ReaHotkey.PluginWinCriteria)
                If WinExist("ahk_class #32768") {
                    ReaHotkey.TurnHotkeysOff()
                    Return False
                }
                Else If ControlGetFocus(ReaHotkey.PluginWinCriteria) == 0 {
                    ReaHotkey.TurnHotkeysOff()
                    Return False
                }
                Else If Plugin.FindClass(ControlGetClassNN(ControlGetFocus(ReaHotkey.PluginWinCriteria))) == 0 {
                    ReaHotkey.TurnHotkeysOff()
                    Return False
                }
                Else {
                    If ReaHotkey.FoundPlugin Is Plugin {
                        If ReaHotkey.AutoFocusPluginOverlay == True {
                            ReaHotkey.FocusPluginOverlay()
                            ReaHotkey.AutoFocusPluginOverlay := False
                        }
                        ReaHotkey.TurnHotkeysOn()
                        If ReaHotkey.FoundPlugin Is Plugin
                        For DefinedHotkey In ReaHotkey.FoundPlugin.GetHotkeys()
                        If DefinedHotkey["Action"] != "Off" {
                            Hotkey DefinedHotkey["KeyName"], DefinedHotkey["Action"], DefinedHotkey["Options"]
                            Hotkey DefinedHotkey["KeyName"], "On"
                        }
                        Return True
                    }
                    ReaHotkey.TurnHotkeysOff()
                    Return False
                }
                Else
                If WinExist("ahk_class #32768") {
                    ReaHotkey.TurnHotkeysOff()
                    Return False
                }
                Else {
                    If ReaHotkey.FoundStandalone Is Standalone And ReaHotkey.StandaloneWinCriteria != False
                    If WinActive(ReaHotkey.StandaloneWinCriteria) {
                        If ReaHotkey.AutoFocusStandaloneOverlay == True {
                            ReaHotkey.FocusStandaloneOverlay()
                            ReaHotkey.AutoFocusStandaloneOverlay := False
                        }
                        ReaHotkey.TurnHotkeysOn()
                        If ReaHotkey.FoundStandalone Is Standalone
                        For DefinedHotkey In ReaHotkey.FoundStandalone.GetHotkeys()
                        If DefinedHotkey["Action"] != "Off" {
                            Hotkey DefinedHotkey["KeyName"], DefinedHotkey["Action"], DefinedHotkey["Options"]
                            Hotkey DefinedHotkey["KeyName"], "On"
                        }
                        Return True
                    }
                    ReaHotkey.TurnHotkeysOff()
                    Return False
                }
            }
            Catch {
                Return False
            }
        }
        
    }
    
    Class ManageTimers {
        
        Static Call() {
            Try {
                If WinActive(ReaHotkey.PluginWinCriteria) {
                    ReaHotkey.TurnStandaloneTimersOff()
                    If WinExist("ahk_class #32768") {
                        ReaHotkey.TurnPluginTimersOff()
                        Return False
                    }
                    Else If ControlGetFocus(ReaHotkey.PluginWinCriteria) == 0 {
                        ReaHotkey.TurnPluginTimersOff()
                        Return False
                    }
                    Else If Plugin.FindClass(ControlGetClassNN(ControlGetFocus(ReaHotkey.PluginWinCriteria))) == 0 {
                        ReaHotkey.TurnPluginTimersOff()
                        Return False
                    }
                    Else If ReaHotkey.FoundPlugin == False {
                        ReaHotkey.TurnPluginTimersOff()
                        Return False
                    }
                    Else {
                        ReaHotkey.TurnPluginTimersOn(ReaHotkey.FoundPlugin.Name)
                        Return True
                    }
                }
                Else {
                    ReaHotkey.TurnPluginTimersOff()
                    If WinExist("ahk_class #32768") {
                        ReaHotkey.TurnStandaloneTimersOff()
                        Return False
                    }
                    Else If ReaHotkey.FoundStandalone == False {
                        ReaHotkey.TurnStandaloneTimersOff()
                        Return False
                    }
                    Else {
                        ReaHotkey.TurnStandaloneTimersOn(ReaHotkey.FoundStandalone.Name)
                        Return True
                    }
                }
                Return False
            }
            Catch {
                Return False
            }
        }
        
    }
    
    Class TogglePause {
        
        Static Call(*) {
            A_TrayMenu.ToggleCheck("&Pause")
            Suspend -1
            If A_IsSuspended == 1 {
                SetTimer ReaHotkey.UpdateState, 0
                SetTimer ReaHotkey.ManageTimers, 0
                SetTimer ReaHotkey.ManageInput, 0
                HotIfWinActive(ReaHotkey.PluginWinCriteria)
                ReaHotkey.TurnHotkeysOff()
                ReaHotkey.TurnPluginTimersOff()
                HotIf
                ReaHotkey.TurnHotkeysOff()
                ReaHotkey.TurnStandaloneTimersOff()
            }
            Else {
                SetTimer ReaHotkey.UpdateState, 100
                SetTimer ReaHotkey.ManageTimers, 100
                SetTimer ReaHotkey.ManageInput, 100
            }
        }
        
    }
    
    Class UpdateState {
        
        Static Call() {
            Try {
                If WinActive(ReaHotkey.PluginWinCriteria) {
                    ReaHotkey.AutoFocusStandaloneOverlay := True
                    ReaHotkey.FoundStandalone := False
                    ReaHotkey.StandaloneWinCriteria := False
                    If !ReaHotkey.GetPluginControl() {
                        ReaHotkey.AutoFocusPluginOverlay := True
                        ReaHotkey.FoundPlugin := False
                    }
                    Else {
                        ReaHotkey.FoundPlugin := Plugin.GetByClass(ControlGetClassNN(ReaHotkey.GetPluginControl()))
                        Return True
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
                        Return True
                    }
                    ReaHotkey.AutoFocusStandaloneOverlay := True
                }
                Return False
            }
            Catch {
                Return False
            }
        }
        
    }
    
}
