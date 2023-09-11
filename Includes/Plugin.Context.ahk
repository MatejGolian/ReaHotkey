#Requires AutoHotkey v2.0

#HotIf WinActive("ahk_exe reaper.exe ahk_class #32770")

Tab:: {
    ReaHotkey.FoundPlugin := Plugin.GetByClass(ControlGetClassNN(ControlGetFocus(ReaHotkey.PluginWinCriteria)))
    PluginOverlay := ReaHotkey.FoundPlugin.GetOverlay()
    PluginOverlay.FocusNextControl()
}

+Tab:: {
    ReaHotkey.FoundPlugin := Plugin.GetByClass(ControlGetClassNN(ControlGetFocus(ReaHotkey.PluginWinCriteria)))
    PluginOverlay := ReaHotkey.FoundPlugin.GetOverlay()
    PluginOverlay.FocusPreviousControl()
}

^Tab:: {
    ReaHotkey.FoundPlugin := Plugin.GetByClass(ControlGetClassNN(ControlGetFocus(ReaHotkey.PluginWinCriteria)))
    PluginOverlay := ReaHotkey.FoundPlugin.GetOverlay()
    ReaHotkey.FocusNextTab(PluginOverlay)
}

^+Tab:: {
    ReaHotkey.FoundPlugin := Plugin.GetByClass(ControlGetClassNN(ControlGetFocus(ReaHotkey.PluginWinCriteria)))
    PluginOverlay := ReaHotkey.FoundPlugin.GetOverlay()
    ReaHotkey.FocusPreviousTab(PluginOverlay)
}

Right:: {
    ReaHotkey.FoundPlugin := Plugin.GetByClass(ControlGetClassNN(ControlGetFocus(ReaHotkey.PluginWinCriteria)))
    PluginOverlay := ReaHotkey.FoundPlugin.GetOverlay()
    If PluginOverlay.GetCurrentControl() Is Object
    Switch(PluginOverlay.GetCurrentControl().ControlType) {
        Case "Edit":
        Hotkey A_ThisHotkey, "Off"
        Send "{" . A_ThisHotkey . "}"
        Hotkey A_ThisHotkey, "On"
        Default:
        PluginOverlay.FocusNextTab()
    }
}

Left:: {
    ReaHotkey.FoundPlugin := Plugin.GetByClass(ControlGetClassNN(ControlGetFocus(ReaHotkey.PluginWinCriteria)))
    PluginOverlay := ReaHotkey.FoundPlugin.GetOverlay()
    If PluginOverlay.GetCurrentControl() Is Object
    Switch(PluginOverlay.GetCurrentControl().ControlType) {
        Case "Edit":
        Hotkey A_ThisHotkey, "Off"
        Send "{" . A_ThisHotkey . "}"
        Hotkey A_ThisHotkey, "On"
        Default:
        PluginOverlay.FocusPreviousTab()
    }
}

Up::
Down:: {
    ReaHotkey.FoundPlugin := Plugin.GetByClass(ControlGetClassNN(ControlGetFocus(ReaHotkey.PluginWinCriteria)))
    PluginOverlay := ReaHotkey.FoundPlugin.GetOverlay()
    If PluginOverlay.GetCurrentControl() Is Object
    Switch(PluginOverlay.GetCurrentControl().ControlType) {
        Case "ComboBox":
        Hotkey A_ThisHotkey, "Off"
        Send "{" . A_ThisHotkey . "}"
        PluginOverlay.GetCurrentControl().Focus(PluginOverlay.GetCurrentControl().ControlID, 1)
        Hotkey A_ThisHotkey, "On"
    }
}

Enter::
Space:: {
    ReaHotkey.FoundPlugin := Plugin.GetByClass(ControlGetClassNN(ControlGetFocus(ReaHotkey.PluginWinCriteria)))
    PluginOverlay := ReaHotkey.FoundPlugin.GetOverlay()
    If PluginOverlay.GetCurrentControl() Is Object
    Switch(PluginOverlay.GetCurrentControl().ControlType) {
        Case "Edit":
        Hotkey A_ThisHotkey, "Off"
        Send "{" . A_ThisHotkey . "}"
        Hotkey A_ThisHotkey, "On"
        Default:
        PluginOverlay.ActivateCurrentControl()
    }
}

Ctrl:: {
    AccessibilityOverlay.StopSpeech()
}
