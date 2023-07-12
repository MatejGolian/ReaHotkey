#Requires AutoHotkey v2.0

#MaxThreadsPerHotkey 1
#SingleInstance Force
#Warn
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
SAPI := ComObject("SAPI.SpVoice")
UnlabelledHotspotLabel := "unlabelled Hotspot"

A_IconTip := AppName
A_TrayMenu.Delete()
A_TrayMenu.Add("&About...", About)
A_TrayMenu.Add("&Quit...", Quit)

#^+A::About()
#^+Enter::AddHotspot()
Enter::ClickHotspot()
#^+C::CopyControlClassToClipboard()
#^+H::CopyHotspotsToClipboard()
#^+P::CopyProcessNameToClipboard()
#^+W::CopyWindowClassToClipboard()
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

About(ItemName := "", ItemPos := "", MyMenu := "") {
    Global DialogOpen
    If DialogOpen == 0 {
        DialogOpen := 1
        MsgBox "Use this tool to determine hotspot mouse coordinates, obtain information about the active window and its controls and copy the retrieved info to clipboard.`nEnable keyboard mode whenever you want to click, delete or rename previously added hotspots.`n`nKeyboard Shortcuts`n`nGeneral Shortcuts:`nWin+Ctrl+Shift+Enter - Add hotspot`nWin+Ctrl+Shift+H - Copy hotspots to clipboard`nWin+Ctrl+Shift+T - Copy the title of the active window to clipboard`nWin+Ctrl+Shift+W - Copy the class of the active window to clipboard`nWin+Ctrl+Shift+P - Copy the process name of the active window to clipboard`nWin+Ctrl+Shift+C - Copy the class of the currently focused control to clipboard`nCtrl - Stop speech`nWin+Ctrl+Shift+A - About the app`nWin+Ctrl+Shift+Q - Quit the app`nKeyboard Mode Shortcuts:`nWin+Ctrl+Shift+K - Toggle keyboard mode on/off`nTab - Select next hotspot`nShift+Tab - Select previous hotspot`nEnter - Click current hotspot`nWin+Ctrl+Shift+Del - Delete current hotspot`nWin+Ctrl+Shift+F2 - Rename current hotspot", "About " . AppName
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

CopyHotspotsToClipboard() {
    Global AppName, DialogOpen, Hotspots
    If DialogOpen == 0 {
        DialogOpen := 1
        ConfirmationDialog := MsgBox("Copy hotspots to clipboard?", AppName, 4)
        If ConfirmationDialog == "Yes" {
            ClipboardData := ""
            For Value In Hotspots {
                Label := Value["Label"]
                MouseXCoordinate := Value["XCoordinate"]
                MouseYCoordinate := Value["YCoordinate"]
                ClipboardData .= "`"" . Label . "`", " . MouseXCoordinate . ", " . MouseYCoordinate . "`r`n"
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
        Hotkey "#^+A", "on"
        Hotkey "#^+Enter", "off"
        Hotkey "Enter", "off"
        Hotkey "#^+C", "off"
        Hotkey "#^+H", "off"
        Hotkey "#^+P", "off"
        Hotkey "#^+W", "off"
        Hotkey "#^+T", "off"
        Hotkey "#^+Del", "off"
        Hotkey "#^+Q", "on"
        Hotkey "#^+F2", "off"
        Hotkey "Tab", "off"
        Hotkey "+Tab", "off"
        Hotkey "Ctrl", "off"
        Hotkey "#^+K", "off"
    }
    Else If KeyboardMode == 1 {
        Hotkey "#^+A", "on"
        Hotkey "#^+Enter", "on"
        Hotkey "Enter", "on"
        Hotkey "#^+C", "on"
        Hotkey "#^+H", "on"
        Hotkey "#^+P", "on"
        Hotkey "#^+W", "on"
        Hotkey "#^+T", "on"
        Hotkey "#^+Del", "on"
        Hotkey "#^+Q", "on"
        Hotkey "#^+F2", "on"
        Hotkey "Tab", "on"
        Hotkey "+Tab", "on"
        Hotkey "Ctrl", "on"
        Hotkey "#^+K", "on"
    }
    Else {
        Hotkey "#^+A", "on"
        Hotkey "#^+Enter", "on"
        Hotkey "Enter", "off"
        Hotkey "#^+C", "on"
        Hotkey "#^+H", "on"
        Hotkey "#^+P", "on"
        Hotkey "#^+W", "on"
        Hotkey "#^+T", "on"
        Hotkey "#^+Del", "off"
        Hotkey "#^+Q", "on"
        Hotkey "#^+F2", "off"
        Hotkey "Tab", "off"
        Hotkey "+Tab", "off"
        Hotkey "Ctrl", "on"
        Hotkey "#^+K", "on"
    }
}

Quit(ItemName := "", ItemPos := "", MyMenu := "") {
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
    Global SAPI
    If FileExist("nvdaControllerClient" . A_PtrSize * 8 . ".dll") And !DllCall("nvdaControllerClient" . A_PtrSize * 8 . ".dll\nvdaController_testIfRunning") {
        DllCall("nvdaControllerClient" . A_PtrSize * 8 . ".dll\nvdaController_cancelSpeech")
        DllCall("nvdaControllerClient" . A_PtrSize * 8 . ".dll\nvdaController_speakText", "wstr", Message)
    }
    Else {
        SAPI.Speak("", 0x1|0x2)
        SAPI.Speak(Message, 0x1)
    }
}

StopSpeech() {
Global SAPI
If !FileExist("nvdaControllerClient" . A_PtrSize * 8 . ".dll") Or DllCall("nvdaControllerClient" . A_PtrSize * 8 . ".dll\nvdaController_testIfRunning")
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
