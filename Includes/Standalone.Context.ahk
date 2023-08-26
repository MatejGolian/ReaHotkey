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

^Tab:: {
    Global FoundStandalone
    FoundStandalone := Standalone.GetByWindowID(WinGetID("A"))
    StandaloneOverlay := FoundStandalone.GetOverlay()
    FocusNextTab(StandaloneOverlay)
}

^+Tab:: {
    Global FoundStandalone
    FoundStandalone := Standalone.GetByWindowID(WinGetID("A"))
    StandaloneOverlay := FoundStandalone.GetOverlay()
    FocusPreviousTab(StandaloneOverlay)
}

Right:: {
    Global FoundStandalone
    FoundStandalone := Standalone.GetByWindowID(WinGetID("A"))
    StandaloneOverlay := FoundStandalone.GetOverlay()
    StandaloneOverlay.FocusNextTab()
}

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
