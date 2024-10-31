#Requires AutoHotkey v2.0

Class Config {
    
    Static Settings := Array()
    
    Static Add(FileName, SectionName, KeyName, DefaultValue, Label, FuncOnSet := False) {
        Setting := {FileName: FileName, SectionName: SectionName, KeyName: KeyName, DefaultValue: DefaultValue, Label: Label, FuncOnSet: FuncOnSet}
        Setting.Value := IniRead(FileName, SectionName, KeyName, DefaultValue)
        IniWrite(Setting.Value, FileName, SectionName, KeyName)
        This.Settings.Push(Setting)
    }
    
    Static Get(KeyName) {
        For Setting In This.Settings
        If Setting.KeyName = KeyName
        Return Setting.Value
    }
    
    Static Set(KeyName, Value) {
        For Setting In This.Settings
        If Setting.KeyName = KeyName {
            Setting.Value := Value
            IniWrite(Setting.Value, Setting.FileName, Setting.SectionName, Setting.KeyName)
            If Setting.FuncOnSet Is Object And Setting.FuncOnSet.HasMethod("Call")
            Setting.FuncOnSet.Call(Setting)
            Return
        }
    }
    
    Static ShowBox(Title := "Configuration") {
        Static ConfigBox := False, ConfigBoxWinID := ""
        If ConfigBox = False {
            ConfigBox := Gui(, Title)
            SettingBoxes := Map()
            For Index, Setting In This.Settings {
                Checked := ""
                If Setting.Value = 1
                Checked := "Checked"
                If Index = 1
                SettingBoxes[Setting.KeyName] := ConfigBox.AddCheckBox(Checked, Setting.Label)
                Else
                SettingBoxes[Setting.KeyName] := ConfigBox.AddCheckBox("XS " . Checked, Setting.Label)
            }
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
