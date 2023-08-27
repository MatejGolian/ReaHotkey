#Requires AutoHotkey v2.0

#HotIf

Tab::
StandaloneNextControlHK(ThisHotkey) {
    Global FoundStandalone
    FoundStandalone := Standalone.GetByWindowID(WinGetID("A"))
    StandaloneOverlay := FoundStandalone.GetOverlay()
    StandaloneOverlay.FocusNextControl()
}

+Tab::
StandalonePreviousControlHK(ThisHotkey) {
    Global FoundStandalone
    FoundStandalone := Standalone.GetByWindowID(WinGetID("A"))
    StandaloneOverlay := FoundStandalone.GetOverlay()
    StandaloneOverlay.FocusPreviousControl()
}

^Tab::
StandaloneNextTabHK1(ThisHotkey) {
    Global FoundStandalone
    FoundStandalone := Standalone.GetByWindowID(WinGetID("A"))
    StandaloneOverlay := FoundStandalone.GetOverlay()
    FocusNextTab(StandaloneOverlay)
}

^+Tab::
StandalonePreviousTabHK1(ThisHotkey) {
    Global FoundStandalone
    FoundStandalone := Standalone.GetByWindowID(WinGetID("A"))
    StandaloneOverlay := FoundStandalone.GetOverlay()
    FocusPreviousTab(StandaloneOverlay)
}

Right::
StandaloneNextTabHK2(ThisHotkey) {
    Global FoundStandalone
    FoundStandalone := Standalone.GetByWindowID(WinGetID("A"))
    StandaloneOverlay := FoundStandalone.GetOverlay()
    StandaloneOverlay.FocusNextTab()
}

Left::
StandalonePreviousTabHK2(ThisHotkey) {
    Global FoundStandalone
    FoundStandalone := Standalone.GetByWindowID(WinGetID("A"))
    StandaloneOverlay := FoundStandalone.GetOverlay()
    StandaloneOverlay.FocusPreviousTab()
}

~Up::
~Down::
StandaloneChangeComboBoxValueHK(ThisHotkey) {
    Global FoundStandalone
    FoundStandalone := Standalone.GetByWindowID(WinGetID("A"))
    StandaloneOverlay := FoundStandalone.GetOverlay()
    If StandaloneOverlay.GetCurrentControl().ControlType == "ComboBox"
    StandaloneOverlay.GetCurrentControl().Focus(StandaloneOverlay.GetCurrentControl().ControlID, 1)
}

Enter::
Space::
StandaloneActivateControlHK(ThisHotkey) {
    Global FoundStandalone
    FoundStandalone := Standalone.GetByWindowID(WinGetID("A"))
    StandaloneOverlay := FoundStandalone.GetOverlay()
    StandaloneOverlay.ActivateCurrentControl()
}

Ctrl::
StandaloneStopSpeechHK(ThisHotkey) {
    AccessibilityOverlay.StopSpeech()
}
