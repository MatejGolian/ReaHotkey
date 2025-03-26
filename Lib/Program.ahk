#Requires AutoHotkey v2.0

Class Program {
    
    CheckerFunction := ""
    Chooser := True
    InitFunction := ""
    InstanceNumber := 0
    HotkeyMode := 1
    Name := ""
    Overlay := AccessibilityOverlay()
    Overlays := Array()
    ProgramNumber := 0
    Static ChooserOverlay := AccessibilityOverlay()
    Static DefaultOverlay := AccessibilityOverlay()
    Static Instances := Array()
    Static List := Array()
    Static UnnamedProgramName := "Unnamed Program"
    
    __New(Name) {
        ProgramNumber := %This.__Class%.FindName(Name)
        This.InstanceNumber := %This.__Class%.Instances.Length + 1
        This.%This.__Class%Number := ProgramNumber
        If Name = ""
        This.Name := %This.__Class%.Unnamed%This.__Class%Name
        Else
        This.Name := Name
        If ProgramNumber > 0 {
            ProgramEntry := %This.__Class%.List[ProgramNumber]
            This.InitFunction := ProgramEntry["InitFunction"]
            This.Chooser := ProgramEntry["Chooser"]
            This.HotkeyMode := ProgramEntry["HotkeyMode"]
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
                This.Overlay.AddControl(%This.__Class%.ChooserOverlay.Clone())
                This.Overlay.OverlayNumber := 0
            }
            Else {
                This.Overlay := AccessibilityOverlay()
                This.Overlay.AddControl(%This.__Class%.DefaultOverlay.Clone())
                This.Overlay.OverlayNumber := 0
            }
            %This.__Class%.Instances.Push(This)
            This.Init()
        }
    }
    
    Check() {
        If This.CheckerFunction Is Object And This.CheckerFunction.HasMethod("Call")
        Return This.CheckerFunction.Call(This)
        Return True
    }
    
    GetHotkeys() {
        Return %This.__Class%.GetHotkeys(This.Name)
    }
    
    GetOverlay() {
        Return This.Overlay
    }
    
    GetOverlays() {
        Return This.Overlays
    }
    
    Init() {
        If This.InitFunction Is Object And This.InitFunction.HasMethod("Call")
        This.InitFunction.Call(This)
    }
    
    RegisterOverlay(ProgramOverlay) {
        %This.__Class%.RegisterOverlay(This.Name, ProgramOverlay)
    }
    
    RegisterOverlayHotkeys(ProgramOverlay) {
        %This.__Class%.RegisterOverlayHotkeys(This.Name, ProgramOverlay)
    }
    
    SetHotkey(KeyName, Action := "", Options := "") {
        %This.__Class%.SetHotkey(This.Name, KeyName, Action, Options)
    }
    
    SetHotkeyMode(Value) {
        %This.Base.__Class%.SetHotkeyMode(This.Name, Value)
        }
    
    SetTimer(Function, Period := "", Priority := "") {
        %This.__Class%.SetTimer(This.Name, Function, Period, Priority)
    }
    
    Static FindHotkey(ProgramName, KeyName) {
        ProgramNumber := This.FindName(ProgramName)
        If ProgramNumber > 0
        For HotkeyNumber, HotkeyParams In This.List[ProgramNumber]["Hotkeys"]
        If HotkeyParams["KeyName"] = KeyName
        Return HotkeyNumber
        Return 0
    }
    
    Static FindName(ProgramName) {
        For ProgramNumber, ProgramEntry In This.List
        If ProgramEntry["Name"] = ProgramName
        Return ProgramNumber
        Return 0
    }
    
    Static FindTimer(ProgramName, Function) {
        ProgramNumber := This.FindName(ProgramName)
        If ProgramNumber > 0
        For TimerNumber, TimerParams In This.List[ProgramNumber]["Timers"]
        If TimerParams["Function"] = Function
        Return TimerNumber
        Return 0
    }
    
    Static GetHotkeyOptions(Options) {
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
        If Not OnOff = "On" And Not OnOff = "Off"
        OnOff := "On"
        Options := {OnOff: OnOff, B: B, P: P, S: S, T: T, I: I, String: Trim(OnOff . " " . B . " " . P . " " . S . " " . T . " " . I)}
        Return Options
    }
    
    Static GetHotkeys(ProgramName) {
        ProgramNumber := This.FindName(ProgramName)
        If ProgramNumber > 0
        Return This.List[ProgramNumber]["Hotkeys"]
        Return Array()
    }
    
    Static GetList() {
        Return This.List
    }
    
    Static GetOverlays(ProgramName) {
        ProgramNumber := This.FindName(ProgramName)
        If ProgramNumber > 0
        Return This.List[ProgramNumber]["Overlays"]
        Return Array()
    }
    
    Static GetTimers(ProgramName) {
        ProgramNumber := This.FindName(ProgramName)
        If ProgramNumber > 0
        Return This.List[ProgramNumber]["Timers"]
        Return Array()
    }
    
    Static Register(ProgramName, InitFunction := False, Chooser := False, HotkeyMode := 1, CheckerFunction := False) {
        If This.FindName(ProgramName) = False {
            If ProgramName = ""
            ProgramName := %This.Prototype.__Class%.Unnamed%This.Prototype.__Class%Name
            If Not InitFunction Is Object Or Not InitFunction.HasMethod("Call")
            InitFunction := False
            If Not Chooser = True And Not Chooser = False
            Chooser := False
            If Not HotkeyMode Is Integer Or HotkeyMode < 1 Or HotkeyMode > 3
            HotkeyMode := 1
            If Not CheckerFunction Is Object Or Not CheckerFunction.HasMethod("Call")
            CheckerFunction := %This.Prototype.__Class%.DefaultChecker
            ProgramEntry := Map()
            ProgramEntry["Name"] := ProgramName
            ProgramEntry["InitFunction"] := InitFunction
            ProgramEntry["Chooser"] := Chooser
            ProgramEntry["HotkeyMode"] := HotkeyMode
            ProgramEntry["CheckerFunction"] := CheckerFunction
            ProgramEntry["Hotkeys"] := Array()
            ProgramEntry["Overlays"] := Array()
            ProgramEntry["Timers"] := Array()
            %This.Prototype.__Class%.List.Push(ProgramEntry)
            Return True
        }
        Return False
    }
    
    Static RegisterOverlay(ProgramName, ProgramOverlay) {
        ProgramNumber := This.FindName(ProgramName)
        If ProgramNumber > 0 {
            ProgramOverlay.OverlayNumber := This.List[ProgramNumber]["Overlays"].Length + 1
            This.List[ProgramNumber]["Overlays"].Push(ProgramOverlay.Clone())
            For ProgramInstance In This.Instances
            If ProgramName = ProgramInstance.Name
            ProgramInstance.Overlays.Push(ProgramOverlay.Clone())
            This.RegisterOverlayHotkeys(ProgramName, ProgramOverlay)
        }
    }
    
    Static RegisterOverlayHotkeys(ProgramName, ProgramOverlay) {
        ProgramNumber := This.FindName(ProgramName)
        If ProgramNumber > 0 And ProgramOverlay Is AccessibilityOverlay
        For OverlayHotkey In ProgramOverlay.GetHotkeys()
        This.SetHotkey(ProgramName, OverlayHotkey)
    }
    
    Static SetHotkey(ProgramName, KeyName, Action := "", Options := "") {
        ProgramNumber := This.FindName(ProgramName)
        HotkeyNumber := This.FindHotkey(ProgramName, KeyName)
        If ProgramNumber > 0 And HotkeyNumber = 0 {
            If Not Action Is Object
            Options := Action . " " . Options
            Options := This.GetHotkeyOptions(Options)
            If Not Action Is Object
            Action := This.TriggerOverlayHotkey
            This.List[ProgramNumber]["Hotkeys"].Push(Map("KeyName", KeyName, "Action", Action, "Options", Options.String, "State", Options.OnOff))
        }
        Else If HotkeyNumber > 0 {
            CurrentAction := This.List[ProgramNumber]["Hotkeys"][HotkeyNumber]["Action"]
            CurrentOptions := This.List[ProgramNumber]["Hotkeys"][HotkeyNumber]["Options"]
            If Not Action Is Object
            Options := Action . " " . Options
            Options := Options . " " . CurrentOptions
            Options := This.GetHotkeyOptions(Options)
            If Not Action Is Object
            Action := CurrentAction
            This.List[ProgramNumber]["Hotkeys"][HotkeyNumber]["Action"] := Action
            This.List[ProgramNumber]["Hotkeys"][HotkeyNumber]["Options"] := Options.String
            This.List[ProgramNumber]["Hotkeys"][HotkeyNumber]["State"] := Options.OnOff
        }
        Else {
            Return False
        }
        Return True
    }
    
    Static SetHotkeyMode(ProgramName, Value) {
        ProgramNumber := This.FindName(ProgramName)
        If ProgramNumber > 0 {
            For ProgramInstance In This.Instances
            If ProgramInstance.%This.Prototype.__Class%Number = ProgramNumber
            ProgramInstance.HotkeyMode := Value
            This.List[ProgramNumber]["HotkeyMode"] := Value
            ReaHotkey.Turn%This.Prototype.__Class%HotkeysOff(ProgramName)
            ReaHotkey.Turn%This.Prototype.__Class%HotkeysOn(ProgramName)
        }
    }
    
    Static SetTimer(ProgramName, Function, Period := "", Priority := "") {
        ProgramNumber := This.FindName(ProgramName)
        TimerNumber := This.FindTimer(ProgramName, Function)
        If ProgramNumber > 0 And TimerNumber = 0 And Not Period = 0 {
            If Period = ""
            Period := 250
            If Priority = ""
            Priority := 0
            This.List[ProgramNumber]["Timers"].Push(Map("Function", Function, "Period", Period, "Priority", Priority, "Enabled", False))
            TimerNumber := This.List[ProgramNumber]["Timers"].Length
        }
        Else {
            If TimerNumber > 0 {
                If Period = ""
                Period := This.List[ProgramNumber]["Timers"][TimerNumber]["Period"]
                If Priority = ""
                Priority := This.List[ProgramNumber]["Timers"][TimerNumber]["Priority"]
                This.List[ProgramNumber]["Timers"][TimerNumber]["Period"] := Period
                This.List[ProgramNumber]["Timers"][TimerNumber]["Priority"] := Priority
            }
        }
        If ReaHotkey.HasOwnProp("Found" . This.Prototype.__Class)
        If A_IsSuspended = 0 And TimerNumber > 0 And ReaHotkey.Found%This.Prototype.__Class% Is %This.Prototype.__Class% And ReaHotkey.Found%This.Prototype.__Class%.Name = ProgramName {
            This.List[ProgramNumber]["Timers"][TimerNumber]["Enabled"] := True
            SetTimer Function, Period, Priority
        }
        If TimerNumber > 0 And Period = 0
        This.List[ProgramNumber]["Timers"].RemoveAt(TimerNumber)
    }
    
    Class DefaultChecker {
        Static Call(*) {
            Return True
        }
    }
    
    Class TriggerOverlayHotkey {
        Static Call(ThisHotkey) {
            PassThroughHotkey(ThisHotkey)
        }
    }
    
}
