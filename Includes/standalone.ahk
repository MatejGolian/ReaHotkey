#requires AutoHotkey v2.0

#hotIf winActive(standalone_winCriteria)

Tab:: {
    global standaloneOverlay
    if !winExist("ahk_class #32768")
    standaloneOverlay.focusNextControl()
    else
    send "{Tab}"
}

+Tab:: {
    global standaloneOverlay
    if !winExist("ahk_class #32768")
    standaloneOverlay.focusPreviousControl()
    else
    send "+{Tab}"
}

Right:: {
    global standaloneOverlay
    if standaloneOverlay.getCurrentControl() is tabControl and !winExist("ahk_class #32768")
    standaloneOverlay.focusNextTab()
    else
    send "{Right}"
}

^Tab:: {
    global standaloneOverlay
    if standaloneOverlay.getCurrentControl() is tabControl and !winExist("ahk_class #32768")
    standaloneOverlay.focusNextTab()
    else
    send "^{Tab}"
}

Left:: {
    global standaloneOverlay
    if standaloneOverlay.getCurrentControl() is tabControl and !winExist("ahk_class #32768")
    standaloneOverlay.focusPreviousTab()
    else
    send "{Left}"
    }
    
    ^+Tab:: {
    global standaloneOverlay
    if standaloneOverlay.getCurrentControl() is tabControl and !winExist("ahk_class #32768")
    standaloneOverlay.focusPreviousTab()
    else
    send "^+{Tab}"
    }
    
    Space:: {
    global standaloneOverlay
    if !winExist("ahk_class #32768")
    standaloneOverlay.activateCurrentControl()
    else
    send "{Space}"
    }
    
    Enter:: {
    global standaloneOverlay
    if !winExist("ahk_class #32768")
    standaloneOverlay.activateCurrentControl()
    else
    send "{Enter}"
    }
    
    Ctrl:: {
    accessibilityOverlay.stopSpeech()
    }
    
    ^R:: {
    global appName, standaloneOverlay
    if !winExist("ahk_class #32768") {
    standaloneOverlay.reset()
    accessibilityOverlay.speak(appName . " reloaded")
    }
    else {
    send "^{R}"
    }
    }
        