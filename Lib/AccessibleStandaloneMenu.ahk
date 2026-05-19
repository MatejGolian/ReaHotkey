#Requires AutoHotkey v2.0

Class AccessibleStandaloneMenu Extends Menu {
    
    Show() {
        ReaHotkey.TurnStandaloneTimersOff()
        ReaHotkey.TurnStandaloneHotkeysOff()
        Super.Show()
        ReaHotkey.TurnStandaloneTimersOn(ReaHotkey.FoundStandalone.Name)
        ReaHotkey.TurnStandaloneHotkeysOn(ReaHotkey.FoundStandalone.Name)
    }
    
}
