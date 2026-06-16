#Requires AutoHotkey v2.0

Class OverlayLoader {
    
    Static Active := False
    Static Context := False
    Static DefaultOverlay := False
    Static ItemDefinitions := Map(
    "AccessibilityOverlay", {OptionalParams: ["Label"]},
    "Button", {RequiredParams: ["Label"], OptionalParams: ["PreExecFocusFunctions", "PostExecFocusFunctions", "PreExecActivationFunctions", "PostExecActivationFunctions", "HotkeyCommand", "HotkeyLabel", "HotkeyFunctions"]},
    "Checkbox", {RequiredParams: ["Label"], OptionalParams: ["PreExecFocusFunctions", "PostExecFocusFunctions", "PreExecActivationFunctions", "PostExecActivationFunctions", "HotkeyCommand", "HotkeyLabel", "HotkeyFunctions"]},
    "CustomButton", {RequiredParams: ["Label"], OptionalParams: ["PreExecFocusFunctions", "PostExecFocusFunctions", "PreExecActivationFunctions", "PostExecActivationFunctions", "HotkeyCommand", "HotkeyLabel", "HotkeyFunctions"]},
    "CustomCheckbox", {RequiredParams: ["Label"], OptionalParams: ["CheckStateFunction", "PreExecFocusFunctions", "PostExecFocusFunctions", "PreExecActivationFunctions", "PostExecActivationFunctions", "HotkeyCommand", "HotkeyLabel", "HotkeyFunctions"]},
    "CustomEdit", {RequiredParams: ["Label"], OptionalParams: ["PreExecFocusFunctions", "PostExecFocusFunctions", "HotkeyCommand", "HotkeyLabel", "HotkeyFunctions"]},
    "CustomListBox", {RequiredParams: ["Label"], OptionalParams: ["Options", "ChangeFunctions", "PreExecFocusFunctions", "PostExecFocusFunctions", "HotkeyCommand", "HotkeyLabel", "HotkeyFunctions"]},
    "CustomTab", {RequiredParams: ["Label"], OptionalParams: ["PreExecFocusFunctions", "PostExecFocusFunctions", "HotkeyCommand", "HotkeyLabel", "HotkeyFunctions"]},
    "CustomToggleButton", {RequiredParams: ["Label"], OptionalParams: ["CheckStateFunction", "PreExecFocusFunctions", "PostExecFocusFunctions", "PreExecActivationFunctions", "PostExecActivationFunctions", "HotkeyCommand", "HotkeyLabel", "HotkeyFunctions"]},
    "Edit", {RequiredParams: ["Label"], OptionalParams: ["PreExecFocusFunctions", "PostExecFocusFunctions", "HotkeyCommand", "HotkeyLabel", "HotkeyFunctions"]},
    "GraphicalButton", {RequiredParams: ["Label", "X1Coordinate", "Y1Coordinate", "X2Coordinate", "Y2Coordinate", "Images"], OptionalParams: ["PreExecFocusFunctions", "PostExecFocusFunctions", "PreExecActivationFunctions", "PostExecActivationFunctions", "HotkeyCommand", "HotkeyLabel", "HotkeyFunctions"]},
    "GraphicalCheckbox", {RequiredParams: ["Label", "X1Coordinate", "Y1Coordinate", "X2Coordinate", "Y2Coordinate", "CheckedImages", "UncheckedImages"], OptionalParams: ["PreExecFocusFunctions", "PostExecFocusFunctions", "PreExecActivationFunctions", "PostExecActivationFunctions", "HotkeyCommand", "HotkeyLabel", "HotkeyFunctions"]},
    "GraphicalTab", {RequiredParams: ["Label", "X1Coordinate", "Y1Coordinate", "X2Coordinate", "Y2Coordinate", "Images"], OptionalParams: ["PreExecFocusFunctions", "PostExecFocusFunctions", "HotkeyCommand", "HotkeyLabel", "HotkeyFunctions"]},
    "GraphicalToggleButton", {RequiredParams: ["Label", "X1Coordinate", "Y1Coordinate", "X2Coordinate", "Y2Coordinate", "OnImages"], OptionalParams: ["OffImages", "PreExecFocusFunctions", "PostExecFocusFunctions", "PreExecActivationFunctions", "PostExecActivationFunctions", "HotkeyCommand", "HotkeyLabel", "HotkeyFunctions"]},
    "HotspotButton", {RequiredParams: ["Label", "XCoordinate", "YCoordinate"], OptionalParams: ["PreExecFocusFunctions", "PostExecFocusFunctions", "PreExecActivationFunctions", "PostExecActivationFunctions", "HotkeyCommand", "HotkeyLabel", "HotkeyFunctions"]},
    "HotspotCheckbox", {RequiredParams: ["Label", "XCoordinate", "YCoordinate", "CheckedColors", "UncheckedColors"], OptionalParams: ["PreExecFocusFunctions", "PostExecFocusFunctions", "PreExecActivationFunctions", "PostExecActivationFunctions", "HotkeyCommand", "HotkeyLabel", "HotkeyFunctions"]},
    "HotspotEdit", {RequiredParams: ["Label", "XCoordinate", "YCoordinate"], OptionalParams: ["PreExecFocusFunctions", "PostExecFocusFunctions", "HotkeyCommand", "HotkeyLabel", "HotkeyFunctions"]},
    "HotspotListBox", {RequiredParams: ["Label", "XCoordinate", "YCoordinate"], OptionalParams: ["Options", "ChangeFunctions", "PreExecFocusFunctions", "PostExecFocusFunctions", "HotkeyCommand", "HotkeyLabel", "HotkeyFunctions"]},
    "HotspotToggleButton", {RequiredParams: ["Label", "XCoordinate", "YCoordinate", "OnColors", "OffColors"], OptionalParams: ["PreExecFocusFunctions", "PostExecFocusFunctions", "PreExecActivationFunctions", "PostExecActivationFunctions", "HotkeyCommand", "HotkeyLabel", "HotkeyFunctions"]},
    "HotspotTab", {RequiredParams: ["Label", "XCoordinate", "YCoordinate"], OptionalParams: ["PreExecFocusFunctions", "PostExecFocusFunctions", "HotkeyCommand", "HotkeyLabel", "HotkeyFunctions"]},
    "ListBox", {RequiredParams: ["Label"], OptionalParams: ["Options", "ChangeFunctions", "PreExecFocusFunctions", "PostExecFocusFunctions", "HotkeyCommand", "HotkeyLabel", "HotkeyFunctions"]},
    "OCRButton", {RequiredParams: ["LabelPrefix", "DefaultLabel", "OCRType", "X1Coordinate", "Y1Coordinate", "X2Coordinate", "Y2Coordinate"], OptionalParams: ["OCRLanguage", "OCRScale", "PreExecFocusFunctions", "PostExecFocusFunctions", "PreExecActivationFunctions", "PostExecActivationFunctions", "HotkeyCommand", "HotkeyLabel", "HotkeyFunctions"]},
    "OCREdit", {RequiredParams: ["Label", "OCRType", "X1Coordinate", "Y1Coordinate", "X2Coordinate", "Y2Coordinate"], OptionalParams: ["OCRLanguage", "OCRScale", "PreExecFocusFunctions", "PostExecFocusFunctions", "HotkeyCommand", "HotkeyLabel", "HotkeyFunctions"]},
    "OCRListBox", {RequiredParams: ["Label", "DefaultValue", "OCRType", "X1Coordinate", "Y1Coordinate", "X2Coordinate", "Y2Coordinate"], OptionalParams: ["OCRLanguage", "OCRScale", "ChangeFunctions", "PreExecFocusFunctions", "PostExecFocusFunctions", "HotkeyCommand", "HotkeyLabel", "HotkeyFunctions"]},
    "OCRTab", {RequiredParams: ["DefaultLabel", "OCRType", "X1Coordinate", "Y1Coordinate", "X2Coordinate", "Y2Coordinate"], OptionalParams: ["OCRLanguage", "OCRScale", "PreExecFocusFunctions", "PostExecFocusFunctions", "HotkeyCommand", "HotkeyLabel", "HotkeyFunctions"]},
    "OCRText", {RequiredParams: ["ValuePrefix", "DefaultValue", "OCRType", "X1Coordinate", "Y1Coordinate", "X2Coordinate", "Y2Coordinate"], OptionalParams: ["OCRLanguage", "OCRScale", "PreExecFocusFunctions", "PostExecFocusFunctions", "HotkeyCommand", "HotkeyLabel", "HotkeyFunctions"]},
    "PluginOverlay", {OptionalParams: ["Label", "PluginName", "CompensationFunction"]},
    "StandaloneOverlay", {OptionalParams: ["Label", "StandaloneName"]},
    "StaticText", {OptionalParams: ["Value", "PreExecFocusFunctions", "PostExecFocusFunctions", "HotkeyCommand", "HotkeyLabel", "HotkeyFunctions"]},
    "Tab", {RequiredParams: ["Label"], OptionalParams: ["PreExecFocusFunctions", "PostExecFocusFunctions", "HotkeyCommand", "HotkeyLabel", "HotkeyFunctions"]},
    "TabControl", {OptionalParams: ["Label"]},
    "ToggleButton", {RequiredParams: ["Label"], OptionalParams: ["PreExecFocusFunctions", "PostExecFocusFunctions", "PreExecActivationFunctions", "PostExecActivationFunctions", "HotkeyCommand", "HotkeyLabel", "HotkeyFunctions"]},
    )
    Static Overlay := False
    Static ProjectFile := False
    
    Static __New() {
        DefaultOverlay := AccessibilityOverlay()
        DefaultOverlay.AddStaticText("Press Shift+Windows+L to load an overlay")
        This.DefaultOverlay := DefaultOverlay
        This.Overlay := DefaultOverlay
        Plugin.Register("OverlayLoader", ".*", ObjBindMethod(This, "Check"), False, ObjBindMethod(This, "Unload"), False, 1, True)
        Plugin.RegisterOverlay("OverlayLoader", DefaultOverlay)
        Plugin.SetTimer("OverlayLoader", This.SetOverlay, -1)
        Standalone.Register("OverlayLoader", "ahk_exe .+.exe", ObjBindMethod(This, "Check"), False, ObjBindMethod(This, "Unload"), False, 1)
        Standalone.RegisterOverlay("OverlayLoader", DefaultOverlay)
        Standalone.SetTimer("OverlayLoader", This.SetOverlay, -1)
    }
    
    Static AddFromJson(OverlayObj, JsonData, StartingID := False) {
        If Not StartingID
        StartingID := JsonData["RootID"]
        If StartingID = JsonData["RootID"] {
            ObjType := JsonData["Items"][StartingID]["ObjType"]
            If This.ItemDefinitions.Has(ObjType) {
                ObjParams := JsonData["Items"][StartingID]["ObjParams"]
                ConstructorParams := This.GetConstructorParams(StartingID, JsonData)
                OverlayObj := %ObjType%(ConstructorParams*)
            }
        }
        StartingItem := JsonData["Items"][StartingID]
        If StartingItem.Has("Children")
        For ChildID In StartingItem["Children"] {
            ChildItem := JsonData["Items"][ChildID]
            ChildItemType := ChildItem["ObjType"]
            If This.ItemDefinitions.Has(ChildItemType) {
                ChildConstructorParams := This.GetConstructorParams(ChildID, JsonData)
                ChildObj := %ChildItemType%(ChildConstructorParams*)
                ChildObj := This.AddFromJson(ChildObj, JsonData, ChildID)
                If OverlayObj Is AccessibilityOverlay
                OverlayObj.AddControl(ChildObj)
                Else If OverlayObj Is TabControl
                OverlayObj.AddTabs(ChildObj)
            }
        }
        Return OverlayObj
    }
    
    Static AddInstance() {
        If ReaHotkey.PluginWinCriteria {
            This.Context := "Plugin"
            If Plugin.Instances.Length > 0
            If Plugin.Instances[1].Name = "OverlayLoader"
            Return
        }
        Else {
            This.Context := "Standalone"
            If Standalone.Instances.Length > 0
            If Standalone.Instances[1].Name = "OverlayLoader" {
                Standalone.Instances[1].WinID := WinGetID("A")
                Return
            }
        }
        If ReaHotkey.PluginWinCriteria
        Plugin.Instances.InsertAt(1, Plugin("OverlayLoader", ReaHotkey.GetPluginControl(), WinGetTitle("A")))
        Else
        Standalone.Instances.InsertAt(1, Standalone("OverlayLoader", WinGetID("A")))
    }
    
    Static Check(Instance) {
        If This.Active
        If Instance Is Plugin {
            If This.Context = "Plugin"
            Return True
        }
        Else {
            If This.Context = "Standalone"
            If Instance.WinID = WinGetID("A")
            Return True
        }
        Return False
    }
    
    Static GetConstructorParams(ItemID, JsonData) {
        ConstructorParams := Array()
        ObjType := JsonData["Items"][ItemID]["ObjType"]
        ObjParams := JsonData["Items"][ItemID]["ObjParams"]
        If This.ItemDefinitions[ObjType].HasProp("RequiredParams")
        For ParamName In This.ItemDefinitions[ObjType].RequiredParams {
            If Not ObjParams.Has(ParamName)
            ObjParams.Set(ParamName, "")
            If ObjType = "PluginOverlay" And ParamName = "PluginName"
            ObjParams[ParamName] := ""
            If ObjType = "StandaloneOverlay" And ParamName = "StandaloneName"
            ObjParams[ParamName] := ""
            ConstructorParams.Push(This.MakeObjProp(ObjType, ParamName, ObjParams[ParamName]))
        }
        If This.ItemDefinitions[ObjType].HasProp("OptionalParams")
        For ParamName In This.ItemDefinitions[ObjType].OptionalParams {
            If Not ObjParams.Has(ParamName)
            ObjParams.Set(ParamName, "")
            If ObjType = "PluginOverlay" And ParamName = "PluginName"
            ObjParams[ParamName] := ""
            If ObjType = "StandaloneOverlay" And ParamName = "StandaloneName"
            ObjParams[ParamName] := ""
            ConstructorParams.Push(This.MakeObjProp(ObjType, ParamName, ObjParams[ParamName]))
        }
        Return ConstructorParams
    }
    
    Static LoadHK(ThisHotkey) {
        This.LoadOverlay()
    }
    
    Static LoadOverlay() {
        ProjectFile := FileSelect("3", "", "Load overlay…", "OverlayDesigner Projects (*.RHK-Overlay)")
        If Not ProjectFile
        Return
        If This.PerformLoad(ProjectFile)
        AccessibilityOverlay.Speak("Overlay loaded")
    }
    
    Static MakeObjProp(ObjType, Name, Value) {
        If SubStr(Name, -8) = "Function" {
            ReturnValue := ""
            Value := Trim(Value)
            If SubStr(Value, 1, 1) = "["
            Value := SubStr(Value, 2)
            If SubStr(Value, -1) = "]"
            Value := SubStr(Value, 1, -1)
            FuncParser := CodeParser()
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
            FuncParser := CodeParser()
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
        If Name = "OnColors" Or Name = "OffColors" Or Name = "CheckedColors" Or Name = "UncheckedColors" Or Name = "Images" Or Name = "OnImages" Or Name = "OffImages" Or Name = "CheckedImages" Or Name = "UncheckedImages" Or Name = "Options" {
            If SubStr(Value, 1, 1) = "["
            Value := SubStr(Value, 2)
            If SubStr(Value, -1) = "]"
            Value := SubStr(Value, 1, -1)
            Value := StrSplit(Value, ",", A_Space)
            For ArrayItem In Value {
                If SubStr(Trim(ArrayItem), 1, 1) = "`""
                ArrayItem := SubStr(Trim(ArrayItem), 2)
                If SubStr(Trim(ArrayItem), -1) = "`""
                ArrayItem  := SubStr(Trim(ArrayItem), 1, -1)
                Value[A_Index] := Trim(ArrayItem)
            }
            Return Value
        }
        If SubStr(Value, 1, 1) = "[" And SubStr(Value, -1) = "]" {
            ExprParser := CodeParser()
            Return ExprParser.ProcessExpression(Value)
        }
        Return Value
    }
    
    Static PerformLoad(ProjectFile) {
        If Not FileExist(ProjectFile) Or InStr(FileExist(ProjectFile), "D") {
            MsgBox "An error occurred while opening " . ProjectFile . ".`nPlease try again.", "OverlayLoader"
            Return False
        }
        JsonData := FileRead(ProjectFile, "UTF-8")
        JsonData := jxon_load(&JsonData)
        If Not JsonData Is Map {
            ReportError()
            Return False
        }
        If Not JsonData.Has("RootID") {
            ReportError()
            Return False
        }
        If Not JsonData.Has("Items") {
            ReportError()
            Return False
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
            Return False
        }
        This.Overlay := This.AddFromJson(This.Overlay, JsonData)
        This.ProjectFile := ProjectFile
        SplitPath This.ProjectFile,, &ProjectDir
        A_WorkingDir := ProjectDir
        This.UpdateHotkeys()
        This.Active := True
        This.AddInstance()
        For ItemType In ["Plugin", "Standalone"] {
            If ReaHotkey.Found%ItemType% Is %ItemType% {
                If ReaHotkey.Found%ItemType%.Name = "OverlayLoader"
                ReaHotkey.Found%ItemType%.Overlay := This.Overlay
            }
        }
        Return True
        ReportError() {
            MsgBox "Failed to open " . ProjectFile . ".", "OverlayLoader"
        }
    }
    
    Static ReloadHK(ThisHotkey) {
        This.ReloadOverlay()
    }
    
    Static ReloadOverlay() {
        If This.ProjectFile {
            If This.PerformLoad(This.ProjectFile)
            AccessibilityOverlay.Speak("Overlay reloaded")
        }
        Else {
            This.LoadOverlay()
        }
    }
    
    Static ToggleHK(ThisHotkey) {
        If Not This.ProjectFile {
            This.LoadOverlay()
            Return
        }
        If Not This.Active {
            SplitPath This.ProjectFile,, &ProjectDir
            A_WorkingDir := ProjectDir
            This.Active := True
            This.AddInstance()
            AccessibilityOverlay.Speak("OverlayLoader enabled")
        }
        Else If This.Active {
            A_WorkingDir := A_ScriptDir
            This.Active := False
            AccessibilityOverlay.Speak("Disabled OverlayLoader")
        }
        Else {
            SplitPath This.ProjectFile,, &ProjectDir
            A_WorkingDir := ProjectDir
            This.Active := True
            This.AddInstance()
            AccessibilityOverlay.Speak("OverlayLoader enabled")
        }
    }
    
    Static Unload(Instance) {
        A_WorkingDir := A_ScriptDir
    }
    
    Static UnloadHK(ThisHotkey) {
        If Not This.ProjectFile
        Return
        If This.Active {
            A_WorkingDir := A_ScriptDir
            This.Active := False
            This.Context := False
            This.Overlay := This.DefaultOverlay
            This.ProjectFile := False
            AccessibilityOverlay.Speak("Overlay unloaded")
        }
    }
    
    Static UpdateHotkeys() {
        For PluginWinCriteria In ReaHotkey.PluginWinCriteriaList {
            HotIfWinActive(PluginWinCriteria)
            For HKItem In Plugin.GetHotkeys("OverlayLoader")
            Plugin.SetHotkey("OverlayLoader", HKItem["KeyName"], "Off")
        }
        Plugin.List[Plugin.FindName("OverlayLoader")]["Hotkeys"] := Array()
        For PluginWinCriteria In ReaHotkey.PluginWinCriteriaList {
            HotIfWinActive(PluginWinCriteria)
            Plugin.RegisterOverlayHotkeys("OverlayLoader", This.Overlay)
        }
        HotIfWinActive("ahk_exe .+.exe")
        For HKItem In Standalone.GetHotkeys("OverlayLoader")
        Standalone.SetHotkey("OverlayLoader", HKItem["KeyName"], "Off")
        Standalone.List[Standalone.FindName("OverlayLoader")]["Hotkeys"] := Array()
        Standalone.RegisterOverlayHotkeys("OverlayLoader", This.Overlay)
    }
    
    Class SetOverlay {
        Static Call() {
            ParentClass := SubStr(This.Prototype.__Class, 1, InStr(This.Prototype.__Class, ".") - 1)
            For ItemType In ["Plugin", "Standalone"]
            If ReaHotkey.Found%ItemType% Is %ItemType% And ReaHotkey.Found%ItemType%.Name = "OverlayLoader"
            If %ParentClass%.Active {
                SplitPath %ParentClass%.ProjectFile,, &ProjectDir
                A_WorkingDir := ProjectDir
                ReaHotkey.Found%ItemType%.Overlay := %ParentClass%.Overlay
            }
        }
    }
    
}

#HotIf
#+L::OverlayLoader.LoadHK(ThisHotkey)
#+F5::OverlayLoader.ReloadHK(ThisHotkey)
#+O::OverlayLoader.ToggleHK(ThisHotkey)
#+U::OverlayLoader.UnloadHK(ThisHotkey)
