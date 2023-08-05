#Requires AutoHotkey v2.0

GetPluginControl() {
    Global PluginWinCriteria
    Controls := WinGetControls(PluginWinCriteria)
    For PluginEntry In Plugin.List {
        If PluginEntry["ControlClasses"] Is Array And PluginEntry["ControlClasses"].Length > 0
        For ControlClass In PluginEntry["ControlClasses"]
        For Control In Controls
        If RegExMatch(Control, ControlClass)
        Return Control
    }
    Return False
}

InArray(Needle, Haystack) {
    For FoundIndex, FoundValue In Haystack
    If FoundValue == Needle
    Return FoundIndex
    Return False
}

ImportOverlays() {
    #Include Overlay.Definitions.ahk
}

ManageHotkeys() {
    Critical
    Global FoundPlugin, FoundStandalone, PluginWinCriteria, StandaloneWinCriteria
    If WinActive(PluginWinCriteria)
    HotIfWinActive(PluginWinCriteria)
    Else
    HotIf
    If WinActive(PluginWinCriteria)
    If WinExist("ahk_class #32768") {
        TurnHotkeysOff()
        Return False
    }
    Else If ControlGetFocus(PluginWinCriteria) == 0 {
        TurnHotkeysOffExceptF6()
        Return False
    }
    Else If Plugin.FindClass(ControlGetClassNN(ControlGetFocus(PluginWinCriteria))) == 0 {
        TurnHotkeysOffExceptF6()
        Return False
    }
    Else {
        Hotkey "F6", "On"
        Hotkey "Tab", "On"
        Hotkey "+Tab", "On"
        Hotkey "^Tab", "On"
        Hotkey "^+Tab", "On"
        Hotkey "Ctrl", "On"
        Hotkey "^R", "On"
        If FoundPlugin Is Plugin And FoundPlugin.Overlay.GetCurrentControl() Is Object And FoundPlugin.Overlay.GetCurrentControl().ControlType == "Edit" {
            Hotkey "Right", "Off"
            Hotkey "Left", "Off"
            Hotkey "Enter", "Off"
            Hotkey "Space", "Off"
        }
        Else {
            Hotkey "Right", "On"
            Hotkey "Left", "On"
            Hotkey "Enter", "On"
            Hotkey "Space", "On"
        }
        Return True
    }
    Else
    If WinExist("ahk_class #32768") {
        TurnHotkeysOff()
        Return False
    }
    Else {
        For Program In Standalone.List
        For WinCriterion In Program["WinCriteria"]
        If WinActive(WinCriterion) {
            StandaloneWinCriteria := WinCriterion
            Hotkey "Tab", "On"
            Hotkey "+Tab", "On"
            Hotkey "^Tab", "On"
            Hotkey "^+Tab", "On"
            Hotkey "Ctrl", "On"
            Hotkey "^R", "On"
            If FoundStandalone Is Standalone And FoundStandalone.Overlay.GetCurrentControl() Is Object And FoundStandalone.Overlay.GetCurrentControl().ControlType == "Edit" {
                Hotkey "Right", "Off"
                Hotkey "Left", "Off"
                Hotkey "Enter", "Off"
                Hotkey "Space", "Off"
            }
            Else {
                Hotkey "Right", "On"
                Hotkey "Left", "On"
                Hotkey "Enter", "On"
                Hotkey "Space", "On"
            }
            Return True
        }
        TurnHotkeysOff()
        Return False
    }
}

ManageTimers() {
    Critical
    Global PluginWinCriteria
    Local FoundPlugin, FoundStandalone, StandaloneWinCriteria
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
        Else {
            FoundPlugin := Plugin.GetByClass(ControlGetClassNN(ControlGetFocus(PluginWinCriteria)))
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
        Else {
            For Program In Standalone.List
            For WinCriterion In Program["WinCriteria"]
            If WinActive(WinCriterion) {
                StandaloneWinCriteria := WinCriterion
                FoundStandalone := Standalone.GetByWindowID(WinGetID("A"))
                TurnStandaloneTimersOn(FoundStandalone.Name)
                Return True
            }
            TurnStandaloneTimersOff()
            Return False
        }
    }
}

TurnHotkeysOff() {
    Global FoundPluginWinCriteria
    If WinActive(PluginWinCriteria)
    HotIfWinActive(PluginWinCriteria)
    Else
    HotIf
    If WinActive(PluginWinCriteria)
    Hotkey "F6", "Off"
    Hotkey "Tab", "Off"
    Hotkey "+Tab", "Off"
    Hotkey "^Tab", "Off"
    Hotkey "Right", "Off"
    Hotkey "^+Tab", "Off"
    Hotkey "Left", "Off"
    Hotkey "Enter", "Off"
    Hotkey "Space", "Off"
    Hotkey "Ctrl", "Off"
    Hotkey "^R", "Off"
}

TurnHotkeysOffExceptF6() {
    Global FoundPluginWinCriteria
    If WinActive(PluginWinCriteria)
    HotIfWinActive(PluginWinCriteria)
    Else
    HotIf
    Hotkey "Tab", "Off"
    Hotkey "+Tab", "Off"
    Hotkey "^Tab", "Off"
    Hotkey "Right", "Off"
    Hotkey "^+Tab", "Off"
    Hotkey "Left", "Off"
    Hotkey "Enter", "Off"
    Hotkey "Space", "Off"
    Hotkey "Ctrl", "Off"
    Hotkey "^R", "Off"
}

TurnHotkeysOn() {
    Global PluginWinCriteria
    If WinActive(PluginWinCriteria)
    HotIfWinActive(PluginWinCriteria)
    Else
    HotIf
    If WinActive(PluginWinCriteria)
    Hotkey "F6", "On"
    Hotkey "Tab", "On"
    Hotkey "+Tab", "On"
    Hotkey "^Tab", "On"
    Hotkey "Right", "On"
    Hotkey "^+Tab", "On"
    Hotkey "Left", "On"
    Hotkey "Enter", "On"
    Hotkey "Space", "On"
    Hotkey "Ctrl", "On"
    Hotkey "^R", "On"
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
