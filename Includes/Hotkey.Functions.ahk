#Requires AutoHotkey v2.0

AboutHK(ThisHotkey) {
    ReaHotkey.ShowAboutBox()
}

AppsKeyEmulatorHK(ThisHotkey) {
    ReaHotkey.ToggleAppsKeyEmulator()
    AccessibilityOverlay.ClearSpeechQueue()
    If ReaHotkey.Config.Get("Config", "AppsKeyEmulator")
    AccessibilityOverlay.Speak("Enabled AppsKey Emulator")
    Else
    AccessibilityOverlay.Speak("Disabled AppsKey Emulator")
}

ConfigHK(ThisHotkey) {
    ReaHotkey.ShowConfigBox()
}

ControlHK(ThisHotkey) {
    Thread "NoTimers"
    AccessibilityOverlay.StopSpeech()
}

ControlShiftTabHK(ThisHotkey) {
    Thread "NoTimers"
    Context := ReaHotkey.GetContext()
    If Context {
        AccessibilityOverlay.Helpers.PassThroughHotkey(ThisHotkey)
        FocusNextPreviousTab("Previous", ReaHotkey.Found%Context%.Overlay)
        Return
    }
    AccessibilityOverlay.Helpers.PassThroughHotkey(ThisHotkey)
}

ControlTabHK(ThisHotkey) {
    Thread "NoTimers"
    Context := ReaHotkey.GetContext()
    If Context {
        AccessibilityOverlay.Helpers.PassThroughHotkey(ThisHotkey)
        FocusNextPreviousTab("Next", ReaHotkey.Found%Context%.Overlay)
        Return
    }
    AccessibilityOverlay.Helpers.PassThroughHotkey(ThisHotkey)
}

EnterSpaceHK(ThisHotkey) {
    Thread "NoTimers"
    Context := ReaHotkey.GetContext()
    If Context {
        Switch(ReaHotkey.Found%Context%.Overlay.GetCurrentControlType()) {
            Case "Edit":
            AccessibilityOverlay.Helpers.PassThroughHotkey(ThisHotkey)
            Case "Focusable":
            AccessibilityOverlay.Helpers.PassThroughHotkey(ThisHotkey)
            Default:
            ReaHotkey.Found%Context%.Overlay.ActivateCurrentControl()
        }
        Return
    }
    AccessibilityOverlay.Helpers.PassThroughHotkey(ThisHotkey)
}

F6HK(ThisHotkey) {
    Thread "NoTimers"
    If Not ReaHotkey.FocusPluginControl()
    AccessibilityOverlay.Helpers.PassThroughHotkey(ThisHotkey)
}

FocusNextPreviousTab(Which, Overlay) {
    If Overlay Is AccessibilityOverlay And Overlay.ChildControls.Length > 0 {
        CurrentControl := Overlay.GetCurrentControl()
        If CurrentControl Is TabControl {
            Sleep 200
            Overlay.Focus%Which%Tab(True)
        }
        Else {
            If CurrentControl Is Object
            Loop AccessibilityOverlay.TotalNumberOfControls {
                SuperordinateControl := CurrentControl.SuperordinateControl
                If SuperordinateControl = 0
                Break
                If SuperordinateControl Is TabControl {
                    Overlay.SetCurrentControlID(SuperordinateControl.ControlID)
                    Overlay.FocusControlByID(SuperordinateControl.ControlID)
                    Sleep 200
                    Overlay.Focus%Which%Tab(True)
                    Break
                }
                CurrentControl := SuperordinateControl
            }
        }
    }
}

LeftRightHK(ThisHotkey) {
    Thread "NoTimers"
    Context := ReaHotkey.GetContext()
    If Context {
        AccessibilityOverlay.Helpers.PassThroughHotkey(ThisHotkey)
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
            ReaHotkey.Found%Context%.Overlay.FocusPreviousTab(False)
            Else
            ReaHotkey.Found%Context%.Overlay.FocusNextTab(False)
        }
        Return
    }
    AccessibilityOverlay.Helpers.PassThroughHotkey(ThisHotkey)
}
ReadmeHK(ThisHotkey) {
    ReaHotkey.ViewReadme()
}

PauseHK(ThisHotkey) {
    ReaHotkey.TogglePause()
    AccessibilityOverlay.ClearSpeechQueue()
    If A_IsSuspended = 1
    AccessibilityOverlay.Speak("Paused ReaHotkey")
    Else
    AccessibilityOverlay.Speak("ReaHotkey ready")
}

QuitHK(ThisHotkey) {
    AccessibilityOverlay.ClearSpeechQueue()
    AccessibilityOverlay.Speak("Quitting ReaHotkey")
    ReaHotkey.Quit()
}

ReaHotkeyMenuHK(ThisHotkey) {
    A_TrayMenu.Show()
}

ReloadHK(ThisHotkey) {
    ReaHotkey.Reload()
}

ShiftTabHK(ThisHotkey) {
    Thread "NoTimers"
    Context := ReaHotkey.GetContext()
    If Context {
        ReaHotkey.Found%Context%.Overlay.FocusPreviousControl()
        Return
    }
    AccessibilityOverlay.Helpers.PassThroughHotkey(ThisHotkey)
}

TabHK(ThisHotkey) {
    Thread "NoTimers"
    Context := ReaHotkey.GetContext()
    If Context {
        ReaHotkey.Found%Context%.Overlay.FocusNextControl()
        Return
    }
    AccessibilityOverlay.Helpers.PassThroughHotkey(ThisHotkey)
}

UpdateCheckHK(ThisHotkey) {
    ReaHotkey.CheckForUpdates(True)
}

UpDownHK(ThisHotkey) {
    Thread "NoTimers"
    Context := ReaHotkey.GetContext()
    If Context {
        AccessibilityOverlay.Helpers.PassThroughHotkey(ThisHotkey)
        Switch(ReaHotkey.Found%Context%.Overlay.GetCurrentControlType()) {
            Case "ListBox":
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
        Return
    }
    AccessibilityOverlay.Helpers.PassThroughHotkey(ThisHotkey)
}
