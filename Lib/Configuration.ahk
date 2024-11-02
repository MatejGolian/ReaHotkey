#Requires AutoHotkey v2.0

Class Configuration {
    
    DefaultTab := ""
    PrevIousTab := False
    Settings := Array()
    Tabs := Array()
    Title := ""
    
    __New(Title := "Configuration", DefaultTab := "General") {
        This.Title := Title
        This.DefaultTab := DefaultTab
    }
    
    Add(FileName, SectionName, KeyName, DefaultValue, Label := False, Tab := False, FuncOnSet := False) {
        For Index, Setting In This.Settings
        If Setting.FileName = FileName And Setting.SectionName = SectionName And Setting.KeyName = KeyName
        Return Index
        If Not This.PrevIousTab
        This.PrevIousTab := This.DefaultTab
        If Not Tab
        Tab := This.PrevIousTab
        Else
        This.PrevIousTab := Tab
        Setting := {FileName: FileName, SectionName: SectionName, KeyName: KeyName, DefaultValue: DefaultValue, Label: Label, Tab: Tab, FuncOnSet: FuncOnSet}
        Setting.Value := IniRead(FileName, SectionName, KeyName, DefaultValue)
        IniWrite(Setting.Value, FileName, SectionName, KeyName)
        This.Settings.Push(Setting)
        For Value In This.Tabs
        If Setting.Tab = Value
        Return This.Settings.Length
        This.Tabs.Push(Setting.Tab)
        Return This.Settings.Length
    }
    
    Get(KeyNameOrNumber) {
        If KeyNameOrNumber Is Integer And KeyNameOrNumber >= 1 And KeyNameOrNumber <= This.Settings.Length
        Return This.Settings[KeyNameOrNumber].Value
        If KeyNameOrNumber Is String
        For Setting In This.Settings
        If Setting.KeyName = KeyNameOrNumber
        Return Setting.Value
    }
    
    Set(KeyNameOrNumber, Value) {
        If KeyNameOrNumber Is Integer And KeyNameOrNumber >= 1 And KeyNameOrNumber <= This.Settings.Length {
            Setting := This.Settings[KeyNameOrNumber]
            SetValue(Setting)
            Return
        }
        If KeyNameOrNumber Is String
        For Setting In This.Settings
        If Setting.KeyName = KeyNameOrNumber {
            SetValue(Setting)
            Return
        }
        SetValue(Setting) {
            Setting.Value := Value
            IniWrite(Setting.Value, Setting.FileName, Setting.SectionName, Setting.KeyName)
            If Setting.FuncOnSet Is Object And Setting.FuncOnSet.HasMethod("Call")
            Setting.FuncOnSet.Call(Setting)
        }
    }
    
    ShowBox() {
        Static ConfigBox := False, ConfigBoxWinID := ""
        If ConfigBox = False {
            ConfigBox := Gui(, This.Title)
            LabelledSettings := Array()
            SettingBoxes := Map()
            TabsUsed := Map()
            For Index, Setting In This.Settings {
                If Setting.Label
                LabelledSettings.Push(Setting)
                TabsUsed.Set(Setting.Tab, False)
            }
            If LabelledSettings.Length = 0
            ConfigBox.AddText("Section", "No settings available.")
            If LabelledSettings.Length > 0 And This.Tabs.Length > 1
            TabBox := ConfigBox.AddTab3("Section", This.Tabs)
            For Index, Setting In LabelledSettings {
                Checked := ""
                If Setting.Value = 1
                Checked := "Checked"
                If IsSet(TabBox)
                TabBox.UseTab(Setting.Tab)
                If Not TabsUsed[Setting.Tab]
                FirstControl := True
                Else
                FirstControl := False
                TabsUsed[Setting.Tab] := True
                If FirstControl
                SettingBoxes[Setting.KeyName] := ConfigBox.AddCheckBox("Section " . Checked, Setting.Label)
                Else
                SettingBoxes[Setting.KeyName] := ConfigBox.AddCheckBox("XS " . Checked, Setting.Label)
            }
            If IsSet(TabBox)
            TabBox.UseTab()
            ConfigBox.AddButton("Section XS Default", "OK").OnEvent("Click", SaveConfig)
            ConfigBox.AddButton("YS", "Cancel").OnEvent("Click", CloseConfigBox)
            ConfigBox.OnEvent("Close", CloseConfigBox)
            ConfigBox.OnEvent("Escape", CloseConfigBox)
            ConfigBox.Show()
            ConfigBoxWinID := WinGetID("A")
        }
        Else {
            WinActivate(ConfigBoxWinID)
        }
        CloseConfigBox(*) {
            ConfigBox.Destroy()
            ConfigBox := False
            ConfigBoxWinID := ""
        }
        SaveConfig(*) {
            For KeyName, SettingBox In SettingBoxes
            This.set(KeyName, SettingBox.Value)
            CloseConfigBox()
        }
    }
    
}
