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
    
    Add(FileName, SectionName, KeyName, DefaultValue, Label := False, Tab := False, ControlType := False, ControlProperties := False, FuncOnInit := False, FuncOnChange := False, FuncOnSet := False) {
        For Index, Setting In This.Settings
        If Setting.FileName = FileName And Setting.SectionName = SectionName And Setting.KeyName = KeyName
        Return Index
        If Not This.PrevIousTab
        This.PrevIousTab := This.DefaultTab
        If Not Tab
        Tab := This.PrevIousTab
        Else
        This.PrevIousTab := Tab
        If Not ControlType
        ControlType := "CheckBox"
        If Not ControlProperties
        ControlProperties := ""
        ControlProperties .= " "
        Setting := {FileName: FileName, SectionName: SectionName, KeyName: KeyName, DefaultValue: DefaultValue, Label: Label, Tab: Tab, ControlType: ControlType, ControlProperties: ControlProperties, FuncOnInit: FuncOnInit, FuncOnChange: FuncOnChange, FuncOnSet: FuncOnSet}
        Setting.Value := IniRead(FileName, SectionName, KeyName, DefaultValue)
        IniWrite(Setting.Value, FileName, SectionName, KeyName)
        This.Settings.Push(Setting)
        For Value In This.Tabs
        If Setting.Tab = Value
        Return This.Settings.Length
        This.Tabs.Push(Setting.Tab)
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
            If Setting.FuncOnSet Is Object And Setting.FuncOnSet.HasMethod("Call")
            Setting.FuncOnSet.Call(Setting)
        }
    }
    
    ShowBox(TabToSelect := 1) {
        If This.ConfigBox = False {
            This.ConfigBox := Gui(, This.Title)
            LabelledSettings := Array()
            This.GuiControls := Map()
            TabsUsed := Map()
            For Index, Setting In This.Settings {
                If Setting.Label
                LabelledSettings.Push(Setting)
                TabsUsed.Set(Setting.Tab, False)
            }
            If LabelledSettings.Length = 0
            This.ConfigBox.AddText("Section", "No settings available.")
            If LabelledSettings.Length > 0 And This.Tabs.Length > 1
            TabBox := This.ConfigBox.AddTab3("Section", This.Tabs)
            For Index, Setting In LabelledSettings {
                Position := ""
                If IsSet(TabBox)
                TabBox.UseTab(Setting.Tab)
                If Not TabsUsed[Setting.Tab]
                FirstControl := True
                TabsUsed[Setting.Tab] := True
                If FirstControl
                Position := "Section "
                Else
                Position := "XS "
                FirstControl := False
                If Not This.GuiControls.Has(Setting.SectionName)
                This.GuiControls[Setting.SectionName] := Map()
                If Setting.ControlType = "Edit" Or Setting.ControlType = "Hotkey" {
                    This.ConfigBox.AddText("Section XS", Setting.Label)
                    This.GuiControls[Setting.SectionName][Setting.KeyName] := This.ConfigBox.Add%Setting.ControlType%("YS", Setting.Value)
                    FirstControl := True
                }
                Else {
                    Properties := Setting.ControlProperties
                    If Setting.ControlType = "CheckBox" And Setting.Value = 1
                    Properties .= "Checked"
                    This.GuiControls[Setting.SectionName][Setting.KeyName] := This.ConfigBox.Add%Setting.ControlType%(Position . Properties, Setting.Label)
                }
                If Setting.FuncOnInit Is Object And Setting.FuncOnInit.HasMethod("Call")
                Setting.FuncOnInit.Call(This.GuiControls[Setting.SectionName][Setting.KeyName])
                If Setting.FuncOnChange Is Object And Setting.FuncOnChange.HasMethod("Call") {
                    If Setting.ControlType = "Edit" Or Setting.ControlType = "Hotkey"
                    This.GuiControls[Setting.SectionName][Setting.KeyName].OnEvent("Change", Setting.FuncOnChange)
                    Else
                    This.GuiControls[Setting.SectionName][Setting.KeyName].OnEvent("Click", Setting.FuncOnChange)
                }
            }
            If IsSet(TabBox)
            TabBox.UseTab()
            This.ConfigBox.AddButton("Section XS Default", "OK").OnEvent("Click", ObjBindMethod(This, "SaveConfig"))
            This.ConfigBox.AddButton("YS", "Cancel").OnEvent("Click", ObjBindMethod(This, "CloseBox"))
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
