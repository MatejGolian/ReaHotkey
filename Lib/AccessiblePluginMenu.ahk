#Requires AutoHotkey v2.0

Class AccessiblePluginMenu Extends Menu {
    
    Show() {
        ReaHotkey.TurnPluginTimersOff()
        ReaHotkey.TurnPluginHotkeysOff()
        Super.Show()
        ReaHotkey.TurnPluginTimersOn(ReaHotkey.FoundPlugin.Name)
        ReaHotkey.TurnPluginHotkeysOn(ReaHotkey.FoundPlugin.Name)
    }
    
}
