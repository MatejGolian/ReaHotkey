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
keyboardMode := 0
mouseXPosition := ""
mouseYPosition := ""
SAPI := comObject("SAPI.spVoice")
unlabelledHotspotLabel := "unlabelled hotspot"

A_IconTip := appName
A_TrayMenu.delete()
A_TrayMenu.add("&About...", about)
A_TrayMenu.add("&Quit...", quit)

#^+A::about()
#^+Enter::addHotspot()
Enter::clickHotspot()
#^+C::copyControlClassToClipboard()
#^+H::copyHotspotsToClipboard()
#^+P::copyProcessNameToClipboard()
#^+W::copyWindowClassToClipboard()
#^+T::copyWindowTitleToClipboard()
#^+Del::deleteHotspot()
#^+Q::quit()
#^+F2::renameHotspot()
Tab::selectNextHotspot()
+Tab::selectPreviousHotspot()
Ctrl::stopSpeech()
#^+K::toggleKeyboardMode()

setTimer manageHotkeys, 100
about()
speak(appName . " ready")

about(itemName := "", itemPos := "", myMenu := "") {
    global dialogOpen
    if dialogOpen == 0 {
        dialogOpen := 1
        msgBox "Use this tool to determine hotspot mouse coordinates, obtain information about the active window and its controls and copy the retrieved info to clipboard.`nEnable Keyboard mode whenever you want to click, delete or rename previously added hotspots.`n`nKeyboard Shortcuts`n`nGeneral Shortcuts:`nWin+Ctrl+Shift+Enter - Add hotspot`nWin+Ctrl+Shift+H - Copy hotspots to clipboard`nWin+Ctrl+Shift+T - Copy the title of the active window to clipboard`nWin+Ctrl+Shift+W - Copy the class of the active window to clipboard`nWin+Ctrl+Shift+P - Copy the process name of the active window to clipboard`nWin+Ctrl+Shift+C - Copy the class of the currently focused control to clipboard`nCtrl - Stop speech`nWin+Ctrl+Shift+A - About the app`nWin+Ctrl+Shift+Q - Quit the app`nKeyboard Mode Shortcuts:`nWin+Ctrl+Shift+K - Toggle Keyboard mode`nTab - Select next hotspot`nShift+Tab - Select previous hotspot`nEnter - Click current hotspot`nWin+Ctrl+Shift+Del - Delete current hotspot`nWin+Ctrl+Shift+F2 - Rename current hotspot", "About " . appName
        dialogOpen := 0
    }
}

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
            speak(hotspots[currentHotspot]["label"])
        }
        dialogOpen := 0
    }
}

clickHotspot() {
    global currentHotspot, dialogOpen, hotspots
    global dialogOpen
    if dialogOpen == 0
    if hotspots.length > 0 and currentHotspot > 0 and currentHotspot <= hotspots.length {
        click hotspots[currentHotspot]["xCoordinate"], hotspots[currentHotspot]["yCoordinate"]
        speak("Hotspot clicked")
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
            confirmationDialog := msgBox("Copy the class of the currently focused control to clipboard?", appName, 4)
            if confirmationDialog == "Yes" {
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
        confirmationDialog := msgBox("Copy hotspots to clipboard?", appName, 4)
        if confirmationDialog == "Yes" {
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

copyProcessNameToClipboard() {
    global appName, dialogOpen
    if dialogOpen == 0 {
        dialogOpen := 1
        confirmationDialog := msgBox("Copy the process name for the active window to clipboard?", appName, 4)
        if confirmationDialog == "Yes" {
            winWaitActive("ahk_id " . winGetID("A"))
            A_Clipboard := winGetProcessName("A")
            speak("process name copied to clipboard")
        }
        dialogOpen := 0
    }
}

copyWindowClassToClipboard() {
    global appName, dialogOpen
    if dialogOpen == 0 {
        dialogOpen := 1
        confirmationDialog := msgBox("Copy the class of the active window to clipboard?", appName, 4)
        if confirmationDialog == "Yes" {
            winWaitActive("ahk_id " . winGetID("A"))
            A_Clipboard := winGetClass("A")
            speak("Window class copied to clipboard")
        }
        dialogOpen := 0
    }
}

copyWindowTitleToClipboard() {
    global appName, dialogOpen
    if dialogOpen == 0 {
        dialogOpen := 1
        confirmationDialog := msgBox("Copy the title of the active window to clipboard?", appName, 4)
        if confirmationDialog == "Yes" {
            winWaitActive("ahk_id " . winGetID("A"))
            A_Clipboard := winGetTitle("A")
            speak("Window title copied to clipboard")
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

manageHotkeys() {
    global dialogOpen, keyboardMode
    if dialogOpen == 1 or winActive("ahk_exe explorer.exe ahk_class Progman") or winActive("ahk_class Shell_TrayWnd" or winExist("ahk_class #32768") ) {
        hotkey "#^+A", "on"
        hotkey "#^+Enter", "off"
        hotkey "Enter", "off"
        hotkey "#^+C", "off"
        hotkey "#^+H", "off"
        hotkey "#^+P", "off"
        hotkey "#^+W", "off"
        hotkey "#^+T", "off"
        hotkey "#^+Del", "off"
        hotkey "#^+Q", "on"
        hotkey "#^+F2", "off"
        hotkey "Tab", "off"
        hotkey "+Tab", "off"
        hotkey "Ctrl", "off"
        hotkey "#^+K", "off"
    }
    else if keyboardMode == 1 {
        hotkey "#^+A", "on"
        hotkey "#^+Enter", "on"
        hotkey "Enter", "on"
        hotkey "#^+C", "on"
        hotkey "#^+H", "on"
        hotkey "#^+P", "on"
        hotkey "#^+W", "on"
        hotkey "#^+T", "on"
        hotkey "#^+Del", "on"
        hotkey "#^+Q", "on"
        hotkey "#^+F2", "on"
        hotkey "Tab", "on"
        hotkey "+Tab", "on"
        hotkey "Ctrl", "on"
        hotkey "#^+K", "on"
    }
    else {
        hotkey "#^+A", "on"
        hotkey "#^+Enter", "on"
        hotkey "Enter", "off"
        hotkey "#^+C", "on"
        hotkey "#^+H", "on"
        hotkey "#^+P", "on"
        hotkey "#^+W", "on"
        hotkey "#^+T", "on"
        hotkey "#^+Del", "off"
        hotkey "#^+Q", "on"
        hotkey "#^+F2", "off"
        hotkey "Tab", "off"
        hotkey "+Tab", "off"
        hotkey "Ctrl", "on"
        hotkey "#^+K", "on"
    }
}

quit(itemName := "", itemPos := "", myMenu := "") {
    global appName, dialogOpen
    if dialogOpen == 0 {
        dialogOpen := 1
        confirmationDialog := msgBox("Are you sure you want to quit the app?", "Quit " . appName, 4)
        if confirmationDialog == "Yes" {
            exitApp
        }
        dialogOpen := 0
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
            speak(hotspots[currentHotspot]["label"])
        }
        dialogOpen := 0
    }
    else {
        speak("No hotspot selected")
    }
}

selectNextHotspot() {
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

selectPreviousHotspot() {
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

toggleKeyboardMode() {
    global keyboardMode
    if  keyboardMode == 0 {
        keyboardMode := 1
        speak("Keyboard mode on")
    }
    else {
        keyboardMode := 0
        speak("Keyboard mode off")
    }
}
