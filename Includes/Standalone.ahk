#Requires AutoHotkey v2.0

#HotIf

Tab:: {
    Global FoundStandalone
    FoundStandalone := Standalone.Get(StandaloneWinCriteria, WinGetID("A"))
    StandaloneOverlay := FoundStandalone.GetOverlay()
    StandaloneOverlay.FocusNextControl()
}

+Tab:: {
    Global FoundStandalone
    FoundStandalone := Standalone.Get(StandaloneWinCriteria, WinGetID("A"))
    StandaloneOverlay := FoundStandalone.GetOverlay()
    StandaloneOverlay.FocusPreviousControl()
}

Right:: {
    Global FoundStandalone
    FoundStandalone := Standalone.Get(StandaloneWinCriteria, WinGetID("A"))
    StandaloneOverlay := FoundStandalone.GetOverlay()
    StandaloneOverlay.FocusNextTab()
}

^Tab:: {
    Global FoundStandalone
    FoundStandalone := Standalone.Get(StandaloneWinCriteria, WinGetID("A"))
    StandaloneOverlay := FoundStandalone.GetOverlay()
    StandaloneOverlay.FocusNextTab()
}

Left:: {
    Global FoundStandalone
    FoundStandalone := Standalone.Get(StandaloneWinCriteria, WinGetID("A"))
    StandaloneOverlay := FoundStandalone.GetOverlay()
    StandaloneOverlay.FocusPreviousTab()
}

^+Tab:: {
    Global FoundStandalone
    FoundStandalone := Standalone.Get(StandaloneWinCriteria, WinGetID("A"))
    StandaloneOverlay := FoundStandalone.GetOverlay()
    StandaloneOverlay.FocusPreviousTab()
}

Space:: {
    Global FoundStandalone
    FoundStandalone := Standalone.Get(StandaloneWinCriteria, WinGetID("A"))
    StandaloneOverlay := FoundStandalone.GetOverlay()
    StandaloneOverlay.ActivateCurrentControl()
}

Enter:: {
    Global FoundStandalone
    FoundStandalone := Standalone.Get(StandaloneWinCriteria, WinGetID("A"))
    StandaloneOverlay := FoundStandalone.GetOverlay()
    StandaloneOverlay.ActivateCurrentControl()
}

Ctrl:: {
    AccessibilityOverlay.StopSpeech()
}

^R:: {
    Global FoundStandalone
    FoundStandalone := Standalone.Get(StandaloneWinCriteria, WinGetID("A"))
    StandaloneOverlay := FoundStandalone.GetOverlay()
    StandaloneOverlay.Reset()
    AccessibilityOverlay.Speak(StandaloneOverlay.Label . " overlay reset")
}
