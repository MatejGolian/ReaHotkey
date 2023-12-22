#Requires AutoHotkey v2.0

#MaxThreadsPerHotkey 1
#SingleInstance Force
#Warn All
SendMode "Input"
SetTitleMatchMode 2
SetWorkingDir A_InitialWorkingDir
CoordMode "Mouse", "Window"
CoordMode "Pixel", "Window"

#Include <OCR>

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
#^+X::CopyPixelColourToClipboard()
#^+Del::DeleteHotspot()
#^+F::ChooseControl()
#^+O::PerformOCR()
#^+Q::Quit()
#^+F2::RenameHotspot()
#^+S::SearchForImage()
Tab::SelectNextHotspot()
+Tab::SelectPreviousHotspot()
Ctrl::StopSpeech()
#^+K::ToggleKeyboardMode()

SetTimer ManageHotkeys, 100
About()
Speak(AppName . " ready")

About(*) {
    Global DialogOpen
    If DialogOpen = 0 {
        DialogOpen := 1
        MsgBox "Use this tool to determine hotspot mouse coordinates, obtain information about the active window and its controls and copy the retrieved info to clipboard.`nEnable keyboard mode whenever you want to click, delete or rename previously added hotspots.`n`nKeyboard Shortcuts`n`nGeneral Shortcuts:`nWin+Ctrl+Shift+Enter - Add hotspot`nWin+Ctrl+Shift+H - Copy hotspots to clipboard`nWin+Ctrl+Shift+I - Copy the ID of the active window to clipboard`nWin+Ctrl+Shift+T - Copy the title of the active window to clipboard`nWin+Ctrl+Shift+W - Copy the class of the active window to clipboard`nWin+Ctrl+Shift+P - Copy the process name of the active window to clipboard`nWin+Ctrl+Shift+O - OCR the active window`nWin+Ctrl+Shift+L - Focus control`nWin+Ctrl+Shift+C - Copy the class of the currently focused control to clipboard`nWin+Ctrl+Shift+M - Copy the position of the currently focused control to clipboard`nCtrl+Win+Shift+S - Search for image`nCtrl+Win+Shift+X - Copy the pixel colour under the mouse to clipboard`nCtrl - Stop speech`nWin+Ctrl+Shift+A - About the app`nWin+Ctrl+Shift+Q - Quit the app`nKeyboard Mode Shortcuts:`nWin+Ctrl+Shift+K - Toggle keyboard mode on/off`nTab - Select next hotspot`nShift+Tab - Select previous hotspot`nEnter - Click current hotspot`nWin+Ctrl+Shift+Del - Delete current hotspot`nWin+Ctrl+Shift+F2 - Rename current hotspot", "About " . AppName
        DialogOpen := 0
    }
}

AddHotspot() {
    Global AppName, CurrentHotspot, DialogOpen, Hotspots, MouseXposition, MouseYPosition, UnlabelledHotspotLabel
    If DialogOpen = 0 {
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
            Sleep 25
            Speak(Hotspots[CurrentHotspot]["Label"])
        }
        DialogOpen := 0
    }
}

ClickHotspot() {
    Global CurrentHotspot, DialogOpen, Hotspots
    Global DialogOpen
    If DialogOpen = 0
    If Hotspots.Length > 0 And CurrentHotspot > 0 And CurrentHotspot <= Hotspots.Length {
        Click Hotspots[CurrentHotspot]["XCoordinate"], Hotspots[CurrentHotspot]["YCoordinate"]
        Sleep 25
        Speak("Hotspot clicked")
    }
    Else {
        Sleep 25
        Speak("No hotspot selected")
    }
}

ChooseControl() {
    Global AppName, DialogOpen
    If DialogOpen = 0 {
        DialogOpen := 1
        Try {
            WinWaitActive("A")
            Sleep 1000
            Controls := WinGetControls("A")
        }
        Catch {
            Controls := Array()
        }
        If Controls.Length = 0 {
            Speak("No controls found")
        }
        Else {
            ControlMenu := Menu()
            For Control In controls {
                ControlMenu.Add(Control, FocusControl)
                Try
                If ControlGetClassNN(ControlGetFocus("A")) = Control
                ControlMenu.Check(control)
            }
            ControlMenu.Show()
        }
        DialogOpen := 0
    }
}

CopyControlClassToClipboard() {
    Global AppName, DialogOpen
    If DialogOpen = 0 {
        DialogOpen := 1
        Try {
            WinWaitActive("A")
            Sleep 1000
            If ControlGetFocus("A") = 0 {
                Speak("Focused control not found")
            }
            Else {
                ConfirmationDialog := MsgBox("Copy the class of the currently focused control to clipboard?", AppName, 4)
                If ConfirmationDialog == "Yes" {
                    WinWaitActive("A")
                    Sleep 1000
                    A_Clipboard := ControlGetClassNN(ControlGetFocus("A"))
                    Speak("Control class copied to clipboard")
                }
            }
        }
        DialogOpen := 0
    }
}

CopyControlPositionToClipboard() {
    Global AppName, DialogOpen
    If DialogOpen = 0 {
        DialogOpen := 1
        Try {
            WinWaitActive("A")
            Sleep 1000
            If ControlGetFocus("A") = 0 {
                Speak("Focused control not found")
            }
            Else {
                ConfirmationDialog := MsgBox("Copy the position of the currently focused control to clipboard?", AppName, 4)
                If ConfirmationDialog == "Yes" {
                    WinWaitActive("A")
                    Sleep 1000
                    ControlGetPos &ControlX, &ControlY,,, ControlGetClassNN(ControlGetFocus("A")), "A"
                    A_Clipboard := ControlX . ", " . ControlY
                    Speak("Control position copied to clipboard")
                }
            }
        }
        DialogOpen := 0
    }
}

CopyHotspotsToClipboard() {
    Global AppName, DialogOpen, Hotspots
    If DialogOpen = 0 {
        DialogOpen := 1
        ConfirmationDialog := MsgBox("Copy hotspots to clipboard?", AppName, 4)
        If ConfirmationDialog == "Yes" {
            ClipboardData := ""
            ConfirmationDialog := MsgBox("Compensate for the position of the currently focused control?", AppName, 4)
            If ConfirmationDialog == "Yes" {
                Try {
                    WinWaitActive("A")
                    Sleep 1000
                    If ControlGetFocus("A") = 0 {
                        Speak("Focused control not found")
                    }
                    Else {
                        ControlGetPos &ControlX, &ControlY,,, ControlGetClassNN(ControlGetFocus("A")), "A"
                        ClipboardData .= "Compensating for X " . ControlX . ", Y " . ControlY . "`r`n"
                        For Value In Hotspots {
                            Label := Value["Label"]
                            MouseXCoordinate := Value["XCoordinate"] - ControlX
                            MouseYCoordinate := Value["YCoordinate"] - ControlY
                            ClipboardData .= "`"" . Label . "`", " . MouseXCoordinate . ", " . MouseYCoordinate . "`r`n"
                        }
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
            If Hotspots.Length = 1
            Speak("1 hotspot copied to clipboard")
            Else
            Speak(Hotspots.Length . " hotspots copied to clipboard")
        }
        DialogOpen := 0
    }
}

CopyPixelColourToClipboard() {
    Global AppName, DialogOpen, MouseXPosition, MouseYPosition
    If DialogOpen = 0 {
        DialogOpen := 1
        ConfirmationDialog := MsgBox("Copy the colour of the pixel currently under the mouse to clipboard?", AppName, 4)
        If ConfirmationDialog == "Yes" {
            Sleep 1000
            MouseGetPos &mouseXPosition, &mouseYPosition
            A_Clipboard := PixelGetColor(MouseXPosition, MouseYPosition, "Slow")
            Speak("Pixel colour copied to clipboard")
        }
        DialogOpen := 0
    }
}

CopyProcessNameToClipboard() {
    Global AppName, DialogOpen
    If DialogOpen = 0 {
        DialogOpen := 1
        ConfirmationDialog := MsgBox("Copy the process name for the active window to clipboard?", AppName, 4)
        If ConfirmationDialog == "Yes" {
            Try {
                WinWaitActive("A")
                Sleep 1000
                A_Clipboard := WinGetProcessName("A")
                Speak("process name copied to clipboard")
            }
        }
        DialogOpen := 0
    }
}

CopyWindowClassToClipboard() {
    Global AppName, DialogOpen
    If DialogOpen = 0 {
        DialogOpen := 1
        ConfirmationDialog := MsgBox("Copy the class of the active window to clipboard?", AppName, 4)
        If ConfirmationDialog == "Yes" {
            Try {
                WinWaitActive("A")
                Sleep 1000
                A_Clipboard := WinGetClass("A")
                Speak("Window class copied to clipboard")
            }
        }
        DialogOpen := 0
    }
}

CopyWindowIDToClipboard() {
    Global AppName, DialogOpen
    If DialogOpen = 0 {
        DialogOpen := 1
        ConfirmationDialog := MsgBox("Copy the ID of the active window to clipboard?", AppName, 4)
        If ConfirmationDialog == "Yes" {
            Try {
                WinWaitActive("A")
                Sleep 1000
                A_Clipboard := WinGetID("A")
                Speak("Window ID copied to clipboard")
            }
        }
        DialogOpen := 0
    }
}

CopyWindowTitleToClipboard() {
    Global AppName, DialogOpen
    If DialogOpen = 0 {
        DialogOpen := 1
        ConfirmationDialog := MsgBox("Copy the title of the active window to clipboard?", AppName, 4)
        If ConfirmationDialog == "Yes" {
            Try {
                WinWaitActive("A")
                Sleep 1000
                A_Clipboard := WinGetTitle("A")
                Speak("Window title copied to clipboard")
            }
        }
        DialogOpen := 0
    }
}

DeleteHotspot() {
    Global CurrentHotspot, DialogOpen, Hotspots
    Global DialogOpen
    If DialogOpen = 0
    If Hotspots.Length > 0 And CurrentHotspot > 0 And CurrentHotspot <= Hotspots.Length {
        Hotspots.RemoveAt(CurrentHotspot)
        If CurrentHotspot > 1
        CurrentHotspot--
        Sleep 25
        Speak("Hotspot deleted")
    }
    Else {
        Sleep 25
        Speak("No hotspot selected")
    }
}

FocusControl(ControlName, ControlNumber, ControlMenu) {
    Try {
        WinWaitActive("A")
        Sleep 1000
        ControlFocus ControlName, "A"
        If ControlGetClassNN(ControlGetFocus("A")) = ControlName {
            Speak(ControlName . " focused")
        }
    }
    Catch {
        Speak("Control not found")
    }
}

ManageHotkeys() {
    Global DialogOpen, KeyboardMode
    If DialogOpen = 1 Or WinActive("ahk_exe Explorer.Exe ahk_class Progman") Or WinActive("ahk_class Shell_TrayWnd" Or WinExist("ahk_class #32768") ) {
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
        Hotkey "#^+X", "On"
        Hotkey "#^+Del", "Off"
        Hotkey "#^+F", "On"
        Hotkey "#^+O", "On"
        Hotkey "#^+Q", "On"
        Hotkey "#^+F2", "Off"
        Hotkey "#^+S", "On"
        Hotkey "Tab", "Off"
        Hotkey "+Tab", "Off"
        Hotkey "Ctrl", "Off"
        Hotkey "#^+K", "Off"
    }
    Else If KeyboardMode = 1 {
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
        Hotkey "#^+X", "On"
        Hotkey "#^+Del", "On"
        Hotkey "#^+F", "On"
        Hotkey "#^+O", "On"
        Hotkey "#^+Q", "On"
        Hotkey "#^+F2", "On"
        Hotkey "#^+S", "On"
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
        Hotkey "#^+X", "On"
        Hotkey "#^+Del", "Off"
        Hotkey "#^+F", "On"
        Hotkey "#^+O", "On"
        Hotkey "#^+Q", "On"
        Hotkey "#^+F2", "Off"
        Hotkey "#^+S", "On"
        Hotkey "Tab", "Off"
        Hotkey "+Tab", "Off"
        Hotkey "Ctrl", "On"
        Hotkey "#^+K", "On"
    }
}

PerformOCR() {
    Global AppName, DialogOpen
    If DialogOpen = 0 {
        DialogOpen := 1
        ConfirmationDialog := MsgBox("OCR the active Window and copy the results to clipboard?", AppName, 4)
        If ConfirmationDialog == "Yes" {
            AvailableLanguages := OCR.GetAvailableLanguages()
            FirstAvailableLanguage := False
            FirstOCRLanguage := False
            PreferredLanguage := False
            PreferredOCRLanguage := ""
            Loop Parse, AvailableLanguages, "`n" {
                If A_Index = 1 And A_LoopField != "" {
                    FirstAvailableLanguage := True
                    FirstOCRLanguage := A_LoopField
                }
                If SubStr(A_LoopField, 1, 3) = "en-" {
                    PreferredLanguage := True
                    PreferredOCRLanguage := A_LoopField
                    Break
                }
            }
            If FirstAvailableLanguage = False And PreferredLanguage = False {
                Sleep 25
                Speak("No OCR languages installed!")
            }
            Else {
                If PreferredLanguage = False
                OCRLanguage := FirstOCRLanguage
                Else
                OCRLanguage := PreferredOCRLanguage
                OCRLines := Array()
                OCRResult := OCR.FromWindow("A", OCRLanguage)
                For OCRLine In OCRResult.Lines {
                    LineWidth := 0
                    For OCRWord In OCRLine.Words
                    LineWidth += OCRWord.BoundingRect.W
                    OCRLines.Push(Map("Text", OCRLine.Text, "X1", OCRLine.Words[1].BoundingRect.X, "Y1", OCRLine.Words[1].BoundingRect.Y, "X2", OCRLine.Words[1].BoundingRect.X + LineWidth, "Y2", OCRLine.Words[OCRLine.Words.Length].BoundingRect.Y + OCRLine.Words[OCRLine.Words.Length].BoundingRect.H))
                }
                ClipboardData := ""
                ConfirmationDialog := MsgBox("Compensate for the position of the currently focused control?", AppName, 4)
                If ConfirmationDialog == "Yes" {
                    Try {
                        WinWaitActive("A")
                        Sleep 1000
                        If ControlGetFocus("A") = 0 {
                            Speak("Focused control not found")
                        }
                        Else {
                            ControlGetPos &ControlX, &ControlY,,, ControlGetClassNN(ControlGetFocus("A")), "A"
                            ClipboardData .= "Compensating for X " . ControlX . ", Y " . ControlY . "`r`n"
                            For Value In OCRLines {
                                Text := Value["Text"]
                                X1Coordinate := Value["X1"] - ControlX
                                Y1Coordinate := Value["Y1"] - ControlY
                                X2Coordinate := Value["X2"] - ControlX
                                Y2Coordinate := Value["Y2"] - ControlY
                                ClipboardData .= "`"" . Text . "`"`r`nBeginning at X " . X1Coordinate . ", Y " . Y1Coordinate . "`r`nEnding approximately at X " . X2Coordinate . ", Y " . Y2Coordinate . "`r`n`r`n"
                            }
                        }
                    }
                }
                Else {
                    Sleep 1000
                    For Value In OCRLines {
                        Text := Value["Text"]
                        X1Coordinate := Value["X1"]
                        Y1Coordinate := Value["Y1"]
                        X2Coordinate := Value["X2"]
                        Y2Coordinate := Value["Y2"]
                        ClipboardData .= "`"" . Text . "`"`r`nBeginning at X " . X1Coordinate . ", Y " . Y1Coordinate . "`r`nEnding approximately at X " . X2Coordinate . ", Y " . Y2Coordinate . "`r`n`r`n"
                    }
                }
                ClipboardData := RTrim(ClipboardData, "`r`n")
                A_Clipboard := ClipboardData
                If OCRLines.Length = 1
                Speak("1 OCR line copied to clipboard")
                Else
                Speak(OCRLines.Length . " OCR lines copied to clipboard")
            }
        }
        DialogOpen := 0
    }
}

Quit(*) {
    Global AppName, DialogOpen
    If DialogOpen = 0 {
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
    If DialogOpen = 0
    If Hotspots.Length > 0 And CurrentHotspot > 0 And CurrentHotspot <= Hotspots.Length {
        DialogOpen := 1
        RenameDialog := InputBox("Enter a new name for this hotspot.", AppName, "", Hotspots[CurrentHotspot]["Label"])
        If RenameDialog.Result == "OK" And RenameDialog.Value != "" {
            Hotspots[CurrentHotspot]["Label"] := RenameDialog.Value
            Sleep 25
            Speak(Hotspots[CurrentHotspot]["Label"])
        }
        DialogOpen := 0
    }
    Else {
        Sleep 25
        Speak("No Hotspot Selected")
    }
}

SearchForImage() {
    Global AppName, DialogOpen
    If DialogOpen = 0 {
        DialogOpen := 1
        ImageFile := FileSelect(3,, "Choose Image", "Supported Images (*.ANI; *.BMP; *.CUR; *.EMF; *.Exif; *.GIF; *.ICO; *.JPG; *.PNG; *.TIF; *.WMF)")
        If ImageFile != "" {
            FoundX := ""
            FoundY := ""
            WinWidth := ""
            WinHeight := ""
            Try {
                WinGetPos ,, &WinWidth, &WinHeight, "A"
            }
            Catch {
                WinWidth := A_ScreenWidth
                WinHeight := A_ScreenHeight
            }
            Try {
                WinWaitActive("A")
                Sleep 1000
                If ImageSearch(&FoundX, &FoundY, 0, 0, WinWidth, WinHeight, ImageFile) {
                    ConfirmationDialog := MsgBox("Your image has been found at X " . FoundX . ", Y " . FoundY . ".`nCopy its coordinates to clipboard?", AppName, 4)
                    If ConfirmationDialog == "Yes" {
                        ClipboardData := ""
                        ConfirmationDialog := MsgBox("Compensate for the position of the currently focused control?", AppName, 4)
                        If ConfirmationDialog == "Yes" {
                            WinWaitActive("A")
                            If ControlGetFocus("A") = 0 {
                                Speak("Focused control not found")
                            }
                            Else {
                                ControlGetPos &ControlX, &ControlY,,, ControlGetClassNN(ControlGetFocus("A")), "A"
                                ClipboardData .= "Compensating for X " . ControlX . ", Y " . ControlY . "`r`n"
                                If FoundX Is Number
                                ImageXCoordinate := FoundX - ControlX
                                Else
                                ImageXCoordinate := ""
                                If FoundY Is Number
                                ImageYCoordinate := FoundY - ControlY
                                Else
                                ImageYCoordinate := ""
                                ClipboardData .= "`"" . ImageFile . "`", " . ImageXCoordinate . ", " . ImageYCoordinate
                            }
                        }
                        Else {
                            ImageXCoordinate := FoundX
                            ImageYCoordinate := FoundY
                            ClipboardData .= "`"" . ImageFile . "`", " . ImageXCoordinate . ", " . ImageYCoordinate
                        }
                        A_Clipboard := ClipboardData
                        Speak("Image coordinates copied to clipboard")
                    }
                }
                Else {
                    MsgBox "The image you selected has not been found on the screen.", AppName
                }
            }
        }
        DialogOpen := 0
    }
}

SelectNextHotspot() {
    Global CurrentHotspot, DialogOpen, Hotspots
    If DialogOpen = 0
    If Hotspots.Length > 0 {
        CurrentHotspot++
        If CurrentHotspot > Hotspots.Length
        CurrentHotspot := 1
        MouseMove Hotspots[CurrentHotspot]["XCoordinate"], Hotspots[CurrentHotspot]["YCoordinate"]
        Sleep 25
        Speak(Hotspots[CurrentHotspot]["Label"])
    }
    Else {
        Sleep 25
        Speak("No hotspots defined")
    }
}

SelectPreviousHotspot() {
    Global CurrentHotspot, DialogOpen, Hotspots
    If DialogOpen = 0
    If Hotspots.Length > 0 {
        CurrentHotspot--
        If CurrentHotspot < 1
        CurrentHotspot := Hotspots.Length
        MouseMove Hotspots[CurrentHotspot]["XCoordinate"], Hotspots[CurrentHotspot]["YCoordinate"]
        Sleep 25
        Speak(Hotspots[CurrentHotspot]["Label"])
    }
    Else {
        Sleep 25
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
    If  KeyboardMode = 0 {
        KeyboardMode := 1
        Sleep 25
        Speak("Keyboard mode on")
    }
    Else {
        KeyboardMode := 0
        Sleep 25
        Speak("Keyboard mode off")
    }
}
