#Requires AutoHotkey v2.0

#HotIf WinActive("ahk_exe reaper.exe ahk_class #32770")

F6:: {
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
        Hotkey A_ThisHotkey, "Off"
        Send "{" . A_ThisHotkey . "}"
        Hotkey A_ThisHotkey, "On"
    }
}

Tab:: {
    Thread "NoTimers"
    Try
    ReaHotkey.FoundPlugin := Plugin.GetByClass(ReaHotkey.GetPluginControl())
    Catch
    ReaHotkey.FoundPlugin := False
    If ReaHotkey.FoundPlugin Is Plugin {
        PluginOverlay := ReaHotkey.FoundPlugin.GetOverlay()
        PluginOverlay.FocusNextControl()
    }
}

+Tab:: {
    Thread "NoTimers"
    Try
    ReaHotkey.FoundPlugin := Plugin.GetByClass(ReaHotkey.GetPluginControl())
    Catch
    ReaHotkey.FoundPlugin := False
    If ReaHotkey.FoundPlugin Is Plugin {
        PluginOverlay := ReaHotkey.FoundPlugin.GetOverlay()
        PluginOverlay.FocusPreviousControl()
    }
}

^Tab:: {
    Thread "NoTimers"
    Try
    ReaHotkey.FoundPlugin := Plugin.GetByClass(ReaHotkey.GetPluginControl())
    Catch
    ReaHotkey.FoundPlugin := False
    If ReaHotkey.FoundPlugin Is Plugin {
        PluginOverlay := ReaHotkey.FoundPlugin.GetOverlay()
        ReaHotkey.FocusNextTab(PluginOverlay)
    }
}

^+Tab:: {
    Thread "NoTimers"
    Try
    ReaHotkey.FoundPlugin := Plugin.GetByClass(ReaHotkey.GetPluginControl())
    Catch
    ReaHotkey.FoundPlugin := False
    If ReaHotkey.FoundPlugin Is Plugin {
        PluginOverlay := ReaHotkey.FoundPlugin.GetOverlay()
        ReaHotkey.FocusPreviousTab(PluginOverlay)
    }
}

Right::
Left:: {
    Thread "NoTimers"
    Try
    ReaHotkey.FoundPlugin := Plugin.GetByClass(ReaHotkey.GetPluginControl())
    Catch
    ReaHotkey.FoundPlugin := False
    If ReaHotkey.FoundPlugin Is Plugin {
        PluginOverlay := ReaHotkey.FoundPlugin.GetOverlay()
        Switch(PluginOverlay.GetCurrentControlType()) {
            Case "TabControl":
            Hotkey A_ThisHotkey, "Off"
            Send "{" . A_ThisHotkey . "}"
            If A_ThisHotkey = "Left"
            PluginOverlay.FocusPreviousTab()
            Else
            PluginOverlay.FocusNextTab()
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
    ReaHotkey.FoundPlugin := Plugin.GetByClass(ReaHotkey.GetPluginControl())
    Catch
    ReaHotkey.FoundPlugin := False
    If ReaHotkey.FoundPlugin Is Plugin {
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
}

Enter::
Space:: {
    Thread "NoTimers"
    Try
    ReaHotkey.FoundPlugin := Plugin.GetByClass(ReaHotkey.GetPluginControl())
    Catch
    ReaHotkey.FoundPlugin := False
    If ReaHotkey.FoundPlugin Is Plugin {
        PluginOverlay := ReaHotkey.FoundPlugin.GetOverlay()
        Switch(PluginOverlay.GetCurrentControlType()) {
            Case "Edit":
            Hotkey A_ThisHotkey, "Off"
            Send "{" . A_ThisHotkey . "}"
            Hotkey A_ThisHotkey, "On"
            Case "Native":
            Hotkey A_ThisHotkey, "Off"
            Send "{" . A_ThisHotkey . "}"
            PluginOverlay.ActivateCurrentControl()
            Hotkey A_ThisHotkey, "On"
            Case "UIA":
            Hotkey A_ThisHotkey, "Off"
            Send "{" . A_ThisHotkey . "}"
            PluginOverlay.ActivateCurrentControl()
            Hotkey A_ThisHotkey, "On"
            Default:
            PluginOverlay.ActivateCurrentControl()
        }
    }
}

Ctrl:: {
    Thread "NoTimers"
    AccessibilityOverlay.StopSpeech()
}
