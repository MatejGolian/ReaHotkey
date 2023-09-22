#Requires AutoHotkey v2.0

Class AccessiblePluginMenu Extends AccessibleMenu {
    
    Type := "Plugin"
    
    Show() {
        ReaHotkey.TurnPluginTimersOff()
        ReaHotkey.TurnPluginHotkeysOff()
        Super.Show()
    }
    
}
