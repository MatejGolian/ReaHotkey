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
    WinID := ""
    
    __New(Name, WinID) {
        Super.__New(Name)
        This.WinID := WinID
    }
    
    Static FindByActiveWindow() {
        For StandaloneNumber, StandaloneEntry In This.List
        For WinCriterion In StandaloneEntry["WinCriteria"]
        If Not WinCriterion = ""
        If WinActive(WinCriterion)
        Return StandaloneNumber
        Return 0
    }
    
    Static GetByWinID(WinID) {
        For StandaloneInstance In This.Instances
        If StandaloneInstance.WinID = WinID And StandaloneInstance.Check() = True
        Return StandaloneInstance
        WinID := WinGetID("A")
        StandaloneNumber := This.FindByActiveWindow()
        If Not StandaloneNumber = 0 {
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
    
    Static Register(StandaloneName, WinCriteria, InitFunction := False, Chooser := False, HotkeyMode := 1, CheckerFunction := False) {
        If Super.Register(StandaloneName, InitFunction, Chooser, HotkeyMode, CheckerFunction) = True {
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
        If Super.SetHotkey(StandaloneName, KeyName, Action, Options) = True {
            Options := Super.GetHotkeyOptions(Options)
            If StandaloneWinCriteria  And WinActive(StandaloneWinCriteria) {
                HotIfWinActive(StandaloneWinCriteria)
                If ReaHotkey.FoundStandalone Is Standalone And StandaloneName = ReaHotkey.FoundStandalone.Name
                Hotkey KeyName, Action, Options.String
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
                HotkeyWait(ThisHotkey)
                ReaHotkey.FoundStandalone.Overlay.TriggerHotkey(ThisHotkey)
            }
        }
    }
    
}
