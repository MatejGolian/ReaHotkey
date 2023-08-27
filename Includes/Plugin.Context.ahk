#Requires AutoHotkey v2.0

#HotIf WinActive("ahk_exe reaper.exe ahk_class #32770")

F6::
PluginFocusPluginControlHK(ThisHotkey) {
    Global FoundPlugin
    If ControlGetFocus(PluginWinCriteria) != 0
    If Plugin.FindClass(ControlGetClassNN(ControlGetFocus(PluginWinCriteria))) {
        Send "{F6}"
    }
    Else If GetPluginControl() {
        ControlFocus(GetPluginControl(), PluginWinCriteria)
        FoundPlugin := Plugin.GetByClass(ControlGetClassNN(ControlGetFocus(PluginWinCriteria)))
        FoundPlugin.Focus()
    }
    Else {
        Send "{F6}"
    }
    Send "{F6}"
}

Tab::
PluginNextControlHK(ThisHotkey) {
    Global FoundPlugin
    FoundPlugin := Plugin.GetByClass(ControlGetClassNN(ControlGetFocus(PluginWinCriteria)))
    PluginOverlay := FoundPlugin.GetOverlay()
    PluginOverlay.FocusNextControl()
}

+Tab::
PluginPreviousControlHK(ThisHotkey) {
    Global FoundPlugin
    FoundPlugin := Plugin.GetByClass(ControlGetClassNN(ControlGetFocus(PluginWinCriteria)))
    PluginOverlay := FoundPlugin.GetOverlay()
    PluginOverlay.FocusPreviousControl()
}

^Tab::
PluginNextTabHK1(ThisHotkey) {
    Global FoundPlugin
    FoundPlugin := Plugin.GetByClass(ControlGetClassNN(ControlGetFocus(PluginWinCriteria)))
    PluginOverlay := FoundPlugin.GetOverlay()
    FocusNextTab(PluginOverlay)
}

^+Tab::
PluginPreviousTabHK1(ThisHotkey) {
    Global FoundPlugin
    FoundPlugin := Plugin.GetByClass(ControlGetClassNN(ControlGetFocus(PluginWinCriteria)))
    PluginOverlay := FoundPlugin.GetOverlay()
    FocusPreviousTab(PluginOverlay)
}

Right::
PluginNextTabHK2(ThisHotkey) {
    Global FoundPlugin
    FoundPlugin := Plugin.GetByClass(ControlGetClassNN(ControlGetFocus(PluginWinCriteria)))
    PluginOverlay := FoundPlugin.GetOverlay()
    PluginOverlay.FocusNextTab()
}

Left::
PluginPreviousTabHK2(ThisHotkey) {
    Global FoundPlugin
    FoundPlugin := Plugin.GetByClass(ControlGetClassNN(ControlGetFocus(PluginWinCriteria)))
    PluginOverlay := FoundPlugin.GetOverlay()
    PluginOverlay.FocusPreviousTab()
}

~Up::
~Down::
PluginChangeComboBoxValueHK(ThisHotkey) {
    Global FoundPlugin
    FoundPlugin := Plugin.GetByClass(ControlGetClassNN(ControlGetFocus(PluginWinCriteria)))
    PluginOverlay := FoundPlugin.GetOverlay()
    If PluginOverlay.GetCurrentControl().ControlType == "ComboBox"
    PluginOverlay.GetCurrentControl().Focus(PluginOverlay.GetCurrentControl().ControlID, 1)
}

Enter::
Space::
PluginActivateControlHK(ThisHotkey) {
    Global FoundPlugin
    FoundPlugin := Plugin.GetByClass(ControlGetClassNN(ControlGetFocus(PluginWinCriteria)))
    PluginOverlay := FoundPlugin.GetOverlay()
    PluginOverlay.ActivateCurrentControl()
}

Ctrl::
PluginStopSpeechHK(ThisHotkey) {
    Global FoundPlugin
    AccessibilityOverlay.StopSpeech()
}
