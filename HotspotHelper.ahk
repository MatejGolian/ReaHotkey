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
#^+C::CopyControlClassAndPositionToClipboard()
#^+L::CopyControlListToClipboard()
#^+H::CopyHotspotsToClipboard()
#^+M::CopyPixelColourToClipboard()
#^+P::CopyProcessNameToClipboard()
#^+W::CopyWindowClassToClipboard()
#^+I::CopyWindowIDToClipboard()
#^+T::CopyWindowTitleToClipboard()
#^+Del::DeleteAllHotspots()
Del::DeleteHotspot()
#^+F::FocusControlFromList()
#^+Down::MoveMouseDown()
#^+Left::MoveMouseLeft()
#^+Right::MoveMouseRight()
#^+Up::MoveMouseUp()
#^+O::PerformOCR()
#^+Q::Quit()
F2::RenameHotspot()
#^+Z::ReportMousePosition()
#^+R::RouteMouseToFocusedControl()
#^+S::SearchForImage()
Tab::SelectNextHotspot()
+Tab::SelectPreviousHotspot()
#^+X::SetMouseXPosition()
#^+Y::SetMouseYPosition()
Ctrl::StopSpeech()
#^+K::ToggleKeyboardMode()
#^+V::ViewClipboard()

SetTimer ManageHotkeys, 100
About()

About(*) {
    Global AppName, DialogOpen
    Static FirstShow := True
    If DialogOpen = 0 {
        DialogOpen := 1
        AboutBox := Gui(, "About " . AppName)
        AboutBox.Add("Edit", "ReadOnly", "Use this tool to determine hotspot mouse coordinates, obtain information about the active window and its controls and copy the retrieved info to clipboard.`nEnable keyboard mode whenever you want to click, delete or rename previously added individual hotspots.`n`nKeyboard Shortcuts`n`nHotspot Shortcuts:`nWin+Ctrl+Shift+Enter - Add hotspot`nWin+Ctrl+Shift+Del - Delete all hotspots`nWin+Ctrl+Shift+H - Copy hotspots to clipboard`nKeyboard Mode Shortcuts:`nWin+Ctrl+Shift+K - Toggle keyboard mode on/off`nTab - Select next hotspot`nShift+Tab - Select previous hotspot`nEnter - Click current hotspot`nDel - Delete current hotspot`nF2 - Rename current hotspot`n`nWindow & Control Shortcuts:`nWin+Ctrl+Shift+I - Copy the ID of the active window to clipboard`nWin+Ctrl+Shift+P - Copy the process name of the active window to clipboard`nWin+Ctrl+Shift+T - Copy the title of the active window to clipboard`nWin+Ctrl+Shift+W - Copy the class of the active window to clipboard`nWin+Ctrl+Shift+C - Copy the class and position of the currently focused control to clipboard`nWin+Ctrl+Shift+L - Copy control list to clipboard`nWin+Ctrl+Shift+F - Focus control`n`nMouse Shortcuts:`nWin+Ctrl+Shift+M - Copy the pixel colour under the mouse to clipboard`nWin+Ctrl+Shift+R - Route the mouse to the position of the currently focused control`nWin+Ctrl+Shift+X - Set mouse X position`nWin+Ctrl+Shift+Y - Set mouse Y position`nWin+Ctrl+Shift+Z - Report mouse position`nWin+Ctrl+Shift+Left - Move mouse leftf`nWin+Ctrl+Shift+Right - Move mouse right`nWin+Ctrl+Shift+Up - Move mouse up`nWin+Ctrl+Shift+Down - Move mouse down`n`nMiscellaneous Shortcuts:`nWin+Ctrl+Shift+O - OCR the active window`nWin+Ctrl+Shift+S - Search for image`nWin+Ctrl+Shift+V - Open Clipboard Viewer`nWin+Ctrl+Shift+A - About the app`nWin+Ctrl+Shift+Q - Quit the app`nCtrl - Stop speech")
        AboutBox.Add("Button", "Default", "OK").OnEvent("Click", CloseAboutBox)
        AboutBox.OnEvent("Close", CloseAboutBox)
        AboutBox.OnEvent("Escape", CloseAboutBox)
        AboutBox.Show()
        CloseAboutBox(*) {
            AboutBox.Destroy()
            DialogOpen := 0
            If FirstShow = True {
                FirstShow := False
                Sleep 500
                Speak(AppName . " ready")
            }
        }
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

CopyControlClassAndPositionToClipboard() {
    Global AppName, DialogOpen
    If DialogOpen = 0 {
        DialogOpen := 1
        Try {
            WinWaitActive("A")
            If ControlGetFocus("A") = 0 {
                Speak("Focused control not found")
            }
            Else {
                FocusedControlClass := ControlGetClassNN(ControlGetFocus("A"))
                ControlGetPos &ControlX, &ControlY,,, FocusedControlClass, "A"
                ConfirmationDialog := MsgBox("Copy the class and position of the currently focused control to clipboard?", AppName, 4)
                If ConfirmationDialog == "Yes" {
                    Sleep 1000
                    A_Clipboard := "`"" . FocusedControlClass . "`", " . ControlX . ", " . ControlY
                    Speak("Control class and position copied to clipboard")
                }
            }
        }
        DialogOpen := 0
    }
}

CopyControlListToClipboard() {
    Global AppName, DialogOpen
    If DialogOpen = 0 {
        DialogOpen := 1
        Try {
            WinWaitActive("A")
            Controls := WinGetControls("A")
        }
        Catch {
            Controls := Array()
        }
        If Controls.Length = 0 {
            Speak("No controls found")
        }
        Else {
            ConfirmationDialog := MsgBox("Copy control list to clipboard?", AppName, 4)
            If ConfirmationDialog == "Yes" {
                Sleep 1000
                ClipboardData := ""
                For Control In controls {
                    ControlClass := ControlGetClassNN(Control)
                    Try {
                        ControlGetPos &ControlX, &ControlY,,, ControlClass, "A"
                    }
                    Catch {
                        ControlX := "-"
                        ControlY := "-"
                    }
                    ClipboardData .= "`"" . ControlClass . "`", " . ControlX . ", " . ControlY . "`r`n"
                }
                ClipboardData := RTrim(ClipboardData, "`r`n")
                A_Clipboard := ClipboardData
                If Controls.Length = 1
                Speak("1 control copied to clipboard")
                Else
                Speak(Controls.Length . " controls copied to clipboard")
            }
        }
        DialogOpen := 0
    }
}

CopyHotspotsToClipboard() {
    Global AppName, DialogOpen, Hotspots
    If DialogOpen = 0 {
        DialogOpen := 1
        Try {
            WinWaitActive("A")
            FocusedControlClass := ControlGetClassNN(ControlGetFocus("A"))
            ControlGetPos &ControlX, &ControlY,,, FocusedControlClass, "A"
        }
        Catch {
            FocusedControlClass := False
            ControlX := 0
            ControlY := 0
        }
        If Hotspots.Length = 0 {
            Speak("No hotspots defined")
        }
        Else {
            ConfirmationDialog := MsgBox("Copy hotspots to clipboard?", AppName, 4)
            If ConfirmationDialog == "Yes" {
                ClipboardData := ""
                ConfirmationDialog := MsgBox("Compensate for the position of the currently focused control?", AppName, 4)
                If ConfirmationDialog == "Yes" {
                    Sleep 1000
                    If FocusedControlClass = False {
                        Speak("Focused control not found")
                    }
                    Else {
                        ClipboardData .= "Compensating for X " . ControlX . ", Y " . ControlY . "`r`n"
                        For Value In Hotspots {
                            Label := Value["Label"]
                            MouseXCoordinate := Value["XCoordinate"] - ControlX
                            MouseYCoordinate := Value["YCoordinate"] - ControlY
                            ClipboardData .= "`"" . Label . "`", " . MouseXCoordinate . ", " . MouseYCoordinate . "`r`n"
                        }
                    }
                }
                Else {
                    Sleep 1000
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
            Sleep 1000
            Try {
                WinWaitActive("A")
                A_Clipboard := WinGetProcessName("A")
                Speak("Process name copied to clipboard")
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
            Sleep 1000
            Try {
                WinWaitActive("A")
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
            Sleep 1000
            Try {
                WinWaitActive("A")
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
            Sleep 1000
            Try {
                WinWaitActive("A")
                A_Clipboard := WinGetTitle("A")
                Speak("Window title copied to clipboard")
            }
        }
        DialogOpen := 0
    }
}

DeleteAllHotspots() {
    Global AppName, CurrentHotspot, DialogOpen, Hotspots
    If DialogOpen = 0 {
        DialogOpen := 1
        If Hotspots.Length = 0 {
            Speak("No hotspots defined")
        }
        Else {
            ConfirmationDialog := MsgBox("Delete all hotspots?", AppName, 4)
            If ConfirmationDialog == "Yes" {
                Sleep 1000
                HotspotCount := Hotspots.Length
                CurrentHotspot := 0
                Hotspots := Array()
                If HotspotCount = 1
                Speak("1 hotspot deleted")
                Else
                Speak(HotspotCount . " hotspots deleted")
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
        ControlFocus ControlName, "A"
        If ControlGetClassNN(ControlGetFocus("A")) = ControlName {
            Speak(ControlName . " focused")
        }
    }
    Catch {
        Speak("Control not found")
    }
}

FocusControlFromList() {
    Global AppName, DialogOpen
    If DialogOpen = 0 {
        DialogOpen := 1
        Try {
            WinWaitActive("A")
            Controls := WinGetControls("A")
            FocusedControlClass := ControlGetClassNN(ControlGetFocus("A"))
        }
        Catch {
            Controls := Array()
            FocusedControlClass := False
        }
        If Controls.Length = 0 {
            Speak("No controls found")
        }
        Else {
            ControlMenu := Menu()
            For Control In controls {
                ControlMenu.Add(Control, FocusControl)
                If Control = FocusedControlClass
                ControlMenu.Check(control)
            }
            ControlMenu.Show()
        }
        DialogOpen := 0
    }
}

ManageHotkeys() {
    Global DialogOpen, KeyboardMode
    If DialogOpen = 1 Or WinActive("ahk_exe Explorer.Exe") Or WinActive("ahk_class Shell_TrayWnd" Or WinExist("ahk_class #32768") ) {
        Hotkey "#^+A", "On"
        Hotkey "#^+Enter", "Off"
        Hotkey "Enter", "Off"
        Hotkey "#^+C", "On"
        Hotkey "#^+L", "On"
        Hotkey "#^+H", "On"
        Hotkey "#^+M", "On"
        Hotkey "#^+P", "On"
        Hotkey "#^+W", "On"
        Hotkey "#^+I", "On"
        Hotkey "#^+T", "On"
        Hotkey "#^+Del", "Off"
        Hotkey "Del", "Off"
        Hotkey "#^+F", "On"
        Hotkey "#^+Down", "On"
        Hotkey "#^+Left", "On"
        Hotkey "#^+Right", "On"
        Hotkey "#^+Up", "On"
        Hotkey "#^+O", "On"
        Hotkey "#^+Q", "On"
        Hotkey "F2", "Off"
        Hotkey "#^+Z", "On"
        Hotkey "#^+R", "On"
        Hotkey "#^+S", "On"
        Hotkey "Tab", "Off"
        Hotkey "+Tab", "Off"
        Hotkey "Ctrl", "Off"
        Hotkey "#^+K", "Off"
        Hotkey "#^+V", "On"
    }
    Else If KeyboardMode = 1 {
        Hotkey "#^+A", "On"
        Hotkey "#^+Enter", "On"
        Hotkey "Enter", "On"
        Hotkey "#^+C", "On"
        Hotkey "#^+L", "On"
        Hotkey "#^+H", "On"
        Hotkey "#^+M", "On"
        Hotkey "#^+P", "On"
        Hotkey "#^+W", "On"
        Hotkey "#^+I", "On"
        Hotkey "#^+T", "On"
        Hotkey "#^+Del", "On"
        Hotkey "Del", "On"
        Hotkey "#^+F", "On"
        Hotkey "#^+Down", "On"
        Hotkey "#^+Left", "On"
        Hotkey "#^+Right", "On"
        Hotkey "#^+Up", "On"
        Hotkey "#^+O", "On"
        Hotkey "#^+Q", "On"
        Hotkey "F2", "On"
        Hotkey "#^+Z", "On"
        Hotkey "#^+R", "On"
        Hotkey "#^+S", "On"
        Hotkey "Tab", "On"
        Hotkey "+Tab", "On"
        Hotkey "Ctrl", "On"
        Hotkey "#^+K", "On"
        Hotkey "#^+V", "On"
    }
    Else {
        Hotkey "#^+A", "On"
        Hotkey "#^+Enter", "On"
        Hotkey "Enter", "Off"
        Hotkey "#^+C", "On"
        Hotkey "#^+L", "On"
        Hotkey "#^+H", "On"
        Hotkey "#^+M", "On"
        Hotkey "#^+P", "On"
        Hotkey "#^+W", "On"
        Hotkey "#^+I", "On"
        Hotkey "#^+T", "On"
        Hotkey "#^+Del", "On"
        Hotkey "Del", "Off"
        Hotkey "#^+F", "On"
        Hotkey "#^+Down", "On"
        Hotkey "#^+Left", "On"
        Hotkey "#^+Right", "On"
        Hotkey "#^+Up", "On"
        Hotkey "#^+O", "On"
        Hotkey "#^+Q", "On"
        Hotkey "F2", "Off"
        Hotkey "#^+Z", "On"
        Hotkey "#^+R", "On"
        Hotkey "#^+S", "On"
        Hotkey "Tab", "Off"
        Hotkey "+Tab", "Off"
        Hotkey "Ctrl", "On"
        Hotkey "#^+K", "On"
        Hotkey "#^+V", "On"
    }
}

MoveMouseDown() {
    Global DialogOpen
    If DialogOpen = 0 {
        DialogOpen := 1
        WinGetPos ,,, &YSize, "A"
        MouseGetPos &MouseXCoordinate, &MouseYCoordinate
        If MouseYCoordinate < 0
        TargetCoordinate := 0
        Else If MouseYCoordinate > YSize
        TargetCoordinate := YSize
        Else
        TargetCoordinate := MouseYCoordinate + 1
        If TargetCoordinate > YSize
        TargetCoordinate := YSize
        MouseYCoordinate := TargetCoordinate
        MouseMove MouseXCoordinate, MouseYCoordinate
        Speak(MouseYCoordinate)
        DialogOpen := 0
    }
}

MoveMouseLeft() {
    Global DialogOpen
    If DialogOpen = 0 {
        DialogOpen := 1
        WinGetPos ,, &XSize,, "A"
        MouseGetPos &MouseXCoordinate, &MouseYCoordinate
        If MouseXCoordinate < 0
        TargetCoordinate := 0
        Else If MouseXCoordinate > XSize
        TargetCoordinate := XSize
        Else
        TargetCoordinate := MouseXCoordinate - 1
        If TargetCoordinate < 0
        TargetCoordinate := 0
        MouseXCoordinate := TargetCoordinate
        MouseMove MouseXCoordinate, MouseYCoordinate
        Speak(MouseXCoordinate)
        DialogOpen := 0
    }
}

MoveMouseRight() {
    Global DialogOpen
    If DialogOpen = 0 {
        DialogOpen := 1
        WinGetPos ,, &XSize,, "A"
        MouseGetPos &MouseXCoordinate, &MouseYCoordinate
        If MouseXCoordinate < 0
        TargetCoordinate := 0
        Else If MouseXCoordinate > XSize
        TargetCoordinate := XSize
        Else
        TargetCoordinate := MouseXCoordinate + 1
        If TargetCoordinate > XSize
        TargetCoordinate := XSize
        MouseXCoordinate := TargetCoordinate
        MouseMove MouseXCoordinate, MouseYCoordinate
        Speak(MouseXCoordinate)
        DialogOpen := 0
    }
}

MoveMouseUp() {
    Global DialogOpen
    If DialogOpen = 0 {
        DialogOpen := 1
        WinGetPos ,,, &YSize, "A"
        MouseGetPos &MouseXCoordinate, &MouseYCoordinate
        If MouseYCoordinate < 0
        TargetCoordinate := 0
        Else If MouseYCoordinate > YSize
        TargetCoordinate := YSize
        Else
        TargetCoordinate := MouseYCoordinate - 1
        If TargetCoordinate < 0
        TargetCoordinate := 0
        MouseYCoordinate := TargetCoordinate
        MouseMove MouseXCoordinate, MouseYCoordinate
        Speak(MouseYCoordinate)
        DialogOpen := 0
    }
}

PerformOCR() {
    Global AppName, DialogOpen
    If DialogOpen = 0 {
        DialogOpen := 1
        Try {
            WinWaitActive("A")
            FocusedControlClass := ControlGetClassNN(ControlGetFocus("A"))
            ControlGetPos &ControlX, &ControlY,,, FocusedControlClass, "A"
        }
        Catch {
            FocusedControlClass := False
            ControlX := 0
            ControlY := 0
        }
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
                    OCRLines.Push(Map("Text", OCRLine.Text, "X1", OCR.WordsBoundingRect(OCRLine.Words*).X, "Y1", OCR.WordsBoundingRect(OCRLine.Words*).Y, "X2", OCR.WordsBoundingRect(OCRLine.Words*).X + OCR.WordsBoundingRect(OCRLine.Words*).W, "Y2", OCR.WordsBoundingRect(OCRLine.Words*).Y + OCR.WordsBoundingRect(OCRLine.Words*).H))
                }
                ClipboardData := ""
                ConfirmationDialog := MsgBox("Compensate for the position of the currently focused control?", AppName, 4)
                If ConfirmationDialog == "Yes" {
                    Sleep 1000
                    If FocusedControlClass = False {
                        Speak("Focused control not found")
                    }
                    Else {
                        ClipboardData .= "Compensating for X " . ControlX . ", Y " . ControlY . "`r`n"
                        For Value In OCRLines {
                            Text := Value["Text"]
                            X1Coordinate := Value["X1"] - ControlX
                            Y1Coordinate := Value["Y1"] - ControlY
                            X2Coordinate := Value["X2"] - ControlX
                            Y2Coordinate := Value["Y2"] - ControlY
                            ClipboardData .= "`"" . Text . "`"`r`nBeginning at X " . X1Coordinate . ", Y " . Y1Coordinate . "`r`nEnding at X " . X2Coordinate . ", Y " . Y2Coordinate . "`r`n`r`n"
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
                        ClipboardData .= "`"" . Text . "`"`r`nBeginning at X " . X1Coordinate . ", Y " . Y1Coordinate . "`r`nEnding at X " . X2Coordinate . ", Y " . Y2Coordinate . "`r`n`r`n"
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
    Global AppName, CurrentHotspot, DialogOpen, Hotspots
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

ReportMousePosition() {
    Global DialogOpen
    If DialogOpen = 0 {
        MouseGetPos &MouseXCoordinate, &MouseYCoordinate
        Speak("X " . MouseXCoordinate . " Y " . MouseYCoordinate)
    }
}

RouteMouseToFocusedControl() {
    Global AppName, DialogOpen
    If DialogOpen = 0 {
        DialogOpen := 1
        Try {
            WinWaitActive("A")
            If ControlGetFocus("A") = 0 {
                Speak("Focused control not found")
            }
            Else {
                WinWaitActive("A")
                ControlGetPos &ControlX, &ControlY,,, ControlGetClassNN(ControlGetFocus("A")), "A"
                MouseMove ControlX, ControlY
                Speak("Mouse routed to X " . ControlX . " Y " . ControlY)
            }
        }
        DialogOpen := 0
    }
}

SearchForImage() {
    Global AppName, DialogOpen
    If DialogOpen = 0 {
        DialogOpen := 1
        Try {
            WinWaitActive("A")
            FocusedControlClass := ControlGetClassNN(ControlGetFocus("A"))
            ControlGetPos &ControlX, &ControlY,,, FocusedControlClass, "A"
        }
        Catch {
            FocusedControlClass := False
            ControlX := 0
            ControlY := 0
        }
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
                            Sleep 1000
                            If FocusedControlClass = False {
                                Speak("Focused control not found")
                            }
                            Else {
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
                            Sleep 1000
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

SetMouseXPosition() {
    Global AppName, DialogOpen
    If DialogOpen = 0 {
        DialogOpen := 1
        WinGetPos ,, &XSize,, "A"
        MouseGetPos &MouseXCoordinate, &MouseYCoordinate
        If MouseXCoordinate < 0
        MouseXCoordinate := 0
        If MouseXCoordinate > XSize
        MouseXCoordinate := XSize
        PositionDialog := InputBox("Set Mouse X Position`nEnter a number between 0 and " . XSize . ".", AppName, "", MouseXCoordinate)
        If PositionDialog.Result == "OK" And Integer(PositionDialog.Value) >= 0 And Integer(PositionDialog.Value) <= XSize
        MouseMove Integer(PositionDialog.Value), MouseYCoordinate
        DialogOpen := 0
    }
}

SetMouseYPosition() {
    Global AppName, DialogOpen
    If DialogOpen = 0 {
        DialogOpen := 1
        WinGetPos ,,, &YSize, "A"
        MouseGetPos &MouseXCoordinate, &MouseYCoordinate
        If MouseYCoordinate < 0
        MouseYCoordinate := 0
        If MouseYCoordinate > YSize
        MouseYCoordinate := YSize
        PositionDialog := InputBox("Set Mouse Y Position`nEnter a number between 0 and " . YSize . ".", AppName, "", MouseYCoordinate)
        If PositionDialog.Result == "OK" And Integer(PositionDialog.Value) >= 0 And Integer(PositionDialog.Value) <= YSize
        MouseMove MouseXCoordinate, Integer(PositionDialog.Value)
        DialogOpen := 0
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

ViewClipBoard(*) {
    Global AppName, DialogOpen
    If DialogOpen = 0 {
        DialogOpen := 1
        ViewerBox := Gui(, AppName . " Clipboard Viewer")
        ViewerBox.Add("Edit", "ReadOnly", A_Clipboard)
        ViewerBox.Add("Button", "Default", "OK").OnEvent("Click", CloseViewerBox)
        ViewerBox.OnEvent("Close", CloseViewerBox)
        ViewerBox.OnEvent("Escape", CloseViewerBox)
        ViewerBox.Show()
        CloseViewerBox(*) {
            ViewerBox.Destroy()
            DialogOpen := 0
        }
    }
}

Version := "0.2.0"
;@Ahk2Exe-Let U_version = %A_PriorLine~U)^(.+"){1}(.+)".*$~$2%
    ;@Ahk2Exe-Let U_OrigFilename = %A_ScriptName~\.[^\.]+$~.exe%
    ;@Ahk2Exe-SetDescription HotspotHelper
    ;@Ahk2Exe-SetFileVersion %U_Version%
    ;@Ahk2Exe-SetProductName HotspotHelper
    ;@Ahk2Exe-SetProductVersion %U_Version%
;@Ahk2Exe-SetOrigFilename %U_OrigFilename%
