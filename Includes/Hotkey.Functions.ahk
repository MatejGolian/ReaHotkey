#Requires AutoHotkey v2.0

F6HK(ThisHotkey) {
    Thread "NoTimers"
    Controls := WinGetControls(ReaHotkey.PluginWinCriteria)
    If ReaHotkey.AbletonPlugin {
        Try
        PluginControl := ReaHotkey.GetPluginControl()
        Catch
        PluginControl := 0
        If PluginControl {
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
    ReaHotkey.PassThroughHotkey(ThisHotkey)
}

TabHK(ThisHotkey) {
    Thread "NoTimers"
    If Not ReaHotkey.Context = False
    Try
    If ReaHotkey.Context = "Plugin"
    ReaHotkey.FoundPlugin := Plugin.GetByWinTitle(WinGetTitle("A"))
    Else
    ReaHotkey.FoundStandalone := Standalone.GetByWinID(WinGetID("A"))
    Catch
    ReaHotkey.Found%ReaHotkey.Context% := False
    If Not ReaHotkey.Context = False And ReaHotkey.Found%ReaHotkey.Context% Is %ReaHotkey.Context%
    ReaHotkey.Found%ReaHotkey.Context%.Overlay.FocusNextControl()
}

ShiftTabHK(ThisHotkey) {
    Thread "NoTimers"
    If Not ReaHotkey.Context = False
    Try
    If ReaHotkey.Context = "Plugin"
    ReaHotkey.FoundPlugin := Plugin.GetByWinTitle(WinGetTitle("A"))
    Else
    ReaHotkey.FoundStandalone := Standalone.GetByWinID(WinGetID("A"))
    Catch
    ReaHotkey.Found%ReaHotkey.Context% := False
    If Not ReaHotkey.Context = False And ReaHotkey.Found%ReaHotkey.Context% Is %ReaHotkey.Context%
    ReaHotkey.Found%ReaHotkey.Context%.Overlay.FocusPreviousControl()
}

ControlTabHK(ThisHotkey) {
    Thread "NoTimers"
    If Not ReaHotkey.Context = False
    Try
    If ReaHotkey.Context = "Plugin"
    ReaHotkey.FoundPlugin := Plugin.GetByWinTitle(WinGetTitle("A"))
    Else
    ReaHotkey.FoundStandalone := Standalone.GetByWinID(WinGetID("A"))
    Catch
    ReaHotkey.Found%ReaHotkey.Context% := False
    If Not ReaHotkey.Context = False And ReaHotkey.Found%ReaHotkey.Context% Is %ReaHotkey.Context%
    FocusNextPreviousTab("Next", ReaHotkey.Found%ReaHotkey.Context%.Overlay)
}

ControlShiftTabHK(ThisHotkey) {
    Thread "NoTimers"
    If Not ReaHotkey.Context = False
    Try
    If ReaHotkey.Context = "Plugin"
    ReaHotkey.FoundPlugin := Plugin.GetByWinTitle(WinGetTitle("A"))
    Else
    ReaHotkey.FoundStandalone := Standalone.GetByWinID(WinGetID("A"))
    Catch
    ReaHotkey.Found%ReaHotkey.Context% := False
    If Not ReaHotkey.Context = False And ReaHotkey.Found%ReaHotkey.Context% Is %ReaHotkey.Context%
    FocusNextPreviousTab("Previous", ReaHotkey.Found%ReaHotkey.Context%.Overlay)
}

LeftRightHK(ThisHotkey) {
    Thread "NoTimers"
    If Not ReaHotkey.Context = False
    Try
    If ReaHotkey.Context = "Plugin"
    ReaHotkey.FoundPlugin := Plugin.GetByWinTitle(WinGetTitle("A"))
    Else
    ReaHotkey.FoundStandalone := Standalone.GetByWinID(WinGetID("A"))
    Catch
    ReaHotkey.Found%ReaHotkey.Context% := False
    If Not ReaHotkey.Context = False And ReaHotkey.Found%ReaHotkey.Context% Is %ReaHotkey.Context%
    Switch(ReaHotkey.Found%ReaHotkey.Context%.Overlay.GetCurrentControlType()) {
        Case "Custom":
        ReaHotkey.Found%ReaHotkey.Context%.Overlay.Focus(False)
        Case "Edit":
        ReaHotkey.PassThroughHotkey(ThisHotkey)
        Case "Slider":
        If ThisHotkey = "Left"
        ReaHotkey.Found%ReaHotkey.Context%.Overlay.DecreaseSlider()
        Else
        ReaHotkey.Found%ReaHotkey.Context%.Overlay.IncreaseSlider()
        Case "TabControl":
        If ThisHotkey = "Left"
        ReaHotkey.Found%ReaHotkey.Context%.Overlay.FocusPreviousTab()
        Else
        ReaHotkey.Found%ReaHotkey.Context%.Overlay.FocusNextTab()
    }
}

UpDownHK(ThisHotkey) {
    Thread "NoTimers"
    If Not ReaHotkey.Context = False
    Try
    If ReaHotkey.Context = "Plugin"
    ReaHotkey.FoundPlugin := Plugin.GetByWinTitle(WinGetTitle("A"))
    Else
    ReaHotkey.FoundStandalone := Standalone.GetByWinID(WinGetID("A"))
    Catch
    ReaHotkey.Found%ReaHotkey.Context% := False
    If Not ReaHotkey.Context = False And ReaHotkey.Found%ReaHotkey.Context% Is %ReaHotkey.Context%
    Switch(ReaHotkey.Found%ReaHotkey.Context%.Overlay.GetCurrentControlType()) {
        Case "ComboBox":
        If ThisHotkey = "Up"
        ReaHotkey.Found%ReaHotkey.Context%.Overlay.SelectPreviousOption()
        Else
        ReaHotkey.Found%ReaHotkey.Context%.Overlay.SelectNextOption()
        Case "Custom":
        ReaHotkey.Found%ReaHotkey.Context%.Overlay.Focus(False)
        Case "Edit":
        ReaHotkey.PassThroughHotkey(ThisHotkey)
        Case "Slider":
        If ThisHotkey = "Down"
        ReaHotkey.Found%ReaHotkey.Context%.Overlay.DecreaseSlider()
        Else
        ReaHotkey.Found%ReaHotkey.Context%.Overlay.IncreaseSlider()
    }
}

EnterSpaceHK(ThisHotkey) {
    Thread "NoTimers"
    If Not ReaHotkey.Context = False
    Try
    If ReaHotkey.Context = "Plugin"
    ReaHotkey.FoundPlugin := Plugin.GetByWinTitle(WinGetTitle("A"))
    Else
    ReaHotkey.FoundStandalone := Standalone.GetByWinID(WinGetID("A"))
    Catch
    ReaHotkey.Found%ReaHotkey.Context% := False
    If Not ReaHotkey.Context = False And ReaHotkey.Found%ReaHotkey.Context% Is %ReaHotkey.Context%
    Switch(ReaHotkey.Found%ReaHotkey.Context%.Overlay.GetCurrentControlType()) {
        Case "Edit":
        ReaHotkey.PassThroughHotkey(ThisHotkey)
        Case "Focusable":
        ReaHotkey.PassThroughHotkey(ThisHotkey)
        Default:
        ReaHotkey.Found%ReaHotkey.Context%.Overlay.ActivateCurrentControl()
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
                    Overlay.FocusControl(SuperordinateControl.ControlID)
                    Sleep 200
                    Overlay.Focus%Which%Tab()
                    Break
                }
                CurrentControl := SuperordinateControl
            }
        }
    }
}
