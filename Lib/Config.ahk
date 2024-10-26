#Requires AutoHotkey v2.0

Class Config {

Static Settings := Array()

Static __New() {
This.Add("ReaHotkey.ini", "Config", "CheckScreenResolutionOnStartup", 1, "Check screen resolution on startup")
This.Add("ReaHotkey.ini", "Config", "CheckForUpdatesOnStartup", 1, "Check for updates on startup")
This.Add("ReaHotkey.ini", "Config", "WarnIfWinCovered", 1, "Warn if another window may be covering the interface in specific cases")
This.Add("ReaHotkey.ini", "Config", "UseImageSearchForEngine2PluginDetection", 1, "Use image search for Engine 2 plug-in detection")
This.Add("ReaHotkey.ini", "Config", "AutomaticallyCloseLibrariBrowsersInKontaktAndKKPlugins", 1, "Automatically close library browsers in Kontakt and Komplete Kontrol plug-ins")
This.Add("ReaHotkey.ini", "Config", "AutomaticallyCloseLibrariBrowsersInKontaktAndKKStandalones", 1, "Automatically close library browsers in Kontakt and Komplete Kontrol standalone applications")
This.Add("ReaHotkey.ini", "Config", "AutomaticallyDetectLibrariesInKontaktAndKKPlugins", 1, "Automatically detect libraries in Kontakt and Komplete Kontrol plug-ins")
}

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

}
