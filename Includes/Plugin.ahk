#Requires AutoHotkey v2.0

#HotIf WinActive(PluginWinCriteria)

F6:: {
    Global FoundPlugin
    If ControlGetFocus(PluginWinCriteria) != 0
    If Plugin.FindClass(ControlGetClassNN(ControlGetFocus(PluginWinCriteria))) {
        Send "{F6}"
    }
    Else If GetPluginControl() {
        ControlFocus(GetPluginControl(), PluginWinCriteria)
        FoundPlugin := Plugin.GetByClass(ControlGetClassNN(ControlGetFocus(PluginWinCriteria)))
        PluginOverlay := FoundPlugin.GetOverlay()
        If PluginOverlay.Label == ""
        AccessibilityOverlay.Speak(FoundPlugin.Name . " overlay active")
        Else
        AccessibilityOverlay.Speak(PluginOverlay.Label . " overlay active")
        FoundPlugin.Focus()
        PluginOverlay.FocusCurrentControl()
    }
    Else {
        Send "{F6}"
    }
    Else
    Send "{F6}"
}

Tab:: {
    Global FoundPlugin
    If ControlGetFocus(PluginWinCriteria) != 0
    If Plugin.FindClass(ControlGetClassNN(ControlGetFocus(PluginWinCriteria))) And !WinExist("ahk_class #32768") {
        FoundPlugin := Plugin.GetByClass(ControlGetClassNN(ControlGetFocus(PluginWinCriteria)))
        PluginOverlay := FoundPlugin.GetOverlay()
        PluginOverlay.FocusNextControl()
    }
    Else {
    Send "{Tab}"
    }
    Else
    Send "{Tab}"
    }
    
    +Tab:: {
    Global FoundPlugin
    If ControlGetFocus(PluginWinCriteria) != 0
    If Plugin.FindClass(ControlGetClassNN(ControlGetFocus(PluginWinCriteria))) And !WinExist("ahk_class #32768") {
    FoundPlugin := Plugin.GetByClass(ControlGetClassNN(ControlGetFocus(PluginWinCriteria)))
    PluginOverlay := FoundPlugin.GetOverlay()
    PluginOverlay.FocusPreviousControl()
    }
    Else {
    Send "+{Tab}"
    }
    Else
    Send "+{Tab}"
    }
    
    Right:: {
    Global FoundPlugin
    If ControlGetFocus(PluginWinCriteria) != 0
    If Plugin.FindClass(ControlGetClassNN(ControlGetFocus(PluginWinCriteria))) And !WinExist("ahk_class #32768") {
    FoundPlugin := Plugin.GetByClass(ControlGetClassNN(ControlGetFocus(PluginWinCriteria)))
    PluginOverlay := FoundPlugin.GetOverlay()
    If PluginOverlay.GetCurrentControl() Is TabControl
    PluginOverlay.FocusNextTab()
    }
    Else {
    Send "{Right}"
    }
    Else
    Send "{Right}"
    }
    
    ^Tab:: {
    Global FoundPlugin
    If ControlGetFocus(PluginWinCriteria) != 0
    If Plugin.FindClass(ControlGetClassNN(ControlGetFocus(PluginWinCriteria))) And !WinExist("ahk_class #32768") {
    FoundPlugin := Plugin.GetByClass(ControlGetClassNN(ControlGetFocus(PluginWinCriteria)))
    PluginOverlay := FoundPlugin.GetOverlay()
    If PluginOverlay.GetCurrentControl() Is TabControl
    PluginOverlay.FocusNextTab()
    }
    Else {
    Send "^{Tab}"
    }
    Else
    Send "^{Tab}"
    }
    
    Left:: {
    Global FoundPlugin
    If ControlGetFocus(PluginWinCriteria) != 0
    If Plugin.FindClass(ControlGetClassNN(ControlGetFocus(PluginWinCriteria))) And !WinExist("ahk_class #32768") {
    FoundPlugin := Plugin.GetByClass(ControlGetClassNN(ControlGetFocus(PluginWinCriteria)))
    PluginOverlay := FoundPlugin.GetOverlay()
    If PluginOverlay.GetCurrentControl() Is TabControl
    PluginOverlay.FocusPreviousTab()
    }
    Else {
    Send "{Left}"
    }
    Else
    Send "{Left}"
    }
    
    ^+Tab:: {
    Global FoundPlugin
    If ControlGetFocus(PluginWinCriteria) != 0
    If Plugin.FindClass(ControlGetClassNN(ControlGetFocus(PluginWinCriteria))) And !WinExist("ahk_class #32768") {
    FoundPlugin := Plugin.GetByClass(ControlGetClassNN(ControlGetFocus(PluginWinCriteria)))
    PluginOverlay := FoundPlugin.GetOverlay()
    If PluginOverlay.GetCurrentControl() Is TabControl
    PluginOverlay.FocusPreviousTab()
    }
    Else {
    Send "^+{Tab}"
    }
    Else
    Send "^+{Tab}"
    }
    
    Space:: {
    Global FoundPlugin
    If ControlGetFocus(PluginWinCriteria) != 0
    If Plugin.FindClass(ControlGetClassNN(ControlGetFocus(PluginWinCriteria))) And !WinExist("ahk_class #32768") {
    FoundPlugin := Plugin.GetByClass(ControlGetClassNN(ControlGetFocus(PluginWinCriteria)))
    PluginOverlay := FoundPlugin.GetOverlay()
    PluginOverlay.ActivateCurrentControl()
    }
    Else {
    Send "{Space}"
    }
    Else
    Send "{Space}"
    }
    
    Enter:: {
    Global FoundPlugin
    If ControlGetFocus(PluginWinCriteria) != 0
    If Plugin.FindClass(ControlGetClassNN(ControlGetFocus(PluginWinCriteria))) And !WinExist("ahk_class #32768") {
    FoundPlugin := Plugin.GetByClass(ControlGetClassNN(ControlGetFocus(PluginWinCriteria)))
    PluginOverlay := FoundPlugin.GetOverlay()
    PluginOverlay.ActivateCurrentControl()
    }
    Else {
    Send "{Enter}"
    }
    Else
    Send "{Enter}"
    }
    
    Ctrl:: {
    Global FoundPlugin
    If ControlGetFocus(PluginWinCriteria) != 0
    If Plugin.FindClass(ControlGetClassNN(ControlGetFocus(PluginWinCriteria))) {
    AccessibilityOverlay.StopSpeech()
    }
    Else {
    Send "^"
    }
    Else
    Send "^"
    }
    
    ^R:: {
    Global FoundPlugin
    If ControlGetFocus(PluginWinCriteria) != 0
    If Plugin.FindClass(ControlGetClassNN(ControlGetFocus(PluginWinCriteria))) And !WinExist("ahk_class #32768") {
    FoundPlugin := Plugin.GetByClass(ControlGetClassNN(ControlGetFocus(PluginWinCriteria)))
    PluginOverlay := FoundPlugin.GetOverlay()
    PluginOverlay.Reset()
    AccessibilityOverlay.Speak(PluginOverlay.Label . " overlay reset")
    }
    Else {
    Send "^{R}"
    }
    Else
    Send "^{R}"
    }
        