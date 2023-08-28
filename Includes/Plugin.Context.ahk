#Requires AutoHotkey v2.0

#HotIf WinActive("ahk_exe reaper.exe ahk_class #32770")

F6:: {
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
    Global FoundPlugin
    AccessibilityOverlay.StopSpeech()
}
