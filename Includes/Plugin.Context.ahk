#Requires AutoHotkey v2.0

#HotIf WinActive("ahk_exe reaper.exe ahk_class #32770")

Tab:: {
    Thread "NoTimers"
    ReaHotkey.FoundPlugin := Plugin.GetByClass(ControlGetClassNN(ControlGetFocus(ReaHotkey.PluginWinCriteria)))
    PluginOverlay := ReaHotkey.FoundPlugin.GetOverlay()
    PluginOverlay.FocusNextControl()
}

+Tab:: {
    Thread "NoTimers"
    ReaHotkey.FoundPlugin := Plugin.GetByClass(ControlGetClassNN(ControlGetFocus(ReaHotkey.PluginWinCriteria)))
    PluginOverlay := ReaHotkey.FoundPlugin.GetOverlay()
    PluginOverlay.FocusPreviousControl()
}

^Tab:: {
    Thread "NoTimers"
    ReaHotkey.FoundPlugin := Plugin.GetByClass(ControlGetClassNN(ControlGetFocus(ReaHotkey.PluginWinCriteria)))
    PluginOverlay := ReaHotkey.FoundPlugin.GetOverlay()
    ReaHotkey.FocusNextTab(PluginOverlay)
}

^+Tab:: {
    Thread "NoTimers"
    ReaHotkey.FoundPlugin := Plugin.GetByClass(ControlGetClassNN(ControlGetFocus(ReaHotkey.PluginWinCriteria)))
    PluginOverlay := ReaHotkey.FoundPlugin.GetOverlay()
    ReaHotkey.FocusPreviousTab(PluginOverlay)
}

Right:: {
    Thread "NoTimers"
    ReaHotkey.FoundPlugin := Plugin.GetByClass(ControlGetClassNN(ControlGetFocus(ReaHotkey.PluginWinCriteria)))
    PluginOverlay := ReaHotkey.FoundPlugin.GetOverlay()
    Switch(PluginOverlay.GetCurrentControlType()) {
        Case "Edit":
        Hotkey A_ThisHotkey, "Off"
        Send "{" . A_ThisHotkey . "}"
        Hotkey A_ThisHotkey, "On"
        Default:
        Hotkey A_ThisHotkey, "Off"
        Send "{" . A_ThisHotkey . "}"
        Hotkey A_ThisHotkey, "On"
        PluginOverlay.FocusNextTab()
    }
}

Left:: {
    Thread "NoTimers"
    ReaHotkey.FoundPlugin := Plugin.GetByClass(ControlGetClassNN(ControlGetFocus(ReaHotkey.PluginWinCriteria)))
    PluginOverlay := ReaHotkey.FoundPlugin.GetOverlay()
    Switch(PluginOverlay.GetCurrentControlType()) {
        Case "Edit":
        Hotkey A_ThisHotkey, "Off"
        Send "{" . A_ThisHotkey . "}"
        Hotkey A_ThisHotkey, "On"
        Default:
        Hotkey A_ThisHotkey, "Off"
        Send "{" . A_ThisHotkey . "}"
        Hotkey A_ThisHotkey, "On"
        PluginOverlay.FocusPreviousTab()
    }
}

Up::
Down:: {
    Thread "NoTimers"
    ReaHotkey.FoundPlugin := Plugin.GetByClass(ControlGetClassNN(ControlGetFocus(ReaHotkey.PluginWinCriteria)))
    PluginOverlay := ReaHotkey.FoundPlugin.GetOverlay()
    Switch(PluginOverlay.GetCurrentControlType()) {
        Case "ComboBox":
        Hotkey A_ThisHotkey, "Off"
        Send "{" . A_ThisHotkey . "}"
        If A_ThisHotkey = "Up"
        PluginOverlay.SelectPreviousOption()
        Else
        PluginOverlay.SelectNextOption()
        Hotkey A_ThisHotkey, "On"
        Default:
        Hotkey A_ThisHotkey, "Off"
        Send "{" . A_ThisHotkey . "}"
        Hotkey A_ThisHotkey, "On"
    }
}

Enter::
Space:: {
    Thread "NoTimers"
    ReaHotkey.FoundPlugin := Plugin.GetByClass(ControlGetClassNN(ControlGetFocus(ReaHotkey.PluginWinCriteria)))
    PluginOverlay := ReaHotkey.FoundPlugin.GetOverlay()
    Switch(PluginOverlay.GetCurrentControlType()) {
        Case "Edit":
        Hotkey A_ThisHotkey, "Off"
        Send "{" . A_ThisHotkey . "}"
        Hotkey A_ThisHotkey, "On"
        Default:
        PluginOverlay.ActivateCurrentControl()
    }
}

Ctrl:: {
    Thread "NoTimers"
    AccessibilityOverlay.StopSpeech()
}
