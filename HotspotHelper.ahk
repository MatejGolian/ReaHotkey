#Requires AutoHotkey v2.0

#MaxThreadsPerHotkey 1
#SingleInstance Force
#Warn LocalSameAsGlobal, Off
SendMode "Input"
SetTitleMatchMode 2
SetWorkingDir A_InitialWorkingDir
CoordMode "Mouse", "Window"

AppName := "HotspotHelper"
CurrentHotspot := 0
DialogOpen := 0
Hotspots := Array()
KeyboardMode := 0
MouseXPosition := ""
MouseYPosition := ""
UnlabelledHotspotLabel := "unlabelled Hotspot"

Try
JAWS := ComObject("FreedomSci.JawsApi")
Catch
JAWS := False

Try
SAPI := ComObject("SAPI.SpVoice")
Catch
SAPI := False

A_IconTip := AppName
A_TrayMenu.Delete()
A_TrayMenu.Add("&About...", About)
A_TrayMenu.Add("&Quit...", Quit)

#^+A::About()
#^+Enter::AddHotspot()
Enter::ClickHotspot()
#^+C::CopyControlClassToClipboard()
#^+M::CopyControlPositionToClipboard()
#^+H::CopyHotspotsToClipboard()
#^+P::CopyProcessNameToClipboard()
#^+W::CopyWindowClassToClipboard()
#^+I::CopyWindowIDToClipboard()
#^+T::CopyWindowTitleToClipboard()
#^+Del::DeleteHotspot()
#^+Q::Quit()
#^+F2::RenameHotspot()
Tab::SelectNextHotspot()
+Tab::SelectPreviousHotspot()
Ctrl::StopSpeech()
#^+K::ToggleKeyboardMode()

SetTimer ManageHotkeys, 100
About()
Speak(AppName . " ready")

About(*) {
    Global DialogOpen
    If DialogOpen == 0 {
        DialogOpen := 1
        MsgBox "Use this tool to determine hotspot mouse coordinates, obtain information about the active window and its controls and copy the retrieved info to clipboard.`nEnable keyboard mode whenever you want to click, delete or rename previously added hotspots.`n`nKeyboard Shortcuts`n`nGeneral Shortcuts:`nWin+Ctrl+Shift+Enter - Add hotspot`nWin+Ctrl+Shift+H - Copy hotspots to clipboard`nWin+Ctrl+Shift+I - Copy the ID of the active window to clipboard`nWin+Ctrl+Shift+T - Copy the title of the active window to clipboard`nWin+Ctrl+Shift+W - Copy the class of the active window to clipboard`nWin+Ctrl+Shift+P - Copy the process name of the active window to clipboard`nWin+Ctrl+Shift+C - Copy the class of the currently focused control to clipboard`nWin+Ctrl+Shift+M - Copy the position of the currently focused control to clipboard`nCtrl - Stop speech`nWin+Ctrl+Shift+A - About the app`nWin+Ctrl+Shift+Q - Quit the app`nKeyboard Mode Shortcuts:`nWin+Ctrl+Shift+K - Toggle keyboard mode on/off`nTab - Select next hotspot`nShift+Tab - Select previous hotspot`nEnter - Click current hotspot`nWin+Ctrl+Shift+Del - Delete current hotspot`nWin+Ctrl+Shift+F2 - Rename current hotspot", "About " . AppName
        DialogOpen := 0
    }
}

AddHotspot() {
    Global AppName, CurrentHotspot, DialogOpen, Hotspots, MouseXposition, MouseYPosition, UnlabelledHotspotLabel
    If DialogOpen == 0 {
        DialogOpen := 1
        If CurrentHotspot < Hotspots.Length
        CurrentHotspot++
        Else
        CurrentHotspot := Hotspots.Length + 1
        MouseGetPos &mouseXPosition, &mouseYPosition
        NameDialog := InputBox("Enter A Name For This Hotspot.", AppName)
        If NameDialog.Result == "OK" {
            If NameDialog.Value != ""
            Label := NameDialog.Value
            Else
            Label := UnlabelledHotspotLabel
            Hotspots.InsertAt(CurrentHotspot, Map())
            Hotspots[CurrentHotspot]["Label"] := Label
            Hotspots[CurrentHotspot]["XCoordinate"] := MouseXPosition
            Hotspots[CurrentHotspot]["YCoordinate"] := MouseYPosition
            Speak(Hotspots[CurrentHotspot]["Label"])
        }
        DialogOpen := 0
    }
}

ClickHotspot() {
    Global CurrentHotspot, DialogOpen, Hotspots
    Global DialogOpen
    If DialogOpen == 0
    If Hotspots.Length > 0 And CurrentHotspot > 0 And CurrentHotspot <= Hotspots.Length {
        Click Hotspots[CurrentHotspot]["XCoordinate"], Hotspots[CurrentHotspot]["YCoordinate"]
        Speak("Hotspot clicked")
    }
    Else {
        Speak("No hotspot selected")
    }
}

CopyControlClassToClipboard() {
    Global AppName, DialogOpen
    If DialogOpen == 0 {
        DialogOpen := 1
        If ControlGetFocus("ahk_id " . WinGetID("A")) == 0 {
            Speak("Focused control not found")
        }
        Else {
            ConfirmationDialog := MsgBox("Copy the class of the currently focused control to clipboard?", AppName, 4)
            If ConfirmationDialog == "Yes" {
                WinWaitActive("ahk_id " . WinGetID("A"))
                A_Clipboard := ControlGetClassNN(ControlGetFocus("ahk_id " . WinGetID("A")))
                Speak("Control class copied to clipboard")
            }
        }
        DialogOpen := 0
    }
}

CopyControlPositionToClipboard() {
    Global AppName, DialogOpen
    If DialogOpen == 0 {
        DialogOpen := 1
        If ControlGetFocus("ahk_id " . WinGetID("A")) == 0 {
            Speak("Focused control not found")
        }
        Else {
            ConfirmationDialog := MsgBox("Copy the position of the currently focused control to clipboard?", AppName, 4)
            If ConfirmationDialog == "Yes" {
                WinWaitActive("ahk_id " . WinGetID("A"))
                ControlGetPos &ControlX, &ControlY,,, ControlGetClassNN(ControlGetFocus("ahk_id " . WinGetID("A"))), "ahk_id " . WinGetID("A")
                A_Clipboard := ControlX . ", " . ControlY
                Speak("Control position copied to clipboard")
            }
        }
        DialogOpen := 0
    }
}

CopyHotspotsToClipboard() {
    Global AppName, DialogOpen, Hotspots
    If DialogOpen == 0 {
        DialogOpen := 1
        ConfirmationDialog := MsgBox("Copy hotspots to clipboard?", AppName, 4)
        If ConfirmationDialog == "Yes" {
            ClipboardData := ""
            ConfirmationDialog := MsgBox("Compensate for the position of the currently focused control?", AppName, 4)
            If ConfirmationDialog == "Yes" {
                WinWaitActive("ahk_id " . WinGetID("A"))
                If ControlGetFocus("ahk_id " . WinGetID("A")) == 0 {
                    Speak("Focused control not found")
                }
                Else {
                    ControlGetPos &ControlX, &ControlY,,, ControlGetClassNN(ControlGetFocus("ahk_id " . WinGetID("A"))), "ahk_id " . WinGetID("A")
                    For Value In Hotspots {
                        Label := Value["Label"]
                        MouseXCoordinate := Value["XCoordinate"] - ControlX
                        MouseYCoordinate := Value["YCoordinate"] - ControlY
                        ClipboardData .= "`"" . Label . "`", " . MouseXCoordinate . ", " . MouseYCoordinate . "`r`n"
                    }
                }
        }
        Else {
            For Value In Hotspots {
                Label := Value["Label"]
                MouseXCoordinate := Value["XCoordinate"]
                MouseYCoordinate := Value["YCoordinate"]
                ClipboardData .= "`"" . Label . "`", " . MouseXCoordinate . ", " . MouseYCoordinate . "`r`n"
            }
        }
        ClipboardData := RTrim(ClipboardData, "`r`n")
        A_Clipboard := ClipboardData
        Speak("Hotspots copied to clipboard")
    }
    DialogOpen := 0
}
}

CopyProcessNameToClipboard() {
    Global AppName, DialogOpen
    If DialogOpen == 0 {
        DialogOpen := 1
        ConfirmationDialog := MsgBox("Copy the process name for the active window to clipboard?", AppName, 4)
        If ConfirmationDialog == "Yes" {
            WinWaitActive("ahk_id " . WinGetID("A"))
            A_Clipboard := WinGetProcessName("A")
            Speak("process name copied to clipboard")
        }
        DialogOpen := 0
    }
}

CopyWindowClassToClipboard() {
    Global AppName, DialogOpen
    If DialogOpen == 0 {
        DialogOpen := 1
        ConfirmationDialog := MsgBox("Copy the class of the active window to clipboard?", AppName, 4)
        If ConfirmationDialog == "Yes" {
            WinWaitActive("ahk_id " . WinGetID("A"))
            A_Clipboard := WinGetClass("A")
            Speak("Window class copied to clipboard")
        }
        DialogOpen := 0
    }
}

CopyWindowIDToClipboard() {
    Global AppName, DialogOpen
    If DialogOpen == 0 {
        DialogOpen := 1
        ConfirmationDialog := MsgBox("Copy the ID of the active window to clipboard?", AppName, 4)
        If ConfirmationDialog == "Yes" {
            WinWaitActive("ahk_id " . WinGetID("A"))
            A_Clipboard := WinGetID("A")
            Speak("Window ID copied to clipboard")
        }
        DialogOpen := 0
    }
}

CopyWindowTitleToClipboard() {
    Global AppName, DialogOpen
    If DialogOpen == 0 {
        DialogOpen := 1
        ConfirmationDialog := MsgBox("Copy the title of the active window to clipboard?", AppName, 4)
        If ConfirmationDialog == "Yes" {
            WinWaitActive("ahk_id " . WinGetID("A"))
            A_Clipboard := WinGetTitle("A")
            Speak("Window title copied to clipboard")
        }
        DialogOpen := 0
    }
}

DeleteHotspot() {
    Global CurrentHotspot, DialogOpen, Hotspots
    Global DialogOpen
    If DialogOpen == 0
    If Hotspots.Length > 0 And CurrentHotspot > 0 And CurrentHotspot <= Hotspots.Length {
        Hotspots.RemoveAt(CurrentHotspot)
        If CurrentHotspot > 1
        CurrentHotspot--
        Speak("Hotspot deleted")
    }
    Else {
        Speak("No hotspot selected")
    }
}

ManageHotkeys() {
    Global DialogOpen, KeyboardMode
    If DialogOpen == 1 Or WinActive("ahk_exe Explorer.Exe ahk_class Progman") Or WinActive("ahk_class Shell_TrayWnd" Or WinExist("ahk_class #32768") ) {
        Hotkey "#^+A", "On"
        Hotkey "#^+Enter", "Off"
        Hotkey "Enter", "Off"
        Hotkey "#^+C", "On"
        Hotkey "#^+M", "On"
        Hotkey "#^+H", "On"
        Hotkey "#^+P", "On"
        Hotkey "#^+W", "On"
        Hotkey "#^+I", "On"
        Hotkey "#^+T", "On"
        Hotkey "#^+Del", "Off"
        Hotkey "#^+Q", "On"
        Hotkey "#^+F2", "Off"
        Hotkey "Tab", "Off"
        Hotkey "+Tab", "Off"
        Hotkey "Ctrl", "Off"
        Hotkey "#^+K", "Off"
    }
    Else If KeyboardMode == 1 {
        Hotkey "#^+A", "On"
        Hotkey "#^+Enter", "On"
        Hotkey "Enter", "On"
        Hotkey "#^+C", "On"
        Hotkey "#^+M", "On"
        Hotkey "#^+H", "On"
        Hotkey "#^+P", "On"
        Hotkey "#^+W", "On"
        Hotkey "#^+I", "On"
        Hotkey "#^+T", "On"
        Hotkey "#^+Del", "On"
        Hotkey "#^+Q", "On"
        Hotkey "#^+F2", "On"
        Hotkey "Tab", "On"
        Hotkey "+Tab", "On"
        Hotkey "Ctrl", "On"
        Hotkey "#^+K", "On"
    }
    Else {
        Hotkey "#^+A", "On"
        Hotkey "#^+Enter", "On"
        Hotkey "Enter", "Off"
        Hotkey "#^+C", "On"
        Hotkey "#^+M", "On"
        Hotkey "#^+H", "On"
        Hotkey "#^+P", "On"
        Hotkey "#^+W", "On"
        Hotkey "#^+I", "On"
        Hotkey "#^+T", "On"
        Hotkey "#^+Del", "Off"
        Hotkey "#^+Q", "On"
        Hotkey "#^+F2", "Off"
        Hotkey "Tab", "Off"
        Hotkey "+Tab", "Off"
        Hotkey "Ctrl", "On"
        Hotkey "#^+K", "On"
    }
}

Quit(*) {
    Global AppName, DialogOpen
    If DialogOpen == 0 {
        DialogOpen := 1
        ConfirmationDialog := MsgBox("Are you sure you want to quit the app?", "Quit " . AppName, 4)
        If ConfirmationDialog == "Yes" {
            ExitApp
        }
        DialogOpen := 0
    }
}

RenameHotspot() {
    Global CurrentHotspot, DialogOpen, Hotspots
    If DialogOpen == 0
    If Hotspots.Length > 0 And CurrentHotspot > 0 And CurrentHotspot <= Hotspots.Length {
        DialogOpen := 1
        RenameDialog := InputBox("Enter a new name for this hotspot.", AppName, "", Hotspots[CurrentHotspot]["Label"])
        If RenameDialog.Result == "OK" And RenameDialog.Value != "" {
            Hotspots[CurrentHotspot]["Label"] := RenameDialog.Value
            Speak(Hotspots[CurrentHotspot]["Label"])
        }
        DialogOpen := 0
    }
    Else {
        Speak("No Hotspot Selected")
    }
}

SelectNextHotspot() {
    Global CurrentHotspot, DialogOpen, Hotspots
    If DialogOpen == 0
    If Hotspots.Length > 0 {
        CurrentHotspot++
        If CurrentHotspot > Hotspots.Length
        CurrentHotspot := 1
        MouseMove Hotspots[CurrentHotspot]["XCoordinate"], Hotspots[CurrentHotspot]["YCoordinate"]
        Speak(Hotspots[CurrentHotspot]["Label"])
    }
    Else {
        Speak("No hotspots defined")
    }
}

SelectPreviousHotspot() {
    Global CurrentHotspot, DialogOpen, Hotspots
    If DialogOpen == 0
    If Hotspots.Length > 0 {
        CurrentHotspot--
        If CurrentHotspot < 1
        CurrentHotspot := Hotspots.Length
        MouseMove Hotspots[CurrentHotspot]["XCoordinate"], Hotspots[CurrentHotspot]["YCoordinate"]
        Speak(Hotspots[CurrentHotspot]["Label"])
    }
    Else {
        Speak("No hotspots defined")
    }
}

Speak(Message) {
    Global JAWS, SAPI
    If (JAWS != False And ProcessExist("jfw.exe")) Or (FileExist("NvdaControllerClient" . A_PtrSize * 8 . ".dll") And !DllCall("NvdaControllerClient" . A_PtrSize * 8 . ".dll\nvdaController_testIfRunning")) {
        If JAWS != False And ProcessExist("jfw.exe") {
            JAWS.SayString(Message)
        }
        If FileExist("NvdaControllerClient" . A_PtrSize * 8 . ".dll") And !DllCall("NvdaControllerClient" . A_PtrSize * 8 . ".dll\nvdaController_testIfRunning") {
            DllCall("NvdaControllerClient" . A_PtrSize * 8 . ".dll\nvdaController_cancelSpeech")
            DllCall("NvdaControllerClient" . A_PtrSize * 8 . ".dll\nvdaController_speakText", "Wstr", Message)
        }
    }
    Else {
        If SAPI != False {
            SAPI.Speak("", 0x1|0x2)
            SAPI.Speak(Message, 0x1)
        }
    }
}

StopSpeech() {
    Global JAWS, SAPI
    If (JAWS != False Or !ProcessExist("jfw.exe")) And (!FileExist("NvdaControllerClient" . A_PtrSize * 8 . ".dll") Or DllCall("NvdaControllerClient" . A_PtrSize * 8 . ".dll\nvdaController_testIfRunning"))
    If SAPI != False
    SAPI.Speak("", 0x1|0x2)
}

ToggleKeyboardMode() {
    Global KeyboardMode
    If  KeyboardMode == 0 {
        KeyboardMode := 1
        Speak("Keyboard mode on")
    }
    Else {
        KeyboardMode := 0
        Speak("Keyboard mode off")
    }
}
