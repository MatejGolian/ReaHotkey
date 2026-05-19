#Requires AutoHotkey v2.0

Class AccessibleMenu Extends Menu {
    
    Show() {
        ReaHotkey.TurnPluginTimersOff()
        ReaHotkey.TurnPluginHotkeysOff()
        ReaHotkey.TurnStandaloneTimersOff()
        ReaHotkey.TurnStandaloneHotkeysOff()
        Super.Show()
        ReaHotkey.TurnPluginTimersOn(ReaHotkey.FoundPlugin.Name)
        ReaHotkey.TurnPluginHotkeysOn(ReaHotkey.FoundPlugin.Name)
        ReaHotkey.TurnStandaloneTimersOn(ReaHotkey.FoundStandalone.Name)
        ReaHotkey.TurnStandaloneHotkeysOn(ReaHotkey.FoundStandalone.Name)
    }
    
}
