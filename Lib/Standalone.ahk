#Requires AutoHotkey v2.0

Class Standalone Extends Program {
    
    Static UnnamedStandaloneName := "Unnamed Program"
    Static ChooserOverlay := StandaloneOverlay()
    Static DefaultOverlay := StandaloneOverlay()
    Static Instances := Array()
    Static List := Array()
    CheckerFunction := ""
    Chooser := True
    InitFunction := ""
    InstanceNumber := 0
    Name := ""
    Overlay := StandaloneOverlay()
    StandaloneNumber := 0
    UnloadFunction := ""
    WinID := ""
    
    __New(Name, WinID) {
        Super.__New(Name)
        This.WinID := WinID
    }
    
    Static FindByActiveWindow() {
        Found := Array()
        For StandaloneNumber, StandaloneEntry In This.List
        For WinCriterion In StandaloneEntry["WinCriteria"]
        If Not WinCriterion = ""
        If WinActive(WinCriterion)
        Found.Push(StandaloneNumber)
        Return Found
    }
    
    Static GetByWinID(WinID) {
        For StandaloneInstance In This.Instances
        If StandaloneInstance.WinID = WinID And StandaloneInstance.Check() = True
        Return StandaloneInstance
        WinID := WinGetID("A")
        Found := This.FindByActiveWindow()
        For StandaloneNumber In Found {
            StandaloneInstance := Standalone("", "")
            CheckResult := This.List[StandaloneNumber]["CheckerFunction"].Call(StandaloneInstance)
            If CheckResult = True {
                StandaloneInstance := Standalone(This.List[StandaloneNumber]["Name"], WinID)
                Return StandaloneInstance
            }
        }
        Return False
    }
    
    Static GetInstance(WinID) {
        For StandaloneInstance In This.Instances
        If StandaloneInstance.WinID = WinID
        Return StandaloneInstance
        Return False
    }
    
    Static Register(StandaloneName, WinCriteria, CheckerFunction := False, InitFunction := False, UnloadFunction := False, Chooser := False, HotkeyMode := 1) {
        If Super.Register(StandaloneName, CheckerFunction, InitFunction, UnloadFunction, Chooser, HotkeyMode) = True {
            StandaloneEntry := This.List[This.List.Length]
            If WinCriteria Is Array
            StandaloneEntry["WinCriteria"] := WinCriteria
            Else
            StandaloneEntry["WinCriteria"] := Array(WinCriteria)
        }
    }
    
    Static SetHotkey(StandaloneName, KeyName, Action := "", Options := "") {
        PluginWinCriteria := ReaHotkey.PluginWinCriteria
        StandaloneWinCriteria := ReaHotkey.StandaloneWinCriteria
        RegisteredHotkey := Super.SetHotkey(StandaloneName, KeyName, Action, Options)
        If RegisteredHotkey Is Map {
            If StandaloneWinCriteria  And WinActive(StandaloneWinCriteria) {
                HotIfWinActive(StandaloneWinCriteria)
                If ReaHotkey.FoundStandalone Is Standalone And StandaloneName = ReaHotkey.FoundStandalone.Name
                Hotkey RegisteredHotkey["KeyName"], RegisteredHotkey["Action"], RegisteredHotkey["Options"]
            }
            If PluginWinCriteria And WinActive(PluginWinCriteria)
            HotIfWinActive(PluginWinCriteria)
            Else If StandaloneWinCriteria And WinActive(StandaloneWinCriteria)
            HotIfWinActive(StandaloneWinCriteria)
            Else
            HotIf
        }
    }
    
    Class DefaultChecker {
        Static Call(*) {
            Return True
        }
    }
    
    Class TriggerOverlayHotkey {
        Static Call(ThisHotkey) {
            If ReaHotkey.FoundStandalone Is Standalone And ReaHotkey.FoundStandalone.Overlay Is AccessibilityOverlay {
                AccessibilityOverlay.Helpers.HotkeyWait(ThisHotkey)
                ReaHotkey.FoundStandalone.Overlay.TriggerHotkey(ThisHotkey)
            }
        }
    }
    
}
