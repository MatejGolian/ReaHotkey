#requires AutoHotkey v2.0

#hotIf winActive(reaperFX_winCriteria)

F6:: {
    global appName, pluginPreferencesTab, pluginLibrariesTab, pluginAddLibraryButton
    if controlGetFocus(reaperFX_winCriteria) != 0
    if reaperFX_isAllowedClass(controlGetClassNN(controlGetFocus(reaperFX_winCriteria))) {
        send "{F6}"
    }
    else if ReaperFX_IsAllowedControl() {
        controlFocus(reaperFX_isAllowedControl(), reaperFX_winCriteria)
        accessibilityOverlay.speak(appName . " overlay active")
        pluginOverlay.FocusCurrentControl()
        if appName == "Engine Access" {
            if pluginOverlay.getCurrentControl() == pluginAddLibraryButton {
                pluginPreferencesTab.focus(PluginPreferencesTab.ControlID)
                pluginLibrariesTab.focus(PluginLibrariesTab.ControlID)
                pluginAddLibraryButton.focus(PluginAddLibraryButton.ControlID)
            }
        }
        else {
            pluginPreferencesTab := ""
            pluginLibrariesTab := ""
            pluginAddLibraryButton := ""
        }
    }
    else {
        send "{F6}"
    }
    else
    send "{F6}"
}

Tab:: {
global pluginOverlay
if controlGetFocus(reaperFX_winCriteria) != 0
if reaperFX_isAllowedClass(controlGetClassNN(controlGetFocus(reaperFX_winCriteria))) and !WinExist("ahk_class #32768")
pluginOverlay.focusNextControl()
else
send "{Tab}"
else
send "{Tab}"
}

+Tab:: {
global pluginOverlay
if controlGetFocus(reaperFX_winCriteria) != 0
if reaperFX_isAllowedClass(controlGetClassNN(controlGetFocus(reaperFX_winCriteria))) and !WinExist("ahk_class #32768")
pluginOverlay.focusPreviousControl()
else
send "+{Tab}"
else
send "+{Tab}"
}

Right:: {
global pluginOverlay
if controlGetFocus(reaperFX_winCriteria) != 0
if reaperFX_isAllowedClass(controlGetClassNN(controlGetFocus(reaperFX_winCriteria))) and pluginOverlay.getCurrentControl() is tabControl and !WinExist("ahk_class #32768")
pluginOverlay.focusNextTab()
else
send "{Right}"
else
send "{Right}"
}

^Tab:: {
global pluginOverlay
if controlGetFocus(reaperFX_winCriteria) != 0
if reaperFX_isAllowedClass(controlGetClassNN(controlGetFocus(reaperFX_winCriteria))) and pluginOverlay.getCurrentControl() is tabControl and !WinExist("ahk_class #32768")
pluginOverlay.focusNextTab()
else
send "^{Tab}"
else
send "^{Tab}"
}

Left:: {
global pluginOverlay
if controlGetFocus(reaperFX_winCriteria) != 0
if reaperFX_isAllowedClass(controlGetClassNN(controlGetFocus(reaperFX_winCriteria))) and pluginOverlay.getCurrentControl() is tabControl and !WinExist("ahk_class #32768")
pluginOverlay.focusPreviousTab()
else
send "{Left}"
else
send "{Left}"
}

^+Tab:: {
global pluginOverlay
if controlGetFocus(reaperFX_winCriteria) != 0
if reaperFX_isAllowedClass(controlGetClassNN(controlGetFocus(reaperFX_winCriteria))) and pluginOverlay.getCurrentControl() is tabControl and !WinExist("ahk_class #32768")
pluginOverlay.focusPreviousTab()
else
send "^+{Tab}"
else
send "^+{Tab}"
}

Space:: {
global pluginOverlay
if controlGetFocus(reaperFX_winCriteria) != 0
if reaperFX_isAllowedClass(controlGetClassNN(controlGetFocus(reaperFX_winCriteria))) and !WinExist("ahk_class #32768")
pluginOverlay.activateCurrentControl()
else
send "{Space}"
else
send "{Space}"
}

Enter:: {
global pluginOverlay
if controlGetFocus(reaperFX_winCriteria) != 0
if reaperFX_isAllowedClass(controlGetClassNN(controlGetFocus(reaperFX_winCriteria))) and !WinExist("ahk_class #32768")
pluginOverlay.activateCurrentControl()
else
send "{Enter}"
else
send "{Enter}"
}

Ctrl:: {
if controlGetFocus(reaperFX_winCriteria) != 0
if reaperFX_isAllowedClass(controlGetClassNN(controlGetFocus(reaperFX_winCriteria)))
accessibilityOverlay.stopSpeech()
else
send "^"
else
send "^"
}

^R:: {
global appName, pluginOverlay
if controlGetFocus(reaperFX_winCriteria) != 0
if reaperFX_isAllowedClass(controlGetClassNN(controlGetFocus(reaperFX_winCriteria))) and !WinExist("ahk_class #32768") {
pluginOverlay.reset()
accessibilityOverlay.speak(appName . " reloaded")
}
else {
send "^{R}"
}
else
send "^{R}"
}

reaperFX_isAllowedClass(className) {
global reaperFX_controlClasses
if !IsObject(reaperFX_controlClasses)
return false
if reaperFX_controlClasses.length == 0
return false
for controlClass in reaperFX_controlClasses
if regExMatch(className, controlClass)
return true
return false
}

reaperFX_IsAllowedControl() {
global reaperFX_controlClasses, reaperFX_winCriteria
controls := winGetControls(reaperFX_winCriteria)
if !IsObject(reaperFX_controlClasses)
return false
if reaperFX_controlClasses.length == 0
return false
for controlClass in reaperFX_controlClasses
for control in controls
if regExMatch(control, controlClass)
return control
return false
}
