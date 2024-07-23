#Requires AutoHotkey v2.0

#MaxThreadsPerHotkey 1
#SingleInstance Force
#Warn All
SendMode "Input"
SetTitleMatchMode 2
SetWorkingDir A_InitialWorkingDir
CoordMode "Mouse", "Window"
CoordMode "Pixel", "Window"

#Include <ScreenArea2File>
#Include <OCR>

AppName := "HotspotHelper"
CurrentHotspot := 0
DialogOpen := 0
Hotspots := Array()
KeyboardMode := 0
LastImage := ""
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
#^+U::CopyPixelColourToClipboard()
#^+P::CopyProcessNameToClipboard()
#^+W::CopyWindowClassToClipboard()
#^+I::CopyWindowIDToClipboard()
#^+T::CopyWindowTitleToClipboard()
#^+Del::DeleteAllHotspots()
Del::DeleteHotspot()
#^+PrintScreen::ExtractImage()
#^+F::FocusControl()
#^+G::GenerateHotspotsFromOCR()
#^+Down::MoveMouseDown()
#^+Left::MoveMouseLeft()
#^+Right::MoveMouseRight()
#^+Up::MoveMouseUp()
#^+O::PerformOCR()
#^+Q::Quit()
F2::RenameHotspot()
#^+R::SearchForImage(LastImage)
#^+Z::ReportMousePosition()
#^+M::RouteMouseToFocusedControl()
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
        AboutBox.AddEdit("ReadOnly", "Use this tool to determine hotspot mouse coordinates, obtain information about the active window and its controls and copy the retrieved info to clipboard.`nEnable keyboard mode whenever you want to click, delete or rename previously added individual hotspots.`n`nKeyboard Shortcuts`n`nHotspot Shortcuts:`nWin+Ctrl+Shift+Enter - Add hotspot`nWin+Ctrl+Shift+Del - Delete all hotspots`nWin+Ctrl+Shift+H - Copy hotspots to clipboard`nKeyboard Mode Shortcuts:`nWin+Ctrl+Shift+K - Toggle keyboard mode on/off`nTab - Select next hotspot`nShift+Tab - Select previous hotspot`nEnter - Click current hotspot`nDel - Delete current hotspot`nF2 - Rename current hotspot`n`nWindow & Control Shortcuts:`nWin+Ctrl+Shift+I - Copy the ID of the active window to clipboard`nWin+Ctrl+Shift+P - Copy the process name of the active window to clipboard`nWin+Ctrl+Shift+T - Copy the title of the active window to clipboard`nWin+Ctrl+Shift+W - Copy the class of the active window to clipboard`nWin+Ctrl+Shift+C - Copy the class and position of the currently focused control to clipboard`nWin+Ctrl+Shift+L - Copy control list to clipboard`nWin+Ctrl+Shift+F - Focus control`n`nMouse Shortcuts:`nWin+Ctrl+Shift+M - Route the mouse to the position of the currently focused control`nWin+Ctrl+Shift+U - Copy the pixel colour under the mouse to clipboard`nWin+Ctrl+Shift+X - Set mouse X position`nWin+Ctrl+Shift+Y - Set mouse Y position`nWin+Ctrl+Shift+Z - Report mouse position`nWin+Ctrl+Shift+Left - Move mouse leftf`nWin+Ctrl+Shift+Right - Move mouse right`nWin+Ctrl+Shift+Up - Move mouse up`nWin+Ctrl+Shift+Down - Move mouse down`n`nMiscellaneous Shortcuts:`nWin+Ctrl+Shift+Print Screen - Extract a region of the active window as an image`nWin+Ctrl+Shift+O - OCR the active window`nWin+Ctrl+Shift+G - Generate hotspots from OCR`n`nWin+Ctrl+Shift+S - Search for image`nWin+Ctrl+Shift+R - Repeat search using last image`nWin+Ctrl+Shift+V - Open Clipboard Viewer`nWin+Ctrl+Shift+A - About the app`nWin+Ctrl+Shift+Q - Quit the app`nCtrl - Stop speech")
        AboutBox.AddButton("Default", "OK").OnEvent("Click", CloseAboutBox)
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
            FocusedControlClass := ControlGetClassNN(ControlGetFocus("A"))
        }
        Catch {
            FocusedControlClass := False
        }
        If FocusedControlClass = False {
            Speak("Focused control not found")
        }
        Else {
            ControlGetPos &ControlX, &ControlY,,, FocusedControlClass, "A"
            ConfirmationDialog := MsgBox("Copy the class and position of the currently focused control to clipboard?", AppName, 4)
            If ConfirmationDialog == "Yes" {
                Sleep 1000
                A_Clipboard := "`"" . FocusedControlClass . "`", " . ControlX . ", " . ControlY
                Speak("Control class and position copied to clipboard")
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
                ProcessName := WinGetProcessName("A")
                A_Clipboard := ProcessName
            }
            Catch {
                ProcessName := False
            }
            If ProcessName = False
            Speak("Process not found")
            Else
            Speak("Process name copied to clipboard")
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
                WindowClass := WinGetClass("A")
                A_Clipboard := WindowClass
            }
            Catch {
                WindowClass := False
            }
            If WindowClass = False
            Speak("Window class not found")
            Else
            Speak("Window class copied to clipboard")
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
                WindowID := WinGetID("A")
                A_Clipboard := WindowID
            }
            Catch {
                WindowID := False
            }
            If WindowID = False
            Speak("Window ID not found")
            Else
            Speak("Window ID copied to clipboard")
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
                WindowTitle := WinGetTitle("A")
                A_Clipboard := WindowTitle
            }
            Catch {
                WindowTitle := False
            }
            If WindowTitle = False
            Speak("Window title not found")
            Else
            Speak("Window title copied to clipboard")
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

ExtractImage(*) {
    Global AppName, DialogOpen
    Static X1Coord := "", Y1Coord := "", X2Coord := "", Y2Coord := ""
    Try {
        WindowID := WinGetID("A")
        WindowTitle := WinGetTitle("A")
        WinGetPos ,, &XSize, &YSize, "A"
    }
    Catch {
        Speak("Could not obtain required information")
        Return
    }
    If DialogOpen = 0 {
        DialogOpen := 1
        CoordinateBox := Gui(, AppName . " Image Extractor {`"" . WindowTitle . "`"}")
        CoordinateBox.AddText(, "X1 coordinate (between 0 and " . XSize . "):")
        CoordinateBox.AddEdit("vX1Coord Number YS", X1Coord).OnEvent("Change", ProcessInput)
        CoordinateBox.AddText("YS", "Y1 coordinate (between 0 and " . YSize . "):")
        CoordinateBox.AddEdit("vY1Coord Number YS", Y1Coord).OnEvent("Change", ProcessInput)
        CoordinateBox.AddButton("YS", "Select hotspot...").OnEvent("Click", ShowHotspotMenu1)
        CoordinateBox.AddText("Section XS", "X2 coordinate (between 0 and " . XSize . "):")
        CoordinateBox.AddEdit("vX2Coord Number YS", X2Coord).OnEvent("Change", ProcessInput)
        CoordinateBox.AddText("YS", "Y2 coordinate (between 0 and " . YSize . "):")
        CoordinateBox.AddEdit("vY2Coord Number YS", Y2Coord).OnEvent("Change", ProcessInput)
        CoordinateBox.AddButton("YS", "Select hotspot...").OnEvent("Click", ShowHotspotMenu2)
        CoordinateBox.AddButton("Disabled Section XS", "OK").OnEvent("Click", SaveImage)
        CoordinateBox.AddButton("Default YS", "Cancel").OnEvent("Click", CloseCoordinateBox)
        CoordinateStatus := CoordinateBox.Add("StatusBar")
        CoordinateBox.OnEvent("Close", CloseCoordinateBox)
        CoordinateBox.OnEvent("Escape", CloseCoordinateBox)
        CoordinateBox.Show()
        HotspotMenuHandler(MenuItemLabel, MenuItemNumber, HotspotMenu) {
            Global Hotspots
            CoordinateBox["X" . HotspotMenu.Number . "Coord"].Value := Hotspots[MenuItemNumber - 1]["XCoordinate"]
            CoordinateBox["Y" . HotspotMenu.Number . "Coord"].Value := Hotspots[MenuItemNumber - 1]["YCoordinate"]
            ProcessInput()
        }
        ProcessInput()
        CloseCoordinateBox(*) {
            CoordinateBox.Destroy()
            DialogOpen := 0
        }
        ProcessInput(*) {
            ControlValues := CoordinateBox.Submit(False)
            X1 := ControlValues.X1Coord
            Y1 := ControlValues.Y1Coord
            X2 := ControlValues.X2Coord
            Y2 := ControlValues.Y2Coord
            If X1 != "" And Y1 != "" And X2 != "" And Y2 != "" And X1 >= 0 And X1 < X2 And X2 <= XSize And Y1 >= 0 And Y1 < Y2 And Y2 <= YSize {
                CoordinateBox["OK"].Opt("+Default -Disabled")
                CoordinateBox["Cancel"].Opt("-Default")
                CoordinateStatus.SetText("`tImage dimensions " . X2 - X1 . " × " . Y2 - Y1)
            }
            Else {
                CoordinateBox["OK"].Opt("-Default +Disabled")
                CoordinateBox["Cancel"].Opt("+Default")
                CoordinateStatus.SetText("`tImage dimensions unknown")
            }
        }
        SaveImage(*) {
            ControlValues := CoordinateBox.Submit(True)
            ControlValues := CoordinateBox.Submit(False)
            X1Coord := ControlValues.X1Coord
            Y1Coord := ControlValues.Y1Coord
            X2Coord := ControlValues.X2Coord
            Y2Coord := ControlValues.Y2Coord
            X1 := ControlValues.X1Coord
            Y1 := ControlValues.Y1Coord
            X2 := ControlValues.X2Coord
            Y2 := ControlValues.Y2Coord
            If Not WinExist("ahk_id" . WindowID) {
                MsgBox "Target window not found.", AppName
                CloseCoordinateBox()
            }
            Else {
                WinActivate("ahk_id" . WindowID)
                WinWaitActive("ahk_id" . WindowID)
                Coord := WinCoordToScreenCoord(X1, Y1)
                X1 := Coord.X
                Y1 := Coord.Y
                Coord := WinCoordToScreenCoord(X2, Y2)
                X2 := Coord.X
                Y2 := Coord.Y
                If X1 Is Number And Y1 Is Number And X2 Is Number And Y2 Is Number {
                    W := X2 - X1
                    H := Y2 - Y1
                    ImageFile := FileSelect("S18", "Image", "Save Image", "PNG Files (*.png)")
                    If ImageFile {
                        SplitPath ImageFile, &FileName, &Directory, &Extension
                        If Extension = "" {
                            FileName := FileName . ".png"
                            ImageFile .= ".png"
                        }
                        ScreenArea2File(Directory, FileName, {X: X1, Y: Y1, W: W, H: H})
                        If Not FileExist(ImageFile) Or InStr(FileExist(ImageFile), "D") {
                            MsgBox "An error occurred while saving file.`nPlease try again.", AppName
                            CoordinateBox.Show()
                        }
                        Else {
                            MsgBox "File saved successfully.", AppName
                            CloseCoordinateBox()
                        }
                    }
                    Else {
                        CloseCoordinateBox()
                    }
                }
                Else {
                    MsgBox "An error occurred.`nPlease try again.", AppName
                    CoordinateBox.Show()
                }
            }
        }
    }
    ShowHotspotMenu(MenuNumber) {
        Global hotspots
        HotspotMenu := Menu()
        HotspotMenu.Number := MenuNumber
        If Hotspots.Length = 0 {
            HotspotMenu.Add("No hotspots", HotspotMenuHandler)
            HotspotMenu.Disable("No hotspots")
        }
        Else {
            HotspotMenu.Add("Select hotspot", HotspotMenuHandler)
            HotspotMenu.Disable("Select hotspot")
            For HotspotNumber, Hotspot In Hotspots
            HotspotMenu.Add(HotspotNumber . ". " . Hotspot["Label"], HotspotMenuHandler)
        }
        HotspotMenu.Show()
    }
    ShowHotspotMenu1(*) {
        ShowHotspotMenu(1)
    }
    ShowHotspotMenu2(*) {
        ShowHotspotMenu(2)
    }
}

FocusControl() {
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
                ControlMenu.Add(Control, ControlMenuHandler)
                If Control = FocusedControlClass
                ControlMenu.Check(control)
            }
            ControlMenu.Show()
        }
        DialogOpen := 0
    }
    ControlMenuHandler(ControlName, ControlNumber, ControlMenu) {
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
}

GenerateHotspotsFromOCR() {
    Global AppName, DialogOpen, Hotspots
    If DialogOpen = 0 {
        DialogOpen := 1
        Try {
            WinWaitActive("A")
            ConfirmationDialog := MsgBox("Generate hotspots from OCR?", AppName, 4)
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
                    NewHotspots := Array()
                    OCRResult := OCR.FromWindow("A", OCRLanguage)
                    For OCRLine In OCRResult.Lines {
                        Hotspots.Push(Map("Label", "`"" . OCRLine.Text . "`" start", "XCoordinate", OCR.WordsBoundingRect(OCRLine.Words*).X, "YCoordinate", OCR.WordsBoundingRect(OCRLine.Words*).Y))
                        Hotspots.Push(Map("Label", "`"" . OCRLine.Text . "`" end", "XCoordinate", OCR.WordsBoundingRect(OCRLine.Words*).X + OCR.WordsBoundingRect(OCRLine.Words*).W, "YCoordinate", OCR.WordsBoundingRect(OCRLine.Words*).Y + OCR.WordsBoundingRect(OCRLine.Words*).H))
                        NewHotspots.Push(Map("Label", "`"" . OCRLine.Text . "`" start", "XCoordinate", OCR.WordsBoundingRect(OCRLine.Words*).X, "YCoordinate", OCR.WordsBoundingRect(OCRLine.Words*).Y))
                        NewHotspots.Push(Map("Label", "`"" . OCRLine.Text . "`" end", "XCoordinate", OCR.WordsBoundingRect(OCRLine.Words*).X + OCR.WordsBoundingRect(OCRLine.Words*).W, "YCoordinate", OCR.WordsBoundingRect(OCRLine.Words*).Y + OCR.WordsBoundingRect(OCRLine.Words*).H))
                    }
                    If OCRResult.Lines.Length = 1
                    Speak("1 hotspot generated")
                    Else
                    Speak(NewHotspots.Length . " hotspots generated")
                }
            }
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
        Hotkey "#^+U", "On"
        Hotkey "#^+P", "On"
        Hotkey "#^+W", "On"
        Hotkey "#^+I", "On"
        Hotkey "#^+T", "On"
        Hotkey "#^+Del", "Off"
        Hotkey "Del", "Off"
        Hotkey "#^+PrintScreen", "On"
        Hotkey "#^+F", "On"
        Hotkey "#^+G", "Off"
        Hotkey "#^+Down", "On"
        Hotkey "#^+Left", "On"
        Hotkey "#^+Right", "On"
        Hotkey "#^+Up", "On"
        Hotkey "#^+O", "On"
        Hotkey "#^+Q", "On"
        Hotkey "F2", "Off"
        Hotkey "#^+R", "On"
        Hotkey "#^+Z", "On"
        Hotkey "#^+M", "On"
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
        Hotkey "#^+U", "On"
        Hotkey "#^+P", "On"
        Hotkey "#^+W", "On"
        Hotkey "#^+I", "On"
        Hotkey "#^+T", "On"
        Hotkey "#^+Del", "On"
        Hotkey "Del", "On"
        Hotkey "#^+PrintScreen", "On"
        Hotkey "#^+F", "On"
        Hotkey "#^+G", "On"
        Hotkey "#^+Down", "On"
        Hotkey "#^+Left", "On"
        Hotkey "#^+Right", "On"
        Hotkey "#^+Up", "On"
        Hotkey "#^+O", "On"
        Hotkey "#^+Q", "On"
        Hotkey "F2", "On"
        Hotkey "#^+R", "On"
        Hotkey "#^+Z", "On"
        Hotkey "#^+M", "On"
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
        Hotkey "#^+U", "On"
        Hotkey "#^+P", "On"
        Hotkey "#^+W", "On"
        Hotkey "#^+I", "On"
        Hotkey "#^+T", "On"
        Hotkey "#^+Del", "On"
        Hotkey "Del", "Off"
        Hotkey "#^+PrintScreen", "On"
        Hotkey "#^+F", "On"
        Hotkey "#^+G", "On"
        Hotkey "#^+Down", "On"
        Hotkey "#^+Left", "On"
        Hotkey "#^+Right", "On"
        Hotkey "#^+Up", "On"
        Hotkey "#^+O", "On"
        Hotkey "#^+Q", "On"
        Hotkey "F2", "Off"
        Hotkey "#^+R", "On"
        Hotkey "#^+Z", "On"
        Hotkey "#^+M", "On"
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
        Try {
            WinGetPos ,,, &YSize, "A"
        }
        Catch {
            Speak("Could not identify window size")
            Return
        }
        DialogOpen := 1
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
        Try {
            WinGetPos ,, &XSize,, "A"
        }
        Catch {
            Speak("Could not identify window size")
            Return
        }
        DialogOpen := 1
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
        Try {
            WinGetPos ,, &XSize,, "A"
        }
        Catch {
            Speak("Could not identify window size")
            Return
        }
        DialogOpen := 1
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
        Try {
            WinGetPos ,,, &YSize, "A"
        }
        Catch {
            Speak("Could not identify window size")
            Return
        }
        DialogOpen := 1
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
            FocusedControlClass := ControlGetClassNN(ControlGetFocus("A"))
        }
        Catch {
            FocusedControlClass := False
        }
        If FocusedControlClass = False {
            Speak("Focused control not found")
        }
        Else {
            WinWaitActive("A")
            ControlGetPos &ControlX, &ControlY,,, FocusedControlClass, "A"
            MouseMove ControlX, ControlY
            Speak("Mouse routed to X " . ControlX . " Y " . ControlY)
        }
        DialogOpen := 0
    }
}

SearchForImage(ImageFile := "") {
    Global AppName, DialogOpen, LastImage
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
        If ImageFile = "" Or Not FileExist(ImageFile) Or InStr(FileExist(ImageFile), "D")
        ImageFile := FileSelect(3,, "Choose Image", "Supported Images (*.ANI; *.BMP; *.CUR; *.EMF; *.Exif; *.GIF; *.ICO; *.JPG; *.PNG; *.TIF; *.WMF)")
        If ImageFile != "" {
            LastImage := ImageFile
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
        Try {
            WinGetPos ,, &XSize,, "A"
        }
        Catch {
            Speak("Could not identify window size")
            Return
        }
        DialogOpen := 1
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
        Try {
            WinGetPos ,,, &YSize, "A"
        }
        Catch {
            Speak("Could not identify window size")
            Return
        }
        DialogOpen := 1
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
        ViewerBox.AddText(, "Clipboard contents:")
        ViewerBox.AddEdit("ReadOnly YS", A_Clipboard)
        ViewerBox.AddButton("Default Section XS", "OK").OnEvent("Click", CloseViewerBox)
        ViewerBox.OnEvent("Close", CloseViewerBox)
        ViewerBox.OnEvent("Escape", CloseViewerBox)
        ViewerBox.Show()
        CloseViewerBox(*) {
            ViewerBox.Destroy()
            DialogOpen := 0
        }
    }
}

WinCoordToScreenCoord(X, Y) {
    CoordMode "Mouse", "Window"
    Try {
        WinWaitActive("A")
        MouseMove X, Y
        CoordMode "Mouse", "Screen"
        MouseGetPos &mouseXPos, &mouseYPos
    }
    Catch {
        MouseXPos := False
        MouseYPos := False
    }
    CoordMode "Mouse", "Window"
    Return {X: MouseXPos, Y: MouseYPos}
}

Version := "0.2.1"
;@Ahk2Exe-Let U_version = %A_PriorLine~U)^(.+"){1}(.+)".*$~$2%
    ;@Ahk2Exe-Let U_OrigFileName = %A_ScriptName~\.[^\.]+$~.exe%
    ;@Ahk2Exe-SetDescription HotspotHelper
    ;@Ahk2Exe-SetFileVersion %U_Version%
    ;@Ahk2Exe-SetProductName HotspotHelper
    ;@Ahk2Exe-SetProductVersion %U_Version%
;@Ahk2Exe-SetOrigFileName %U_OrigFileName%
