#Requires AutoHotkey v2.0

ActionTriggerHK(ThisHotkey) {
    If WinExist("ahk_class #32768") {
        AccessibilityOverlay.Helpers.PassThroughHotkey(ThisHotkey)
        Return
    }
    If Editor.Active {
        Editor.OnlyWhenEditorActiveHKs[ThisHotkey].Call(ThisHotkey)
        Return
    }
    AccessibilityOverlay.Helpers.PassThroughHotkey(ThisHotkey)
}

AddHotspotButtonHK(ThisHotkey) {
    If Editor.Overlay.CurrentControl
    AddMarkerOrHotspotButton("HotspotButton")
}

AddMarkerHK(ThisHotkey) {
    If Editor.Overlay.CurrentControl
    AddMarkerOrHotspotButton("Marker")
}

ContextMenuHK(ThisHotkey) {
    ContextMenu := Editor.CreateContextMenu()
    If ContextMenu Is Menu {
        Editor.ToggleHKs("Off")
        ContextMenu.Show()
    }
}

ControlHK(ThisHotkey) {
    AccessibilityOverlay.StopSpeech()
}

ControlShiftTabHK(ThisHotkey) {
    AccessibilityOverlay.Helpers.PassThroughHotkey(ThisHotkey)
    FocusNextPreviousTab("Previous", Editor.Overlay)
}

ControlTabHK(ThisHotkey) {
    AccessibilityOverlay.Helpers.PassThroughHotkey(ThisHotkey)
    FocusNextPreviousTab("Next", Editor.Overlay)
}

CopyItemHK(ThisHotkey) {
    Editor.CopyItem()
}

CreateProjectHK(ThisHotkey) {
    Editor.CreateProject()
}

CutItemHK(ThisHotkey) {
    Editor.CutItem()
}

DeleteItemHK(ThisHotkey) {
    Editor.DeleteItem(Editor.Overlay.CurrentControlID)
}

EditItemHK(ThisHotkey) {
    If Not Editor.Overlay.CurrentControl
    Return
    If Editor.Overlay.CurrentControl Is Separator
    Editor.EditItem(Editor.Overlay.CurrentControl.SuperordinateControlID)
    Else
    Editor.EditItem(Editor.Overlay.CurrentControl.ControlID)
}

EnterSpaceHK(ThisHotkey) {
    Switch(Editor.Overlay.GetCurrentControlType()) {
        Case "Edit":
        AccessibilityOverlay.Helpers.PassThroughHotkey(ThisHotkey)
        Case "Focusable":
        AccessibilityOverlay.Helpers.PassThroughHotkey(ThisHotkey)
        Default:
        Editor.Overlay.ActivateCurrentControl()
    }
}

F6HK(ThisHotkey) {
}

FocusNextPreviousTab(Which, Overlay) {
    If Overlay Is AccessibilityOverlay And Overlay.ChildControls.Length > 0 {
        CurrentControl := Overlay.GetCurrentControl()
        If CurrentControl Is TabControl {
            Sleep 200
            Overlay.Focus%Which%Tab(True)
        }
        Else {
            If CurrentControl Is Object
            Loop AccessibilityOverlay.TotalNumberOfControls {
                SuperordinateControl := CurrentControl.SuperordinateControl
                If SuperordinateControl = 0
                Break
                If SuperordinateControl Is TabControl {
                    Overlay.SetCurrentControlID(SuperordinateControl.ControlID)
                    Overlay.FocusControlByID(SuperordinateControl.ControlID)
                    Sleep 200
                    Overlay.Focus%Which%Tab(True)
                    Break
                }
                CurrentControl := SuperordinateControl
            }
        }
    }
}

GenerateCodeHK(ThisHotkey) {
    Editor.GenerateCode()
}

GenerateMarkersFromOcrHK(ThisHotkey) {
    PerformOCR(True)
}

LeftRightHK(ThisHotkey) {
    AccessibilityOverlay.Helpers.PassThroughHotkey(ThisHotkey)
    Switch(Editor.Overlay.GetCurrentControlType()) {
        Case "Custom":
        Editor.Overlay.Focus(False)
        Case "Slider":
        If ThisHotkey = "Left"
        Editor.Overlay.DecreaseSlider()
        Else
        Editor.Overlay.IncreaseSlider()
        Case "TabControl":
        If ThisHotkey = "Left"
        Editor.Overlay.FocusPreviousTab(False)
        Else
        Editor.Overlay.FocusNextTab(False)
    }
}

MoveMouseDownHK(ThisHotkey) {
    Try {
        WinGetClientPos ,,, &YSize, "A"
    }
    Catch {
        AccessibilityOverlay.Speak("Could not determine window size")
        Return
    }
    MouseGetPos &XPosition, &YPosition
    If YPosition < 0
    TargetCoordinate := 0
    Else If YPosition > YSize
    TargetCoordinate := YSize
    Else
    TargetCoordinate := YPosition + 1
    If TargetCoordinate > YSize
    TargetCoordinate := YSize
    YPosition := TargetCoordinate
    MouseMove XPosition, YPosition
    AccessibilityOverlay.Speak(YPosition)
}

MoveMouseLeftHK(ThisHotkey) {
    Try {
        WinGetClientPos ,, &XSize,, "A"
    }
    Catch {
        AccessibilityOverlay.Speak("Could not determine window size")
        Return
    }
    MouseGetPos &XPosition, &YPosition
    If XPosition < 0
    TargetCoordinate := 0
    Else If XPosition > XSize
    TargetCoordinate := XSize
    Else
    TargetCoordinate := XPosition - 1
    If TargetCoordinate < 0
    TargetCoordinate := 0
    XPosition := TargetCoordinate
    MouseMove XPosition, YPosition
    AccessibilityOverlay.Speak(XPosition)
}

MoveMouseRightHK(ThisHotkey) {
    Try {
        WinGetClientPos ,, &XSize,, "A"
    }
    Catch {
        AccessibilityOverlay.Speak("Could not determine window size")
        Return
    }
    MouseGetPos &XPosition, &YPosition
    If XPosition < 0
    TargetCoordinate := 0
    Else If XPosition > XSize
    TargetCoordinate := XSize
    Else
    TargetCoordinate := XPosition + 1
    If TargetCoordinate > XSize
    TargetCoordinate := XSize
    XPosition := TargetCoordinate
    MouseMove XPosition, YPosition
    AccessibilityOverlay.Speak(XPosition)
}

MoveMouseUpHK(ThisHotkey) {
    Try {
        WinGetClientPos ,,, &YSize, "A"
    }
    Catch {
        AccessibilityOverlay.Speak("Could not determine window size")
        Return
    }
    MouseGetPos &XPosition, &YPosition
    If YPosition < 0
    TargetCoordinate := 0
    Else If YPosition > YSize
    TargetCoordinate := YSize
    Else
    TargetCoordinate := YPosition - 1
    If TargetCoordinate < 0
    TargetCoordinate := 0
    YPosition := TargetCoordinate
    MouseMove XPosition, YPosition
    AccessibilityOverlay.Speak(YPosition)
}

OpenProjectHK(ThisHotkey) {
    Editor.OpenProject()
}

PasteItemHK(ThisHotkey) {
    Editor.PasteItem()
}

PerformMouseClickHK(ThisHotkey) {
    Try {
        MouseGetPos &XPosition, &YPosition
    }
    Catch {
        AccessibilityOverlay.Speak("Could not determine mouse position")
        Return
    }
    Click XPosition, YPosition
    AccessibilityOverlay.Speak("Mouse clicked at X " . XPosition . " Y " . YPosition)
}

PerformOcrHK(ThisHotkey) {
    PerformOCR(False)
}

QuitHK(ThisHotkey) {
    Editor.Quit()
}

RepeatSearchForImageHK(ThisHotkey) {
    SearchForImage(True)
}

ReportMousePositionHK(ThisHotkey) {
    Try {
        MouseGetPos &XPosition, &YPosition
    }
    Catch {
        AccessibilityOverlay.Speak("Could not determine mouse position")
        Return
    }
    AccessibilityOverlay.Speak("X " . XPosition . " Y " . YPosition)
}

ReportPixelColorHK(ThisHotkey) {
    Try {
        MouseGetPos &XPosition, &YPosition
    }
    Catch {
        AccessibilityOverlay.Speak("Could not determine mouse position")
        Return
    }
    PixelColor := PixelGetColor(XPosition, YPosition, "Slow")
    AccessibilityOverlay.Speak(PixelColor)
}

SaveProjectAsHK(ThisHotkey) {
    Editor.SaveProjectAs()
}

SaveProjectHK(ThisHotkey) {
    Editor.SaveProject()
}

SearchForImageHK(ThisHotkey) {
    SearchForImage(False)
}

SetMouseXCoordinateHK(ThisHotkey) {
    Try {
        WinGetClientPos ,, &XSize,, "A"
    }
    Catch {
        AccessibilityOverlay.Speak("Could not determine window size")
        Return
    }
    MouseGetPos &XPosition, &YPosition
    If XPosition < 0
    XPosition := 0
    If XPosition > XSize
    XPosition := XSize
    PositionDialog := InputBox("Set Mouse X Position`nEnter a number between 0 and " . XSize . ".", Editor.AppName, "", XPosition)
    If PositionDialog.Result == "OK" And Integer(PositionDialog.Value) >= 0 And Integer(PositionDialog.Value) <= XSize
    MouseMove Integer(PositionDialog.Value), YPosition
}

SetMouseYCoordinateHK(ThisHotkey) {
    Try {
        WinGetClientPos ,,, &YSize, "A"
    }
    Catch {
        AccessibilityOverlay.Speak("Could not determine window size")
        Return
    }
    MouseGetPos &XPosition, &YPosition
    If YPosition < 0
    YPosition := 0
    If YPosition > YSize
    YPosition := YSize
    PositionDialog := InputBox("Set Mouse Y Position`nEnter a number between 0 and " . YSize . ".", Editor.AppName, "", YPosition)
    If PositionDialog.Result == "OK" And Integer(PositionDialog.Value) >= 0 And Integer(PositionDialog.Value) <= YSize
    MouseMove XPosition, Integer(PositionDialog.Value)
}

ShiftTabHK(ThisHotkey) {
    Editor.Overlay.FocusPreviousControl()
}

ShowAboutBoxHK(ThisHotkey) {
    Editor.ShowAboutBox()
}

TabHK(ThisHotkey) {
    Editor.Overlay.FocusNextControl()
}

ToggleEditorHK(ThisHotkey) {
    If Editor.Active {
        Editor.ActiveInWindow := ""
        Editor.Active := False
        AccessibilityOverlay.Speak("Deactivated " . Editor.AppName)
    }
    Else {
        Try
        CurrentTitle := WinGetTitle("A")
        Catch
        CurrentTitle := False
        If CurrentTitle {
            Editor.ActiveInWindow := CurrentTitle
            Editor.Active := True
            AccessibilityOverlay.Speak(Editor.AppName . " active")
        }
    }
    Return Editor.Active
}

TogglePauseHK(ThisHotkey) {
    Editor.TogglePause()
    AccessibilityOverlay.ClearSpeechQueue()
    If A_IsSuspended = 1
    AccessibilityOverlay.Speak("Paused " . Editor.AppName)
    Else
    AccessibilityOverlay.Speak(Editor.AppName . " ready")
}

TriggerOverlayHotkey(ThisHotkey) {
    If Editor.Overlay
    Editor.Overlay.TriggerHotkey(ThisHotkey)
}

UpDownHK(ThisHotkey) {
    AccessibilityOverlay.Helpers.PassThroughHotkey(ThisHotkey)
    Switch(Editor.Overlay.GetCurrentControlType()) {
        Case "ListBox":
        If ThisHotkey = "Up"
        Editor.Overlay.SelectPreviousOption()
        Else
        Editor.Overlay.SelectNextOption()
        Case "Custom":
        Editor.Overlay.Focus(False)
        Case "Slider":
        If ThisHotkey = "Down"
        Editor.Overlay.DecreaseSlider()
        Else
        Editor.Overlay.IncreaseSlider()
    }
}

UndoHK(ThisHotkey) {
    AccessibilityOverlay.Speak("Undo")
    Editor.PerformUndo()
}
