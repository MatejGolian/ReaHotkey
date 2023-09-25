#Requires AutoHotkey v2.0

Class AccessiblePluginMenu Extends AccessibleMenu {
    
    Type := "Plugin"
    
    Show() {
        ReaHotkey.TurnPluginTimersOff()
        ReaHotkey.TurnPluginHotkeysOff()
        AccessibilityOverlay.Speak(This.ContextMenuString)
        AccessibleMenu.CurrentMenu := This
        Loop {
            If Not AccessibleMenu.CurrentMenu Is AccessiblePluginMenu {
                AccessibleMenu.CurrentMenu := False
                Break
            }
            Else If WinExist("ahk_class #32768") {
                AccessibleMenu.CurrentMenu := False
                Break
            }
            Else If Not WinActive(ReaHotkey.PluginWinCriteria) {
                AccessibleMenu.CurrentMenu := False
                Break
            }
            Else {
                AccessibleMenu.CurrentMenu.Manage()
            }
        }
    }
    
}
