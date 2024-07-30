#Requires AutoHotkey v2.0

Tab:: {
    Thread "NoTimers"
    If ReaHotkey.Context != False
    Try
    If ReaHotkey.Context = "Plugin"
    ReaHotkey.FoundPlugin := Plugin.GetByClass(ReaHotkey.GetPluginControl())
    Else
    ReaHotkey.FoundStandalone := Standalone.GetByWindowID(WinGetID("A"))
    Catch
    ReaHotkey.Found%ReaHotkey.Context% := False
    If ReaHotkey.Context != False And ReaHotkey.Found%ReaHotkey.Context% Is %ReaHotkey.Context% {
        ReaHotkey.Found%ReaHotkey.Context%.Overlay.FocusNextControl()
    }
}

+Tab:: {
    Thread "NoTimers"
    If ReaHotkey.Context != False
    Try
    If ReaHotkey.Context = "Plugin"
    ReaHotkey.FoundPlugin := Plugin.GetByClass(ReaHotkey.GetPluginControl())
    Else
    ReaHotkey.FoundStandalone := Standalone.GetByWindowID(WinGetID("A"))
    Catch
    ReaHotkey.Found%ReaHotkey.Context% := False
    If ReaHotkey.Context != False And ReaHotkey.Found%ReaHotkey.Context% Is %ReaHotkey.Context% {
        ReaHotkey.Found%ReaHotkey.Context%.Overlay.FocusPreviousControl()
    }
}

^Tab:: {
    Thread "NoTimers"
    If ReaHotkey.Context != False
    Try
    If ReaHotkey.Context = "Plugin"
    ReaHotkey.FoundPlugin := Plugin.GetByClass(ReaHotkey.GetPluginControl())
    Else
    ReaHotkey.FoundStandalone := Standalone.GetByWindowID(WinGetID("A"))
    Catch
    ReaHotkey.Found%ReaHotkey.Context% := False
    If ReaHotkey.Context != False And ReaHotkey.Found%ReaHotkey.Context% Is %ReaHotkey.Context% {
        ReaHotkey.FocusNextTab(ReaHotkey.Found%ReaHotkey.Context%.Overlay)
    }
}

^+Tab:: {
    Thread "NoTimers"
    If ReaHotkey.Context != False
    Try
    If ReaHotkey.Context = "Plugin"
    ReaHotkey.FoundPlugin := Plugin.GetByClass(ReaHotkey.GetPluginControl())
    Else
    ReaHotkey.FoundStandalone := Standalone.GetByWindowID(WinGetID("A"))
    Catch
    ReaHotkey.Found%ReaHotkey.Context% := False
    If ReaHotkey.Context != False And ReaHotkey.Found%ReaHotkey.Context% Is %ReaHotkey.Context% {
        ReaHotkey.FocusPreviousTab(ReaHotkey.Found%ReaHotkey.Context%.Overlay)
    }
}

Right::
Left:: {
    Thread "NoTimers"
    If ReaHotkey.Context != False
    Try
    If ReaHotkey.Context = "Plugin"
    ReaHotkey.FoundPlugin := Plugin.GetByClass(ReaHotkey.GetPluginControl())
    Else
    ReaHotkey.FoundStandalone := Standalone.GetByWindowID(WinGetID("A"))
    Catch
    ReaHotkey.Found%ReaHotkey.Context% := False
    If ReaHotkey.Context != False And ReaHotkey.Found%ReaHotkey.Context% Is %ReaHotkey.Context% {
        Switch(ReaHotkey.Found%ReaHotkey.Context%.Overlay.GetCurrentControlType()) {
            Case "TabControl":
            Hotkey A_ThisHotkey, "Off"
            Send "{" . A_ThisHotkey . "}"
            If A_ThisHotkey = "Left"
            ReaHotkey.Found%ReaHotkey.Context%.Overlay.FocusPreviousTab()
            Else
            ReaHotkey.Found%ReaHotkey.Context%.Overlay.FocusNextTab()
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
    If ReaHotkey.Context != False
    Try
    If ReaHotkey.Context = "Plugin"
    ReaHotkey.FoundPlugin := Plugin.GetByClass(ReaHotkey.GetPluginControl())
    Else
    ReaHotkey.FoundStandalone := Standalone.GetByWindowID(WinGetID("A"))
    Catch
    ReaHotkey.Found%ReaHotkey.Context% := False
    If ReaHotkey.Context != False And ReaHotkey.Found%ReaHotkey.Context% Is %ReaHotkey.Context% {
        Switch(ReaHotkey.Found%ReaHotkey.Context%.Overlay.GetCurrentControlType()) {
            Case "ComboBox":
            Hotkey A_ThisHotkey, "Off"
            Send "{" . A_ThisHotkey . "}"
            If A_ThisHotkey = "Up"
            ReaHotkey.Found%ReaHotkey.Context%.Overlay.SelectPreviousOption()
            Else
            ReaHotkey.Found%ReaHotkey.Context%.Overlay.SelectNextOption()
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
    If ReaHotkey.Context != False
    Try
    If ReaHotkey.Context = "Plugin"
    ReaHotkey.FoundPlugin := Plugin.GetByClass(ReaHotkey.GetPluginControl())
    Else
    ReaHotkey.FoundStandalone := Standalone.GetByWindowID(WinGetID("A"))
    Catch
    ReaHotkey.Found%ReaHotkey.Context% := False
    If ReaHotkey.Context != False And ReaHotkey.Found%ReaHotkey.Context% Is %ReaHotkey.Context% {
        Switch(ReaHotkey.Found%ReaHotkey.Context%.Overlay.GetCurrentControlType()) {
            Case "Edit":
            Hotkey A_ThisHotkey, "Off"
            Send "{" . A_ThisHotkey . "}"
            Hotkey A_ThisHotkey, "On"
            Case "Native":
            Hotkey A_ThisHotkey, "Off"
            Send "{" . A_ThisHotkey . "}"
            ReaHotkey.Found%ReaHotkey.Context%.Overlay.ActivateCurrentControl()
            Hotkey A_ThisHotkey, "On"
            Case "UIA":
            Hotkey A_ThisHotkey, "Off"
            Send "{" . A_ThisHotkey . "}"
            ReaHotkey.Found%ReaHotkey.Context%.Overlay.ActivateCurrentControl()
            Hotkey A_ThisHotkey, "On"
            Default:
            ReaHotkey.Found%ReaHotkey.Context%.Overlay.ActivateCurrentControl()
        }
    }
}
