#Requires AutoHotkey v2.0

#HotIf WinActive(ReaperFX_WinCriteria)

F6:: {
    Global AppName, PluginPreferencesTab, PluginLibrariesTab, PluginAddLibraryButton
    If ControlGetFocus(ReaperFX_WinCriteria) != 0
    If ReaperFX_IsAllowedClass(ControlGetClassNN(ControlGetFocus(ReaperFX_WinCriteria))) {
        Send "{F6}"
    }
    Else If ReaperFX_IsAllowedControl() {
        ControlFocus(ReaperFX_IsAllowedControl(), ReaperFX_WinCriteria)
        AccessibilityOverlay.Speak(AppName . " overlay active")
        PluginOverlay.FocusCurrentControl()
        If AppName == "Engine Access" {
            If PluginOverlay.GetCurrentControl() == PluginAddLibraryButton {
                PluginPreferencesTab.Focus(PluginPreferencesTab.ControlID)
                PluginLibrariesTab.Focus(PluginLibrariesTab.ControlID)
                PluginAddLibraryButton.Focus(PluginAddLibraryButton.ControlID)
            }
        }
        Else {
            PluginPreferencesTab := ""
            PluginLibrariesTab := ""
            PluginAddLibraryButton := ""
        }
    }
    Else {
        Send "{F6}"
    }
    Else
    Send "{F6}"
}

Tab:: {
    Global PluginOverlay
    If ControlGetFocus(ReaperFX_WinCriteria) != 0
    If ReaperFX_IsAllowedClass(ControlGetClassNN(ControlGetFocus(ReaperFX_WinCriteria))) And !WinExist("ahk_Class #32768")
    PluginOverlay.FocusNextControl()
    Else
    Send "{Tab}"
    Else
    Send "{Tab}"
}

+Tab:: {
    Global PluginOverlay
    If ControlGetFocus(ReaperFX_WinCriteria) != 0
    If ReaperFX_IsAllowedClass(ControlGetClassNN(ControlGetFocus(ReaperFX_WinCriteria))) And !WinExist("ahk_Class #32768")
    PluginOverlay.FocusPreviousControl()
    Else
    Send "+{Tab}"
    Else
    Send "+{Tab}"
    }
    
    Right:: {
    Global PluginOverlay
    If ControlGetFocus(ReaperFX_WinCriteria) != 0
    If ReaperFX_IsAllowedClass(ControlGetClassNN(ControlGetFocus(ReaperFX_WinCriteria))) And PluginOverlay.GetCurrentControl() Is TabControl And !WinExist("ahk_Class #32768")
    PluginOverlay.FocusNextTab()
    Else
    Send "{Right}"
    Else
    Send "{Right}"
    }
    
    ^Tab:: {
    Global PluginOverlay
    If ControlGetFocus(ReaperFX_WinCriteria) != 0
    If ReaperFX_IsAllowedClass(ControlGetClassNN(ControlGetFocus(ReaperFX_WinCriteria))) And PluginOverlay.GetCurrentControl() Is TabControl And !WinExist("ahk_Class #32768")
    PluginOverlay.FocusNextTab()
    Else
    Send "^{Tab}"
    Else
    Send "^{Tab}"
    }
    
    Left:: {
    Global PluginOverlay
    If ControlGetFocus(ReaperFX_WinCriteria) != 0
    If ReaperFX_IsAllowedClass(ControlGetClassNN(ControlGetFocus(ReaperFX_WinCriteria))) And PluginOverlay.GetCurrentControl() Is TabControl And !WinExist("ahk_Class #32768")
    PluginOverlay.FocusPreviousTab()
    Else
    Send "{Left}"
    Else
    Send "{Left}"
    }
    
    ^+Tab:: {
    Global PluginOverlay
    If ControlGetFocus(ReaperFX_WinCriteria) != 0
    If ReaperFX_IsAllowedClass(ControlGetClassNN(ControlGetFocus(ReaperFX_WinCriteria))) And PluginOverlay.GetCurrentControl() Is TabControl And !WinExist("ahk_Class #32768")
    PluginOverlay.FocusPreviousTab()
    Else
    Send "^+{Tab}"
    Else
    Send "^+{Tab}"
    }
    
    Space:: {
    Global PluginOverlay
    If ControlGetFocus(ReaperFX_WinCriteria) != 0
    If ReaperFX_IsAllowedClass(ControlGetClassNN(ControlGetFocus(ReaperFX_WinCriteria))) And !WinExist("ahk_Class #32768")
    PluginOverlay.ActivateCurrentControl()
    Else
    Send "{Space}"
    Else
    Send "{Space}"
    }
    
    Enter:: {
    Global PluginOverlay
    If ControlGetFocus(ReaperFX_WinCriteria) != 0
    If ReaperFX_IsAllowedClass(ControlGetClassNN(ControlGetFocus(ReaperFX_WinCriteria))) And !WinExist("ahk_Class #32768")
    PluginOverlay.ActivateCurrentControl()
    Else
    Send "{Enter}"
    Else
    Send "{Enter}"
    }
    
    Ctrl:: {
    If ControlGetFocus(ReaperFX_WinCriteria) != 0
    If ReaperFX_IsAllowedClass(ControlGetClassNN(ControlGetFocus(ReaperFX_WinCriteria)))
    AccessibilityOverlay.StopSpeech()
    Else
    Send "^"
    Else
    Send "^"
    }
    
    ^R:: {
    Global AppName, PluginOverlay
    If ControlGetFocus(ReaperFX_WinCriteria) != 0
    If ReaperFX_IsAllowedClass(ControlGetClassNN(ControlGetFocus(ReaperFX_WinCriteria))) And !WinExist("ahk_Class #32768") {
    PluginOverlay.Reset()
    AccessibilityOverlay.Speak(AppName . " reloaded")
    }
    Else {
    Send "^{R}"
    }
    Else
    Send "^{R}"
    }
    
    ReaperFX_IsAllowedClass(ClassName) {
    Global ReaperFX_ControlClasses
    If !IsObject(ReaperFX_ControlClasses)
    Return False
    If ReaperFX_ControlClasses.Length == 0
    Return False
    For ControlClass In ReaperFX_ControlClasses
    If RegExMatch(ClassName, ControlClass)
    Return True
    Return False
    }
    
    ReaperFX_IsAllowedControl() {
    Global ReaperFX_ControlClasses, ReaperFX_WinCriteria
    Controls := WinGetControls(ReaperFX_WinCriteria)
    If !IsObject(ReaperFX_ControlClasses)
    Return False
    If ReaperFX_ControlClasses.Length == 0
    Return False
    For ControlClass In ReaperFX_ControlClasses
    For Control In Controls
    If RegExMatch(Control, ControlClass)
    Return Control
    Return False
    }
        