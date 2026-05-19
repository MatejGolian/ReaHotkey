#Requires AutoHotkey v2.0

Class CodeGenerator {
    
    Static ParamSeparator := ", "
    
    Static GenerateConstructor(ItemID) {
        ItemData := Editor.Items[ItemID]
        ItemType := Type(ItemData.OverlayObj)
        Return ItemType . "(" . This.GenerateConstructorParams(ItemID) . ")"
    }
    
    Static GenerateConstructorParams(ItemID) {
        ConstructorParams := ""
        ItemData := Editor.Items[ItemID]
        ObjParams := ItemData.ObjParams
        OverlayObj := ItemData.OverlayObj
        ItemType := Type(OverlayObj)
        ItemDefinition := Editor.ItemDefinitions[ItemType]
        If ItemDefinition.HasProp("RequiredParams")
        RequiredParams := ItemDefinition.RequiredParams
        Else
        RequiredParams := False
        If ItemDefinition.HasProp("OptionalParams")
        OptionalParams := ItemDefinition.OptionalParams
        Else
        OptionalParams := False
        If ItemData.HasProp("ExpressionParams")
        ExpressionParams := ItemData.ExpressionParams
        Else
        ExpressionParams := False
        If RequiredParams
        For Param In RequiredParams {
            ProcessParam(Param, False)
        }
        If OptionalParams
        For Param In OptionalParams {
            ProcessParam(Param, True)
        }
        While SubStr(ConstructorParams, - StrLen(This.ParamSeparator)) = This.ParamSeparator
        ConstructorParams := SubStr(ConstructorParams, 1, - StrLen(This.ParamSeparator))
        Return ConstructorParams
        ProcessParam(Param, Optional) {
            If ObjParams.HasProp(Param.Name) {
                If Optional And ObjParams.%Param.Name% = "" {
                    ConstructorParams .= This.ParamSeparator
                }
                Else If ExpressionParams.%Param.Name% {
                    ParamValue := ObjParams.%Param.Name%
                    If OverlayObj.HasProp(Param.Name)
                    If OverlayObj.%Param.Name% Is Array {
                        CommaSplit := Editor.CodeParser().Split(ObjParams.%Param.Name%, ",").Length
                        SpaceSplit := Editor.CodeParser().Split(ObjParams.%Param.Name%, " ").Length
                        If CommaSplit > 1 Or SpaceSplit > 1 {
                            If SubStr(ParamValue, 1, 6) = "Array(" {
                                If Not SubStr(ParamValue, -1) = ")"
                                ParamValue := ParamValue . ")"
                            }
                            Else {
                                If Not SubStr(ParamValue, 1, 1) = "["
                                ParamValue := "[" . ParamValue
                                If Not SubStr(ParamValue, -1) = "]"
                                ParamValue := ParamValue . "]"
                            }
                        }
                    }
                    ConstructorParams .= ParamValue . This.ParamSeparator
                }
                Else {
                    ConstructorParams .= "`"" . ObjParams.%Param.Name% . "`"" . This.ParamSeparator
                }
            }
            Else {
                ConstructorParams .= This.ParamSeparator
            }
        }
    }
    
    Static GenerateOverlay(OverlayObj, ParentVarName := False) {
        Editor.Items := Editor.Items
        Editor.ItemDefinitions := Editor.ItemDefinitions
        OverlayVarName := Editor.Items[OverlayObj.ControlID].VarName
        If ParentVarName {
            If InStr(Type(OverlayObj), ".")
            OverlayCode := OverlayVarName . " := " . ParentVarName . ".AddControl(" . This.GenerateConstructor(OverlayObj.ControlID) . ")`n"
            Else
            OverlayCode := OverlayVarName . " := " . ParentVarName . ".Add" . This.GenerateConstructor(OverlayObj.ControlID) . "`n"
        }
        Else {
            OverlayCode := OverlayVarName . " := " . This.GenerateConstructor(OverlayObj.ControlID) . "`n"
        }
        If OverlayObj Is AccessibilityOverlay
        ChildPropName := "ChildControls"
        Else If OverlayObj Is TabControl
        ChildPropName := "Tabs"
        Else
        ChildPropName := False
        If ChildPropName
        For ChildItem In OverlayObj.%ChildPropName% {
            If Editor.Items.Has(ChildItem.ControlID)
            ChildItemVarName := Editor.Items[ChildItem.ControlID].VarName
            Else
            ChildItemVarName := False
            If ChildItem Is             AccessibilityOverlay {
                OverlayCode .= This.GenerateOverlay(ChildItem, OverlayVarName)
            }
            Else If ChildItem Is Marker Or ChildItem Is Separator {
                Continue
            }
            Else If ChildItem Is TabControl {
                If InStr(Type(ChildItem), ".") {
                    OverlayCode .= ChildItemVarName . " := " . OverlayVarName . ".AddControl(" . This.GenerateConstructor(ChildItem.ControlID) . ")`n"
                }
                Else {
                    OverlayCode .= ChildItemVarName . " := " . OverlayVarName . ".Add" . This.GenerateConstructor(ChildItem.ControlID) . "`n"
                }
                For TabItem In ChildItem.Tabs {
                    TabItemVarName := Editor.Items[TabItem.ControlID].VarName
                    OverlayCode .= This.GenerateOverlay(TabItem)
                    OverlayCode .= ChildItemVarName . ".AddTabs(" . TabItemVarName . ")`n"
                }
            }
            Else {
                If InStr(Type(ChildItem), ".") {
                    OverlayCode .= OverlayVarName . ".AddControl(" . This.GenerateConstructor(ChildItem.ControlID) . ")`n"
                }
                Else {
                    OverlayCode .= OverlayVarName . ".Add" . This.GenerateConstructor(ChildItem.ControlID) . "`n"
                }
            }
        }
        Return OverlayCode
    }
    
}
