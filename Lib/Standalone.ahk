#Requires AutoHotkey v2.0

Class Standalone {
    
    CheckerFunction := ""
    Chooser := True
    InitFunction := ""
    Name := ""
    InstanceNumber := 0
    ProgramNumber := 0
    NoHotkeys := False
    Overlay := AccessibilityOverlay()
    Overlays := Array()
    WindowID := ""
    Static ChooserOverlay := AccessibilityOverlay()
    Static DefaultOverlay := AccessibilityOverlay()
    Static Instances := Array()
    Static List := Array()
    Static UnnamedProgramName := "Unnamed Program"
    
    __New(Name, WindowID) {
        ProgramNumber := Standalone.FindName(Name)
        This.InstanceNumber := Standalone.Instances.Length + 1
        This.ProgramNumber := ProgramNumber
        If Name = ""
        This.Name := Standalone.UnnamedProgramName
        Else
        This.Name := Name
        This.WindowID := WindowID
        If ProgramNumber > 0 {
            ProgramEntry := Standalone.List[ProgramNumber]
            This.InitFunction := ProgramEntry["InitFunction"]
            This.Chooser := ProgramEntry["Chooser"]
            This.NoHotkeys := ProgramEntry["NoHotkeys"]
            This.CheckerFunction := ProgramEntry["CheckerFunction"]
            For OverlayNumber, Overlay In ProgramEntry["Overlays"]
            This.Overlays.Push(Overlay.Clone())
            If This.Overlays.Length = 1 {
                This.Overlay := This.Overlays[1].Clone()
            }
            Else If This.Overlays.Length > 1 And This.Chooser = False {
                This.Overlay := This.Overlays[1].Clone()
            }
            Else If This.Overlays.Length > 1 And This.Chooser = True {
                This.Overlay := AccessibilityOverlay()
                This.Overlay.AddAccessibilityOverlay()
                This.Overlay.AddControl(Standalone.ChooserOverlay.Clone())
                This.Overlay.OverlayNumber := 0
            }
            Else {
                This.Overlay := AccessibilityOverlay()
                This.Overlay.AddControl(Standalone.DefaultOverlay.Clone())
                This.Overlay.OverlayNumber := 0
            }
            Standalone.Instances.Push(This)
            This.Init()
        }
    }
    
    Check() {
        If This.CheckerFunction Is Func
        Return This.CheckerFunction.Call(This)
        Return True
    }
    
    GetHotkeys() {
        Return Standalone.GetHotkeys(This.Name)
    }
    
    GetOverlay() {
        Return This.Overlay
    }
    
    GetOverlays() {
        Return This.Overlays
    }
    
    Init() {
        If This.InitFunction Is Func
        This.InitFunction.Call(This)
    }
    
    RegisterOverlay(ProgramOverlay) {
        Standalone.RegisterOverlay(This.Name, ProgramOverlay)
    }
    
    RegisterOverlayHotkeys(ProgramOverlay) {
        Standalone.RegisterOverlayHotkeys(This.Name, ProgramOverlay)
    }
    
    SetHotkey(KeyName, Action := "", Options := "") {
        Standalone.SetHotkey(This.Name, KeyName, Action, Options)
    }
    
    SetNoHotkeys(Value) {
        Standalone.SetNoHotkeys(This.Name, Value)
    }
    
    SetTimer(Function, Period := "", Priority := "") {
        Standalone.SetTimer(This.Name, Function, Period, Priority)
    }
    
    Static DefaultChecker(*) {
        Return True
    }
    
    Static FindByActiveWindow() {
        For ProgramNumber, ProgramEntry In Standalone.List
        For WinCriterion In ProgramEntry["WinCriteria"]
        If WinCriterion != ""
        If WinActive(WinCriterion)
        Return ProgramNumber
        Return 0
    }
    
    Static FindHotkey(ProgramName, KeyName) {
        ProgramNumber := Standalone.FindName(ProgramName)
        If ProgramNumber > 0
        For HotkeyNumber, HotkeyParams In Standalone.List[ProgramNumber]["Hotkeys"]
        If HotkeyParams["KeyName"] = KeyName
        Return HotkeyNumber
        Return 0
    }
    
    Static FindName(ProgramName) {
        For ProgramNumber, ProgramEntry In Standalone.List
        If ProgramEntry["Name"] = ProgramName
        Return ProgramNumber
        Return 0
    }
    
    Static FindTimer(ProgramName, Function) {
        ProgramNumber := Standalone.FindName(ProgramName)
        If ProgramNumber > 0
        For TimerNumber, TimerParams In Standalone.List[ProgramNumber]["Timers"]
        If TimerParams["Function"] = Function
        Return TimerNumber
        Return 0
    }
    
    Static GetByWindowID(WinID) {
        For ProgramInstance In Standalone.Instances
        If ProgramInstance.WindowID = WinID And ProgramInstance.Check() = True
        Return ProgramInstance
        ProgramNumber := Standalone.FindByActiveWindow()
        If ProgramNumber != False And Standalone.List[ProgramNumber]["CheckerFunction"].Call(Standalone.List[ProgramNumber]) = True {
            ProgramInstance := Standalone(Standalone.List[ProgramNumber]["Name"], WinGetID("A"))
            Return ProgramInstance
        }
        Return False
    }
    
    Static GetHotkeys(ProgramName) {
        ProgramNumber := Standalone.FindName(ProgramName)
        If ProgramNumber > 0
        Return Standalone.List[ProgramNumber]["Hotkeys"]
        Return Array()
    }
    
    Static GetInstance(WinID) {
        For ProgramInstance In Standalone.Instances
        If ProgramInstance.WindowID = WinID
        Return ProgramInstance
        Return False
    }
    
    Static GetList() {
        Return Standalone.List
    }
    
    Static GetOverlays(ProgramName) {
        ProgramNumber := Standalone.FindName(ProgramName)
        If ProgramNumber > 0
        Return Standalone.List[ProgramNumber]["Overlays"]
        Return Array()
    }
    
    Static GetTimers(ProgramName) {
        ProgramNumber := Standalone.FindName(ProgramName)
        If ProgramNumber > 0
        Return Standalone.List[ProgramNumber]["Timers"]
        Return Array()
    }
    
    Static Register(ProgramName, WinCriteria, InitFunction := "", Chooser := True, NoHotkeys := False, CheckerFunction := "") {
        If Standalone.FindName(ProgramName) = False {
            If ProgramName = ""
            ProgramName := Standalone.UnnamedProgramName
            If Chooser != True And Chooser != False
            Chooser := True
            If NoHotkeys != True And NoHotkeys != False
            NoHotkeys := False
            If Not CheckerFunction Is Func
            CheckerFunction := ObjBindMethod(Standalone, "DefaultChecker")
            ProgramEntry := Map()
            ProgramEntry["Name"] := ProgramName
            If WinCriteria Is Array
            ProgramEntry["WinCriteria"] := WinCriteria
            Else
            ProgramEntry["WinCriteria"] := Array(WinCriteria)
            ProgramEntry["InitFunction"] := InitFunction
            ProgramEntry["Chooser"] := Chooser
            ProgramEntry["NoHotkeys"] := NoHotkeys
            ProgramEntry["CheckerFunction"] := CheckerFunction
            ProgramEntry["Hotkeys"] := Array()
            ProgramEntry["Overlays"] := Array()
            ProgramEntry["Timers"] := Array()
            Standalone.List.Push(ProgramEntry)
        }
    }
    
    Static RegisterOverlay(ProgramName, ProgramOverlay) {
        ProgramNumber := Standalone.FindName(ProgramName)
        If ProgramNumber > 0 {
            ProgramOverlay.OverlayNumber := Standalone.List[ProgramNumber]["Overlays"].Length + 1
            Standalone.List[ProgramNumber]["Overlays"].Push(ProgramOverlay.Clone())
            For ProgramInstance In Standalone.Instances
            If ProgramName = ProgramInstance.Name
            ProgramInstance.Overlays.Push(ProgramOverlay.Clone())
            Standalone.RegisterOverlayHotkeys(ProgramName, ProgramOverlay)
        }
    }
    
    Static RegisterOverlayHotkeys(ProgramName, ProgramOverlay) {
        ProgramNumber := Standalone.FindName(ProgramName)
        If ProgramNumber > 0 And ProgramOverlay Is AccessibilityOverlay
        For OverlayHotkey In ProgramOverlay.GetHotkeys()
        Standalone.SetHotkey(ProgramName, OverlayHotkey)
    }
    
    Static SetHotkey(ProgramName, KeyName, Action := "", Options := "") {
        For NonRemappableHotkey In ReaHotkey.NonRemappableHotkeys
        If KeyName = NonRemappableHotkey
        Return
        ProgramNumber := Standalone.FindName(ProgramName)
        HotkeyNumber := Standalone.FindHotkey(ProgramName, KeyName)
        If ProgramNumber > 0 And HotkeyNumber = 0 {
            If Not Action Is Object
            Options := Action . " " . Options
            GetOptions()
            If Not Action Is Object
            Action := Standalone.TriggerOverlayHotkey
            Standalone.List[ProgramNumber]["Hotkeys"].Push(Map("KeyName", KeyName, "Action", Action, "Options", Options.String, "State", Options.OnOff))
        }
        Else If HotkeyNumber > 0 {
            CurrentAction := Standalone.List[ProgramNumber]["Hotkeys"][HotkeyNumber]["Action"]
            CurrentOptions := Standalone.List[ProgramNumber]["Hotkeys"][HotkeyNumber]["Options"]
            If Not Action Is Object
            Options := Action . " " . Options
            Options := Options . " " . CurrentOptions
            GetOptions()
            If ProgramName = "Komplete Kontrol" And KeyName = "!F"
            If Not Action Is Object
            Action := CurrentAction
            Standalone.List[ProgramNumber]["Hotkeys"][HotkeyNumber]["Action"] := Action
            Standalone.List[ProgramNumber]["Hotkeys"][HotkeyNumber]["Options"] := Options.String
            Standalone.List[ProgramNumber]["Hotkeys"][HotkeyNumber]["State"] := Options.OnOff
        }
        Else {
            Return
        }
        HotIf
        If ReaHotkey.FoundStandalone Is Standalone And ReaHotkey.FoundStandalone.Name = ProgramName
        Hotkey KeyName, Action, Options.String
        If WinActive(ReaHotkey.PluginWinCriteria)
        HotIfWinActive(ReaHotkey.PluginWinCriteria)
        GetOptions() {
            OnOff := ""
            B := ""
            P := ""
            S := ""
            T := ""
            I := ""
            Options := StrSplit(Options, [A_Space, A_Tab])
            Match := ""
            For Option In Options {
                If OnOff = "" And RegexMatch(Option, "i)^((On)|(Off))$", &Match)
                OnOff := Match[0]
                If B = "" And RegexMatch(Option, "i)^(B0?)$", &Match)
                B := Match[0]
                If P = "" And RegexMatch(Option, "i)^((P[1-9][0-9]*)|(P0?))$", &Match)
                P := Match[0]
                If S = "" And RegexMatch(Option, "i)^(S0?)$", &Match)
                S := Match[0]
                If T = "" And RegexMatch(Option, "i)^(T([1-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5]))$", &Match)
                T := Match[0]
                If I = "" And RegexMatch(Option, "i)^(I([0-9]|[1-9][0-9]|100))$", &Match)
                I := Match[0]
            }
            If OnOff != "On" And OnOff != "Off"
            OnOff := "On"
            Options := {OnOff: OnOff, B: B, P: P, S: S, T: T, I: I, String: Trim(OnOff . " " . B . " " . P . " " . S . " " . T . " " . I)}
        }
    }
    
    Static SetNoHotkeys(ProgramName, Value) {
        ProgramNumber := Standalone.FindName(ProgramName)
        If ProgramNumber > 0 {
            For ProgramInstance In Standalone.Instances
            If ProgramInstance.ProgramNumber = ProgramNumber
            ProgramInstance.NoHotkeys := Value
            Standalone.List[ProgramNumber]["NoHotkeys"] := Value
            If Value = False
            ReaHotkey.TurnStandaloneHotkeysOn(ProgramName)
            If Value = True
            ReaHotkey.TurnStandaloneHotkeysOff(ProgramName)
        }
    }
    
    Static SetTimer(ProgramName, Function, Period := "", Priority := "") {
        ProgramNumber := Standalone.FindName(ProgramName)
        TimerNumber := Standalone.FindTimer(ProgramName, Function)
        If ProgramNumber > 0 And TimerNumber = 0 And Period != 0 {
            If Period = ""
            Period := 250
            If Priority = ""
            Priority := 0
            Standalone.List[ProgramNumber]["Timers"].Push(Map("Function", Function, "Period", Period, "Priority", Priority, "Enabled", False))
            TimerNumber := Standalone.List[ProgramNumber]["Timers"].Length
        }
        Else {
            If TimerNumber > 0 {
                If Period = ""
                Period := Standalone.List[ProgramNumber]["Timers"][TimerNumber]["Period"]
                If Priority = ""
                Priority := Standalone.List[ProgramNumber]["Timers"][TimerNumber]["Priority"]
                Standalone.List[ProgramNumber]["Timers"][TimerNumber]["Period"] := Period
                Standalone.List[ProgramNumber]["Timers"][TimerNumber]["Priority"] := Priority
            }
        }
        If A_IsSuspended = 0 And TimerNumber > 0 And ReaHotkey.FoundStandalone Is Standalone And ReaHotkey.FoundStandalone.Name = ProgramName {
            Standalone.List[ProgramNumber]["Timers"][TimerNumber]["Enabled"] := True
            SetTimer Function, Period, Priority
        }
        If TimerNumber > 0 And Period = 0
        Standalone.List[ProgramNumber]["Timers"].RemoveAt(TimerNumber)
    }
    
    Class TriggerOverlayHotkey {
        Static Call(HotkeyCommand) {
            If ReaHotkey.FoundStandalone Is Standalone And ReaHotkey.FoundStandalone.Overlay Is AccessibilityOverlay
            ReaHotkey.FoundStandalone.Overlay.TriggerHotkey(HotkeyCommand)
        }
    }
    
}
