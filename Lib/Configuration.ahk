#Requires AutoHotkey v2.0

Class Configuration {
    
    ConfigBox := False
    ConfigBoxWinID := ""
    DefaultTab := ""
    GuiControls := Map()
    PrevIousTab := False
    Settings := Array()
    Tabs := Array()
    Title := ""
    
    __New(Title := "Configuration", DefaultTab := "General") {
        This.Title := Title
        This.DefaultTab := DefaultTab
    }
    
    Add(FileName, SectionName, KeyName, DefaultValue, ControlData := {}) {
        Control := {Label: False, Tab: False, Type: "CheckBox", Options: False, Parameters: False, FuncOnInit: False, FuncOnChange: False, FuncOnSet: False}
        If ControlData Is Object
        For PropName, PropValue In Control.OwnProps()
        If ControlData.HasOwnProp(PropName)
        Control.%PropName% := ControlData.%PropName%
        If Not This.PrevIousTab
        This.PrevIousTab := This.DefaultTab
        If Not Control.Tab
        Control.Tab := This.PrevIousTab
        Else
        This.PrevIousTab := Control.Tab
        Setting := {FileName: FileName, SectionName: SectionName, KeyName: KeyName, DefaultValue: DefaultValue, Control: Control}
        Setting.Value := IniRead(FileName, SectionName, KeyName, DefaultValue)
        IniWrite(Setting.Value, FileName, SectionName, KeyName)
        This.Settings.Push(Setting)
        For Value In This.Tabs
        If Setting.Control.Tab = Value
        Return This.Settings.Length
        This.Tabs.Push(Setting.Control.Tab)
        Return This.Settings.Length
    }
    
    CloseBox(*) {
        This.ConfigBox.Destroy()
        This.ConfigBox := False
        This.ConfigBoxWinID := ""
    }
    
    Get(SectionName, KeyNameOrNumber) {
        Setting := This.GetSetting(SectionName, KeyNameOrNumber)
        If Setting
        Return Setting.Value
        Return False
    }
    
    GetSetting(SectionName, KeyNameOrNumber) {
        If KeyNameOrNumber Is Integer And KeyNameOrNumber >= 1 And KeyNameOrNumber <= This.Settings.Length
        Return This.Settings[KeyNameOrNumber].Value
        If KeyNameOrNumber Is String {
            For Setting In This.Settings
            If SectionName = "" {
                If Setting.KeyName = KeyNameOrNumber
                Return Setting
            }
            Else {
                If Setting.SectionName = SectionName And Setting.KeyName = KeyNameOrNumber
                Return Setting
            }
        }
        Return False
    }
    
    SaveConfig(*) {
        This.ConfigBox.Submit()
        For Setting In This.Settings
        This.set(Setting.SectionName, Setting.KeyName, This.GuiControls[Setting.SectionName][Setting.KeyName].Value)
        This.CloseBox()
    }
    
    Set(SectionName, KeyNameOrNumber, Value) {
        Setting := This.GetSetting(SectionName, KeyNameOrNumber)
        If Setting
        SetValue(Setting, Value)
        SetValue(Setting, Value) {
            Setting.Value := Value
            IniWrite(Setting.Value, Setting.FileName, Setting.SectionName, Setting.KeyName)
            If Setting.Control.FuncOnSet Is Object And Setting.Control.FuncOnSet.HasMethod("Call")
            Setting.Control.FuncOnSet.Call(Setting)
        }
    }
    
    ShowBox(TabToSelect := 1) {
        If This.ConfigBox = False {
            This.ConfigBox := Gui(, This.Title)
            LabelledSettings := Array()
            This.GuiControls := Map()
            TabsUsed := Map()
            For Index, Setting In This.Settings {
                If Setting.Control.Label
                LabelledSettings.Push(Setting)
                TabsUsed.Set(Setting.Control.Tab, False)
            }
            If LabelledSettings.Length = 0
            This.ConfigBox.AddText("Section", "No settings available.")
            If LabelledSettings.Length > 0 And This.Tabs.Length > 1
            TabBox := This.ConfigBox.AddTab3("Section", This.Tabs)
            For Index, Setting In LabelledSettings {
                Position := ""
                If IsSet(TabBox)
                TabBox.UseTab(Setting.Control.Tab)
                If Not TabsUsed[Setting.Control.Tab]
                FirstControl := True
                TabsUsed[Setting.Control.Tab] := True
                If FirstControl
                Position := "Section"
                Else
                Position := "Section XS"
                FirstControl := False
                If Not This.GuiControls.Has(Setting.SectionName)
                This.GuiControls[Setting.SectionName] := Map()
                Options := ""
                Parameters := ""
                If Setting.Control.Options
                Options := Setting.Control.Options
                If Setting.Control.Parameters
                Parameters := Setting.Control.Parameters
                If Setting.Control.Type = "Button" Or Setting.Control.Type = "GroupBox" Or Setting.Control.Type = "Radio" Or Setting.Control.Type = "Text" {
                    This.GuiControls[Setting.SectionName][Setting.KeyName] := This.ConfigBox.Add%Setting.Control.Type%(Position . " " . Options, Setting.Control.Label)
                }
                Else If Setting.Control.Type = "CheckBox" {
                    Checked := ""
                    If Setting.Value = 1
                    Checked := "Checked "
                    This.GuiControls[Setting.SectionName][Setting.KeyName] := This.ConfigBox.Add%Setting.Control.Type%(Position . " " . Checked . " " . Options, Setting.Control.Label)
                }
                Else If Setting.Control.Type = "ComboBox" Or Setting.Control.Type = "DDL" Or Setting.Control.Type = "DropDownList" Or Setting.Control.Type = "ListBox" Or Setting.Control.Type = "ListView" {
                    If Not Parameters Is Array
                    Parameters := Array()
                    This.ConfigBox.AddText(Position, Setting.Control.Label)
                    This.GuiControls[Setting.SectionName][Setting.KeyName] := This.ConfigBox.Add%Setting.Control.Type%("YP " . Options . " Choose" . Setting.Value, Parameters)
                }
                Else If Setting.Control.Type = "Custom" Or Setting.Control.Type = "MonthCal" Or Setting.Control.Type = "TreeView" {
                    This.GuiControls[Setting.SectionName][Setting.KeyName] := This.ConfigBox.Add%Setting.Control.Type%(Position . " " . Options)
                }
                Else If Setting.Control.Type = "Edit" Or Setting.Control.Type = "Hotkey" {
                    This.ConfigBox.AddText(Position, Setting.Control.Label)
                    This.GuiControls[Setting.SectionName][Setting.KeyName] := This.ConfigBox.Add%Setting.Control.Type%("YP " . Options, Setting.Value)
                }
                Else If Setting.Control.Type = "Link" {
                    This.GuiControls[Setting.SectionName][Setting.KeyName] := This.ConfigBox.Add%Setting.Control.Type%(Parameters)
                }
                Else {
                    This.GuiControls[Setting.SectionName][Setting.KeyName] := This.ConfigBox.Add%Setting.Control.Type%(Position . " " . Options, Parameters)
                }
                If Setting.Control.FuncOnInit Is Object And Setting.Control.FuncOnInit.HasMethod("Call")
                Setting.Control.FuncOnInit.Call(This.GuiControls[Setting.SectionName][Setting.KeyName])
                If Not Setting.Control.Type = "Custom" {
                    If Setting.Control.FuncOnChange Is Object And Setting.Control.FuncOnChange.HasMethod("Call") {
                        If Setting.Control.Type = "ComboBox" Or Setting.Control.Type = "DateTime" Or Setting.Control.Type = "DDL" Or Setting.Control.Type = "DropDownList" Or Setting.Control.Type = "Edit" Or Setting.Control.Type = "Hotkey" Or Setting.Control.Type = "ListBox" Or Setting.Control.Type = "Slider" Or Setting.Control.Type = "UpDown"
                        This.GuiControls[Setting.SectionName][Setting.KeyName].OnEvent("Change", Setting.Control.FuncOnChange)
                        Else
                        This.GuiControls[Setting.SectionName][Setting.KeyName].OnEvent("Click", Setting.Control.FuncOnChange)
                    }
                }
            }
            If IsSet(TabBox)
            TabBox.UseTab()
            This.ConfigBox.AddButton("Section Default", "OK").OnEvent("Click", ObjBindMethod(This, "SaveConfig"))
            This.ConfigBox.AddButton("YP", "Cancel").OnEvent("Click", ObjBindMethod(This, "CloseBox"))
            This.ConfigBox.OnEvent("Close", ObjBindMethod(This, "CloseBox"))
            This.ConfigBox.OnEvent("Escape", ObjBindMethod(This, "CloseBox"))
            If IsSet(TabBox) And Not TabToSelect = 1
            TabBox.Choose(TabToSelect)
            This.ConfigBox.Show()
            This.ConfigBoxWinID := WinGetID("A")
        }
        Else {
            WinActivate(This.ConfigBoxWinID)
        }
    }
    
}
