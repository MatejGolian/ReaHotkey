#Requires AutoHotkey v2.0

#HotIf

Tab:: {
    Global FoundStandalone
    FoundStandalone := Standalone.Get(StandaloneWinCriteria, WinGetID("A"))
    StandaloneOverlay := FoundStandalone.Overlay
    StandaloneOverlay.FocusNextControl()
}

+Tab:: {
    Global FoundStandalone
    FoundStandalone := Standalone.Get(StandaloneWinCriteria, WinGetID("A"))
    StandaloneOverlay := FoundStandalone.Overlay
    StandaloneOverlay.FocusPreviousControl()
}

Right:: {
    Global FoundStandalone
    FoundStandalone := Standalone.Get(StandaloneWinCriteria, WinGetID("A"))
    StandaloneOverlay := FoundStandalone.Overlay
    StandaloneOverlay.FocusNextTab()
}

^Tab:: {
    Global FoundStandalone
    FoundStandalone := Standalone.Get(StandaloneWinCriteria, WinGetID("A"))
    StandaloneOverlay := FoundStandalone.Overlay
    StandaloneOverlay.FocusNextTab()
}

Left:: {
    Global FoundStandalone
    FoundStandalone := Standalone.Get(StandaloneWinCriteria, WinGetID("A"))
    StandaloneOverlay := FoundStandalone.Overlay
    StandaloneOverlay.FocusPreviousTab()
}

^+Tab:: {
    Global FoundStandalone
    FoundStandalone := Standalone.Get(StandaloneWinCriteria, WinGetID("A"))
    StandaloneOverlay := FoundStandalone.Overlay
    StandaloneOverlay.FocusPreviousTab()
}

Space:: {
    Global FoundStandalone
    FoundStandalone := Standalone.Get(StandaloneWinCriteria, WinGetID("A"))
    StandaloneOverlay := FoundStandalone.Overlay
    StandaloneOverlay.ActivateCurrentControl()
}

Enter:: {
    Global FoundStandalone
    FoundStandalone := Standalone.Get(StandaloneWinCriteria, WinGetID("A"))
    StandaloneOverlay := FoundStandalone.Overlay
    StandaloneOverlay.ActivateCurrentControl()
}

Ctrl:: {
    AccessibilityOverlay.StopSpeech()
}

^R:: {
    Global FoundStandalone
    FoundStandalone := Standalone.Get(StandaloneWinCriteria, WinGetID("A"))
    StandaloneOverlay := FoundStandalone.Overlay
    StandaloneOverlay.Reset()
    AccessibilityOverlay.Speak(StandaloneOverlay.Label . " overlay reset")
}
