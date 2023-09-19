#Requires AutoHotkey v2.0

#HotIf WinActive("ahk_exe reaper.exe ahk_class #32770")

Tab:: {
    Thread "NoTimers"
    If AccessibleMenu.CurrentMenu Is AccessibleMenu {
        SoundPlay "*48"
    }
    Else {
        ReaHotkey.FoundPlugin := Plugin.GetByClass(ControlGetClassNN(ControlGetFocus(ReaHotkey.PluginWinCriteria)))
        PluginOverlay := ReaHotkey.FoundPlugin.GetOverlay()
        PluginOverlay.FocusNextControl()
    }
}

+Tab:: {
    Thread "NoTimers"
    If AccessibleMenu.CurrentMenu Is AccessibleMenu {
        SoundPlay "*48"
    }
    Else {
        ReaHotkey.FoundPlugin := Plugin.GetByClass(ControlGetClassNN(ControlGetFocus(ReaHotkey.PluginWinCriteria)))
        PluginOverlay := ReaHotkey.FoundPlugin.GetOverlay()
        PluginOverlay.FocusPreviousControl()
    }
}

^Tab:: {
    Thread "NoTimers"
    If Not AccessibleMenu.CurrentMenu Is AccessibleMenu {
        ReaHotkey.FoundPlugin := Plugin.GetByClass(ControlGetClassNN(ControlGetFocus(ReaHotkey.PluginWinCriteria)))
        PluginOverlay := ReaHotkey.FoundPlugin.GetOverlay()
        ReaHotkey.FocusNextTab(PluginOverlay)
    }
}

^+Tab:: {
    Thread "NoTimers"
    If Not AccessibleMenu.CurrentMenu Is AccessibleMenu {
        ReaHotkey.FoundPlugin := Plugin.GetByClass(ControlGetClassNN(ControlGetFocus(ReaHotkey.PluginWinCriteria)))
        PluginOverlay := ReaHotkey.FoundPlugin.GetOverlay()
        ReaHotkey.FocusPreviousTab(PluginOverlay)
    }
}

Right:: {
    Thread "NoTimers"
    If AccessibleMenu.CurrentMenu Is AccessibleMenu {
        AccessibleMenu.CurrentMenu.OpenSubmenu()
    }
    Else {
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
}

Left:: {
    Thread "NoTimers"
    If AccessibleMenu.CurrentMenu Is AccessibleMenu {
        AccessibleMenu.CurrentMenu.CloseSubmenu()
    }
    Else {
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
}

Up::
Down:: {
    Thread "NoTimers"
    If AccessibleMenu.CurrentMenu Is AccessibleMenu {
        If A_ThisHotkey = "Down"
        AccessibleMenu.CurrentMenu.FocusNextItem()
        Else
        AccessibleMenu.CurrentMenu.FocusPreviousItem()
    }
    Else {
        ReaHotkey.FoundPlugin := Plugin.GetByClass(ControlGetClassNN(ControlGetFocus(ReaHotkey.PluginWinCriteria)))
        PluginOverlay := ReaHotkey.FoundPlugin.GetOverlay()
        If PluginOverlay.GetCurrentControl() Is Object
        Switch(PluginOverlay.GetCurrentControl().ControlType) {
            Case "ComboBox":
            Hotkey A_ThisHotkey, "Off"
            Send "{" . A_ThisHotkey . "}"
            PluginOverlay.GetCurrentControl().ChangeValue()
            PluginOverlay.GetCurrentControl().ReportValue()
            Hotkey A_ThisHotkey, "On"
        }
    }
}

Enter::
Space:: {
    Thread "NoTimers"
    If AccessibleMenu.CurrentMenu Is AccessibleMenu {
        If A_ThisHotkey = "Enter"
        AccessibleMenu.CurrentMenu.ChooseItem()
        Else
        SoundPlay "*48"
    }
    Else {
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
}

Escape:: {
    If AccessibleMenu.CurrentMenu Is AccessibleMenu {
        AccessibilityOverlay.Speak("leaving menu")
        AccessibleMenu.CurrentMenu.Close()
    }
    Else {
        Hotkey "Escape", "Off"
        Send "{Escape}"
        Hotkey "Escape", "On"
    }
}

Ctrl:: {
    Thread "NoTimers"
    AccessibilityOverlay.StopSpeech()
}
