#Requires AutoHotkey v2.0

AddItemHandler(ItemName, ItemPos, MenuObj) {
    MouseGetPos &XPosition, &YPosition
    AddedControl:= Editor.AddItem(ItemName, True,False).OverlayObj
    If AddedControl.HasProp("XCoordinate") And AddedControl.HasProp("YCoordinate") {
        Editor.ParamHandler.SetControlCoords(AddedControl, XPosition, YPosition)
    }
    Else {
        If AddedControl.HasProp("X1Coordinate") And AddedControl.HasProp("Y1Coordinate")
        If AddedControl.HasProp("X1Coordinate") And AddedControl.HasProp("Y1Coordinate") And AddedControl.HasProp("X2Coordinate") And AddedControl.HasProp("Y2Coordinate")
        Editor.ParamHandler.SetControlCoords(AddedControl, XPosition, YPosition, XPosition, YPosition)
    }
    If Editor.ParamHandler.HasCompensationFunc(AddedControl)
    AccessibilityOverlay.Speak(Type(AddedControl) . " added compensated at X " . XPosition . " Y " . YPosition)
    Else
    AccessibilityOverlay.Speak(Type(AddedControl) . " added at X " . XPosition . " Y " . YPosition)
    MouseMove XPosition, YPosition
}

DeleteItemHandler(ItemName, ItemPos, MenuObj) {
    Editor.DeleteItem(Editor.Overlay.CurrentControl.ControlID)
}

EditItemHandler(ItemName, ItemPos, MenuObj) {
    If Editor.Overlay.CurrentControl {
        If Editor.Overlay.CurrentControl Is Separator
        Editor.EditItem(Editor.Overlay.CurrentControl.SuperordinateControlID)
        Else
        Editor.EditItem(Editor.Overlay.CurrentControl.ControlID)
    }
}

GenerateMarkersFromOCRHandler(ItemName, ItemPos, MenuObj) {
    PerformOCR(True)
}

ItemActionMenuHandler(ItemName, ItemPos, MenuObj) {
    If Not Editor.Overlay.CurrentControl
    Return
    If Editor.Overlay.CurrentControl Is Separator
    TargetControl := Editor.Overlay.CurrentControl.SuperordinateControl
    Else
    TargetControl := Editor.Overlay.CurrentControl
    FuncName := StrReplace(StrTitle(ItemName), " ", "")
    FuncName := StrReplace(FuncName, "&", "")
    If InStr(FuncName, "`t")
    FuncName := SubStr(FuncName, 1, InStr(FuncName, "`t") - 1)
    %FuncName%.Call(TargetControl)
}

PerformOCRHandler(ItemName, ItemPos, MenuObj) {
    PerformOCR(False)
}

RepeatSearchForImageHandler(ItemName, ItemPos, MenuObj) {
    SearchForImage(True)
}

SearchForImageHandler(ItemName, ItemPos, MenuObj) {
    SearchForImage(False)
}
