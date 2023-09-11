#Requires AutoHotkey v2.0

#HotIf

Tab:: {
    ReaHotkey.FoundStandalone :=  Standalone.GetByWindowID(WinGetID("A"))
    StandaloneOverlay := ReaHotkey.FoundStandalone.GetOverlay()
    StandaloneOverlay.FocusNextControl()
}

+Tab:: {
    ReaHotkey.FoundStandalone :=  Standalone.GetByWindowID(WinGetID("A"))
    StandaloneOverlay := ReaHotkey.FoundStandalone.GetOverlay()
    StandaloneOverlay.FocusPreviousControl()
}

^Tab:: {
    ReaHotkey.FoundStandalone :=  Standalone.GetByWindowID(WinGetID("A"))
    StandaloneOverlay := ReaHotkey.FoundStandalone.GetOverlay()
    ReaHotkey.FocusNextTab(StandaloneOverlay)
}

^+Tab:: {
    ReaHotkey.FoundStandalone :=  Standalone.GetByWindowID(WinGetID("A"))
    StandaloneOverlay := ReaHotkey.FoundStandalone.GetOverlay()
    ReaHotkey.FocusPreviousTab(StandaloneOverlay)
}

Right:: {
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

Left:: {
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

Up::
Down:: {
    ReaHotkey.FoundStandalone :=  Standalone.GetByWindowID(WinGetID("A"))
    StandaloneOverlay := ReaHotkey.FoundStandalone.GetOverlay()
    If StandaloneOverlay.GetCurrentControl() Is Object
    Switch(StandaloneOverlay.GetCurrentControl().ControlType) {
        Case "ComboBox":
        Hotkey A_ThisHotkey, "Off"
        Send "{" . A_ThisHotkey . "}"
        StandaloneOverlay.GetCurrentControl().Focus(StandaloneOverlay.GetCurrentControl().ControlID, 1)
        Hotkey A_ThisHotkey, "On"
    }
}

Enter::
Space:: {
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
    AccessibilityOverlay.StopSpeech()
}
