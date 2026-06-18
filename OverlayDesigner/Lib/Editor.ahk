#Requires AutoHotkey v2.0

Class Editor {
    
    Static Active := False
    Static ActiveInWindow := ""
    Static AppName := "OverlayDesigner"
    Static Clipboard := {Json: False, Operation: False}
    Static GeneralHKList := Array()
    Static ItemCounts := Map()
    Static Items := Map()
    Static Overlay := False
    Static OverlayHKList := Array()
    Static ProjectFile := ""
    Static Undo := {Json: False, ControlNumber: 0}
    
    Static Init() {
        #Include ../Includes/Hotkey.Definitions.ahk
        #Include ../Includes/Item.Definitions.ahk
        A_IconTip := This.AppName
        A_TrayMenu.Delete
        A_TrayMenu.Add("&Pause", ObjBindMethod(This, "TogglePause"))
        A_TrayMenu.Add("&About…", ObjBindMethod(This, "ShowAboutBox"))
        A_TrayMenu.Add("&Quit…", ObjBindMethod(This, "Quit"))
        This.Overlay := This.AddItem("AccessibilityOverlay", False).OverlayObj
        This.Overlay.CurrentControlID := This.Overlay.GetFocusableControlIDs()[1]
        For HKItem, HKAction In This.AlwaysActiveHKs
        Hotkey HKItem, HKAction
        For HKItem In This.HKsExemptFromPause
        Hotkey HKItem, This.AlwaysActiveHKs[HKItem], "S"
        For HKItem In This.OnlyWhenEditorActiveHKs {
            This.GeneralHKList.Push(HKItem)
            Hotkey HKItem, ActionTriggerHK
        }
        This.ToggleHKs("Off")
        If A_Args.Length > 0 {
            This.PerformOpen(A_Args[1])
            Try
            CurrentTitle := WinGetTitle("A")
            Catch
            CurrentTitle := False
            If CurrentTitle {
                Editor.ActiveInWindow := CurrentTitle
                Editor.Active := True
            }
        }
        Else {
            This.ShowAboutBox()
        }
        SetTimer This.CheckWindow, 200
    }
    
    Static AddFromJson(ProjectOverlay, JsonData, StartingID, IDPrefix := "") {
        If ProjectOverlay Is AccessibilityOverlay
        If Not ProjectOverlay.CurrentControl {
            ControlToFocus := ProjectOverlay.GetControlByNumber(1)
            If ControlToFocus
            ProjectOverlay.CurrentControlID := ControlToFocus.ControlID
        }
        If Not IDPrefix = "" {
            If SubStr(StartingID, 1, StrLen(IDPrefix)) = IDPrefix
            StartingIDNoPrefix := SubStr(StartingID, StrLen(IDPrefix) + 1)
            Else
            StartingIDNoPrefix := StartingID
        }
        Else {
            StartingIDNoPrefix := StartingID
        }
        For Key, Value In JsonData["Items"]
        If Key = IDPrefix . StartingIDNoPrefix {
            StartingItem := Value
            Break
        }
        If IDPrefix {
            EditorItem := This.Additem(StartingItem["ObjType"], True, True)
        }
        Else If Not StartingIDNoPrefix = ProjectOverlay.ControlID {
            EditorItem := This.Additem(StartingItem["ObjType"], True, True)
        }
        Else {
            For Key, Value In This.Items
            If Key = StartingIDNoPrefix {
                EditorItem := This.Items[Key]
                Break
            }
        }
        EditorItem := This.UpdateFromJson(EditorItem, StartingItem)
        If StartingItem.Has("Children")
        For ChildID In StartingItem["Children"] {
            If EditorItem.OverlayObj Is TabControl
            ProjectOverlay.CurrentControlID := EditorItem.OverlayObj.ControlID
            ProjectOverlay := This.AddFromJson(ProjectOverlay, JsonData, ChildID, IDPrefix)
        }
        If EditorItem.OverlayObj Is AccessibilityOverlay {
            FocusableControlIDs := ProjectOverlay.GetFocusableControlIDs()
            ProjectOverlay.CurrentControlID := FocusableControlIDs[FocusableControlIDs.Length]
        }
        If EditorItem.OverlayObj Is TabControl {
            EditorItem.OverlayObj.CurrentTab := StartingItem["CurrentChild"]
        }
        Return ProjectOverlay
    }
    
    Static AddItem(ItemType, OverlayObj := True, FakeFocus := False) {
        If Not FakeFocus
        This.CreateUndo()
        ItemEntry := This.CreateItem(ItemType, False, True)
        NewItem := %ItemType%(ItemEntry.InitialParamList*)
        ItemEntry.DeleteProp("InitialParamList")
        If NewItem Is AccessibilityOverlay {
            NewItem.AddStartSeparator()
            NewItem.AddEndSeparator()
        }
        CurrentControl := False
        If OverlayObj {
            If This.Overlay Is AccessibilityOverlay
            CurrentControl := This.Overlay.CurrentControl
        }
        If CurrentControl Is TabControl {
            If CurrentControl.Tabs.Length = 0
            NewTabNumber := 1
            Else
            NewTabNumber := CurrentControl.CurrentTab + 1
            If CurrentControl.Tabs.Length = 0
            CurrentControl.AddTabs(NewItem)
            Else
            CurrentControl.AddTabsAt(NewTabNumber, NewItem)
            NewItem := CurrentControl.Tabs[NewTabNumber]
            If FakeFocus
            CurrentControl.CurrentTab := NewTabNumber
            Else
            CurrentControl.FocusNextTab()
        }
        Else If OverlayObj {
            ParentControl := CurrentControl.SuperordinateControl
            CurrentChildNumber := This.Helpers.GetControlChildNumber(CurrentControl.ControlID, ParentControl)
            If CurrentControl Is StartSeparator {
                Position := 2
                NewItem := ParentControl.AddControlAt(Position, NewItem)
            }
            Else If CurrentControl Is EndSeparator And ParentControl = This.Overlay {
                Position := ParentControl.ChildControls.Length
                NewItem := ParentControl.AddControlAt(Position, NewItem)
            }
            Else If CurrentControl Is EndSeparator {
                ParentControl := CurrentControl.SuperordinateControl
                GrandparentControl := ParentControl.SuperordinateControl
                ParentChildNumber := This.Helpers.GetControlChildNumber(ParentControl.ControlID, GrandparentControl)
                If GrandparentControl Is TabControl {
                    GreatGrandparentControl := GrandparentControl.SuperordinateControl
                    GrandparentChildNumber := This.Helpers.GetControlChildNumber(GrandparentControl.ControlID, GreatGrandparentControl)
                    Position := GrandparentChildNumber +1
                    NewItem := GreatGrandparentControl.AddControlAt(Position, NewItem)
                }
                Else {
                    Position := ParentChildNumber +1
                    NewItem := GrandparentControl.AddControlAt(Position, NewItem)
                }
            }
            Else {
                Position := CurrentChildNumber + 1
                NewItem := ParentControl.AddControlAt(Position, NewItem)
            }
        }
        If OverlayObj {
            If NewItem Is AccessibilityOverlay {
                If FakeFocus
                This.Overlay.CurrentControlID := NewItem.ChildControls[1].ControlID
                Else
                This.Overlay.FocusControlByID(NewItem.ChildControls[1].ControlID)
            }
            Else {
                If FakeFocus
                This.Overlay.CurrentControlID := NewItem.ControlID
                Else
                This.Overlay.FocusControlByID(NewItem.ControlID)
            }
        }
        This.UpdateOverlayHKs()
        ItemEntry.OverlayObj := NewItem
        This.Items.Set(NewItem.ControlID, ItemEntry)
        This.UpdateFromObject(NewItem.ControlID, NewItem)
        Return ItemEntry
    }
    
    Static ClearClipboard() {
        This.Clipboard := {Json: False, Operation: False}
    }
    
    Static ClearUndo() {
        This.Undo := {Json: False, ControlNumber: 0}
    }
    
    Static ConvertToJson(OverlayObj, IDPrefix := "") {
        JsonData := Map()
        JsonData.Set("RootID", IDPrefix . OverlayObj.ControlID)
        JsonData.Set("Items", Map())
        For ItemID, ItemValue In This.Items {
            JsonData["Items"].Set(IDPrefix . ItemID, Map("VarName", ItemValue.VarName, "ObjType", Type(ItemValue.OverlayObj), "ObjParams", This.Helpers.ObjToMap(ItemValue.ObjParams), "ExpressionParams", This.Helpers.ObjToMap(ItemValue.ExpressionParams)))
        }
        JsonData := AddToData(JsonData, JsonData["RootID"], OverlayObj)
        Return JsonData
        AddToData(JsonData, ParentID, ObjToAdd) {
            If Not ObjToAdd Is Separator
            If Not ParentID = IDPrefix . ObjToAdd.ControlID {
                If Not JsonData["Items"][ParentID].Has("Children")
                JsonData["Items"][ParentID].Set("Children", Array())
                JsonData["Items"][ParentID]["Children"].Push(IDPrefix . ObjToAdd.ControlID)
            }
            If ObjToAdd Is AccessibilityOverlay
            PropName := "ChildControls"
            Else If ObjToAdd Is TabControl
            PropName := "Tabs"
            Else
            PropName := False
            If PropName
            For Child In ObjToAdd.%PropName% {
                If Child Is Separator
                Continue
                JsonData := AddToData(JsonData, IDPrefix . ObjToAdd.ControlID, Child)
            }
            If ObjToAdd Is TabControl {
                JsonData["Items"][IDPrefix . ObjToAdd.ControlID].Set("CurrentChild", ObjToAdd.CurrentTab)
            }
            Return JsonData
        }
    }
    
    Static CopyItem(*) {
        CurrentControl := This.Overlay.CurrentControl
        If Not CurrentControl {
            AccessibilityOverlay.Speak("No control selected")
            Return
        }
        ParentControl := CurrentControl.SuperordinateControl
        If This.Overlay.CurrentControl Is Separator {
            ItemToCopy := ParentControl
        }
        Else {
            ItemToCopy := CurrentControl
        }
        This.Clipboard := {Json: This.ConvertToJson(ItemToCopy, "ClipboardItem"), Operation: "Copy"}
        AccessibilityOverlay.Speak(Type(ItemToCopy) " copied to clipboard")
    }
    
    Static CreateContextMenu() {
        If Not This.Overlay.CurrentControl
        Return False
        CurrentControl := This.Overlay.CurrentControl
        ParentControl := CurrentControl.SuperordinateControl
        FileSubmenu := Menu()
        FileSubmenu.Add("New…`tCtrl+N", ObjBindMethod(This, "CreateProject"))
        FileSubmenu.Add("Open…`tCtrl+O", ObjBindMethod(This, "OpenProject"))
        FileSubmenu.Add("Save`tCtrl+S", ObjBindMethod(This, "SaveProject"))
        FileSubmenu.Add("Save as…`tCtrl+Alt+S", ObjBindMethod(This, "SaveProjectAs"))
        FileSubmenu.Add("Generate code for export…`tShift+Windows+E", ObjBindMethod(This, "GenerateCode"))
        FileSubmenu.Add("Quit…`tShift+Windows+Q", ObjBindMethod(This, "Quit"))
        EditSubmenu := Menu()
        EditSubmenu.Add("Undo`tCtrl+Z", ObjBindMethod(This, "PerformUndo"))
        EditSubmenu.Add("Cut`tCtrl+X", ObjBindMethod(This, "CutItem"))
        EditSubmenu.Add("Copy`tCtrl+C", ObjBindMethod(This, "CopyItem"))
        EditSubmenu.Add("Paste`tCtrl+V", ObjBindMethod(This, "PasteItem"))
        EditSubmenu.Add("Delete item`tDel", DeleteItemHandler)
        EditSubmenu.Add("Item properties…`tF2", EditItemHandler)
        EditSubmenu.Add("Delete markers…`tShift+Windows+Del", ObjBindMethod(This, "DeleteMarkers"))
        If Not This.Undo.Json {
            EditSubmenu.Disable("Undo`tCtrl+Z")
        }
        If Not This.Overlay.CurrentControl {
            EditSubmenu.Disable("Cut`tCtrl+X")
            EditSubmenu.Disable("Copy`tCtrl+C")
            EditSubmenu.Disable("Paste`tCtrl+V")
            EditSubmenu.Disable("Delete item`tDel")
            EditSubmenu.Disable("Item properties…`F2")
        }
        If This.Overlay.CurrentControl Is Separator
        If This.Overlay.CurrentControl.SuperordinateControl = This.Overlay {
            EditSubmenu.Disable("Cut`tCtrl+X")
            EditSubmenu.Disable("Delete item`tDel")
        }
        If Not This.Clipboard.Json {
            EditSubmenu.Disable("Paste`tCtrl+V")
        }
        AddSubmenu := Menu()
        If CurrentControl Is TabControl {
            For Value In This.TabControlAddList {
                If This.ItemDefinitions.Has(Value)
                AddSubmenu.Add(Value, AddItemHandler)
            }
        }
        Else {
            For Value In This.GenericAddList {
                If This.ItemDefinitions.Has(Value)
                AddSubmenu.Add(Value, AddItemHandler)
            }
        }
        ItemSubmenuLabel := ""
        If This.Overlay.CurrentControl Is Separator {
            ItemSubmenuLabel := "Current item <" . Type(ParentControl) . ">"
            CurrentItem := ParentControl
        }
        Else {
            ItemSubmenuLabel :=  "Current item <" . Type(CurrentControl) . ">"
            CurrentItem := CurrentControl
        }
        ItemSubmenu := False
        If This.ItemDefinitions[Type(CurrentItem)].HasProp("MenuActions")
        If This.ItemDefinitions[Type(CurrentItem)].MenuActions Is Array And This.ItemDefinitions[Type(CurrentItem)].MenuActions.Length > 0 {
            ItemSubmenu := Menu()
            For ActionMenuItem In This.ItemDefinitions[Type(CurrentItem)].MenuActions
            ItemSubmenu.Add(ActionMenuItem, ItemActionMenuHandler)
        }
        ToolsSubmenu := Menu()
        For ToolsMenuItem In This.ToolsMenuList
        ToolsSubmenu.Add(ToolsMenuItem.Name, ToolsMenuItem.Handler)
        HelpSubmenu := Menu()
        HelpSubmenu.Add("About…`tShift+Windows+F1", ObjBindMethod(This, "ShowAboutBox"))
        ContextMenu := Menu()
        ContextMenu.Add("File", FileSubmenu)
        ContextMenu.Add("Edit", EditSubmenu)
        ContextMenu.Add("Add", AddSubmenu)
        If ItemSubmenu Is Menu
        ContextMenu.Add(ItemSubmenuLabel, ItemSubmenu)
        ContextMenu.Add("Tools", ToolsSubmenu)
        ContextMenu.Add("Help", HelpSubmenu)
        Return ContextMenu
    }
    
    Static CreateItem(ItemType, OverlayObj := False, WithInitParamList := False) {
        If Not This.ItemCounts.Has(ItemType)
        This.ItemCounts.Set(ItemType, 0)
        This.ItemCounts[ItemType] := This.ItemCounts[ItemType] + 1
        ItemDefinition := This.ItemDefinitions[ItemType]
        DefaultParams := Array()
        If ItemDefinition.HasProp("DefaultValues")
        DefaultParams := ItemDefinition.DefaultValues
        InitialParamList := Array()
        ObjParamList := Array()
        ItemLabel := ItemType . " " . This.ItemCounts[ItemType]
        ParamNumber := 0
        If ItemDefinition.HasProp("RequiredParams")
        For Param In ItemDefinition.RequiredParams {
            ParamNumber++
            If DefaultParams.Has(ParamNumber) {
                InitialParamList.Push(DefaultParams[ParamNumber])
                ObjParamList.Push(DefaultParams[ParamNumber])
                If Param.Name = "Label" Or Param.Name = "Value" {
                    InitialParamList[InitialParamList.Length] := ItemLabel
                    ObjParamList[ObjParamList.Length] := ItemLabel
                }
            }
            Else {
                ObjParamList.Push("")
                If Param.Name = "Label" Or Param.Name = "Value" {
                    ObjParamList[ObjParamList.Length] := ItemLabel
                }
            }
        }
        If ItemDefinition.HasProp("OptionalParams")
        For Param In ItemDefinition.OptionalParams {
            ParamNumber++
            If DefaultParams.Has(ParamNumber) {
                InitialParamList.Push(DefaultParams[ParamNumber])
                ObjParamList.Push(DefaultParams[ParamNumber])
                If Param.Name = "Label" Or Param.Name = "Value" {
                    InitialParamList[InitialParamList.Length] := ItemLabel
                    ObjParamList[ObjParamList.Length] := ItemLabel
                }
            }
            Else {
                ObjParamList.Push("")
                If Param.Name = "Label" Or Param.Name = "Value" {
                    ObjParamList[ObjParamList.Length] := ItemLabel
                }
            }
        }
        ObjParams := Object()
        ExpressionParams := Object()
        ParamNumber := 0
        If ItemDefinition.HasProp("RequiredParams")
        For Param In ItemDefinition.RequiredParams {
            ParamNumber++
            ObjParams.%Param.Name% := ObjParamList[ParamNumber]
            If Param.Expression > 2
            ExpressionParams.%Param.Name% := 1
            Else
            ExpressionParams.%Param.Name% := 0
            ObjParams.%Param.Name% := This.ParamHandler.MakeEditorProp(ItemType, Param.Name, ObjParams.%Param.Name%, ExpressionParams.%Param.Name%, False)
        }
        If ItemDefinition.HasProp("OptionalParams")
        For Param In ItemDefinition.OptionalParams {
            ParamNumber++
            ObjParams.%Param.Name% := ObjParamList[ParamNumber]
            If Param.Expression > 2
            ExpressionParams.%Param.Name% := 1
            Else
            ExpressionParams.%Param.Name% := 0
            ObjParams.%Param.Name% := This.ParamHandler.MakeEditorProp(ItemType, Param.Name, ObjParams.%Param.Name%, ExpressionParams.%Param.Name%, True)
        }
        ItemEntry := {VarName: ItemType . This.ItemCounts[ItemType], ObjParams: ObjParams, ExpressionParams: ExpressionParams, OverlayObj: OverlayObj}
        If WithInitParamList
        ItemEntry.InitialParamlist := InitialParamList
        Return ItemEntry
    }
    
    Static CreateProject(*) {
        This.ShowNewProjectBox()
    }
    
    Static CreateUndo() {
        If Not This.Overlay
        Return {Json: False, ControlNumber: 0}
        This.Undo.ControlNumber := This.Overlay.GetCurrentControlNumber()
        This.Undo.Json := This.ConvertToJson(This.Overlay)
        Return This.Undo
    }
    
    Static CutItem(*) {
        CurrentControl := This.Overlay.CurrentControl
        If Not CurrentControl {
            AccessibilityOverlay.Speak("No control selected")
            Return
        }
        ParentControl := CurrentControl.SuperordinateControl
        If This.Overlay.CurrentControl Is Separator {
            ItemToCut := ParentControl
        }
        Else {
            ItemToCut := CurrentControl
        }
        If ItemToCut = This.Overlay {
            AccessibilityOverlay.Speak("Can't cut this item")
            Return
        }
        This.Clipboard := {Json: This.ConvertToJson(ItemToCut, "ClipboardItem"), Operation: "Cut"}
        This.DeleteItem(ItemtoCut.ControlID, true, false)
        AccessibilityOverlay.Speak(Type(ItemToCut) " cut")
    }
    
    Static DeleteItem(ItemID, FocusNext := True, Speak := True) {
        TargetControl := False
        For OverlayControl In This.Overlay.AllControls
        If OverlayControl.ControlID = ItemID {
            TargetControl := OverlayControl
            Break
        }
        If Not TargetControl
        Return
        TargetControlType := Type(TargetControl)
        ParentControl := TargetControl.SuperordinateControl
        ParentControlType := Type(ParentControl)
        If TargetControl Is Separator And ParentControl = This.Overlay {
            If Speak
            AccessibilityOverlay.Speak("This item can't be deleted")
        }
        Else If TargetControl Is Separator {
            This.CreateUndo()
            TargetControlNumber := This.Overlay.GetCurrentControlNumber()
            GrandparentControl := ParentControl.SuperordinateControl
            ParentControlID := ParentControl.ControlID
            If GrandparentControl Is TabControl
            ParentChildNumber := GrandparentControl.CurrentTab
            Else
            ParentChildNumber := This.Helpers.GetControlChildNumber(ParentControlID, GrandparentControl)
            SiblingControlIDs := Array()
            SiblingControls := ParentControl.AllControls
            For SiblingControl In SiblingControls
            SiblingControlIDs.Push(SiblingControl.ControlID)
            If GrandparentControl Is TabControl
            GrandparentControl.RemoveTabAt(ParentChildNumber)
            Else
            GrandparentControl.RemoveControlAt(ParentChildNumber)
            This.Items.Delete(ParentControlID)
            For SiblingControlID In SiblingControlIDs
            If This.Items.Has(SiblingControlID)
            This.Items.Delete(SiblingControlID)
            This.Overlay.CurrentControlID := 0
            FocusNextControl(TargetControlNumber)
            If Speak
            AccessibilityOverlay.Speak(ParentControlType . " deleted")
        }
        Else If Not This.Items.Has(ItemID) {
            Return
        }
        Else {
            This.CreateUndo()
            TargetControlNumber := This.Overlay.GetCurrentControlNumber()
            TargetChildNumber := This.Helpers.GetControlChildNumber(TargetControl.ControlID, ParentControl)
            TargetControlID := TargetControl.ControlID
            If ParentControl Is TabControl
            ParentControl.RemoveTabAt(TargetChildNumber)
            Else
            ParentControl.RemoveControlAt(TargetChildNumber)
            This.Items.Delete(TargetControlID)
            This.Overlay.CurrentControlID := 0
            FocusNextControl(TargetControlNumber)
            If Speak
            AccessibilityOverlay.Speak(TargetControlType . " deleted")
        }
        FocusNextControl(TargetControlNumber) {
            If Not FocusNext
            Return
            NumberOfFocusableControls := This.Overlay.GetFocusableControls().Length
            If NumberOfFocusableControls >= TargetControlNumber
            This.Overlay.FocusControlByNumber(TargetControlNumber)
            Else
            This.Overlay.FocusControlByNumber(NumberOfFocusableControls)
        }
        This.UpdateOverlayHKs()
    }
    
    Static EditItem(ItemID) {
        Static ParamBox := False
        If ParamBox = False {
            If Not This.Items.Has(ItemID)
            Return
            Item := This.Items[ItemID]
            ItemType := Type(Item.OverlayObj)
            ItemDefinition := This.ItemDefinitions[ItemType]
            EditorBoxes := Map()
            ExpressionBoxes := Map()
            OptionalBoxes := Map()
            ParamBox := GUI("+OwnDialogs", ItemType . " Properties")
            ControlIndex := 0
            For Param In This.GeneralParams {
                ControlIndex++
                If Not Item.HasProp(Param.Param)
                Item.%Param.Param% := ""
                Label := This.ParamHandler.GetFriendlyName(Param.Label) . ":"
                If ControlIndex = 1
                ParamBox.AddText(, Label)
                Else
                ParamBox.AddText("Section XS", Label)
                EditorBoxes[Param.Param] := ParamBox.AddEdit("YS", Item.%Param.Param%)
                Checked := ""
                If Param.Expression > 2
                Checked := "Checked"
                ExpressionBoxes[Param.Param] := ParamBox.AddCheckBox("YS " . Checked, "Treat as expression")
                If Param.Expression = 2 Or Param.Expression = 4
                ExpressionBoxes[Param.Param].Opt("+Disabled")
                OptionalBoxes[Param.Param] := False
                If Item.OverlayObj Is Marker
                EditorBoxes[Param.Param].Opt("+Disabled")
            }
            If ItemDefinition.HasProp("RequiredParams")
            For Param In ItemDefinition.RequiredParams {
                ControlIndex++
                If Not Item.ObjParams.HasProp(Param.Name)
                Item.ObjParams.%Param.Name% := ""
                If Not Item.ExpressionParams.HasProp(Param.Name) {
                    If Param.Expression > 2
                    BoxExpression := 1
                    Else
                    BoxExpression := 0
                    Item.ExpressionParams.%Param.Name% := BoxExpression
                }
                Label := This.ParamHandler.GetFriendlyName(Param.Name) . ":"
                If ControlIndex = 1
                ParamBox.AddText(, Label)
                Else
                ParamBox.AddText("Section XS", Label)
                If Param.HasProp("IsHotkey") And Param.IsHotkey
                EditorBoxes[Param.Name] := ParamBox.AddHotkey("YS", Item.ObjParams.%Param.Name%)
                Else
                EditorBoxes[Param.Name] := ParamBox.AddEdit("YS", Item.ObjParams.%Param.Name%)
                Checked := ""
                If Item.ExpressionParams.%Param.Name% {
                    Checked := "Checked"
                    ExpressionBoxes[Param.Name] := ParamBox.AddCheckBox("YS " . Checked, "Treat as expression")
                }
                Else {
                    ExpressionBoxes[Param.Name] := ParamBox.AddCheckBox("YS " . Checked, "Treat as expression")
                }
                If Param.Expression = 2 Or Param.Expression = 4 {
                    ExpressionBoxes[Param.Name].Opt("+Disabled")
                }
                OptionalBoxes[Param.Name] := False
            }
            If ItemDefinition.HasProp("OptionalParams")
            For Param In ItemDefinition.OptionalParams {
                ControlIndex++
                If Not Item.ObjParams.HasProp(Param.Name)
                Item.ObjParams.%Param.Name% := ""
                If Not Item.ExpressionParams.HasProp(Param.Name) {
                    If Param.Expression > 2
                    BoxExpression := 1
                    Else
                    BoxExpression := 0
                    Item.ExpressionParams.%Param.Name% := BoxExpression
                }
                Label := This.ParamHandler.GetFriendlyName(Param.Name) . " (optional):"
                If ControlIndex = 1
                ParamBox.AddText(, Label)
                Else
                ParamBox.AddText("Section XS", Label)
                If Param.HasProp("IsHotkey") And Param.IsHotkey
                EditorBoxes[Param.Name] := ParamBox.AddHotkey("YS", Item.ObjParams.%Param.Name%)
                Else
                EditorBoxes[Param.Name] := ParamBox.AddEdit("YS", Item.ObjParams.%Param.Name%)
                Checked := ""
                If Item.ExpressionParams.%Param.Name% {
                    Checked := "Checked"
                    ExpressionBoxes[Param.Name] := ParamBox.AddCheckBox("YS " . Checked, "Treat as expression")
                }
                Else {
                    ExpressionBoxes[Param.Name] := ParamBox.AddCheckBox("YS" . Checked, "Treat as expression")
                }
                If Param.Expression = 2 Or Param.Expression = 4 {
                    ExpressionBoxes[Param.Name].Opt("+Disabled")
                }
                OptionalBoxes[Param.Name] := True
            }
            ParamBox.AddButton("Section XS Default", "OK").OnEvent("Click", Save)
            ParamBox.AddButton("YS", "Cancel").OnEvent("Click", Close)
            ParamBox.OnEvent("Close", Close)
            ParamBox.OnEvent("Escape", Close)
            ParamBox.Show()
        }
        Else {
            ParamBox.Show()
        }
        Close(*) {
            ParamBox.Destroy()
            ParamBox := False
        }
        Save(*) {
            ParamBox.Opt("+OwnDialogs")
            For Key, Value In EditorBoxes {
                Result := This.ParamHandler.Validate%Key%(Item.OverlayObj, Key, EditorBoxes[Key].Value, ExpressionBoxes[Key].Value, OptionalBoxes[Key])
                If Result Is This.ParamHandler.Error {
                    ParamBox.Opt("+Disabled")
                    MsgBox Result.Message, "Error"
                    ParamBox.Opt("-Disabled")
                    EditorBoxes[Key].Focus()
                    Return
                }
            }
            This.CreateUndo()
            For Key, Value In EditorBoxes {
                If Item.HasProp(Key) {
                    Item.%Key% := EditorBoxes[Key].Value
                }
                Else If Item.ObjParams.HasProp(Key) {
                    Item.ObjParams.%Key% := EditorBoxes[Key].Value
                    Item.ExpressionParams.%Key% := ExpressionBoxes[Key].Value
                    If Item.OverlayObj.HasProp("Original" . Key)
                    Item.OverlayObj.DeleteProp("Original" . Key)
                    Try
                    Item.OverlayObj.%Key% := This.ParamHandler.MakeObjProp(Item.OverlayObj, Key, EditorBoxes[Key].Value, ExpressionBoxes[Key].Value, OptionalBoxes[Key])
                    Catch
                    Item.OverlayObj.%Key% := Item.OverlayObj.%Key%
                }
            }
            Close()
            This.UpdateOverlayHKs()
        }
    }
    
    Static GenerateCode(*) {
        GeneratedCode := This.CodeGenerator.GenerateOverlay(This.Overlay)
        This.ShowDlgBox("Code For Export", GeneratedCode)
    }
    
    Static InitializeOverlay(OverlayType := "AccessibilityOverlay") {
        This.Items := Map()
        This.ItemCounts := Map()
        AccessibilityOverlay.AllControls := Array()
        AccessibilityOverlay.TotalNumberOfControls := 0
        This.Overlay := False
        This.Overlay := This.Additem(OverlayType, False).OverlayObj
        This.Overlay.CurrentControlID := This.Overlay.GetFocusableControlIDs()[1]
        This.UpdateOverlayHKs()
    }
    
    Static LoadFromJson(OverlayObj, JsonData, StartingID := False) {
        If Not StartingID
        StartingID := JsonData["RootID"]
        If StartingID = JsonData["RootID"] {
            ObjType := JsonData["Items"][StartingID]["ObjType"]
            If This.ItemDefinitions.Has(ObjType) {
                VarName := JsonData["Items"][StartingID]["VarName"]
                ObjParams := This.Helpers.MapToObj(JsonData["Items"][StartingID]["ObjParams"])
                ExpressionParams := This.Helpers.MapToObj(JsonData["Items"][StartingID]["ExpressionParams"])
                ConstructorParams := GetConstructorParams(StartingID, ObjType, ObjParams, ExpressionParams)
                OverlayObj := %ObjType%(ConstructorParams*)
                If Not This.ItemCounts.Has(ObjType)
                This.ItemCounts.Set(ObjType, 0)
                This.ItemCounts[ObjType] := This.ItemCounts[ObjType] + 1
                This.Items.Set(OverlayObj.ControlID, {VarName: VarName, ObjType: ObjType, ObjParams: ObjParams, ExpressionParams: ExpressionParams, OverlayObj: OverlayObj})
            }
        }
        If OverlayObj Is AccessibilityOverlay
        OverlayObj.AddStartSeparator()
        StartingItem := JsonData["Items"][StartingID]
        If StartingItem.Has("Children")
        For ChildID In StartingItem["Children"] {
            ChildObj := JsonData["Items"][ChildID]
            ChildObjType := ChildObj["ObjType"]
            If This.ItemDefinitions.Has(ChildObjType) {
                VarName := ChildObj["VarName"]
                ObjParams := This.Helpers.MapToObj(ChildObj["ObjParams"])
                ExpressionParams := This.Helpers.MapToObj(ChildObj["ExpressionParams"])
                ChildConstructorParams := GetConstructorParams(ChildID, ChildObjType, ObjParams, ExpressionParams)
                ChildObj := %ChildObjType%(ChildConstructorParams*)
                ChildObj := This.LoadFromJson(ChildObj, JsonData, ChildID)
                If OverlayObj Is AccessibilityOverlay {
                    ChildObj := OverlayObj.AddControl(ChildObj)
                }
                Else If OverlayObj Is TabControl {
                    OverlayObj.AddTabs(ChildObj)
                    ChildObj := OverlayObj.Tabs[OverlayObj.Tabs.Length]
                }
                If Not This.ItemCounts.Has(ChildObjType)
                This.ItemCounts.Set(ChildObjType, 0)
                This.ItemCounts[ChildObjType] := This.ItemCounts[ChildObjType] + 1
                This.Items.Set(ChildObj.ControlID, {VarName: VarName, ObjType: ChildObjType, ObjParams: ObjParams, ExpressionParams: ExpressionParams, OverlayObj: ChildObj})
            }
        }
        If OverlayObj Is AccessibilityOverlay
        OverlayObj.AddEndSeparator()
        Return OverlayObj
        GetConstructorParams(ItemID, ObjType, ObjParams, ExpressionParams) {
            ConstructorParams := Array()
            If This.ItemDefinitions[ObjType].HasProp("RequiredParams")
            For Param In This.ItemDefinitions[ObjType].RequiredParams {
                If Not ObjParams.HasProp(Param.Name)
                ObjParams.DefineProp(Param.Name, {Value: ""})
                ConstructorParams.Push(This.ParamHandler.MakeObjProp(ObjParams, Param.Name, ObjParams.%Param.Name%, ExpressionParams.%Param.Name%, False))
            }
            If This.ItemDefinitions[ObjType].HasProp("OptionalParams")
            For Param In This.ItemDefinitions[ObjType].OptionalParams {
                If Not ObjParams.HasProp(Param.Name)
                ObjParams.DefineProp(Param.Name, {Value: ""})
                ConstructorParams.Push(This.ParamHandler.MakeObjProp(ObjParams, Param.Name, ObjParams.%Param.Name%, ExpressionParams.%Param.Name%, True))
            }
            Return ConstructorParams
        }
    }
    
    Static OpenProject(*) {
        This.ToggleHKs("Off")
        NewProjectFile := FileSelect("3", "", "Open…", "OverlayDesigner Projects (*.RHK-Overlay)")
        If Not NewProjectFile
        Return
        This.PerformOpen(NewProjectFile)
    }
    
    Static PasteItem(*) {
        CurrentControl := This.Overlay.CurrentControl
        If Not This.Clipboard.Json {
            AccessibilityOverlay.Speak("Nothing to paste")
            Return
        }
        If Not CurrentControl {
            AccessibilityOverlay.Speak("Nowhere to paste")
            Return
        }
        ParentControl := CurrentControl.SuperordinateControl
        SourceType := This.Clipboard.Json["Items"][This.Clipboard.Json["RootID"]]["ObjType"]
        SourceTypeFound := False
        If This.Overlay.CurrentControl Is Separator
        TargetControl := ParentControl
        Else
        TargetControl := CurrentControl
        If TargetControl Is TabControl {
            For ControlType In This.TabControlAddList
            If ControlType = SourceType {
                SourceTypeFound := True
                Break
            }
        }
        Else {
            For ControlType In This.GenericAddList
            If ControlType = SourceType {
                SourceTypeFound := True
                Break
            }
        }
        If Not SourceTypeFound {
            AccessibilityOverlay.Speak(SourceType . "s can't be pasted here")
            Return
        }
        If This.Clipboard.Operation = "Copy" Or This.Clipboard.Operation = "Cut" {
            This.Overlay := This.AddFromJson(This.Overlay, This.Clipboard.Json, This.Clipboard.Json["RootID"], "ClipboardItem")
        }
        Else {
            AccessibilityOverlay.Speak("Unsupported clipboard operation")
            Return
        }
        If This.Clipboard.Operation = "Cut"
        This.ClearClipboard()
        AccessibilityOverlay.Speak(SourceType . " pasted")
        This.UpdateOverlayHKs()
    }
    
    Static PerformOpen(NewProjectFile) {
        If Not FileExist(NewProjectFile) Or InStr(FileExist(NewProjectFile), "D") {
            MsgBox "An error occurred while opening " . NewProjectFile . ".`nPlease try again.", This.AppName
            Return
        }
        JsonData := FileRead(NewProjectFile, "UTF-8")
        JsonData := jxon_load(&JsonData)
        If Not JsonData Is Map {
            ReportError()
            Return
        }
        If Not JsonData.Has("RootID") {
            ReportError()
            Return
        }
        If Not JsonData.Has("Items") {
            ReportError()
            Return
        }
        RootID := 0
        For Key, Value In JsonData["Items"]
        If Key = JsonData["RootID"] {
            RootID := Key
            ObjType := Value["ObjType"]
            Break
        }
        If Not RootID Or Not ObjType {
            ReportError()
            Return
        }
        If This.ProjectFile {
            This.ToggleHKs("Off")
            ConfirmationDialog := MsgBox("Save changes to " . This.ProjectFile . "?", This.AppName, 4)
            If ConfirmationDialog == "Yes"
            This.PerformSave(This.ProjectFile, True)
            This.ToggleHKs("On")
        }
        This.InitializeOverlay()
        This.Items := Map()
        This.ItemCounts := Map()
        This.Overlay := False
        This.Overlay := This.LoadFromJson(This.Overlay, JsonData)
        This.Overlay.Reset()
        This.Overlay.CurrentControlID := This.Overlay.GetFocusableControlIDs()[1]
        This.ClearClipboard()
        This.ClearUndo()
        MsgBox "File opened successfully.", This.AppName
        This.UpdateOverlayHKs()
        This.ProjectFile := NewProjectFile
        SplitPath This.ProjectFile,, &ProjectDir
        A_WorkingDir := ProjectDir
        ReportError() {
            MsgBox "Failed to open " . This.ProjectFile . ".", This.AppName
        }
    }
    
    Static PerformSave(NewProjectFile, SilenceOnSuccess := False) {
        NewProjectFileObj := FileOpen(NewProjectFile, "w", "UTF-8")
        NewProjectFileObj.Write(Jxon_dump(This.ConvertToJson(This.Overlay)))
        This.ProjectFile := NewProjectFile
        If Not FileExist(NewProjectFile) Or InStr(FileExist(NewProjectFile), "D") {
            MsgBox "An error occurred while saving file.`nPlease try again.", This.AppName
        }
        Else {
            SplitPath This.ProjectFile,, &ProjectDir
            A_WorkingDir := ProjectDir
            If Not SilenceOnSuccess
            MsgBox "File saved successfully.", This.AppName
        }
    }
    
    Static PerformUndo(*) {
        If Not This.Undo.Json
        Return
        PreviousControlNumber := This.Undo.ControlNumber
        PreviousJson := This.Undo.Json.Clone()
        This.CreateUndo()
        ObjType := Type(This.Overlay)
        This.InitializeOverlay(ObjType)
        This.Overlay := This.AddFromJson(This.Overlay, PreviousJson, PreviousJson["RootID"])
        This.Overlay.FocusControlByNumber(PreviousControlNumber)
        This.UpdateOverlayHKs()
    }
    
    Static Quit(*) {
        This.ToggleHKs("Off")
        ConfirmationDialog := MsgBox("Are you sure you want to quit the app?", "Quit " . This.AppName, 4)
        If ConfirmationDialog == "Yes"
        ExitApp
    }
    
    Static SaveProject(*) {
        If This.ProjectFile = "" Or Not FileExist(This.ProjectFile) Or InStr(FileExist(This.ProjectFile), "D")
        This.SaveProjectAs()
        Else
        This.PerformSave(This.ProjectFile)
    }
    
    Static SaveProjectAs(*) {
        This.ToggleHKs("Off")
        NewProjectFile := FileSelect("S18", This.ProjectFile, "Save as…", "OverlayDesigner Projects (*.RHK-Overlay)")
        If Not NewProjectFile
        Return
        SplitPath NewProjectFile, &FileName, &Directory, &Extension
        If Extension = "" {
            FileName := FileName . ".RHK-Overlay"
            NewProjectFile .= ".RHK-Overlay"
        }
        This.PerformSave(NewProjectFile)
    }
    
    Static SetItemParam(ItemID, ParamCategory, Name, Value) {
        If Not This.Items.Has(ItemID)
        Return
        EditorItem := This.Items[ItemID]
        If Not ParamCategory = "ExpressionParams" And Not ParamCategory = "ObjParams"
        ParamCategory := "General"
        If ParamCategory = "General" {
            If EditorItem.HasProp(Name)
            EditorItem.%Name% := Value
        }
        Else If ParamCategory = "ObjParams" {
            If EditorItem.HasProp(ParamCategory) {
                If EditorItem.%ParamCategory%.HasProp(Name)
                EditorItem.%ParamCategory%.%Name% := Value
            }
            If EditorItem.HasProp("OverlayObj") And EditorItem.OverlayObj Is Object {
                If EditorItem.OverlayObj.HasProp(Name)
                EditorItem.OverlayObj.%Name% := Value
            }
        }
        Else {
            If EditorItem.HasProp(ParamCategory) {
                If EditorItem.%ParamCategory%.HasProp(Name)
                EditorItem.%ParamCategory%.%Name% := Value
            }
        }
    }
    
    Static ShowAboutBox(*) {
        #Include ../Includes/About.Text.ahk
        This.ShowDlgBox("About OverlayDesigner", AboutText, True)
    }
    
    Static ShowDlgBox(BoxTitle, BoxValue := "", ReadOnly := False, OKButtonAction := False) {
        Static DlgBox := False
        If DlgBox = False {
            DlgBox := Gui(, BoxTitle)
            If ReadOnly
            DlgBox.AddEdit("ReadOnly vEditField +Multi", BoxValue)
            Else
            DlgBox.AddEdit("vEditField +Multi", BoxValue)
            OKButton := DlgBox.AddButton("Default Section", "OK")
            If OKButtonAction
            OKButton.OnEvent("Click", OKButtonAction)
            Else
            OKButton.OnEvent("Click", CloseDlgBox)
            DlgBox.OnEvent("Close", CloseDlgBox)
            DlgBox.OnEvent("Escape", CloseDlgBox)
            DlgBox.Show()
        }
        Else {
            DlgBox.Show()
        }
        Return DlgBox
        CloseDlgBox(*) {
            DlgBox.Destroy()
            DlgBox := False
        }
    }
    
    Static ShowNewProjectBox() {
        Static NewProjectBox := False
        If NewProjectBox = False {
            NewProjectBox := GUI("+OwnDialogs", "Create New Project")
            NewProjectBox.AddText(, "Create:")
            NewProjectBox.AddDropDownList("YS Choose1 vOverlayType", ["AccessibilityOverlay", "PluginOverlay", "StandaloneOverlay"])
            NewProjectBox.AddButton("Section XS Default", "OK").OnEvent("Click", Create)
            NewProjectBox.AddButton("YS", "Cancel").OnEvent("Click", Close)
            NewProjectBox.OnEvent("Close", Close)
            NewProjectBox.OnEvent("Escape", Close)
            NewProjectBox.Show()
        }
        Else {
            NewProjectBox.Show()
        }
        Close(*) {
            NewProjectBox.Destroy()
            NewProjectBox := False
        }
        Create(*) {
            If This.ProjectFile {
                This.ToggleHKs("Off")
                ConfirmationDialog := MsgBox("Save changes to " . This.ProjectFile . "?", This.AppName, 4)
                If ConfirmationDialog == "Yes"
                This.PerformSave(This.ProjectFile, True)
                This.ToggleHKs("On")
            }
            This.ProjectFile := ""
            A_WorkingDir := A_ScriptDir
            This.InitializeOverlay(NewProjectBox["OverlayType"].Text)
            This.ClearClipboard()
            This.ClearUndo()
            Close()
        }
    }
    
    Static ToggleHKs(State) {
        For HK In This.GeneralHKList
        Hotkey HK, State
        For HK In This.OverlayHKList
        Hotkey HK, State
    }
    
    Static TogglePause(*) {
        A_TrayMenu.ToggleCheck("&Pause")
        Suspend -1
        If A_IsSuspended = 1 {
            SetTimer This.CheckWindow, 0
            This.ToggleHKs("Off")
        }
        Else {
            SetTimer This.CheckWindow, 200
        }
    }
    
    Static UpdateFromJson(ItemToUpdate, JsonItem) {
        UpdatedItem := ItemToUpdate
        For Key, Value In JsonItem {
            If Value Is Map
            UpdatedItem.%Key% := This.Helpers.MapToObj(Value)
            Else
            UpdatedItem.%Key% := Value
        }
        For Key, Value In UpdatedItem.ObjParams.OwnProps() {
            UpdatedItem.OverlayObj.%Key% := This.ParamHandler.MakeObjProp(UpdatedItem.OverlayObj, Key, Value, UpdatedItem.ExpressionParams.%Key%)
        }
        Return UpdatedItem
    }
    
    Static UpdateFromObject(ItemID, OverlayObj) {
        If Not This.Items.Has(ItemID)
        Return
        EditorItem := This.Items[ItemID]
        ObjParams := EditorItem.ObjParams
        ExpressionParams := EditorItem.ExpressionParams
        ItemDefinition := This.ItemDefinitions[Type(OverlayObj)]
        If ItemDefinition.HasProp("RequiredParams")
        RequiredParams := ItemDefinition.RequiredParams
        Else
        RequiredParams := False
        If ItemDefinition.HasProp("OptionalParams")
        OptionalParams := ItemDefinition.OptionalParams
        Else
        OptionalParams := False
        If RequiredParams
        For Param In RequiredParams {
            ObjParams.%Param.Name% := This.ParamHandler.MakeEditorProp(Type(OverlayObj), Param.Name, OverlayObj.%Param.Name%, ExpressionParams.%Param.Name%, False)
        }
        If OptionalParams
        For Param In OptionalParams {
            ObjParams.%Param.Name% := This.ParamHandler.MakeEditorProp(Type(OverlayObj), Param.Name, OverlayObj.%Param.Name%, ExpressionParams.%Param.Name%, True)
        }
        EditorItem.OverlayObj := OverlayObj
    }
    
    Static UpdateOverlayHKs() {
        For HKItem In This.OverlayHKList {
            Hotkey HKItem, "Off"
        }
        This.OverlayHKList := Array()
        If This.Overlay
        For HKItem In This.Overlay.Hotkeys {
            This.OverlayHKList.Push(HKItem)
            Hotkey HKItem, TriggerOverlayHotkey
        }
    }
    
    Class CheckWindow {
        Static Call() {
            Try
            CurrentTitle := WinGetTitle("A")
            Catch
            CurrentTitle := False
            If WinExist("ahk_class #32768") {
                Editor.Active := False
                Editor.ToggleHKs("Off")
            }
            Else If CurrentTitle And CurrentTitle == Editor.ActiveInWindow {
                Editor.Active := True
                Editor.ToggleHKs("On")
            }
            Else {
                Editor.Active := False
                Editor.ToggleHKs("Off")
            }
            Return Editor.Active
        }
    }
    
    #Include CodeGenerator.ahk
    #Include CodeParser.ahk
    #Include Helpers.ahk
    #Include ParamHandler.ahk
    #Include Plugin.ahk
    
}
