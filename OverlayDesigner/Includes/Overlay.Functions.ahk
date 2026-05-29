#Requires AutoHotkey v2.0

AddMarkerOrHotspotButton(ItemType) {
    If Editor.Overlay.CurrentControl Is TabControl {
        AccessibilityOverlay.Speak(ItemType . "s can't be added while a TabControl has focus")
        Return
    }
    MouseGetPos &XPosition, &YPosition
    AddedControl := Editor.AddItem(ItemType, True, False).OverlayObj
    Editor.ParamHandler.SetControlCoords(AddedControl, XPosition, YPosition)
    If Editor.ParamHandler.HasCompensationFunc(AddedControl)
    AccessibilityOverlay.Speak(Type(AddedControl) . " added compensated at X " . XPosition . " Y " . YPosition)
    Else
    AccessibilityOverlay.Speak(ItemType . " added at X " . XPosition . " Y " . YPosition)
    MouseMove XPosition, YPosition
}

DeleteMarkers(*) {
    MarkerList := GetMarkers()
    MarkerCount := MarkerList.Length
    If MarkerCount = 0 {
        MsgBox "No markers found.", Editor.AppName
        Return
    }
    If MarkerCount = 1
    ConfirmationQuestion := "Delete " . MarkerCount . " marker?"
    Else
    ConfirmationQuestion := "Delete " . MarkerCount . " markers?"
    ConfirmationDialog := MsgBox(ConfirmationQuestion, Editor.AppName, 4)
    If ConfirmationDialog == "Yes" {
        Undo := Editor.CreateUndo().Clone()
        For MarkerControl In MarkerList
        Editor.DeleteItem(MarkerControl.ControlID, False, False)
        Editor.ItemCounts["Marker"] := 0
        Editor.Undo := Undo
        If MarkerCount = 1
        DeletedMessage := "Marker deleted."
        Else
        DeletedMessage := "Markers deleted."
        MsgBox DeletedMessage, Editor.AppName
    }
}

GetMarkers() {
    MarkerList := Array()
    For OverLayControl In Editor.Overlay.AllControls
    If OverlayControl Is Marker
    MarkerList.Push(OverlayControl)
    Return MarkerList
}

SetBottomCornerCoordinatesToMouseCursor(*) {
    If Not Editor.Overlay.CurrentControl
    Return
    If Editor.Overlay.CurrentControl Is Separator
    TargetControl := Editor.Overlay.CurrentControl.SuperordinateControl
    Else
    TargetControl := Editor.Overlay.CurrentControl
    If Not TargetControl Is Object
    Return
    If TargetControl.HasProp("X2Coordinate") And TargetControl.HasProp("Y2Coordinate") {
        MouseGetPos &XPosition, &YPosition
        Editor.ParamHandler.SetControlCoords(TargetControl,,, XPosition, YPosition)
        If Editor.ParamHandler.HasCompensationFunc(TargetControl)
        AccessibilityOverlay.Speak(Type(TargetControl) . " bottom corner coordinates set compensated to X " . XPosition . " Y " . YPosition)
        Else
        AccessibilityOverlay.Speak(Type(TargetControl) . " bottom corner coordinates set to X " . XPosition . " Y " . YPosition)
    }
}

SetHotspotCoordinatesToMouseCursor(*) {
    If Not Editor.Overlay.CurrentControl
    Return
    If Editor.Overlay.CurrentControl Is Separator
    TargetControl := Editor.Overlay.CurrentControl.SuperordinateControl
    Else
    TargetControl := Editor.Overlay.CurrentControl
    If Not TargetControl Is Object
    Return
    If TargetControl.HasProp("XCoordinate") And TargetControl.HasProp("YCoordinate") {
        MouseGetPos &XPosition, &YPosition
        Editor.ParamHandler.SetControlCoords(TargetControl, XPosition, YPosition)
        ReportAction()
    }
    Else {
        If TargetControl.HasProp("X1Coordinate") And TargetControl.HasProp("Y1Coordinate") {
            MouseGetPos &XPosition, &YPosition
            Editor.ParamHandler.SetControlCoords(TargetControl, XPosition, YPosition)
            ReportAction()
        }
    }
    ReportAction() {
        If Editor.ParamHandler.HasCompensationFunc(TargetControl)
        AccessibilityOverlay.Speak(Type(TargetControl) . " coordinates set compensated to X " . XPosition . " Y " . YPosition)
        Else
        AccessibilityOverlay.Speak(Type(TargetControl) . " coordinates set to X " . XPosition . " Y " . YPosition)
    }
}

SetTopCornerCoordinatesToMouseCursor(*) {
    If Not Editor.Overlay.CurrentControl
    Return
    If Editor.Overlay.CurrentControl Is Separator
    TargetControl := Editor.Overlay.CurrentControl.SuperordinateControl
    Else
    TargetControl := Editor.Overlay.CurrentControl
    If Not TargetControl Is Object
    Return
    If TargetControl.HasProp("X1Coordinate") And TargetControl.HasProp("Y1Coordinate") {
        MouseGetPos &XPosition, &YPosition
        Editor.ParamHandler.SetControlCoords(TargetControl, XPosition, YPosition)
        If Editor.ParamHandler.HasCompensationFunc(TargetControl)
        AccessibilityOverlay.Speak(Type(TargetControl) . " top corner coordinates set compensated to X " . XPosition . " Y " . YPosition)
        Else
        AccessibilityOverlay.Speak(Type(TargetControl) . " top corner coordinates set to X " . XPosition . " Y " . YPosition)
    }
}
