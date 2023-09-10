#Requires AutoHotkey v2.0

#HotIf WinActive("ahk_exe reaper.exe ahk_class #32770")

Tab:: {
    ReaHotkey.FoundPlugin := Plugin.GetByClass(ControlGetClassNN(ControlGetFocus(ReaHotkey.PluginWinCriteria)))
    PluginOverlay := ReaHotkey.FoundPlugin.GetOverlay()
    PluginOverlay.FocusNextControl()
}

+Tab:: {
    ReaHotkey.FoundPlugin := Plugin.GetByClass(ControlGetClassNN(ControlGetFocus(ReaHotkey.PluginWinCriteria)))
    PluginOverlay := ReaHotkey.FoundPlugin.GetOverlay()
    PluginOverlay.FocusPreviousControl()
}

^Tab:: {
    ReaHotkey.FoundPlugin := Plugin.GetByClass(ControlGetClassNN(ControlGetFocus(ReaHotkey.PluginWinCriteria)))
    PluginOverlay := ReaHotkey.FoundPlugin.GetOverlay()
    ReaHotkey.FocusNextTab(PluginOverlay)
}

^+Tab:: {
    ReaHotkey.FoundPlugin := Plugin.GetByClass(ControlGetClassNN(ControlGetFocus(ReaHotkey.PluginWinCriteria)))
    PluginOverlay := ReaHotkey.FoundPlugin.GetOverlay()
    ReaHotkey.FocusPreviousTab(PluginOverlay)
}

~Right:: {
    ReaHotkey.FoundPlugin := Plugin.GetByClass(ControlGetClassNN(ControlGetFocus(ReaHotkey.PluginWinCriteria)))
    PluginOverlay := ReaHotkey.FoundPlugin.GetOverlay()
    PluginOverlay.FocusNextTab()
}

~Left:: {
    ReaHotkey.FoundPlugin := Plugin.GetByClass(ControlGetClassNN(ControlGetFocus(ReaHotkey.PluginWinCriteria)))
    PluginOverlay := ReaHotkey.FoundPlugin.GetOverlay()
    PluginOverlay.FocusPreviousTab()
}

~Up::
~Down:: {
    ReaHotkey.FoundPlugin := Plugin.GetByClass(ControlGetClassNN(ControlGetFocus(ReaHotkey.PluginWinCriteria)))
    PluginOverlay := ReaHotkey.FoundPlugin.GetOverlay()
    If PluginOverlay.GetCurrentControl() Is Object And PluginOverlay.GetCurrentControl().ControlType = "ComboBox"
    PluginOverlay.GetCurrentControl().Focus(PluginOverlay.GetCurrentControl().ControlID, 1)
}

~Enter::
~Space:: {
    ReaHotkey.FoundPlugin := Plugin.GetByClass(ControlGetClassNN(ControlGetFocus(ReaHotkey.PluginWinCriteria)))
    PluginOverlay := ReaHotkey.FoundPlugin.GetOverlay()
    PluginOverlay.ActivateCurrentControl()
}

~Ctrl:: {
    AccessibilityOverlay.StopSpeech()
}
