#Requires AutoHotkey v2.0

ClientCoordToScreenCoord(X, Y) {
    CoordMode "Mouse", "Client"
    Try {
        WinWaitActive("A")
        MouseMove X, Y
        CoordMode "Mouse", "Screen"
        MouseGetPos &XPos, &YPos
    }
    Catch {
        XPos := False
        YPos := False
    }
    CoordMode "Mouse", "Client"
    Return {X: XPos, Y: YPos}
}

ExtractImage(*) {
    Static X1Coord := "", Y1Coord := "", X2Coord := "", Y2Coord := ""
    Try {
        WindowID := WinGetID("A")
        WindowTitle := WinGetTitle("A")
        WinGetPos ,, &XSize, &YSize, "A"
    }
    Catch {
        AccessibilityOverlay.Speak("Could not obtain required information")
        Return
    }
    CoordinateBox := Gui(, Editor.AppName . " Image Extractor {`"" . WindowTitle . "`"}")
    CoordinateBox.AddText(, "X1 coordinate (between 0 and " . XSize . "):")
    CoordinateBox.AddEdit("vX1Coord Number YS", X1Coord).OnEvent("Change", ProcessInput)
    CoordinateBox.AddText("YS", "Y1 coordinate (between 0 and " . YSize . "):")
    CoordinateBox.AddEdit("vY1Coord Number YS", Y1Coord).OnEvent("Change", ProcessInput)
    CoordinateBox.AddButton("YS", "Select marker…").OnEvent("Click", ShowMarkerMenu1)
    CoordinateBox.AddText("Section XS", "X2 coordinate (between 0 and " . XSize . "):")
    CoordinateBox.AddEdit("vX2Coord Number YS", X2Coord).OnEvent("Change", ProcessInput)
    CoordinateBox.AddText("YS", "Y2 coordinate (between 0 and " . YSize . "):")
    CoordinateBox.AddEdit("vY2Coord Number YS", Y2Coord).OnEvent("Change", ProcessInput)
    CoordinateBox.AddButton("YS", "Select marker…").OnEvent("Click", ShowMarkerMenu2)
    CoordinateBox.AddButton("Disabled Section XS", "OK").OnEvent("Click", SaveImage)
    CoordinateBox.AddButton("Default YS", "Cancel").OnEvent("Click", CloseCoordinateBox)
    CoordinateStatus := CoordinateBox.Add("StatusBar")
    CoordinateBox.OnEvent("Close", CloseCoordinateBox)
    CoordinateBox.OnEvent("Escape", CloseCoordinateBox)
    CoordinateBox.Show()
    MarkerMenuHandler(MenuItemLabel, MenuItemNumber, MarkerMenu) {
        MarkerList := GetMarkers()
        CoordinateBox["X" . MarkerMenu.Number . "Coord"].Value := MarkerList[MenuItemNumber - 1].XCoordinate
        CoordinateBox["Y" . MarkerMenu.Number . "Coord"].Value := MarkerList[MenuItemNumber - 1].YCoordinate
        ProcessInput()
    }
    ProcessInput()
    CloseCoordinateBox(*) {
        CoordinateBox.Destroy()
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
        X1Coord := ControlValues.X1Coord
        Y1Coord := ControlValues.Y1Coord
        X2Coord := ControlValues.X2Coord
        Y2Coord := ControlValues.Y2Coord
        X1 := ControlValues.X1Coord
        Y1 := ControlValues.Y1Coord
        X2 := ControlValues.X2Coord
        Y2 := ControlValues.Y2Coord
        If Not WinExist("ahk_id" . WindowID) {
            MsgBox "Target window not found.", Editor.AppName
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
                        MsgBox "An error occurred while saving file.`nPlease try again.", Editor.AppName
                        CoordinateBox.Show()
                    }
                    Else {
                        MsgBox "File saved successfully.", Editor.AppName
                        CloseCoordinateBox()
                    }
                }
                Else {
                    CloseCoordinateBox()
                }
            }
            Else {
                MsgBox "An error occurred.`nPlease try again.", Editor.AppName
                CoordinateBox.Show()
            }
        }
    }
    ShowMarkerMenu(MenuNumber) {
        MarkerList := GetMarkers()
        MarkerMenu := Menu()
        MarkerMenu.Number := MenuNumber
        If MarkerList.Length = 0 {
            MarkerMenu.Add("No markers", MarkerMenuHandler)
            MarkerMenu.Disable("No markers")
        }
        Else {
            MarkerMenu.Add("Select marker", MarkerMenuHandler)
            MarkerMenu.Disable("Select marker")
            For MarkerNumber, MarkerItem In MarkerList
            MarkerMenu.Add(MarkerNumber . ". " . MarkerItem.Label, MarkerMenuHandler)
        }
        MarkerMenu.Show()
    }
    ShowMarkerMenu1(*) {
        ShowMarkerMenu(1)
    }
    ShowMarkerMenu2(*) {
        ShowMarkerMenu(2)
    }
}

FocusControl(*) {
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
        AccessibilityOverlay.Speak("No controls found")
        Return
    }
    ControlMenu := Menu()
    For Control In controls {
        ControlMenu.Add(Control, ControlMenuHandler)
        If Control = ControlClass
        ControlMenu.Check(control)
    }
    ControlMenu.Show()
}
ControlMenuHandler(ControlName, ControlNumber, ControlMenu) {
    Try {
        WinWaitActive("A")
        ControlFocus ControlName, "A"
        If ControlGetClassNN(ControlGetFocus("A")) = ControlName {
            AccessibilityOverlay.Speak(ControlName . " focused")
        }
    }
    Catch {
        AccessibilityOverlay.Speak("Control not found")
    }
}

NudgeCoordinates(*) {
    Static CoordinateBox := False
    ItemTypeList := ["All controls", "Current control", "HotspotButton", "HotspotToggleButton", "HotspotCheckbox", "HotspotComboBox", "HotspotEdit", "HotspotTab"]
    If CoordinateBox = False {
        CoordinateBox := Gui("+OwnDialogs", "Nudge Item Coordinates")
        CoordinateBox.AddText(, "X offset:")
        CoordinateBox.AddEdit("vXOffset YS", 0)
        CoordinateBox.AddText("Section XS", "Y offset:")
        CoordinateBox.AddEdit("vYOffset YS", 0)
        CoordinateBox.AddText("Section XS", "Nudge:")
        CoordinateBox.AddDropDownList("YS Choose1 vItemType", ItemTypeList)
        CoordinateBox.AddButton("Default Section XS", "OK").OnEvent("Click", NudgeItems)
        CoordinateBox.AddButton("YS", "Cancel").OnEvent("Click", CloseCoordinateBox)
        CoordinateBox.OnEvent("Close", CloseCoordinateBox)
        CoordinateBox.OnEvent("Escape", CloseCoordinateBox)
        CoordinateBox.Show()
    }
    Else {
        CoordinateBox.Show()
    }
    CloseCoordinateBox(*) {
        CoordinateBox.Destroy()
        CoordinateBox := False
    }
    NudgeItems(*) {
        ControlValues := CoordinateBox.Submit(False)
        X := ControlValues.XOffset
        Y := ControlValues.YOffset
        ItemType := CoordinateBox["ItemType"].Text
        If X
        Try
        X := Number(X)
        Catch
        X := X
        If Y
        Try
        Y := Number(Y)
        Catch
        Y := Y
        If Editor.Overlay And Editor.Overlay.CurrentControl
        CurrentControl := editor.Overlay.CurrentControl
        Else
        CurrentControl := False
        If CurrentControl
        ParentControl := CurrentControl.SuperordinateControl
        Else
        ParentControl := False
        If CurrentControl And ParentControl
        If Editor.Overlay.CurrentControl Is Separator
        CurrentControl := ParentControl
        If X = "" {
            MsgBox "You did not enter the X offset.", Editor.AppName
            CoordinateBox["XOffset"].Focus()
        }
        Else If Not X = 0 And Not X Is Integer {
            MsgBox "The X offset must be a whole number.", Editor.AppName
            CoordinateBox["XOffset"].Focus()
        }
        Else If Y = "" {
            MsgBox "You did not enter the Y offset.", Editor.AppName
            CoordinateBox["YOffset"].Focus()
        }
        Else If Not Y = 0 And Not Y Is Integer {
            MsgBox "The Y offset must be a whole number.", Editor.AppName
            CoordinateBox["YOffset"].Focus()
        }
        Else If Not Editor.Overlay {
            MsgBox "It seems that the editor does not hold any overlay at the moment.", Editor.AppName
            CloseCoordinateBox()
        }
        Else If ItemType = "All controls" And Editor.Overlay.ChildControls.Length = 2 {
            MsgBox "The editor overlay does not hold any child controls at the moment.", Editor.AppName
            CloseCoordinateBox()
        }
        Else If ItemType = "Current control" And Not CurrentControl {
            MsgBox "There is no control currently selected.", Editor.AppName
            CloseCoordinateBox()
        }
        Else {
            ItemTypeList.RemoveAt(1, 2)
            If ItemType = "All controls" {
                For OverlayControl In Editor.Overlay.AllControls
                For AvailableType In ItemTypeList
                If Type(OverlayControl) = AvailableType {
                    If OverlayControl.HasProp("XCoordinate") And OverlayControl.HasProp("YCoordinate") {
                        Editor.ParamHandler.SetControlCoords(OverlayControl, OverlayControl.XCoordinate + X, OverlayControl.YCoordinate + Y)
                    }
                    Else {
                        If OverlayControl.HasProp("X1Coordinate") And OverlayControl.HasProp("Y1Coordinate") And OverlayControl.HasProp("X2Coordinate") And OverlayControl.HasProp("Y2Coordinate")
                        Editor.ParamHandler.SetControlCoords(OverlayControl, OverlayControl.X1Coordinate + X, OverlayControl.Y1Coordinate + Y, OverlayControl.X2Coordinate + X, OverlayControl.Y2Coordinate + Y)
                    }
                    Break
                }
            }
            Else If ItemType = "Current control" {
                For AvailableType In ItemTypeList
                If Type(CurrentControl) = AvailableType {
                    If OverlayControl.HasProp("XCoordinate") And OverlayControl.HasProp("YCoordinate") {
                        Editor.ParamHandler.SetControlCoords(OverlayControl, OverlayControl.XCoordinate + X, OverlayControl.YCoordinate + Y)
                    }
                    Else {
                        If CurrentControl.HasProp("X1Coordinate") And CurrentControl.HasProp("Y1Coordinate") And CurrentControl.HasProp("X2Coordinate") And CurrentControl.HasProp("Y2Coordinate")
                        Editor.ParamHandler.SetControlCoords(CurrentControl, CurrentControl.X1Coordinate + X, CurrentControl.Y1Coordinate + Y, CurrentControl.X2Coordinate + X, CurrentControl.Y2Coordinate + Y)
                    }
                    Break
                }
            }
            Else {
                For OverlayControl In Editor.Overlay.AllControls
                If Type(OverlayControl) = ItemType {
                    If OverlayControl.HasProp("XCoordinate") And OverlayControl.HasProp("YCoordinate") {
                        Editor.ParamHandler.SetControlCoords(OverlayControl, OverlayControl.XCoordinate + X, OverlayControl.YCoordinate + Y)
                    }
                    Else {
                        If OverlayControl.HasProp("X1Coordinate") And OverlayControl.HasProp("Y1Coordinate") And OverlayControl.HasProp("X2Coordinate") And OverlayControl.HasProp("Y2Coordinate")
                        Editor.ParamHandler.SetControlCoords(OverlayControl, OverlayControl.X1Coordinate + X, OverlayControl.Y1Coordinate + Y, OverlayControl.X2Coordinate + X, OverlayControl.Y2Coordinate + Y)
                    }
                }
            }
            MsgBox "Operation complete.", Editor.AppName
            CloseCoordinateBox()
        }
    }
}

PerformOCR(GenerateMarkers := False) {
    If GenerateMarkers {
        ConfirmationDialog := MsgBox("Generate markers from OCR?", Editor.AppName, 4)
        If ConfirmationDialog == "Yes" {
            OCRLines := RunOCR()
            MakeMarkersFromLines(OCRLines)
            AccessibilityOverlay.Speak(OCRLines.Length * 2 . " markers generated")
        }
    }
    Else {
        RunOCR()
        ViewResult(OCRLines)
    }
    MakeMarkersFromLines(OCRLines) {
        If OCRLines.Length > 0
        Editor.Overlay.FocusControlByNumber(Editor.Overlay.FocusableControls.Length)
        For Value In OCRLines {
            AddedControl := Editor.AddItem("Marker", True, True).OverlayObj
            Editor.SetItemParam(AddedControl.ControlID, "ObjParams", "Label", "`"" . Value.Text . "`" start")
            Editor.SetItemParam(AddedControl.ControlID, "ObjParams", "XCoordinate", Value.X1)
            Editor.SetItemParam(AddedControl.ControlID, "ObjParams", "YCoordinate", Value.Y1)
            AddedControl := Editor.AddItem("Marker", True, True).OverlayObj
            Editor.SetItemParam(AddedControl.ControlID, "ObjParams", "Label", "`"" . Value.Text . "`" end")
            Editor.SetItemParam(AddedControl.ControlID, "ObjParams", "XCoordinate", Value.X2)
            Editor.SetItemParam(AddedControl.ControlID, "ObjParams", "YCoordinate", Value.Y2)
        }
    }
    RunOCR() {
        OCRLines := Array()
        Try {
            WinWaitActive("A")
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
                AccessibilityOverlay.Speak("No OCR languages installed!")
            }
            Else {
                If PreferredLanguage = False
                OCRLanguage := FirstOCRLanguage
                Else
                OCRLanguage := PreferredOCRLanguage
                OCRResult := OCR.FromWindow("A", {lang: OCRLanguage})
                For OCRLine In OCRResult.Lines
                OCRLines.Push({Text: OCRLine.Text, X1: OCR.WordsBoundingRect(OCRLine.Words*).X, Y1: OCR.WordsBoundingRect(OCRLine.Words*).Y, X2: OCR.WordsBoundingRect(OCRLine.Words*).X + OCR.WordsBoundingRect(OCRLine.Words*).W, Y2: OCR.WordsBoundingRect(OCRLine.Words*).Y + OCR.WordsBoundingRect(OCRLine.Words*).H})
            }
        }
        Return OCRLines
    }
    ViewResult(OCRLines) {
        OCRResult := ""
        For Value In OCRLines
        OCRResult .= "`"" . Value.Text . "`"`nBeginning at X " . Value.X1 . ", Y " . Value.Y1 . "`nEnding at X " . Value.X2 . ", Y " . Value.Y2 . "`n`n"
        Editor.ShowDlgBox("OCR Result", OCRResult)
    }
}

RouteMouseToFocusedControl(*) {
    Try {
        WinWaitActive("A")
        ControlClass := ControlGetClassNN(ControlGetFocus("A"))
    }
    Catch {
        AccessibilityOverlay.Speak("Focused control not found")
        Return
    }
    WinWaitActive("A")
    ControlGetPos &ControlX, &ControlY,,, ControlClass, "A"
    MouseMove ControlX, ControlY
    AccessibilityOverlay.Speak("Mouse routed to X " . ControlX . " Y " . ControlY)
}

SearchForImage(RepeatLast := False) {
    Static ImageFile := ""
    If Not RepeatLast
    ImageFile := ""
    If ImageFile = "" Or Not FileExist(ImageFile) Or InStr(FileExist(ImageFile), "D")
    ImageFile := FileSelect(3,, "Choose Image", "Supported Images (*.ANI; *.BMP; *.CUR; *.EMF; *.Exif; *.GIF; *.ICO; *.JPG; *.PNG; *.TIF; *.WMF)")
    If Not ImageFile = "" {
        LastImage := ImageFile
        XPosition := ""
        YPosition := ""
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
            If ImageSearch(&XPosition, &YPosition, 0, 0, WinWidth, WinHeight, ImageFile) {
                ConfirmationDialog := MsgBox("Your image has been found at X " . XPosition . ", Y " . YPosition . ".`nAdd a marker at that position?", Editor.AppName, 4)
                If ConfirmationDialog == "Yes" {
                    Editor.Overlay.FocusControlByNumber(Editor.Overlay.FocusableControls.Length)
                    AddedControl := Editor.AddItem("Marker", True, False).OverlayObj
                    Editor.SetItemParam(AddedControl.ControlID, "ObjParams", "Label", "`"" . ImageFile . "`"")
                    Editor.SetItemParam(AddedControl.ControlID, "ObjParams", "XCoordinate", XPosition)
                    Editor.SetItemParam(AddedControl.ControlID, "ObjParams", "YCoordinate", YPosition)
                }
                Sleep 1000
                MouseMove XPosition, YPosition
            }
            Else {
                MsgBox "The image you selected has not been found on the screen.", Editor.AppName
            }
        }
    }
}

ViewClipboardContents(*) {
    Editor.ShowDlgBox("Clipboard Contents", A_Clipboard)
}

ViewControlInfo(*) {
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
        ControlHWND := ControlGetHWND(ControlClass, "A")
        Try {
            WinGetPos &WinX, &WinY, &WinW, &WinH, ControlHWND
            WinDimensions := WinW . " × " . WinH
            WinPos := "X " . WinX . ", Y " . WinY
        }
        Catch {
            WinDimensions := ""
            WinPos := ""
        }
        Try {
            WinGetClientPos &ClientX, &ClientY, &ClientW, &ClientH, ControlHWND
            ClientDimensions := ClientW . " × " . ClientH
            ClientPos := "X " . ClientX . ", Y " . ClientY
        }
        Catch {
            ClientDimensions := ""
            ClientPos := ""
        }
    }
    Catch {
        AccessibilityOverlay.Speak("Focused control not found")
        Return
    }
    ControlInfo := "Control HWND:`t" . ControlHWND . "`nControl class:`t" . ControlClass . "`nControl Position:`t" . ControlPos . "`nControl Dimensions:`t" . ControlDimensions . "`n`nWhen Treated As A Window:`nWindow Position:`t" . WinPos . "`nWindow Dimensions:`t" . WinDimensions . "`nClient Area Position:`t" . ClientPos . "`nClient Area Dimensions:`t" . ClientDimensions
    Editor.ShowDlgBox("Control Info", ControlInfo)
}

ViewControlList(*) {
    Try {
        WinWaitActive("A")
        Controls := WinGetControls("A")
    }
    Catch {
        AccessibilityOverlay.Speak("No controls found")
        Return
    }
    ControlList := "Control HWND`tControl class`tX coordinate`tY coordinate`tWidth`tHeight`n"
    For Control In controls {
        Try
        ControlClass := ControlGetClassNN(Control)
        Catch
        ControlClass := "-"
        Try
        ControlHWND := ControlGetHWND(ControlClass)
        Catch
        ControlHWND := "-"
        Try {
            ControlGetPos &ControlX, &ControlY, &ControlW, &ControlH, ControlClass, "A"
        }
        Catch {
            ControlX := "-"
            ControlY := "-"
            ControlW := "-"
            ControlH := "-"
        }
        ControlList .= ControlHWND . "`t" . ControlClass . "`t" . ControlX . "`t" . ControlY . "`t" . ControlW . "`t" . ControlH . "`n"
    }
    Editor.ShowDlgBox("Control List", ControlList)
}

ViewMouseInfo(*) {
    Try {
        WinWaitActive("A")
        Try {
            MouseGetPos &XPosition, &YPosition
            MousePos := "X " . XPosition . ", Y " . YPosition
        }
        Catch {
            AccessibilityOverlay.Speak("Could not determine mouse position")
            Return
        }
        PixelColor := PixelGetColor(XPosition, YPosition, "Slow")
    }
    Catch {
        AccessibilityOverlay.Speak("Active window not found")
        Return
    }
    MouseInfo := "Mouse Position:`t" . MousePos . "`nColor Under The Cursor:`t" . PixelColor
    Editor.ShowDlgBox("Mouse Info", MouseInfo)
}

ViewWindowInfo(*) {
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
        AccessibilityOverlay.Speak("Active window not found")
        Return
    }
    WindowInfo := "Process Name:`t" . ProcessName . "`nProcess Path:`t" . ProcessPath . "`nWindow ID:`t" . WindowID . "`nWindow Class:`t" . WindowClass . "`nWindow Title:`t" . WindowTitle . "`nWindow Position:`t" . WinPos . "`nWindow Dimensions:`t" . WinDimensions . "`nClient Area Position:`t" . ClientPos . "`nClient Area Dimensions:`t" . ClientDimensions
    Editor.ShowDlgBox("Window Info", WindowInfo)
}
