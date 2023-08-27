#Requires AutoHotkey v2.0

FocusNextTab(Overlay) {
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

FocusPluginOverlay() {
    Global FoundPlugin
    If FoundPlugin Is Plugin
    If FoundPlugin.Overlay.ChildControls.Length > 0 And FoundPlugin.Overlay.GetFocusableControlIDs().Length > 0 {
        FoundPlugin.Overlay.Focus()
    }
    Else {
        If HasProp(FoundPlugin.Overlay, "Metadata") And FoundPlugin.Overlay.Metadata.Has("Product") And FoundPlugin.Overlay.Metadata["Product"] != ""
        AccessibilityOverlay.Speak(FoundPlugin.Overlay.Metadata["Product"] . " overlay active")
        Else If FoundPlugin.Overlay.Label == ""
        AccessibilityOverlay.Speak(FoundPlugin.Name . " overlay active")
        Else
        AccessibilityOverlay.Speak(FoundPlugin.Overlay.Label . " overlay active")
    }
}

FocusPreviousTab(Overlay) {
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

FocusStandaloneOverlay() {
    Global FoundStandalone
    If FoundStandalone Is Standalone {
        Sleep 500
        If FoundStandalone Is Standalone
        FoundStandalone.Overlay.Focus()
    }
}

GetPluginControl() {
    Global PluginWinCriteria
    If WinActive(PluginWinCriteria) {
        Controls := WinGetControls(PluginWinCriteria)
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

ImportOverlays() {
    #Include Overlay.Definitions.ahk
}

ManageInput() {
    Global FoundPlugin, FoundStandalone, PluginWinCriteria, StandaloneWinCriteria
    If WinActive(PluginWinCriteria)
    HotIfWinActive(PluginWinCriteria)
    Else
    HotIf
    Try {
        If WinActive(PluginWinCriteria)
        If WinExist("ahk_class #32768") {
            TurnHotkeysOff()
            Return False
        }
        Else If ControlGetFocus(PluginWinCriteria) == 0 {
            TurnHotkeysOff()
            Hotkey "F6", "On"
            Return False
        }
        Else If Plugin.FindClass(ControlGetClassNN(ControlGetFocus(PluginWinCriteria))) == 0 {
            TurnHotkeysOff()
            Hotkey "F6", "On"
            Return False
        }
        Else {
            If FoundPlugin Is Plugin {
                Plugin.SetTimer(FoundPlugin.Name, FocusPluginOverlay, -1)
                TurnHotkeysOn()
                If FoundPlugin Is Plugin
                For DefinedHotkey In FoundPlugin.GetHotkeys()
                If DefinedHotkey["Action"] != "Off" {
                    Hotkey DefinedHotkey["KeyName"], DefinedHotkey["Action"], DefinedHotkey["Options"]
                    Hotkey DefinedHotkey["KeyName"], "On"
                }
                Return True
            }
            TurnHotkeysOff()
            Hotkey "F6", "On"
            Return False
        }
        Else
        If WinExist("ahk_class #32768") {
            TurnHotkeysOff()
            Return False
        }
        Else {
            If FoundStandalone Is Standalone And StandaloneWinCriteria != False
            If WinActive(StandaloneWinCriteria) {
                Standalone.SetTimer(FoundStandalone.Name, FocusStandaloneOverlay, -1)
                TurnHotkeysOn()
                If FoundStandalone Is Standalone
                For DefinedHotkey In FoundStandalone.GetHotkeys()
                If DefinedHotkey["Action"] != "Off" {
                    Hotkey DefinedHotkey["KeyName"], DefinedHotkey["Action"], DefinedHotkey["Options"]
                    Hotkey DefinedHotkey["KeyName"], "On"
                }
                Return True
            }
            TurnHotkeysOff()
            Return False
        }
    }
    Catch {
        Return False
    }
}

ManageTimers() {
    Global FoundPlugin, FoundStandalone, PluginWinCriteria
    Try {
        If WinActive(PluginWinCriteria) {
            TurnStandaloneTimersOff()
            If WinExist("ahk_class #32768") {
                TurnPluginTimersOff()
                Return False
            }
            Else If ControlGetFocus(PluginWinCriteria) == 0 {
                TurnPluginTimersOff()
                Return False
            }
            Else If Plugin.FindClass(ControlGetClassNN(ControlGetFocus(PluginWinCriteria))) == 0 {
                TurnPluginTimersOff()
                Return False
            }
            Else If FoundPlugin == False {
                TurnPluginTimersOff()
                Return False
            }
            Else {
                TurnPluginTimersOn(FoundPlugin.Name)
                Return True
            }
        }
        Else {
            TurnPluginTimersOff()
            If WinExist("ahk_class #32768") {
                TurnStandaloneTimersOff()
                Return False
            }
            Else If FoundStandalone == False {
                TurnStandaloneTimersOff()
                Return False
            }
            Else {
                TurnStandaloneTimersOn(FoundStandalone.Name)
                Return True
            }
        }
        Return False
    }
    Catch {
        Return False
    }
}

TurnHotkeysOff() {
    Global PluginWinCriteria
    If WinActive(PluginWinCriteria)
    HotIfWinActive(PluginWinCriteria)
    Else
    HotIf
    If WinActive(PluginWinCriteria)
    Hotkey "F6", "Off"
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
    HotIfWinActive(PluginWinCriteria)
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
    If WinActive(PluginWinCriteria)
    HotIfWinActive(PluginWinCriteria)
    Else
    HotIf
}

TurnHotkeysOn() {
    Global FoundPlugin, FoundStandalone, PluginWinCriteria
    If WinActive(PluginWinCriteria)
    HotIfWinActive(PluginWinCriteria)
    Else
    HotIf
    If WinActive(PluginWinCriteria)
    Hotkey "F6", "On"
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
    If FoundPlugin Is Plugin {
        HotIfWinActive(PluginWinCriteria)
        For DefinedHotkey In FoundPlugin.GetHotkeys()
        If DefinedHotkey["Action"] != "Off" {
            Hotkey DefinedHotkey["KeyName"], DefinedHotkey["Action"], DefinedHotkey["Options"]
            Hotkey DefinedHotkey["KeyName"], "On"
        }
    }
    If FoundStandalone Is Standalone {
        HotIf
        For DefinedHotkey In FoundStandalone.GetHotkeys()
        If DefinedHotkey["Action"] != "Off" {
            Hotkey DefinedHotkey["KeyName"], DefinedHotkey["Action"], DefinedHotkey["Options"]
            Hotkey DefinedHotkey["KeyName"], "On"
        }
    }
    If WinActive(PluginWinCriteria)
    HotIfWinActive(PluginWinCriteria)
    Else
    HotIf
}

TurnPluginTimersOff(Name := "") {
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

TurnPluginTimersOn(Name := "") {
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

TurnStandaloneTimersOff(Name := "") {
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

TurnStandaloneTimersOn(Name := "") {
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

UpdateState() {
    Global FoundPlugin, FoundStandalone, PluginWinCriteria, StandaloneWinCriteria
    Try {
        If WinActive(PluginWinCriteria) {
            FoundStandalone := False
            StandaloneWinCriteria := False
            If !GetPluginControl()
            FoundPlugin := False
            Else
            FoundPlugin := Plugin.GetByClass(ControlGetClassNN(GetPluginControl()))
            Return True
        }
        Else {
            FoundPlugin := False
            FoundStandalone := False
            StandaloneWinCriteria := False
            For Program In Standalone.List
            For WinCriterion In Program["WinCriteria"]
            If WinActive(WinCriterion) {
                FoundStandalone := Standalone.GetByWindowID(WinGetID("A"))
                StandaloneWinCriteria := WinCriterion
                Return True
            }
        }
        Return False
    }
    Catch {
        Return False
    }
}
