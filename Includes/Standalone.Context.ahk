#Requires AutoHotkey v2.0

#HotIf

Tab:: {
    Thread "NoTimers"
    Try
    ReaHotkey.FoundStandalone := Standalone.GetByWindowID(WinGetID("A"))
    Catch
    ReaHotkey.FoundStandalone := False
    If ReaHotkey.FoundStandalone Is Standalone {
        StandaloneOverlay := ReaHotkey.FoundStandalone.GetOverlay()
        StandaloneOverlay.FocusNextControl()
    }
}

+Tab:: {
    Thread "NoTimers"
    Try
    ReaHotkey.FoundStandalone := Standalone.GetByWindowID(WinGetID("A"))
    Catch
    ReaHotkey.FoundStandalone := False
    If ReaHotkey.FoundStandalone Is Standalone {
        StandaloneOverlay := ReaHotkey.FoundStandalone.GetOverlay()
        StandaloneOverlay.FocusPreviousControl()
    }
}

^Tab:: {
    Thread "NoTimers"
    Try
    ReaHotkey.FoundStandalone := Standalone.GetByWindowID(WinGetID("A"))
    Catch
    ReaHotkey.FoundStandalone := False
    If ReaHotkey.FoundStandalone Is Standalone {
        StandaloneOverlay := ReaHotkey.FoundStandalone.GetOverlay()
        ReaHotkey.FocusNextTab(StandaloneOverlay)
    }
}

^+Tab:: {
    Thread "NoTimers"
    Try
    ReaHotkey.FoundStandalone := Standalone.GetByWindowID(WinGetID("A"))
    Catch
    ReaHotkey.FoundStandalone := False
    If ReaHotkey.FoundStandalone Is Standalone {
        StandaloneOverlay := ReaHotkey.FoundStandalone.GetOverlay()
        ReaHotkey.FocusPreviousTab(StandaloneOverlay)
    }
}

Right::
Left:: {
    Thread "NoTimers"
    Try
    ReaHotkey.FoundStandalone := Standalone.GetByWindowID(WinGetID("A"))
    Catch
    ReaHotkey.FoundStandalone := False
    If ReaHotkey.FoundStandalone Is Standalone {
        StandaloneOverlay := ReaHotkey.FoundStandalone.GetOverlay()
        Switch(StandaloneOverlay.GetCurrentControlType()) {
            Case "TabControl":
            Hotkey A_ThisHotkey, "Off"
            Send "{" . A_ThisHotkey . "}"
            If A_ThisHotkey = "Left"
            StandaloneOverlay.FocusPreviousTab()
            Else
            StandaloneOverlay.FocusNextTab()
            Hotkey A_ThisHotkey, "On"
            Default:
            Hotkey A_ThisHotkey, "Off"
            Send "{" . A_ThisHotkey . "}"
            Hotkey A_ThisHotkey, "On"
        }
    }
}

Up::
Down:: {
    Thread "NoTimers"
    Try
    ReaHotkey.FoundStandalone := Standalone.GetByWindowID(WinGetID("A"))
    Catch
    ReaHotkey.FoundStandalone := False
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
    Try
    ReaHotkey.FoundStandalone := Standalone.GetByWindowID(WinGetID("A"))
    Catch
    ReaHotkey.FoundStandalone := False
    If ReaHotkey.FoundStandalone Is Standalone {
        StandaloneOverlay := ReaHotkey.FoundStandalone.GetOverlay()
        Switch(StandaloneOverlay.GetCurrentControlType()) {
            Case "Edit":
            Hotkey A_ThisHotkey, "Off"
            Send "{" . A_ThisHotkey . "}"
            Hotkey A_ThisHotkey, "On"
            Case "Native":
            Hotkey A_ThisHotkey, "Off"
            Send "{" . A_ThisHotkey . "}"
            StandaloneOverlay.ActivateCurrentControl()
            Hotkey A_ThisHotkey, "On"
            Case "UIA":
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
