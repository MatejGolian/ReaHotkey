#Requires AutoHotkey v2.0

#HotIf WinActive("ahk_exe reaper.exe ahk_class #32770")

Tab:: {
    Global FoundPlugin
    FoundPlugin := Plugin.GetByClass(ControlGetClassNN(ControlGetFocus(PluginWinCriteria)))
    PluginOverlay := FoundPlugin.GetOverlay()
    PluginOverlay.FocusNextControl()
}

+Tab:: {
    Global FoundPlugin
    FoundPlugin := Plugin.GetByClass(ControlGetClassNN(ControlGetFocus(PluginWinCriteria)))
    PluginOverlay := FoundPlugin.GetOverlay()
    PluginOverlay.FocusPreviousControl()
}

^Tab:: {
    Global FoundPlugin
    FoundPlugin := Plugin.GetByClass(ControlGetClassNN(ControlGetFocus(PluginWinCriteria)))
    PluginOverlay := FoundPlugin.GetOverlay()
    FocusNextTab(PluginOverlay)
}

^+Tab:: {
    Global FoundPlugin
    FoundPlugin := Plugin.GetByClass(ControlGetClassNN(ControlGetFocus(PluginWinCriteria)))
    PluginOverlay := FoundPlugin.GetOverlay()
    FocusPreviousTab(PluginOverlay)
}

~Right:: {
    Global FoundPlugin
    FoundPlugin := Plugin.GetByClass(ControlGetClassNN(ControlGetFocus(PluginWinCriteria)))
    PluginOverlay := FoundPlugin.GetOverlay()
    PluginOverlay.FocusNextTab()
}

~Left:: {
    Global FoundPlugin
    FoundPlugin := Plugin.GetByClass(ControlGetClassNN(ControlGetFocus(PluginWinCriteria)))
    PluginOverlay := FoundPlugin.GetOverlay()
    PluginOverlay.FocusPreviousTab()
}

~Up::
~Down:: {
    Global FoundPlugin
    FoundPlugin := Plugin.GetByClass(ControlGetClassNN(ControlGetFocus(PluginWinCriteria)))
    PluginOverlay := FoundPlugin.GetOverlay()
    If PluginOverlay.GetCurrentControl() Is Object And PluginOverlay.GetCurrentControl().ControlType == "ComboBox"
    PluginOverlay.GetCurrentControl().Focus(PluginOverlay.GetCurrentControl().ControlID, 1)
}

~Enter::
~Space:: {
    Global FoundPlugin
    FoundPlugin := Plugin.GetByClass(ControlGetClassNN(ControlGetFocus(PluginWinCriteria)))
    PluginOverlay := FoundPlugin.GetOverlay()
    PluginOverlay.ActivateCurrentControl()
}

~Ctrl:: {
    AccessibilityOverlay.StopSpeech()
}
