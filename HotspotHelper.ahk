﻿#Requires AutoHotkey v2.0

#MaxThreadsPerHotkey 1
#SingleInstance Force
#Warn All
SendMode "Input"
SetTitleMatchMode 2
SetWorkingDir A_InitialWorkingDir
CoordMode "Caret", "Client"
CoordMode "Menu", "Client"
CoordMode "Mouse", "Client"
CoordMode "Pixel", "Client"
CoordMode "ToolTip", "Client"

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

#+A::About()
#+C::CopyControlInfoToClipboard()
#+Del::DeleteAllHotspots()
#+Down::MoveMouseDown()
#+Enter::AddHotspot()
#+F::FocusControl()
#+G::GenerateHotspotsFromOCR()
#+H::CopyHotspotsToClipboard()
#+I::SearchForImage()
#+K::ToggleKeyboardMode()
#+L::CopyControlListToClipboard()
#+Left::MoveMouseLeft()
#+M::RouteMouseToFocusedControl()
#+N::CopyPixelColorToClipboard()
#+O::PerformOCR()
#+P::SearchForColor()
#+PrintScreen::ExtractImage()
#+Q::Quit()
#+R::SearchForImage(LastImage)
#+Right::MoveMouseRight()
#+U::ReportPixelColor()
#+Up::MoveMouseUp()
#+V::ViewClipboard()
#+W::CopyWindowInfoToClipboard()
#+X::SetMouseXPosition()
#+Y::SetMouseYPosition()
#+Z::ReportMousePosition()
+Tab::SelectPreviousHotspot()
Ctrl::StopSpeech()
Del::DeleteHotspot()
Enter::ClickHotspot()
F2::RenameHotspot()
Tab::SelectNextHotspot()

SetTimer ManageHotkeys, 100
About()

About(*) {
    Global AppName, DialogOpen
    Static FirstShow := True
    If DialogOpen = 0 {
        DialogOpen := 1
        AboutBox := Gui(, "About " . AppName)
        AboutBox.AddEdit("ReadOnly -WantReturn", "Use this tool to determine hotspot mouse coordinates, obtain information about the active window and its controls and copy the retrieved info to clipboard.`nEnable keyboard mode whenever you want to click, delete or rename previously added individual hotspots.`n`nKeyboard Shortcuts`n`nHotspot Shortcuts:`nShift+Win+Enter - Add hotspot`nShift+Win+Del - Delete all hotspots`nShift+Win+H - Copy hotspots to clipboard`nKeyboard Mode Shortcuts:`nShift+Win+K - Toggle keyboard mode on/off`nTab - Select next hotspot`nShift+Tab - Select previous hotspot`nEnter - Click current hotspot`nDel - Delete current hotspot`nF2 - Rename current hotspot`n`nWindow & Control Shortcuts:`nShift+Win+W - Copy info about the active window to clipboard`nShift+Win+C - Copy info about the currently focused control to clipboard`nShift+Win+L - Copy control list to clipboard`nShift+Win+F - Focus control`n`nMouse Shortcuts:`nShift+Win+M - Route the mouse to the position of the currently focused control`nShift+Win+U - Report the pixel color under the mouse cursor`nShift+Win+N - Copy the pixel color under the mouse cursor to clipboard`nShift+Win+X - Set mouse X position`nShift+Win+Y - Set mouse Y position`nShift+Win+Z - Report mouse position`nShift+Win+Left - Move mouse leftf`nShift+Win+Right - Move mouse right`nShift+Win+Up - Move mouse up`nShift+Win+Down - Move mouse down`n`nMiscellaneous Shortcuts:`nShift+Win+Print Screen - Extract a region of the active window as an image`nShift+Win+O - OCR the active window`nShift+Win+G - Generate hotspots from OCR`nShift+Win+P - Search for color`nShift+Win+I - Search for image`nShift+Win+R - Repeat search using last image`nShift+Win+V - Open Clipboard Viewer`nShift+Win+A - About the app`nShift+Win+Q - Quit the app`nCtrl - Stop speech")
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
            If Not NameDialog.Value = ""
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

ClientCoordToScreenCoord(X, Y) {
    CoordMode "Mouse", "Client"
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
    CoordMode "Mouse", "Client"
    Return {X: MouseXPos, Y: MouseYPos}
}

CopyControlInfoToClipboard() {
    Global AppName, DialogOpen
    If DialogOpen = 0 {
        Try {
            WinWaitActive("A")
            Try
            ControlClass := ControlGetClassNN(ControlGetFocus("A"))
            Catch
            ControlClass := ""
            Try {
                ControlGetPos &ControlX, &ControlY, &ControlW, &ControlH, ControlClass, "A"
                ControlDimensions := ControlW . " × " . ControlH
                ControlPos := "X " . ControlX . ", Y " . ControlY
            }
            Catch {
                ControlDimensions := ""
                ControlPos := ""
            }
            ControlHwnd := ControlGetHwnd(ControlClass, "A")
            Try {
                WinGetPos &WinX, &WinY, &WinW, &WinH, ControlHwnd
                WinDimensions := WinW . " × " . WinH
                WinPos := "X " . WinX . ", Y " . WinY
            }
            Catch {
                WinDimensions := ""
                WinPos := ""
            }
            Try {
                WinGetClientPos &ClientX, &ClientY, &ClientW, &ClientH, ControlHwnd
                ClientDimensions := ClientW . " × " . ClientH
                ClientPos := "X " . ClientX . ", Y " . ClientY
            }
            Catch {
                ClientDimensions := ""
                ClientPos := ""
            }
        }
        Catch {
            Speak("Focused control not found")
            Return
        }
        DialogOpen := 1
        ConfirmationDialog := MsgBox("Copy info About the currently focused control to clipboard?", AppName, 4)
        If ConfirmationDialog == "Yes" {
            Sleep 1000
            A_Clipboard := "Control class: " . ControlClass . "`nControl Position: " . ControlPos . "`nControl Dimensions: " . ControlDimensions . "`n`nWhen Treated As A Window:`nWindow Position: " . WinPos . "`nWindow Dimensions: " . WinDimensions . "`nClient Area Position: " . ClientPos . "`nClient Area Dimensions: " . ClientDimensions
            Speak("Control info copied to clipboard")
        }
        DialogOpen := 0
    }
}

CopyControlListToClipboard() {
    Global AppName, DialogOpen
    If DialogOpen = 0 {
        Try {
            WinWaitActive("A")
            Controls := WinGetControls("A")
        }
        Catch {
            Speak("No controls found")
            Return
        }
        DialogOpen := 1
        ConfirmationDialog := MsgBox("Copy control list to clipboard?", AppName, 4)
        If ConfirmationDialog == "Yes" {
            Sleep 1000
            ClipboardData := "Control class`tX coordinate`tY coordinate`tWidth`tHeight`r`n"
            For Control In controls {
                ControlClass := ControlGetClassNN(Control)
                Try {
                    ControlGetPos &ControlX, &ControlY, &ControlW, &ControlH, ControlClass, "A"
                }
                Catch {
                    ControlX := "-"
                    ControlY := "-"
                    ControlW := "-"
                    ControlH := "-"
                }
                ClipboardData .= ControlClass . "`t" . ControlX . "`t" . ControlY . "`t" . ControlW . "`t" . ControlH . "`r`n"
            }
            ClipboardData := RTrim(ClipboardData, "`r`n")
            A_Clipboard := ClipboardData
            If Controls.Length = 1
            Speak("1 control copied to clipboard")
            Else
            Speak(Controls.Length . " controls copied to clipboard")
        }
        DialogOpen := 0
    }
}

CopyHotspotsToClipboard() {
    Global AppName, DialogOpen, Hotspots
    If DialogOpen = 0 {
        Try {
            WinWaitActive("A")
            ControlClass := ControlGetClassNN(ControlGetFocus("A"))
            ControlGetPos &ControlX, &ControlY,,, ControlClass, "A"
        }
        Catch {
            ControlClass := False
            ControlX := 0
            ControlY := 0
        }
        If Hotspots.Length = 0 {
            Speak("No hotspots defined")
            Return
        }
        DialogOpen := 1
        ConfirmationDialog := MsgBox("Copy hotspots to clipboard?", AppName, 4)
        If ConfirmationDialog == "Yes" {
            ClipboardData := ""
            ConfirmationDialog := MsgBox("Compensate for the position of the currently focused control?", AppName, 4)
            If ConfirmationDialog == "Yes" {
                Sleep 1000
                If ControlClass = False {
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

CopyPixelColorToClipboard() {
    Global AppName, DialogOpen, MouseXPosition, MouseYPosition
    If DialogOpen = 0 {
        DialogOpen := 1
        ConfirmationDialog := MsgBox("Copy the color of the pixel currently under the mouse to clipboard?", AppName, 4)
        If ConfirmationDialog == "Yes" {
            Sleep 1000
            MouseGetPos &mouseXPosition, &mouseYPosition
            A_Clipboard := PixelGetColor(MouseXPosition, MouseYPosition, "Slow")
            Speak("Pixel color copied to clipboard")
        }
        DialogOpen := 0
    }
}

CopyWindowInfoToClipboard() {
    Global AppName, DialogOpen
    If DialogOpen = 0 {
        Try {
            WinWaitActive("A")
            Try
            ProcessName := WinGetProcessName("A")
            Catch
            ProcessName := ""
            Try
            ProcessPath := WinGetProcessPath("A")
            Catch
            ProcessPath := ""
            Try
            WindowClass := WinGetClass("A")
            Catch
            WindowClass := ""
            Try
            WindowID := WinGetID("A")
            Catch
            WindowID := ""
            Try
            WindowTitle := WinGetTitle("A")
            Catch
            WindowTitle := ""
            Try {
                WinGetPos &WinX, &WinY, &WinW, &WinH, "A"
                WinDimensions := WinW . " × " . WinH
                WinPos := "X " . WinX . ", Y " . WinY
            }
            Catch {
                WinDimensions := ""
                WinPos := ""
            }
            Try {
                WinGetClientPos &ClientX, &ClientY, &ClientW, &ClientH, "A"
                ClientDimensions := ClientW . " × " . ClientH
                ClientPos := "X " . ClientX . ", Y " . ClientY
            }
            Catch {
                ClientDimensions := ""
                ClientPos := ""
            }
        }
        Catch {
            Speak("Active window not found")
            Return
        }
        DialogOpen := 1
        ConfirmationDialog := MsgBox("Copy info about the active window to clipboard?", AppName, 4)
        If ConfirmationDialog == "Yes" {
            Sleep 1000
            A_Clipboard := "Process Name: " . ProcessName . "`nProcess Path: " . ProcessPath . "`nWindow Class: " . WindowClass . "`nWindow ID: " . WindowID . "`nWindow Title: " . WindowTitle . "`nWindow Position: " . WinPos . "`nWindow Dimensions: " . WinDimensions . "`nClient Area Position: " . ClientPos . "`nClient Area Dimensions: " . ClientDimensions
            Speak("Window info copied to clipboard")
        }
        DialogOpen := 0
    }
}

DeleteAllHotspots() {
    Global AppName, CurrentHotspot, DialogOpen, Hotspots
    If DialogOpen = 0 {
        If Hotspots.Length = 0 {
            Speak("No hotspots defined")
            Return
        }
        DialogOpen := 1
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
            If Not X1 = "" And Not Y1 = "" And Not X2 = "" And Not Y2 = "" And X1 >= 0 And X1 < X2 And X2 <= XSize And Y1 >= 0 And Y1 < Y2 And Y2 <= YSize {
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
                Coord := ClientCoordToScreenCoord(X1, Y1)
                X1 := Coord.X
                Y1 := Coord.Y
                Coord := ClientCoordToScreenCoord(X2, Y2)
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
                        Sleep 500
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
        Try {
            WinWaitActive("A")
            Controls := WinGetControls("A")
            ControlClass := ControlGetClassNN(ControlGetFocus("A"))
        }
        Catch {
            Controls := Array()
            ControlClass := False
        }
        If Controls.Length = 0 {
            Speak("No controls found")
            Return
        }
        DialogOpen := 1
        ControlMenu := Menu()
        For Control In controls {
            ControlMenu.Add(Control, ControlMenuHandler)
            If Control = ControlClass
            ControlMenu.Check(control)
        }
        ControlMenu.Show()
    }
    DialogOpen := 0
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
                    If A_Index = 1 And Not A_LoopField = "" {
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
                    OCRResult := OCR.FromWindow("A", OCRLanguage,, 1)
                    For OCRLine In OCRResult.Lines {
                        Hotspots.Push(Map("Label", "`"" . OCRLine.Text . "`" start", "XCoordinate", OCR.WordsBoundingRect(OCRLine.Words*).X, "YCoordinate", OCR.WordsBoundingRect(OCRLine.Words*).Y))
                        Hotspots.Push(Map("Label", "`"" . OCRLine.Text . "`" end", "XCoordinate", OCR.WordsBoundingRect(OCRLine.Words*).X + OCR.WordsBoundingRect(OCRLine.Words*).W, "YCoordinate", OCR.WordsBoundingRect(OCRLine.Words*).Y + OCR.WordsBoundingRect(OCRLine.Words*).H))
                    }
                    Speak(OCRResult.Lines.Length * 2 . " hotspots generated")
                }
            }
        }
        DialogOpen := 0
    }
}

ManageHotkeys() {
    Global DialogOpen, KeyboardMode
    If DialogOpen = 1 Or WinActive("ahk_exe Explorer.Exe") Or WinActive("ahk_class Shell_TrayWnd" Or WinExist("ahk_class #32768") ) {
        Hotkey "#+A", "On"
        Hotkey "#+C", "On"
        Hotkey "#+Del", "Off"
        Hotkey "#+Down", "On"
        Hotkey "#+Enter", "Off"
        Hotkey "#+F", "On"
        Hotkey "#+G", "Off"
        Hotkey "#+H", "On"
        Hotkey "#+I", "On"
        Hotkey "#+K", "Off"
        Hotkey "#+L", "On"
        Hotkey "#+Left", "On"
        Hotkey "#+M", "On"
        Hotkey "#+N", "On"
        Hotkey "#+O", "On"
        Hotkey "#+P", "On"
        Hotkey "#+PrintScreen", "On"
        Hotkey "#+Q", "On"
        Hotkey "#+R", "On"
        Hotkey "#+Right", "On"
        Hotkey "#+U", "On"
        Hotkey "#+Up", "On"
        Hotkey "#+V", "On"
        Hotkey "#+W", "On"
        Hotkey "#+Z", "On"
        Hotkey "+Tab", "Off"
        Hotkey "Ctrl", "Off"
        Hotkey "Del", "Off"
        Hotkey "Enter", "Off"
        Hotkey "F2", "Off"
        Hotkey "Tab", "Off"
    }
    Else If KeyboardMode = 1 {
        Hotkey "#+A", "On"
        Hotkey "#+C", "On"
        Hotkey "#+Del", "On"
        Hotkey "#+Down", "On"
        Hotkey "#+Enter", "On"
        Hotkey "#+F", "On"
        Hotkey "#+G", "On"
        Hotkey "#+H", "On"
        Hotkey "#+I", "On"
        Hotkey "#+K", "On"
        Hotkey "#+L", "On"
        Hotkey "#+Left", "On"
        Hotkey "#+M", "On"
        Hotkey "#+N", "On"
        Hotkey "#+O", "On"
        Hotkey "#+P", "On"
        Hotkey "#+PrintScreen", "On"
        Hotkey "#+Q", "On"
        Hotkey "#+R", "On"
        Hotkey "#+Right", "On"
        Hotkey "#+U", "On"
        Hotkey "#+Up", "On"
        Hotkey "#+V", "On"
        Hotkey "#+W", "On"
        Hotkey "#+Z", "On"
        Hotkey "+Tab", "On"
        Hotkey "Ctrl", "On"
        Hotkey "Del", "On"
        Hotkey "Enter", "On"
        Hotkey "F2", "On"
        Hotkey "Tab", "On"
    }
    Else {
        Hotkey "#+A", "On"
        Hotkey "#+C", "On"
        Hotkey "#+Del", "On"
        Hotkey "#+Down", "On"
        Hotkey "#+Enter", "On"
        Hotkey "#+F", "On"
        Hotkey "#+G", "On"
        Hotkey "#+H", "On"
        Hotkey "#+I", "On"
        Hotkey "#+K", "On"
        Hotkey "#+L", "On"
        Hotkey "#+Left", "On"
        Hotkey "#+M", "On"
        Hotkey "#+N", "On"
        Hotkey "#+O", "On"
        Hotkey "#+P", "On"
        Hotkey "#+PrintScreen", "On"
        Hotkey "#+Q", "On"
        Hotkey "#+R", "On"
        Hotkey "#+Right", "On"
        Hotkey "#+U", "On"
        Hotkey "#+Up", "On"
        Hotkey "#+V", "On"
        Hotkey "#+W", "On"
        Hotkey "#+Z", "On"
        Hotkey "+Tab", "Off"
        Hotkey "Ctrl", "On"
        Hotkey "Del", "Off"
        Hotkey "Enter", "Off"
        Hotkey "F2", "Off"
        Hotkey "Tab", "Off"
    }
}

MoveMouseDown() {
    Global DialogOpen
    If DialogOpen = 0 {
        Try {
            WinGetClientPos ,,, &YSize, "A"
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
            WinGetClientPos ,, &XSize,, "A"
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
            WinGetClientPos ,, &XSize,, "A"
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
            WinGetClientPos ,,, &YSize, "A"
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
            ControlClass := ControlGetClassNN(ControlGetFocus("A"))
            ControlGetPos &ControlX, &ControlY,,, ControlClass, "A"
        }
        Catch {
            ControlClass := False
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
                If A_Index = 1 And Not A_LoopField = "" {
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
                OCRResult := OCR.FromWindow("A", OCRLanguage,, 1)
                For OCRLine In OCRResult.Lines {
                    OCRLines.Push(Map("Text", OCRLine.Text, "X1", OCR.WordsBoundingRect(OCRLine.Words*).X, "Y1", OCR.WordsBoundingRect(OCRLine.Words*).Y, "X2", OCR.WordsBoundingRect(OCRLine.Words*).X + OCR.WordsBoundingRect(OCRLine.Words*).W, "Y2", OCR.WordsBoundingRect(OCRLine.Words*).Y + OCR.WordsBoundingRect(OCRLine.Words*).H))
                }
                ClipboardData := ""
                ConfirmationDialog := MsgBox("Compensate for the position of the currently focused control?", AppName, 4)
                If ConfirmationDialog == "Yes" {
                    Sleep 1000
                    If ControlClass = False {
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
        If RenameDialog.Result == "OK" And Not RenameDialog.Value = "" {
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

ReportPixelColor() {
    Global MouseXPosition, MouseYPosition
    MouseGetPos &mouseXPosition, &mouseYPosition
    Speak(PixelGetColor(MouseXPosition, MouseYPosition, "Slow"))
}

RouteMouseToFocusedControl() {
    Global AppName, DialogOpen
    If DialogOpen = 0 {
        DialogOpen := 1
        Try {
            WinWaitActive("A")
            ControlClass := ControlGetClassNN(ControlGetFocus("A"))
        }
        Catch {
            ControlClass := False
        }
        If ControlClass = False {
            Speak("Focused control not found")
        }
        Else {
            WinWaitActive("A")
            ControlGetPos &ControlX, &ControlY,,, ControlClass, "A"
            MouseMove ControlX, ControlY
            Speak("Mouse routed to X " . ControlX . " Y " . ControlY)
        }
        DialogOpen := 0
    }
}

SearchForColor(*) {
    Global AppName, DialogOpen
    Static ColorValue := "", X1Coord := "", Y1Coord := "", X2Coord := "", Y2Coord := ""
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
        SearchBox := Gui(, AppName . " Color Search {`"" . WindowTitle . "`"}")
        SearchBox.AddText(, "Color to find:")
        SearchBox.AddEdit("vColorValue YS", ColorValue).OnEvent("Change", ProcessInput)
        SearchBox.AddText("Section XS", "X1 coordinate (between 0 and " . XSize . "):")
        SearchBox.AddEdit("vX1Coord Number YS", X1Coord).OnEvent("Change", ProcessInput)
        SearchBox.AddText("YS", "Y1 coordinate (between 0 and " . YSize . "):")
        SearchBox.AddEdit("vY1Coord Number YS", Y1Coord).OnEvent("Change", ProcessInput)
        SearchBox.AddButton("YS", "Select hotspot...").OnEvent("Click", ShowHotspotMenu1)
        SearchBox.AddText("Section XS", "X2 coordinate (between 0 and " . XSize . "):")
        SearchBox.AddEdit("vX2Coord Number YS", X2Coord).OnEvent("Change", ProcessInput)
        SearchBox.AddText("YS", "Y2 coordinate (between 0 and " . YSize . "):")
        SearchBox.AddEdit("vY2Coord Number YS", Y2Coord).OnEvent("Change", ProcessInput)
        SearchBox.AddButton("YS", "Select hotspot...").OnEvent("Click", ShowHotspotMenu2)
        SearchBox.AddButton("Disabled Section XS", "OK").OnEvent("Click", FindColor)
        SearchBox.AddButton("Default YS", "Cancel").OnEvent("Click", CloseSearchBox)
        CoordinateStatus := SearchBox.Add("StatusBar")
        SearchBox.OnEvent("Close", CloseSearchBox)
        SearchBox.OnEvent("Escape", CloseSearchBox)
        SearchBox.Show()
        FindColor(*) {
            ControlValues := SearchBox.Submit(True)
            ColorValue := ControlValues.ColorValue
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
                CloseSearchBox()
            }
            Else {
                WinActivate("ahk_id" . WindowID)
                WinWaitActive("ahk_id" . WindowID)
                If Not ColorValue = "" And Not X1 = "" And Not Y1 = "" And Not X2 = "" And Not Y2 = "" {
                    CloseSearchBox()
                    Try {
                        ControlClass := ControlGetClassNN(ControlGetFocus("A"))
                        ControlGetPos &ControlX, &ControlY,,, ControlClass, "A"
                    }
                    Catch {
                        ControlClass := False
                        ControlX := 0
                        ControlY := 0
                    }
                    If Not ColorValue = "" {
                        FoundX := ""
                        FoundY := ""
                        Try {
                            WinWaitActive("A")
                            Sleep 1000
                            If PixelSearch(&FoundX, &FoundY, X1, Y1, X2, Y2, ColorValue) {
                                ConfirmationDialog := MsgBox("Your color has been found at X " . FoundX . ", Y " . FoundY . ".`nCopy its coordinates to clipboard?", AppName, 4)
                                If ConfirmationDialog == "Yes" {
                                    ClipboardData := ""
                                    ConfirmationDialog := MsgBox("Compensate for the position of the currently focused control?", AppName, 4)
                                    If ConfirmationDialog == "Yes" {
                                        Sleep 1000
                                        If ControlClass = False {
                                            Speak("Focused control not found")
                                        }
                                        Else {
                                            ClipboardData .= "Compensating for X " . ControlX . ", Y " . ControlY . "`r`n"
                                            If FoundX Is Number
                                            ColorXCoordinate := FoundX - ControlX
                                            Else
                                            ColorXCoordinate := ""
                                            If FoundY Is Number
                                            ColorYCoordinate := FoundY - ControlY
                                            Else
                                            ColorYCoordinate := ""
                                            ClipboardData .= "`"" . ColorValue . "`", " . ColorXCoordinate . ", " . ColorYCoordinate
                                        }
                                    }
                                    Else {
                                        Sleep 1000
                                        ColorXCoordinate := FoundX
                                        ColorYCoordinate := FoundY
                                        ClipboardData .= "`"" . ColorValue . "`", " . ColorXCoordinate . ", " . ColorYCoordinate
                                    }
                                    A_Clipboard := ClipboardData
                                    Speak("Color coordinates copied to clipboard")
                                }
                                Sleep 500
                                MouseMove FoundX, FoundY
                            }
                            Else {
                                MsgBox "The color you specified has not been found on the screen.", AppName
                            }
                        }
                    }
                }
                Else {
                    MsgBox "An error occurred.`nPlease try again.", AppName
                    SearchBox.Show()
                }
            }
        }
    }
    HotspotMenuHandler(MenuItemLabel, MenuItemNumber, HotspotMenu) {
        Global Hotspots
        SearchBox["X" . HotspotMenu.Number . "Coord"].Value := Hotspots[MenuItemNumber - 1]["XCoordinate"]
        SearchBox["Y" . HotspotMenu.Number . "Coord"].Value := Hotspots[MenuItemNumber - 1]["YCoordinate"]
        ProcessInput()
    }
    ProcessInput()
    CloseSearchBox(*) {
        SearchBox.Destroy()
        DialogOpen := 0
    }
    ProcessInput(*) {
        ControlValues := SearchBox.Submit(False)
        ColorValue := ControlValues.ColorValue
        X1 := ControlValues.X1Coord
        Y1 := ControlValues.Y1Coord
        X2 := ControlValues.X2Coord
        Y2 := ControlValues.Y2Coord
        If Not ColorValue = "" And Not X1 = "" And Not Y1 = "" And Not X2 = "" And Not Y2 = "" And X1 >= 0 And X1 < X2 And X2 <= XSize And Y1 >= 0 And Y1 < Y2 And Y2 <= YSize {
            SearchBox["OK"].Opt("+Default -Disabled")
            SearchBox["Cancel"].Opt("-Default")
        }
        Else {
            SearchBox["OK"].Opt("-Default +Disabled")
            SearchBox["Cancel"].Opt("+Default")
        }
        If Not X1 = "" And Not Y1 = "" And Not X2 = "" And Not Y2 = "" And X1 >= 0 And X1 < X2 And X2 <= XSize And Y1 >= 0 And Y1 < Y2 And Y2 <= YSize
        CoordinateStatus.SetText("`tRegion dimensions " . X2 - X1 . " × " . Y2 - Y1)
        Else
        CoordinateStatus.SetText("`tRegion dimensions unknown")
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

SearchForImage(ImageFile := "") {
    Global AppName, DialogOpen, LastImage
    If DialogOpen = 0 {
        DialogOpen := 1
        Try {
            WinWaitActive("A")
            ControlClass := ControlGetClassNN(ControlGetFocus("A"))
            ControlGetPos &ControlX, &ControlY,,, ControlClass, "A"
        }
        Catch {
            ControlClass := False
            ControlX := 0
            ControlY := 0
        }
        If ImageFile = "" Or Not FileExist(ImageFile) Or InStr(FileExist(ImageFile), "D")
        ImageFile := FileSelect(3,, "Choose Image", "Supported Images (*.ANI; *.BMP; *.CUR; *.EMF; *.Exif; *.GIF; *.ICO; *.JPG; *.PNG; *.TIF; *.WMF)")
        If Not ImageFile = "" {
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
                            If ControlClass = False {
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
                    Sleep 500
                    MouseMove FoundX, FoundY
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
            WinGetClientPos ,, &XSize,, "A"
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
            WinGetClientPos ,,, &YSize, "A"
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
    If (Not JAWS = False And ProcessExist("jfw.exe")) Or (FileExist("NvdaControllerClient" . A_PtrSize * 8 . ".dll") And Not DllCall("NvdaControllerClient" . A_PtrSize * 8 . ".dll\nvdaController_testIfRunning")) {
        If Not JAWS = False And ProcessExist("jfw.exe") {
            JAWS.SayString(Message)
        }
        If FileExist("NvdaControllerClient" . A_PtrSize * 8 . ".dll") And Not DllCall("NvdaControllerClient" . A_PtrSize * 8 . ".dll\nvdaController_testIfRunning") {
            DllCall("NvdaControllerClient" . A_PtrSize * 8 . ".dll\nvdaController_cancelSpeech")
            DllCall("NvdaControllerClient" . A_PtrSize * 8 . ".dll\nvdaController_speakText", "Wstr", Message)
        }
    }
    Else {
        If Not SAPI = False {
            SAPI.Speak("", 0x1|0x2)
            SAPI.Speak(Message, 0x1)
        }
    }
}

StopSpeech() {
    Global JAWS, SAPI
    If (Not JAWS = False Or Not ProcessExist("jfw.exe")) And (Not FileExist("NvdaControllerClient" . A_PtrSize * 8 . ".dll") Or DllCall("NvdaControllerClient" . A_PtrSize * 8 . ".dll\nvdaController_testIfRunning"))
    If Not SAPI = False
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
        ViewerBox.AddEdit("ReadOnly YS -WantReturn", A_Clipboard)
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

#Include Includes/Version.ahk
#Include *i Includes/CIVersion.ahk
;@Ahk2Exe-SetDescription HotspotHelper
;@Ahk2Exe-SetProductName HotspotHelper
