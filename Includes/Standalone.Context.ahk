#Requires AutoHotkey v2.0

#HotIf

Tab:: {
    Thread "NoTimers"
    ReaHotkey.FoundStandalone :=  Standalone.GetByWindowID(WinGetID("A"))
    If ReaHotkey.FoundStandalone Is Standalone {
        StandaloneOverlay := ReaHotkey.FoundStandalone.GetOverlay()
        StandaloneOverlay.FocusNextControl()
    }
}

+Tab:: {
    Thread "NoTimers"
    ReaHotkey.FoundStandalone :=  Standalone.GetByWindowID(WinGetID("A"))
    If ReaHotkey.FoundStandalone Is Standalone {
        StandaloneOverlay := ReaHotkey.FoundStandalone.GetOverlay()
        StandaloneOverlay.FocusPreviousControl()
    }
}

^Tab:: {
    Thread "NoTimers"
    ReaHotkey.FoundStandalone :=  Standalone.GetByWindowID(WinGetID("A"))
    If ReaHotkey.FoundStandalone Is Standalone {
        StandaloneOverlay := ReaHotkey.FoundStandalone.GetOverlay()
        ReaHotkey.FocusNextTab(StandaloneOverlay)
    }
}

^+Tab:: {
    Thread "NoTimers"
    ReaHotkey.FoundStandalone :=  Standalone.GetByWindowID(WinGetID("A"))
    If ReaHotkey.FoundStandalone Is Standalone {
        StandaloneOverlay := ReaHotkey.FoundStandalone.GetOverlay()
        ReaHotkey.FocusPreviousTab(StandaloneOverlay)
    }
}

Right::
Left:: {
    Thread "NoTimers"
    ReaHotkey.FoundStandalone :=  Standalone.GetByWindowID(WinGetID("A"))
    If ReaHotkey.FoundStandalone Is Standalone {
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
            If A_ThisHotkey = "Left"
            StandaloneOverlay.FocusPreviousTab()
            Else
            StandaloneOverlay.FocusNextTab()
        }
    }
}

Up::
Down:: {
    Thread "NoTimers"
    ReaHotkey.FoundStandalone :=  Standalone.GetByWindowID(WinGetID("A"))
    If ReaHotkey.FoundStandalone Is Standalone {
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
}

Enter::
Space:: {
    Thread "NoTimers"
    ReaHotkey.FoundStandalone :=  Standalone.GetByWindowID(WinGetID("A"))
    If ReaHotkey.FoundStandalone Is Standalone {
        StandaloneOverlay := ReaHotkey.FoundStandalone.GetOverlay()
        Switch(StandaloneOverlay.GetCurrentControlType()) {
            Case "Edit":
            Hotkey A_ThisHotkey, "Off"
            Send "{" . A_ThisHotkey . "}"
            Hotkey A_ThisHotkey, "On"
            Case "NativeControl":
            Hotkey A_ThisHotkey, "Off"
            Send "{" . A_ThisHotkey . "}"
            StandaloneOverlay.ActivateCurrentControl()
            Hotkey A_ThisHotkey, "On"
            Default:
            StandaloneOverlay.ActivateCurrentControl()
        }
    }
}

Ctrl:: {
    Thread "NoTimers"
    AccessibilityOverlay.StopSpeech()
}
