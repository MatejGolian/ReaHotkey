#requires AutoHotkey v2.0

#maxThreadsPerHotkey 1
#singleInstance force
#warn
sendMode "input"
setTitleMatchMode 2
setWorkingDir A_InitialWorkingDir
coordMode "mouse", "window"

appName := "HotspotHelper"
currentHotspot := 0
dialogOpen := 0
hotspots := array()
mouseXPosition := ""
mouseYPosition := ""
SAPI := comObject("SAPI.spVoice")
unlabelledHotspotLabel := "unlabelled hotspot"
windowID := ""

A_IconTip := appName
A_TrayMenu.delete("&Pause Script")
A_TrayMenu.rename("E&xit", "&Close")

^+A::addHotspot()
^+M::clickHotspot()
^+F::copyControlClassToClipboard()
^+C::copyHotspotsToClipboard()
^+G::copyWindowClassToClipboard()
^+D::deleteHotspot()
Tab::focusNextHotspot()
+Tab::focusPreviousHotspot()
^+R::renameHotspot()
Ctrl::stopSpeech()
^+W::toggleWindowSelection()

setTimer checkWindowID, 100

msgBox "Use this tool to determine hotspot mouse coordinates and export them to clipboard.", appName
msgBox "Keyboard shortcuts:`nCtrl+Shift+W - Toggle window selection`nCtrl+Shift+G - Copy the class of the active window to clipboard`nCtrl+Shift+F - Copy the class of the currently focused control to clipboard`nCtrl+Shift+A - Add hotspot`nCtrl+Shift+D - Delete hotspot`nCtrl+Shift+R - Rename hotspot`nCtrl+Shift+M - Perform a mouse click on the current hotspot`nCtrl+Shift+C - Copy hotspots to clipboard`nTab - Focus next hotspot`nShift+Tab - Focus previous hotspot", appName
msgBox "Press Ctrl+Shift+W in the window that you want to create hotspots for.", appName

speak(appName . " ready")

addHotspot() {
    global appName, currentHotspot, dialogOpen, hotspots, mouseXposition, mouseYPosition, unlabelledHotspotLabel
    if dialogOpen == 0 {
        dialogOpen := 1
        if currentHotspot < hotspots.length
        currentHotspot++
        else
        currentHotspot := hotspots.length + 1
        mouseGetPos &mouseXPosition, &mouseYPosition
        nameDialog := inputBox("Enter a name for this hotspot.", appName)
        if nameDialog.result == "OK" {
            if nameDialog.value != ""
            label := nameDialog.value
            else
            label := unlabelledHotspotLabel
            hotspots.insertAt(currentHotspot, map())
            hotspots[currentHotspot]["label"] := label
            hotspots[currentHotspot]["xCoordinate"] := mouseXPosition
            hotspots[currentHotspot]["yCoordinate"] := mouseYPosition
            speak("hotspot added " . hotspots[currentHotspot]["label"])
        }
        dialogOpen := 0
    }
}

checkWindowID() {
    global windowID
    if windowID != "" and winActive(windowID) and !winExist("ahk_class #32768") {
        hotkey "^+A", "on"
        hotkey "^+M", "on"
        hotkey "^+D", "on"
        hotkey "Tab", "on"
        hotkey "+Tab", "on"
        hotkey "^+R", "on"
    }
    else {
        hotkey "^+A", "off"
        hotkey "^+M", "off"
        hotkey "^+D", "off"
        hotkey "Tab", "off"
        hotkey "+Tab", "off"
        hotkey "^+R", "off"
    }
}

clickHotspot() {
    global currentHotspot, dialogOpen, hotspots
    global dialogOpen
    if dialogOpen == 0
    if hotspots.length > 0 and currentHotspot > 0 and currentHotspot <= hotspots.length {
        click hotspots[currentHotspot]["xCoordinate"], hotspots[currentHotspot]["yCoordinate"]
    }
    else {
        speak("No hotspot selected")
    }
}

copyControlClassToClipboard() {
    global appName, dialogOpen
    if dialogOpen == 0 {
        dialogOpen := 1
        if controlGetFocus("ahk_id " . winGetID("A")) == 0 {
            speak("Focused control not found")
        }
        else {
            clipboardDialog := msgBox("Copy the class of the currently focused control to clipboard?", appName, 4)
            if clipboardDialog == "Yes" {
                winWaitActive("ahk_id " . winGetID("A"))
                A_Clipboard := controlGetClassNN(controlGetFocus("ahk_id " . winGetID("A")))
                speak("Control class copied to clipboard")
            }
        }
        dialogOpen := 0
    }
}

copyHotspotsToClipboard() {
    global appName, dialogOpen, hotspots
    if dialogOpen == 0 {
        dialogOpen := 1
        clipboardDialog := msgBox("Copy hotspots to clipboard?", appName, 4)
        if clipboardDialog == "Yes" {
            clipboardData := ""
            for value in hotspots {
                label := value["label"]
                mouseXCoordinate := value["xCoordinate"]
                mouseYCoordinate := value["yCoordinate"]
                clipboardData .= "`"" . label . "`", " . mouseXCoordinate . ", " . mouseYCoordinate . "`r`n"
            }
            clipboardData := rTrim(clipboardData, "`r`n")
            A_Clipboard := clipboardData
            speak("Hotspots copied to clipboard")
        }
        dialogOpen := 0
    }
}

copyWindowClassToClipboard() {
    global appName, dialogOpen
    if dialogOpen == 0 {
        dialogOpen := 1
        clipboardDialog := msgBox("Copy the class of the active window to clipboard?", appName, 4)
        if clipboardDialog == "Yes" {
            winWaitActive("ahk_id " . winGetID("A"))
            A_Clipboard := winGetClass("A")
            speak("Window class copied to clipboard")
        }
        dialogOpen := 0
    }
}

deleteHotspot() {
    global currentHotspot, dialogOpen, hotspots
    global dialogOpen
    if dialogOpen == 0
    if hotspots.length > 0 and currentHotspot > 0 and currentHotspot <= hotspots.length {
        hotspots.removeAt(currentHotspot)
        if currentHotspot > 1
        currentHotspot--
        speak("Hotspot deleted")
    }
    else {
        speak("No hotspot selected")
    }
}

focusNextHotspot() {
    global currentHotspot, dialogOpen, hotspots
    if dialogOpen == 0
    if hotspots.length > 0 {
        currentHotspot++
        if currentHotspot > hotspots.length
        currentHotspot := 1
        mouseMove hotspots[currentHotspot]["xCoordinate"], hotspots[currentHotspot]["yCoordinate"]
        speak(hotspots[currentHotspot]["label"])
    }
    else {
        speak("No hotspots defined")
    }
}

focusPreviousHotspot() {
    global currentHotspot, dialogOpen, hotspots
    if dialogOpen == 0
    if hotspots.length > 0 {
        currentHotspot--
        if currentHotspot < 1
        currentHotspot := hotspots.length
        mouseMove hotspots[currentHotspot]["xCoordinate"], hotspots[currentHotspot]["yCoordinate"]
        speak(hotspots[currentHotspot]["label"])
    }
    else {
        speak("No hotspots defined")
    }
}

renameHotspot() {
    global currentHotspot, dialogOpen, hotspots
    if dialogOpen == 0
    if hotspots.length > 0 and currentHotspot > 0 and currentHotspot <= hotspots.length {
        dialogOpen := 1
        renameDialog := inputBox("Enter a new name for this hotspot.", appName, "", hotspots[currentHotspot]["label"])
        if renameDialog.result == "OK" and renameDialog.value != "" {
            hotspots[currentHotspot]["label"] := renameDialog.value
            speak("hotspot renamed " . hotspots[currentHotspot]["label"])
        }
        dialogOpen := 0
    }
    else {
        speak("No hotspot selected")
    }
}

speak(message) {
    global SAPI
    if fileExist("nvdaControllerClient" . A_PtrSize * 8 . ".dll") and !DllCall("nvdaControllerClient" . A_PtrSize * 8 . ".dll\nvdaController_testIfRunning") {
        dllCall("nvdaControllerClient" . A_PtrSize * 8 . ".dll\nvdaController_cancelSpeech")
        dllCall("nvdaControllerClient" . A_PtrSize * 8 . ".dll\nvdaController_speakText", "wstr", message)
    }
    else {
        SAPI.speak("", 0x1|0x2)
        SAPI.speak(message, 0x1)
    }
}

stopSpeech() {
    global SAPI
    if !FileExist("nvdaControllerClient" . A_PtrSize * 8 . ".dll") or dllCall("nvdaControllerClient" . A_PtrSize * 8 . ".dll\nvdaController_testIfRunning")
    SAPI.speak("", 0x1|0x2)
}

toggleWindowSelection() {
    global windowID
    if windowID == winGetID("A") {
        windowID := ""
        speak("Window deselected")
    }
    else {
        windowID := winGetID("A")
        speak("Window selected")
    }
}
