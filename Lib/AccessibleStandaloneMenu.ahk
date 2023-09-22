#Requires AutoHotkey v2.0

Class AccessibleStandaloneMenu Extends AccessibleMenu {
    
    Type := "Standalone"
    
    Show() {
        ReaHotkey.TurnStandaloneTimersOff()
        ReaHotkey.TurnStandaloneHotkeysOff()
        Super.Show()
    }
    
}
