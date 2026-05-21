#Requires AutoHotkey v2.0

Class ParamHandler {
    
    Static __Call(Value, Params) {
        If Params.Length = 5 {
            Name := Params[2]
            Value := Params[3]
            Expression := Params[4]
            Optional := Params[5]
            If Value = "" And Not Optional
            Return This.Error("You did not enter the " . StrLower(This.GetFriendlyName(Name)) . ".")
            Return Value
        }
        Return False
    }
    
    Static ArrayToString(ArrayObj) {
        ReturnValue := ""
        For ArrayItem In ArrayObj
        If ArrayItem Is Number Or ArrayItem Is String
        ReturnValue .= ArrayItem . ", "
        While SubStr(ReturnValue, - -2) = ", "
        ReturnValue := SubStr(ReturnValue, 1, -2)
        Return ReturnValue
    }
    
    Static CompensateCoords(OverlayObj, X1, Y1, X2 := "", Y2 := "") {
        If X2 = ""
        X2 := 0
        If Y2 = ""
        Y2 := 0
        PluginControlPos := GetPluginControlPos()
        RequiredPropList := Array("Start", "End", "XCoordinate", "YCoordinate", "X1Coordinate", "Y1Coordinate", "X2Coordinate", "Y2Coordinate")
        If OverlayObj Is Object {
            Found := False
            For CurrentProp In RequiredPropList
            If OverlayObj.HasProp(CurrentProp) {
                Found := True
                Break
            }
            If Not Found
            Return False
            For CurrentProp In RequiredPropList
            If OverlayObj.HasProp("Original" . CurrentProp) {
                OverlayObj.DeleteProp("Original" . CurrentProp)
            }
            If OverlayObj.HasProp("XCoordinate") {
                X1 := X1 - PluginControlPos.X
                Editor.SetItemParam(OverlayObj.ControlID, "ObjParams", "XCoordinate", X1)
            }
            If OverlayObj.HasProp("YCoordinate") {
                Y1 := Y1 - PluginControlPos.Y
                Editor.SetItemParam(OverlayObj.ControlID, "ObjParams", "YCoordinate", Y1)
            }
            If OverlayObj.HasProp("X1Coordinate") {
                X1 := X1 - PluginControlPos.X
                Editor.SetItemParam(OverlayObj.ControlID, "ObjParams", "X1Coordinate", X1)
            }
            If OverlayObj.HasProp("Y1Coordinate") {
                Y1 := Y1 - PluginControlPos.Y
                Editor.SetItemParam(OverlayObj.ControlID, "ObjParams", "Y1Coordinate", Y1)
            }
            If OverlayObj.HasProp("X2Coordinate") {
                X2 := X2 - PluginControlPos.X
                Editor.SetItemParam(OverlayObj.ControlID, "ObjParams", "X2Coordinate", X2)
            }
            If OverlayObj.HasProp("Y2Coordinate") {
                Y2 := Y2 - PluginControlPos.Y
                Editor.SetItemParam(OverlayObj.ControlID, "ObjParams", "Y2Coordinate", Y2)
            }
            Return True
        }
        Return False
    }
    
    Static FuncToString(FuncObj) {
        If FuncObj Is Func
        If FuncObj Is Func And FuncObj.HasProp("Name")
        If FuncObj.Name Is Number Or FuncObj.Name Is String
        Return FuncObj.Name
        Return ""
    }
    
    Static FuncArrayToString(FuncArray) {
        If FuncArray Is String
        Return FuncArray
        If Not FuncArray Is Array
        Return FuncArray
        ResultingString := ""
        For FuncItem In FuncArray {
            If FuncItem Is Func And FuncItem.HasProp("Name")
            ResultingString .= FuncItem.Name . ", "
        }
        If SubStr(ResultingString, -2) = ", "
        ResultingString := SubStr(ResultingString, 1, -2)
        Return ResultingString
    }
    
    Static GetFriendlyName(Name) {
        FriendlyNames := Map(
        "ChangeFunctions", "Functions when the value of the control changes",
        "CheckedColors", "Colors when the control is checked",
        "CheckedImages", "Image files when the control is checked",
        "CheckStateFunction", "Check State Function",
        "CompensationFunction", "Compensation Function",
        "DefaultLabel", "Default Label",
        "DefaultValue", "Default Value",
        "HotkeyCommand", "Hotkey Command",
        "HotkeyFunctions", "Hotkey Functions",
        "HotkeyLabel", "Hotkey Label",
        "LabelPrefix", "Label Prefix",
        "OCRLanguage", "OCR Language",
        "OCRScale", "OCR Scale",
        "OCRType", "OCR Type",
        "OffColors", "Colors when the control is off",
        "OffImages", "Image files when the control is off",
        "OnColors", "Colors when the control is on",
        "OnImages", "Image files when the control is on",
        "PluginName", "Plug-in Name",
        "PostExecActivationFunctions", "Post-exec Activation Functions",
        "PostExecFocusFunctions", "Post-exec Focus Functions",
        "PreExecActivationFunctions", "Pre-exec Activation Functions",
        "PreExecFocusFunctions", "Pre-exec Focus Functions",
        "StandaloneName", "Standalone Name",
        "UncheckedColors", "Colors when the control is unchecked",
        "UncheckedImages", "Image files when the control is unchecked",
        "ValuePrefix", "Value Prefix",
        "XCoordinate", "X Coordinate",
        "YCoordinate", "Y Coordinate",
        "X1Coordinate", "X1 Coordinate",
        "Y1Coordinate", "Y1 Coordinate",
        "X2Coordinate", "X2 Coordinate",
        "Y2Coordinate", "Y2 Coordinate",
        )
        If FriendlyNames.Has(Name)
        If Not Trim(FriendlyNames[Name]) = ""
        Return FriendlyNames[Name]
        Return Name
    }
    
    Static HasCompensationFunc(OverlayObj) {
        CompensatorList := [CompensatePluginCoordinates]
        RequiredPropList := Array("Start", "End", "XCoordinate", "YCoordinate", "X1Coordinate", "Y1Coordinate", "X2Coordinate", "Y2Coordinate")
        TargetPropList := Array("PreExecFocusFunctions", "PostExecFocusFunctions", "PreExecActivationFunctions", "PostExecActivationFunctions", "ChangeFunctions")
        If OverlayObj Is Object {
            Found := False
            For CurrentProp In RequiredPropList
            If OverlayObj.HasProp(CurrentProp) {
                Found := True
                Break
            }
            If Found
            For TargetProp In TargetPropList
            If OverlayObj.HasProp(TargetProp) {
                For CurrentFunction In OverlayObj.%TargetProp%
                For Compensator In CompensatorList
                If CurrentFunction == Compensator
                Return True
            }
        }
        Return False
    }
    
    Static MakeEditorProp(ItemType, Name, Value, Expression, Optional := True) {
        If Value Is Number Or Value Is String
        Return Value
        If Value Is Array {
            If Name = "PreExecFocusFunctions" Or Name = "PostExecFocusFunctions" Or Name = "PreExecActivationFunctions" Or Name = "PostExecActivationFunctions" Or Name = "ChangeFunctions"
            Return This.FuncArrayToString(Value)
            Else If Name = "OnColors" Or Name = "OffColors" Or Name = "CheckedColors" Or Name = "UncheckedColors" Or Name = "Images" Or Name = "OnImages" Or Name = "OffImages" Or Name = "CheckedImages" Or Name = "UncheckedImages"
            Return This.ArrayToString(Value)
        }
        If Value Is Func {
            Return This.FuncToString(Value)
        }
        If Value Is Object {
            Return This.ObjToString(Value)
        }
        Return ""
    }
    
    Static MakeOverlayProp(OverlayObj, Name, Value, Expression, Optional := True) {
        If Expression {
            If SubStr(Name, -8) = "Function" {
                ReturnValue := ""
                Value := Trim(Value)
                If SubStr(Value, 1, 1) = "["
                Value := SubStr(Value, 2)
                If SubStr(Value, -1) = "]"
                Value := SubStr(Value, 1, -1)
                FuncParser := Editor.CodeParser()
                For FuncItem In FuncParser.Split(Value, ",") {
                    Try
                    FuncItem := FuncParser.ParseSegment(FuncItem)
                    Catch
                    FuncItem := False
                    If FuncItem Is Object {
                        If FuncItem Is BoundFunc
                        FuncItem := FuncItem.Call()
                        Return FuncItem
                    }
                }
                Return ReturnValue
            }
            If SubStr(Name, -9) = "Functions" {
                ReturnValue := Array()
                Value := Trim(Value)
                If SubStr(Value, 1, 1) = "["
                Value := SubStr(Value, 2)
                If SubStr(Value, -1) = "]"
                Value := SubStr(Value, 1, -1)
                FuncParser := Editor.CodeParser()
                For FuncItem In FuncParser.Split(Value, ",") {
                    Try
                    FuncItem := FuncParser.ParseSegment(FuncItem)
                    Catch
                    FuncItem := False
                    If FuncItem Is Object {
                        If FuncItem Is BoundFunc
                        FuncItem := FuncItem.Call()
                        ReturnValue.Push(FuncItem)
                    }
                }
                Return ReturnValue
            }
        }
        If Name = "OnColors" Or Name = "OffColors" Or Name = "CheckedColors" Or Name = "UncheckedColors" {
            If SubStr(Value, 1, 1) = "["
            Value := SubStr(Value, 2)
            If SubStr(Value, -1) = "]"
            Value := SubStr(Value, 1, -1)
            Value := StrSplit(Value, ",", A_Space)
            Return Value
        }
        If Expression {
            ExprParser := Editor.CodeParser()
            Return ExprParser.ProcessExpression(Value)
        }
        Return Value
    }
    
    Static ObjToString(Value) {
        If Value Is Object
        If Value Is Object And Value.HasProp("Name")
        Return Value.Name
        Return ""
    }
    
    Static SetControlCoords(OverlayObj, X1, Y1, X2 := "", Y2 := "") {
        If This.HasCompensationFunc(OverlayObj) {
            This.CompensateCoords(OverlayObj, X1, Y1, X2, Y2)
        }
        Else {
            If OverlayObj.HasProp("XCoordinate")
            Editor.SetItemParam(OverlayObj.ControlID, "ObjParams", "XCoordinate", X1)
            If OverlayObj.HasProp("YCoordinate")
            Editor.SetItemParam(OverlayObj.ControlID, "ObjParams", "YCoordinate", Y1)
            If OverlayObj.HasProp("X1Coordinate")
            Editor.SetItemParam(OverlayObj.ControlID, "ObjParams", "X1Coordinate", X1)
            If OverlayObj.HasProp("Y1Coordinate")
            Editor.SetItemParam(OverlayObj.ControlID, "ObjParams", "Y1Coordinate", Y1)
            If OverlayObj.HasProp("X2Coordinate") {
                If Not X2 = ""
                Editor.SetItemParam(OverlayObj.ControlID, "ObjParams", "X2Coordinate", X2)
            }
            If OverlayObj.HasProp("Y2Coordinate") {
                If Not Y2 = ""
                Editor.SetItemParam(OverlayObj.ControlID, "ObjParams", "Y2Coordinate", Y2)
            }
        }
    }
    
    Static ValidateHotkeyCommand(OverlayObj, Name, Value, Expression, Optional) {
        If Value = "" And Not Expression
        Return Value
        Return Value
    }
    
    Static ValidateDefaultValue(OverlayObj, Name, Value, Expression, Optional) {
        If Value = "" And Not Expression
        Return Value
        If Value = "" And Optional
        Return Value
        If Value = ""
        Return This.Error("You did not enter the " . StrLower(This.GetFriendlyName(Name)) . ".")
        Return Value
    }
    
    Static ValidateLabel(OverlayObj, Name, Value, Expression, Optional) {
        If Value = "" And Not Expression
        Return Value
        If Value = "" And Optional
        Return Value
        If Value = ""
        Return This.Error("You did not enter the " . StrLower(This.GetFriendlyName(Name)) . ".")
        Return Value
    }
    
    Static ValidateLabelPrefix(OverlayObj, Name, Value, Expression, Optional) {
        If Value = "" And Not Expression
        Return Value
        If Value = "" And Optional
        Return Value
        If Value = ""
        Return This.Error("You did not enter the " . StrLower(This.GetFriendlyName(Name)) . ".")
        Return Value
    }
    
    Static ValidateValue(OverlayObj, Name, Value, Expression, Optional) {
        If Value = "" And Not Expression
        Return Value
        If Value = "" And Optional
        Return Value
        If Value = ""
        Return This.Error("You did not enter the " . StrLower(This.GetFriendlyName(Name)) . ".")
        Return Value
    }
    
    Static ValidateValuePrefix(OverlayObj, Name, Value, Expression, Optional) {
        If Value = "" And Not Expression
        Return Value
        If Value = "" And Optional
        Return Value
        If Value = ""
        Return This.Error("You did not enter the " . StrLower(This.GetFriendlyName(Name)) . ".")
        Return Value
    }
    
    Static ValidateVarName(OverlayObj, Name, Value, Expression, Optional) {
        If Value = ""
        Return This.Error("You did not enter the variable name.")
        For ItemType, ItemDefinition In Editor.ItemDefinitions
        If Trim(Value) = ItemType
        Return This.Error("You can't set `"" . ItemType . "`" as the variable name.")
        If Not RegExMatch(Value, "^([A-Za-z_][0-9A-Za-z_]+)$")
        Return This.Error("The variable name has an invalid format.")
        Return Value
    }
    
    Class Error {
        
        Message := ""
        
        __New(Message) {
            This.Message := Message
        }
        
    }
    
}
