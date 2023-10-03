#Requires AutoHotkey v2.0

#HotIf

Tab:: {
    Thread "NoTimers"
    ReaHotkey.FoundStandalone :=  Standalone.GetByWindowID(WinGetID("A"))
    StandaloneOverlay := ReaHotkey.FoundStandalone.GetOverlay()
    StandaloneOverlay.FocusNextControl()
}

+Tab:: {
    Thread "NoTimers"
    ReaHotkey.FoundStandalone :=  Standalone.GetByWindowID(WinGetID("A"))
    StandaloneOverlay := ReaHotkey.FoundStandalone.GetOverlay()
    StandaloneOverlay.FocusPreviousControl()
}

^Tab:: {
    Thread "NoTimers"
    ReaHotkey.FoundStandalone :=  Standalone.GetByWindowID(WinGetID("A"))
    StandaloneOverlay := ReaHotkey.FoundStandalone.GetOverlay()
    ReaHotkey.FocusNextTab(StandaloneOverlay)
}

^+Tab:: {
    Thread "NoTimers"
    ReaHotkey.FoundStandalone :=  Standalone.GetByWindowID(WinGetID("A"))
    StandaloneOverlay := ReaHotkey.FoundStandalone.GetOverlay()
    ReaHotkey.FocusPreviousTab(StandaloneOverlay)
}

Right:: {
    Thread "NoTimers"
    ReaHotkey.FoundStandalone :=  Standalone.GetByWindowID(WinGetID("A"))
    StandaloneOverlay := ReaHotkey.FoundStandalone.GetOverlay()
    Switch(StandaloneOverlay.GetCurrentControlType()) {
        Case "Edit":
        Hotkey A_ThisHotkey, "Off"
        Send "{" . A_ThisHotkey . "}"
        Hotkey A_ThisHotkey, "On"
        Default:
        Hotkey A_ThisHotkey, "Off"
        Send "{" . A_ThisHotkey . "}"
        Hotkey A_ThisHotkey, "On"
        StandaloneOverlay.FocusNextTab()
    }
}

Left:: {
    Thread "NoTimers"
    ReaHotkey.FoundStandalone :=  Standalone.GetByWindowID(WinGetID("A"))
    StandaloneOverlay := ReaHotkey.FoundStandalone.GetOverlay()
    Switch(StandaloneOverlay.GetCurrentControlType()) {
        Case "Edit":
        Hotkey A_ThisHotkey, "Off"
        Send "{" . A_ThisHotkey . "}"
        Hotkey A_ThisHotkey, "On"
        Default:
        Hotkey A_ThisHotkey, "Off"
        Send "{" . A_ThisHotkey . "}"
        Hotkey A_ThisHotkey, "On"
        StandaloneOverlay.FocusPreviousTab()
    }
}

Up::
Down:: {
    Thread "NoTimers"
    ReaHotkey.FoundStandalone :=  Standalone.GetByWindowID(WinGetID("A"))
    StandaloneOverlay := ReaHotkey.FoundStandalone.GetOverlay()
    Switch(StandaloneOverlay.GetCurrentControlType()) {
        Case "ComboBox":
        Hotkey A_ThisHotkey, "Off"
        Send "{" . A_ThisHotkey . "}"
        If A_ThisHotkey = "Up"
        StandaloneOverlay.SelectPreviousOption()
        Else
        StandaloneOverlay.SelectNextOption()
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

Ctrl:: {
    Thread "NoTimers"
    AccessibilityOverlay.StopSpeech()
}
