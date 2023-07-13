#Requires AutoHotkey v2.0

#HotIf WinActive(Standalone_WinCriteria)

Tab:: {
    Global StandaloneOverlay
    If !WinExist("ahk_class #32768")
    StandaloneOverlay.FocusNextControl()
    Else
    Send "{Tab}"
}

+Tab:: {
    Global StandaloneOverlay
    If !WinExist("ahk_class #32768")
    StandaloneOverlay.FocusPreviousControl()
    Else
    Send "+{Tab}"
}

Right:: {
    Global StandaloneOverlay
    If StandaloneOverlay.GetCurrentControl() Is TabControl And !WinExist("ahk_class #32768")
    StandaloneOverlay.FocusNextTab()
    Else
    Send "{Right}"
}

^Tab:: {
    Global StandaloneOverlay
    If StandaloneOverlay.GetCurrentControl() Is TabControl And !WinExist("ahk_class #32768")
    StandaloneOverlay.FocusNextTab()
    Else
    Send "^{Tab}"
}

Left:: {
    Global StandaloneOverlay
    If StandaloneOverlay.GetCurrentControl() Is TabControl And !WinExist("ahk_class #32768")
    StandaloneOverlay.FocusPreviousTab()
    Else
    Send "{Left}"
}

^+Tab:: {
    Global StandaloneOverlay
    If StandaloneOverlay.GetCurrentControl() Is TabControl And !WinExist("ahk_class #32768")
    StandaloneOverlay.FocusPreviousTab()
    Else
    Send "^+{Tab}"
}

Space:: {
    Global StandaloneOverlay
    If !WinExist("ahk_class #32768")
    StandaloneOverlay.ActivateCurrentControl()
    Else
    Send "{Space}"
}

Enter:: {
    Global StandaloneOverlay
    If !WinExist("ahk_class #32768")
    StandaloneOverlay.ActivateCurrentControl()
    Else
    Send "{Enter}"
}

Ctrl:: {
    AccessibilityOverlay.StopSpeech()
}

^R:: {
    Global AppName, StandaloneOverlay
    If !WinExist("ahk_class #32768") {
        StandaloneOverlay.Reset()
        AccessibilityOverlay.Speak(AppName . " reloaded")
    }
    Else {
    Send "^{R}"
    }
    }
        