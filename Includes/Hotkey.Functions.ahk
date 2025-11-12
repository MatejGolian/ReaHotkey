#Requires AutoHotkey v2.0

F6HK(ThisHotkey) {
    Thread "NoTimers"
    If Not ReaHotkey.FocusPluginControl()
    PassThroughHotkey(ThisHotkey)
}

TabHK(ThisHotkey) {
    Thread "NoTimers"
    Context := ReaHotkey.GetContext()
    If Context {
        ReaHotkey.Found%Context%.Overlay.FocusNextControl()
        Return
    }
    PassThroughHotkey(ThisHotkey)
}

ShiftTabHK(ThisHotkey) {
    Thread "NoTimers"
    Context := ReaHotkey.GetContext()
    If Context {
        ReaHotkey.Found%Context%.Overlay.FocusPreviousControl()
        Return
    }
    PassThroughHotkey(ThisHotkey)
}

ControlTabHK(ThisHotkey) {
    Thread "NoTimers"
    Context := ReaHotkey.GetContext()
    If Context {
        FocusNextPreviousTab("Next", ReaHotkey.Found%Context%.Overlay)
        Return
    }
    PassThroughHotkey(ThisHotkey)
}

ControlShiftTabHK(ThisHotkey) {
    Thread "NoTimers"
    Context := ReaHotkey.GetContext()
    If Context {
        FocusNextPreviousTab("Previous", ReaHotkey.Found%Context%.Overlay)
        Return
    }
    PassThroughHotkey(ThisHotkey)
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
            ReaHotkey.Found%Context%.Overlay.FocusPreviousTab(False)
            Else
            ReaHotkey.Found%Context%.Overlay.FocusNextTab(False)
        }
        Return
    }
    PassThroughHotkey(ThisHotkey)
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
        Return
    }
    PassThroughHotkey(ThisHotkey)
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
        Return
    }
    PassThroughHotkey(ThisHotkey)
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
                    Overlay.FocusControlID(SuperordinateControl.ControlID)
                    Sleep 200
                    Overlay.Focus%Which%Tab(True)
                    Break
                }
                CurrentControl := SuperordinateControl
            }
        }
    }
}

HotkeyWait(ThisHotkey) {
    Stripped := RegExReplace(ThisHotkey, "i)[$~*]{0,3}(.*)", "$1")
    RegExMatch(Stripped, "i)(?:([<>!^#+]+)|(?:(\S+) +& +))?(\S+)", &M)
    Keys := array()
    If M[1] {
        Index := 1
        Loop StrLen(M[1]) {
            Str := SubStr(M[1], Index++, 1)
            LR := ""
            (Str = "<") && LR := "L"
            (Str = ">") && LR := "R"
            Switch LR ? SubStr(M[1], Index++, 1) : Str {
                Case "!":
                Keys.Push(LR "Alt")
                Case "^":
                Keys.Push(LR "Ctrl")
                Case "+":
                Keys.Push(LR "Shift")
                Case "#":
                Keys.Push((LR||"L") "Win")
            }
        }
        } Else If M[2] {
            Keys.Push(M[2])
        }
        Keys.Push(M[3])
        For K in Keys {
            KeyWait K
        }
}

PassThroughHotkey(ThisHotkey) {
    Match := RegExMatch(ThisHotkey, "[a-zA-Z]")
    If Match > 0 {
        Modifiers := SubStr(ThisHotkey, 1, Match - 1)
        KeyName := SubStr(ThisHotkey, Match)
        If StrLen(KeyName) > 1
        KeyName := "{" . KeyName . "}"
        Try
        Hotkey ThisHotkey, "Off"
        Send Modifiers . KeyName
        Try
        Hotkey ThisHotkey, "On"
    }
}
