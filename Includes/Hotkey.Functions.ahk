#Requires AutoHotkey v2.0

F6HK(ThisHotkey) {
    Thread "NoTimers"
    Controls := WinGetControls(ReaHotkey.PluginWinCriteria)
    ContainerIndex := 0
    Try
    For Index, Control In Controls
    If Control = "reaperPluginHostWrapProc1" And Index < Controls.Length {
        ContainerIndex := Index + 1
        Break
    }
    CurrentIndex := 0
    Try
    For Index, Control In Controls
    If Control = ControlGetClassNN(ControlGetFocus(ReaHotkey.PluginWinCriteria)) {
        CurrentIndex := Index
        Break
    }
    If CurrentIndex > 0 And ContainerIndex > 0 And CurrentIndex <= 6 And CurrentIndex != ContainerIndex {
        Try
        ControlFocus Controls[ContainerIndex], ReaHotkey.PluginWinCriteria
    }
    Else {
        Hotkey ThisHotkey, "Off"
        Send "{" . ThisHotkey . "}"
        Hotkey ThisHotkey, "On"
    }
}

TabHK(ThisHotkey) {
    Thread "NoTimers"
    If ReaHotkey.Context != False
    Try
    If ReaHotkey.Context = "Plugin"
    ReaHotkey.FoundPlugin := Plugin.GetByWinTitle(ReaHotkey.GetPluginControl(), WinGetTitle("A"))
    Else
    ReaHotkey.FoundStandalone := Standalone.GetByWindowID(WinGetID("A"))
    Catch
    ReaHotkey.Found%ReaHotkey.Context% := False
    If ReaHotkey.Context != False And ReaHotkey.Found%ReaHotkey.Context% Is %ReaHotkey.Context% {
        ReaHotkey.Found%ReaHotkey.Context%.Overlay.FocusNextControl()
    }
}

ShiftTabHK(ThisHotkey) {
    Thread "NoTimers"
    If ReaHotkey.Context != False
    Try
    If ReaHotkey.Context = "Plugin"
    ReaHotkey.FoundPlugin := Plugin.GetByWinTitle(ReaHotkey.GetPluginControl(), WinGetTitle("A"))
    Else
    ReaHotkey.FoundStandalone := Standalone.GetByWindowID(WinGetID("A"))
    Catch
    ReaHotkey.Found%ReaHotkey.Context% := False
    If ReaHotkey.Context != False And ReaHotkey.Found%ReaHotkey.Context% Is %ReaHotkey.Context% {
        ReaHotkey.Found%ReaHotkey.Context%.Overlay.FocusPreviousControl()
    }
}

ControlTabHK(ThisHotkey) {
    Thread "NoTimers"
    If ReaHotkey.Context != False
    Try
    If ReaHotkey.Context = "Plugin"
    ReaHotkey.FoundPlugin := Plugin.GetByWinTitle(ReaHotkey.GetPluginControl(), WinGetTitle("A"))
    Else
    ReaHotkey.FoundStandalone := Standalone.GetByWindowID(WinGetID("A"))
    Catch
    ReaHotkey.Found%ReaHotkey.Context% := False
    If ReaHotkey.Context != False And ReaHotkey.Found%ReaHotkey.Context% Is %ReaHotkey.Context% {
        ReaHotkey.FocusNextTab(ReaHotkey.Found%ReaHotkey.Context%.Overlay)
    }
}

ControlShiftTabHK(ThisHotkey) {
    Thread "NoTimers"
    If ReaHotkey.Context != False
    Try
    If ReaHotkey.Context = "Plugin"
    ReaHotkey.FoundPlugin := Plugin.GetByWinTitle(ReaHotkey.GetPluginControl(), WinGetTitle("A"))
    Else
    ReaHotkey.FoundStandalone := Standalone.GetByWindowID(WinGetID("A"))
    Catch
    ReaHotkey.Found%ReaHotkey.Context% := False
    If ReaHotkey.Context != False And ReaHotkey.Found%ReaHotkey.Context% Is %ReaHotkey.Context% {
        ReaHotkey.FocusPreviousTab(ReaHotkey.Found%ReaHotkey.Context%.Overlay)
    }
}

LeftRightHK(ThisHotkey) {
    Thread "NoTimers"
    If ReaHotkey.Context != False
    Try
    If ReaHotkey.Context = "Plugin"
    ReaHotkey.FoundPlugin := Plugin.GetByWinTitle(ReaHotkey.GetPluginControl(), WinGetTitle("A"))
    Else
    ReaHotkey.FoundStandalone := Standalone.GetByWindowID(WinGetID("A"))
    Catch
    ReaHotkey.Found%ReaHotkey.Context% := False
    If ReaHotkey.Context != False And ReaHotkey.Found%ReaHotkey.Context% Is %ReaHotkey.Context% {
        Switch(ReaHotkey.Found%ReaHotkey.Context%.Overlay.GetCurrentControlType()) {
            Case "Slider":
            Hotkey ThisHotkey, "Off"
            Send "{" . ThisHotkey . "}"
            If ThisHotkey = "Left"
            ReaHotkey.Found%ReaHotkey.Context%.Overlay.DecreaseSlider()
            Else
            ReaHotkey.Found%ReaHotkey.Context%.Overlay.IncreaseSlider()
            Hotkey ThisHotkey, "On"
            Case "TabControl":
            Hotkey ThisHotkey, "Off"
            Send "{" . ThisHotkey . "}"
            If ThisHotkey = "Left"
            ReaHotkey.Found%ReaHotkey.Context%.Overlay.FocusPreviousTab()
            Else
            ReaHotkey.Found%ReaHotkey.Context%.Overlay.FocusNextTab()
            Hotkey ThisHotkey, "On"
            Default:
            Hotkey ThisHotkey, "Off"
            Send "{" . ThisHotkey . "}"
            Hotkey ThisHotkey, "On"
        }
    }
}

UpDownHK(ThisHotkey) {
    Thread "NoTimers"
    If ReaHotkey.Context != False
    Try
    If ReaHotkey.Context = "Plugin"
    ReaHotkey.FoundPlugin := Plugin.GetByWinTitle(ReaHotkey.GetPluginControl(), WinGetTitle("A"))
    Else
    ReaHotkey.FoundStandalone := Standalone.GetByWindowID(WinGetID("A"))
    Catch
    ReaHotkey.Found%ReaHotkey.Context% := False
    If ReaHotkey.Context != False And ReaHotkey.Found%ReaHotkey.Context% Is %ReaHotkey.Context% {
        Switch(ReaHotkey.Found%ReaHotkey.Context%.Overlay.GetCurrentControlType()) {
            Case "ComboBox":
            Hotkey ThisHotkey, "Off"
            Send "{" . ThisHotkey . "}"
            If ThisHotkey = "Up"
            ReaHotkey.Found%ReaHotkey.Context%.Overlay.SelectPreviousOption()
            Else
            ReaHotkey.Found%ReaHotkey.Context%.Overlay.SelectNextOption()
            Hotkey ThisHotkey, "On"
            Case "Slider":
            Hotkey ThisHotkey, "Off"
            Send "{" . ThisHotkey . "}"
            If ThisHotkey = "Down"
            ReaHotkey.Found%ReaHotkey.Context%.Overlay.DecreaseSlider()
            Else
            ReaHotkey.Found%ReaHotkey.Context%.Overlay.IncreaseSlider()
            Hotkey ThisHotkey, "On"
            Default:
            Hotkey ThisHotkey, "Off"
            Send "{" . ThisHotkey . "}"
            Hotkey ThisHotkey, "On"
        }
    }
}

EnterSpaceHK(ThisHotkey) {
    Thread "NoTimers"
    If ReaHotkey.Context != False
    Try
    If ReaHotkey.Context = "Plugin"
    ReaHotkey.FoundPlugin := Plugin.GetByWinTitle(ReaHotkey.GetPluginControl(), WinGetTitle("A"))
    Else
    ReaHotkey.FoundStandalone := Standalone.GetByWindowID(WinGetID("A"))
    Catch
    ReaHotkey.Found%ReaHotkey.Context% := False
    If ReaHotkey.Context != False And ReaHotkey.Found%ReaHotkey.Context% Is %ReaHotkey.Context% {
        Switch(ReaHotkey.Found%ReaHotkey.Context%.Overlay.GetCurrentControlType()) {
            Case "Edit":
            Hotkey ThisHotkey, "Off"
            Send "{" . ThisHotkey . "}"
            Hotkey ThisHotkey, "On"
            Case "Native":
            Hotkey ThisHotkey, "Off"
            Send "{" . ThisHotkey . "}"
            ReaHotkey.Found%ReaHotkey.Context%.Overlay.ActivateCurrentControl()
            Hotkey ThisHotkey, "On"
            Case "UIA":
            Hotkey ThisHotkey, "Off"
            Send "{" . ThisHotkey . "}"
            ReaHotkey.Found%ReaHotkey.Context%.Overlay.ActivateCurrentControl()
            Hotkey ThisHotkey, "On"
            Default:
            ReaHotkey.Found%ReaHotkey.Context%.Overlay.ActivateCurrentControl()
        }
    }
}

ReadmeHK(ThisHotkey) {
    ReaHotkey.ViewReadme()
}

ReloadHK(ThisHotkey) {
    ReaHotkey.Reload()
}

ControlHK(ThisHotkey) {
    Thread "NoTimers"
    AccessibilityOverlay.StopSpeech()
}

AboutHK(ThisHotkey) {
    ReaHotkey.ShowAboutBox()
}

ConfigHK(ThisHotkey) {
    ReaHotkey.ShowConfigBox()
}

PauseHK(ThisHotkey) {
    ReaHotkey.TogglePause()
    If A_IsSuspended = 1
    AccessibilityOverlay.Speak("Paused ReaHotkey")
    Else
    AccessibilityOverlay.Speak("ReaHotkey ready")
}

QuitHK(ThisHotkey) {
    AccessibilityOverlay.Speak("Quitting ReaHotkey")
    ReaHotkey.Quit()
}

ReaHotkeyMenuHK(ThisHotkey) {
    A_TrayMenu.Show()
}
