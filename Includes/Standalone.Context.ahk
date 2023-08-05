#Requires AutoHotkey v2.0

#HotIf

Tab:: {
    Global FoundStandalone
    FoundStandalone := Standalone.GetByWindowID(WinGetID("A"))
    StandaloneOverlay := FoundStandalone.GetOverlay()
    StandaloneOverlay.FocusNextControl()
}

+Tab:: {
    Global FoundStandalone
    FoundStandalone := Standalone.GetByWindowID(WinGetID("A"))
    StandaloneOverlay := FoundStandalone.GetOverlay()
    StandaloneOverlay.FocusPreviousControl()
}

^Tab::
Right:: {
    Global FoundStandalone
    FoundStandalone := Standalone.GetByWindowID(WinGetID("A"))
    StandaloneOverlay := FoundStandalone.GetOverlay()
    StandaloneOverlay.FocusNextTab()
}

^+Tab::
Left:: {
    Global FoundStandalone
    FoundStandalone := Standalone.GetByWindowID(WinGetID("A"))
    StandaloneOverlay := FoundStandalone.GetOverlay()
    StandaloneOverlay.FocusPreviousTab()
}

Enter::
Space:: {
    Global FoundStandalone
    FoundStandalone := Standalone.GetByWindowID(WinGetID("A"))
    StandaloneOverlay := FoundStandalone.GetOverlay()
    StandaloneOverlay.ActivateCurrentControl()
}

Ctrl:: {
    AccessibilityOverlay.StopSpeech()
}

^R:: {
    Global FoundStandalone
    FoundStandalone := Standalone.GetByWindowID(WinGetID("A"))
    StandaloneOverlay := FoundStandalone.GetOverlay()
    StandaloneOverlay.Reset()
    AccessibilityOverlay.Speak(StandaloneOverlay.Label . " overlay reset")
}
