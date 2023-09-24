#Requires AutoHotkey v2.0

Class AccessibleStandaloneMenu Extends AccessibleMenu {
    
    Type := "Standalone"
    
    Show() {
        ReaHotkey.TurnStandaloneTimersOff()
        ReaHotkey.TurnStandaloneHotkeysOff()
        AccessibilityOverlay.Speak(This.ContextMenuString)
        AccessibleMenu.CurrentMenu := This
        Loop {
            If Not AccessibleMenu.CurrentMenu Is AccessibleStandaloneMenu {
                AccessibleMenu.CurrentMenu := False
                Break
            }
            Else If ReaHotkey.StandaloneWinCriteria = False Or Not WinActive(ReaHotkey.StandaloneWinCriteria) {
                AccessibleMenu.CurrentMenu := False
                Break
            }
            Else {
                AccessibleMenu.CurrentMenu.Manage()
            }
        }
    }
    
}
