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

~Right:: {
    ReaHotkey.FoundStandalone :=  Standalone.GetByWindowID(WinGetID("A"))
    StandaloneOverlay := ReaHotkey.FoundStandalone.GetOverlay()
    StandaloneOverlay.FocusNextTab()
}

~Left:: {
    ReaHotkey.FoundStandalone :=  Standalone.GetByWindowID(WinGetID("A"))
    StandaloneOverlay := ReaHotkey.FoundStandalone.GetOverlay()
    StandaloneOverlay.FocusPreviousTab()
}

~Up::
~Down:: {
    ReaHotkey.FoundStandalone :=  Standalone.GetByWindowID(WinGetID("A"))
    StandaloneOverlay := ReaHotkey.FoundStandalone.GetOverlay()
    If StandaloneOverlay.GetCurrentControl() Is Object And StandaloneOverlay.GetCurrentControl().ControlType = "ComboBox"
    StandaloneOverlay.GetCurrentControl().Focus(StandaloneOverlay.GetCurrentControl().ControlID, 1)
}

~Enter::
~Space:: {
    ReaHotkey.FoundStandalone :=  Standalone.GetByWindowID(WinGetID("A"))
    StandaloneOverlay := ReaHotkey.FoundStandalone.GetOverlay()
    StandaloneOverlay.ActivateCurrentControl()
}

~Ctrl:: {
    AccessibilityOverlay.StopSpeech()
}
