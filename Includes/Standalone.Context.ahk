#Requires AutoHotkey v2.0

#HotIf

Tab:: {
    Thread "NoTimers"
    If AccessibleMenu.CurrentMenu Is AccessibleMenu {
        SoundPlay "*48"
    }
    Else {
        ReaHotkey.FoundStandalone :=  Standalone.GetByWindowID(WinGetID("A"))
        StandaloneOverlay := ReaHotkey.FoundStandalone.GetOverlay()
        StandaloneOverlay.FocusNextControl()
    }
}

+Tab:: {
    Thread "NoTimers"
    If AccessibleMenu.CurrentMenu Is AccessibleMenu {
        SoundPlay "*48"
    }
    Else {
        ReaHotkey.FoundStandalone :=  Standalone.GetByWindowID(WinGetID("A"))
        StandaloneOverlay := ReaHotkey.FoundStandalone.GetOverlay()
        StandaloneOverlay.FocusPreviousControl()
    }
}

^Tab:: {
    Thread "NoTimers"
    If Not AccessibleMenu.CurrentMenu Is AccessibleMenu {
        ReaHotkey.FoundStandalone :=  Standalone.GetByWindowID(WinGetID("A"))
        StandaloneOverlay := ReaHotkey.FoundStandalone.GetOverlay()
        ReaHotkey.FocusNextTab(StandaloneOverlay)
    }
}

^+Tab:: {
    Thread "NoTimers"
    If Not AccessibleMenu.CurrentMenu Is AccessibleMenu {
        ReaHotkey.FoundStandalone :=  Standalone.GetByWindowID(WinGetID("A"))
        StandaloneOverlay := ReaHotkey.FoundStandalone.GetOverlay()
        ReaHotkey.FocusPreviousTab(StandaloneOverlay)
    }
}

Right:: {
    Thread "NoTimers"
    If AccessibleMenu.CurrentMenu Is AccessibleMenu {
        AccessibleMenu.CurrentMenu.OpenSubmenu()
    }
    Else {
        ReaHotkey.FoundStandalone :=  Standalone.GetByWindowID(WinGetID("A"))
        StandaloneOverlay := ReaHotkey.FoundStandalone.GetOverlay()
        If StandaloneOverlay.GetCurrentControl() Is Object
        Switch(StandaloneOverlay.GetCurrentControl().ControlType) {
            Case "Edit":
            Hotkey A_ThisHotkey, "Off"
            Send "{" . A_ThisHotkey . "}"
            Hotkey A_ThisHotkey, "On"
            Default:
            StandaloneOverlay.FocusNextTab()
        }
    }
}

Left:: {
    Thread "NoTimers"
    If AccessibleMenu.CurrentMenu Is AccessibleMenu {
        AccessibleMenu.CurrentMenu.CloseSubmenu()
    }
    Else {
        ReaHotkey.FoundStandalone :=  Standalone.GetByWindowID(WinGetID("A"))
        StandaloneOverlay := ReaHotkey.FoundStandalone.GetOverlay()
        If StandaloneOverlay.GetCurrentControl() Is Object
        Switch(StandaloneOverlay.GetCurrentControl().ControlType) {
            Case "Edit":
            Hotkey A_ThisHotkey, "Off"
            Send "{" . A_ThisHotkey . "}"
            Hotkey A_ThisHotkey, "On"
            Default:
            StandaloneOverlay.FocusPreviousTab()
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
        ReaHotkey.FoundStandalone :=  Standalone.GetByWindowID(WinGetID("A"))
        StandaloneOverlay := ReaHotkey.FoundStandalone.GetOverlay()
        If StandaloneOverlay.GetCurrentControl() Is Object
        Switch(StandaloneOverlay.GetCurrentControl().ControlType) {
            Case "ComboBox":
            Hotkey A_ThisHotkey, "Off"
            Send "{" . A_ThisHotkey . "}"
            StandaloneOverlay.GetCurrentControl().ChangeValue()
            StandaloneOverlay.GetCurrentControl().ReportValue()
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
        ReaHotkey.FoundStandalone :=  Standalone.GetByWindowID(WinGetID("A"))
        StandaloneOverlay := ReaHotkey.FoundStandalone.GetOverlay()
        If StandaloneOverlay.GetCurrentControl() Is Object
        Switch(StandaloneOverlay.GetCurrentControl().ControlType) {
            Case "Edit":
            Hotkey A_ThisHotkey, "Off"
            Send "{" . A_ThisHotkey . "}"
            Hotkey A_ThisHotkey, "On"
            Default:
            StandaloneOverlay.ActivateCurrentControl()
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
