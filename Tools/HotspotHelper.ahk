#requires AutoHotkey v2.0

#maxThreadsPerHotkey 1
#singleInstance force
#warn
sendMode "input"
setTitleMatchMode "regEx"
setWorkingDir A_InitialWorkingDir
coordMode "mouse", "window"
coordMode "pixel", "window"

appName := "HotspotHelper"
dialogOpen := 0
hotspots := Array()
mouseXPosition := ""
mouseYPosition := ""
SAPI := comObject("SAPI.spVoice")

A_IconTip := appName
A_TrayMenu.delete("&Pause Script")
A_TrayMenu.rename("E&xit", "&Close")

msgBox "Use this tool to find mouse coordinates and export them to clipboard.`nKeyboard shortcuts:`nCtrl+Shift+R - Record hotspot`nCtrl+Shift+N - Record and name hotspot`nCtrl+Shift+C - Copy hotspots to clipboard", appName

speak(appName . " ready")

^+C::copyToClipboard()
^+N::recordAndNameHotspot()
^+R::recordHotspot()
Ctrl::stopSpeech()

copyToClipboard() {
    global appName, dialogOpen, hotspots
    if dialogOpen == 0 {
        dialogOpen := 1
        clipboardDialog := msgBox "Copy hotspots to clipboard?", appName, 4
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
        }
        dialogOpen := 0
    }
}

recordAndNameHotspot() {
    global appName, dialogOpen, hotspots, mouseXposition, mouseYPosition
    if dialogOpen == 0 {
        dialogOpen := 1
        mouseGetPos &mouseXPosition, &mouseYPosition
        hotspots.push(map())
        hotspots[hotspots.length]["label"] := ""
        hotspots[hotspots.length]["xCoordinate"] := mouseXPosition
        hotspots[hotspots.length]["yCoordinate"] := mouseYPosition
        nameDialog := inputBox("Enter a name for this hotspot and click OK.", appName)
        if nameDialog.result == "OK"
        hotspots[hotspots.length]["label"] := nameDialog.value
        speak("hotspot recorded")
        dialogOpen := 0
    }
}

recordHotspot() {
    Global dialogOpen, hotspots, mouseXposition, mouseYPosition
    if dialogOpen == 0 {
        mouseGetPos &mouseXPosition, &mouseYPosition
        hotspots.push(Map())
        hotspots[hotspots.length]["label"] := ""
        hotspots[hotspots.length]["xCoordinate"] := mouseXPosition
        hotspots[hotspots.length]["yCoordinate"] := mouseYPosition
        speak("hotspot recorded")
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
