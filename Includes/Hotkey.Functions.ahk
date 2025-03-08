#Requires AutoHotkey v2.0

F6HK(ThisHotkey) {
    Thread "NoTimers"
    Controls := WinGetControls(ReaHotkey.PluginWinCriteria)
    If ReaHotkey.AbletonPlugin {
        Try
        CurrentControl := ControlGetClassNN(ControlGetFocus(ReaHotkey.PluginWinCriteria))
        Catch
        CurrentControl := 0
        Try
        PluginControl := ReaHotkey.GetPluginControl()
        Catch
        PluginControl := 0
        If PluginControl
        If Not PluginControl = CurrentControl {
            Try
            ControlFocus Controls[1], ReaHotkey.PluginWinCriteria
            Return
        }
    }
    If ReaHotkey.ReaperPlugin {
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
        If CurrentIndex > 0 And ContainerIndex > 0 And CurrentIndex <= 6 And Not CurrentIndex = ContainerIndex {
            Try
            ControlFocus Controls[ContainerIndex], ReaHotkey.PluginWinCriteria
            Return
        }
    }
    PassThroughHotkey(ThisHotkey)
}

TabHK(ThisHotkey) {
    Thread "NoTimers"
    Context := ReaHotkey.GetContext()
    If Context {
        ReaHotkey.Found%Context%.Overlay.FocusNextControl()
    }
}

ShiftTabHK(ThisHotkey) {
    Thread "NoTimers"
    Context := ReaHotkey.GetContext()
    If Context {
        ReaHotkey.Found%Context%.Overlay.FocusPreviousControl()
    }
}

ControlTabHK(ThisHotkey) {
    Thread "NoTimers"
    Context := ReaHotkey.GetContext()
    If Context {
        FocusNextPreviousTab("Next", ReaHotkey.Found%Context%.Overlay)
    }
}

ControlShiftTabHK(ThisHotkey) {
    Thread "NoTimers"
    Context := ReaHotkey.GetContext()
    If Context {
        FocusNextPreviousTab("Previous", ReaHotkey.Found%Context%.Overlay)
    }
}

LeftRightHK(ThisHotkey) {
    Thread "NoTimers"
    Context := ReaHotkey.GetContext()
    If Context {
        PassThroughHotkey(ThisHotkey)
        Switch(ReaHotkey.Found%Context%.Overlay.GetCurrentControlType()) {
            Case "Custom":
            ReaHotkey.Found%Context%.Overlay.Focus(False)
            Case "Slider":
            If ThisHotkey = "Left"
            ReaHotkey.Found%Context%.Overlay.DecreaseSlider()
            Else
            ReaHotkey.Found%Context%.Overlay.IncreaseSlider()
            Case "TabControl":
            If ThisHotkey = "Left"
            ReaHotkey.Found%Context%.Overlay.FocusPreviousTab()
            Else
            ReaHotkey.Found%Context%.Overlay.FocusNextTab()
        }
    }
}

UpDownHK(ThisHotkey) {
    Thread "NoTimers"
    Context := ReaHotkey.GetContext()
    If Context {
        PassThroughHotkey(ThisHotkey)
        Switch(ReaHotkey.Found%Context%.Overlay.GetCurrentControlType()) {
            Case "ComboBox":
            If ThisHotkey = "Up"
            ReaHotkey.Found%Context%.Overlay.SelectPreviousOption()
            Else
            ReaHotkey.Found%Context%.Overlay.SelectNextOption()
            Case "Custom":
            ReaHotkey.Found%Context%.Overlay.Focus(False)
            Case "Slider":
            If ThisHotkey = "Down"
            ReaHotkey.Found%Context%.Overlay.DecreaseSlider()
            Else
            ReaHotkey.Found%Context%.Overlay.IncreaseSlider()
        }
    }
}

EnterSpaceHK(ThisHotkey) {
    Thread "NoTimers"
    Context := ReaHotkey.GetContext()
    If Context {
        Switch(ReaHotkey.Found%Context%.Overlay.GetCurrentControlType()) {
            Case "Edit":
            PassThroughHotkey(ThisHotkey)
            Case "Focusable":
            PassThroughHotkey(ThisHotkey)
            Default:
            ReaHotkey.Found%Context%.Overlay.ActivateCurrentControl()
        }
    }
}

AboutHK(ThisHotkey) {
    ReaHotkey.ShowAboutBox()
}

ConfigHK(ThisHotkey) {
    ReaHotkey.ShowConfigBox()
}

ControlHK(ThisHotkey) {
    Thread "NoTimers"
    AccessibilityOverlay.StopSpeech()
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

ReadmeHK(ThisHotkey) {
    ReaHotkey.ViewReadme()
}

ReaHotkeyMenuHK(ThisHotkey) {
    A_TrayMenu.Show()
}

ReloadHK(ThisHotkey) {
    ReaHotkey.Reload()
}

UpdateCheckHK(ThisHotkey) {
    ReaHotkey.CheckForUpdates(True)
}

FocusNextPreviousTab(Which, Overlay) {
    If Overlay Is AccessibilityOverlay And Overlay.ChildControls.Length > 0 {
        CurrentControl := Overlay.GetCurrentControl()
        If CurrentControl Is TabControl {
            Sleep 200
            Overlay.Focus%Which%Tab()
        }
        Else {
            If CurrentControl Is Object
            Loop AccessibilityOverlay.TotalNumberOfControls {
                SuperordinateControl := CurrentControl.GetSuperordinateControl()
                If SuperordinateControl = 0
                Break
                If SuperordinateControl Is TabControl {
                    Overlay.SetCurrentControlID(SuperordinateControl.ControlID)
                    Overlay.FocusControlID(SuperordinateControl.ControlID)
                    Sleep 200
                    Overlay.Focus%Which%Tab()
                    Break
                }
                CurrentControl := SuperordinateControl
            }
        }
    }
}

PassThroughHotkey(ThisHotkey) {
    Match := RegExMatch(ThisHotkey, "[a-zA-Z]")
    If Match > 0 {
        Modifiers := SubStr(ThisHotkey, 1, Match - 1)
        KeyName := SubStr(ThisHotkey, Match)
        If StrLen(KeyName) > 1
        KeyName := "{" . KeyName . "}"
        Hotkey ThisHotkey, "Off"
        Send Modifiers . KeyName
        Hotkey ThisHotkey, "On"
    }
}
