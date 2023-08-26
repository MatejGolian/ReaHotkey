#Requires AutoHotkey v2.0

Class Standalone {
    
    Chooser := True
    InitFunction := ""
    Name := ""
    Overlay := AccessibilityOverlay()
    Overlays := Array()
    WindowID := ""
    Static ChooserOverlay := AccessibilityOverlay()
    Static DefaultOverlay := AccessibilityOverlay()
    Static Instances := Array()
    Static List := Array()
    Static UnnamedProgramName := "Unnamed Program"
    
    __New(Name, WindowID, InitFunction := "", Chooser := True) {
        If Name == ""
        This.Name := Standalone.UnnamedProgramName
        Else
        This.Name := Name
        This.WindowID := WindowID
        This.InitFunction := InitFunction
        If Chooser == True Or Chooser == False
        This.Chooser := Chooser
        Else
        This.Chooser := True
        For Number, Overlay In Standalone.GetOverlays(Name) {
            This.Overlays.Push(Overlay.Clone())
            This.Overlays[Number].OverlayNumber := Number
        }
        If This.Overlays.Length == 1 {
            This.Overlay := This.Overlays[1].Clone()
        }
        Else If This.Overlays.Length > 1 And This.Chooser == False {
            This.Overlay := This.Overlays[1].Clone()
        }
        Else If This.Overlays.Length > 1 And This.Chooser == True {
            This.Overlay := AccessibilityOverlay()
            This.Overlay.AddControl(Standalone.ChooserOverlay.Clone())
            This.Overlay.OverlayNumber := 0
        }
        Else {
            This.Overlay := AccessibilityOverlay()
            This.Overlay.AddControl(Standalone.DefaultOverlay.Clone())
            This.Overlay.OverlayNumber := 0
        }
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
        If This.InitFunction != ""
        %This.InitFunction.Name%(This)
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
        If HotkeyParams["KeyName"] == KeyName
        Return HotkeyNumber
        Return 0
    }
    
    Static FindName(ProgramName) {
        For ProgramNumber, ProgramEntry In Standalone.List
        If ProgramEntry["Name"] == ProgramName
        Return ProgramNumber
        Return 0
    }
    
    Static FindTimer(ProgramName, Function) {
        ProgramNumber := Standalone.FindName(ProgramName)
        If ProgramNumber > 0
        For TimerNumber, TimerParams In Standalone.List[ProgramNumber]["Timers"]
        If TimerParams["Function"] == Function
        Return TimerNumber
        Return 0
    }
    
    Static GetByWindowID(WinID) {
        For ProgramInstance In Standalone.Instances
        If ProgramInstance.WindowID == WinID
        Return ProgramInstance
        ProgramNumber := Standalone.FindByActiveWindow()
        If ProgramNumber != False {
            ProgramInstance := Standalone(Standalone.List[ProgramNumber]["Name"], WinGetID("A"), Standalone.List[ProgramNumber]["InitFunction"], Standalone.List[ProgramNumber]["Chooser"])
            Standalone.Instances.Push(ProgramInstance)
            ProgramInstance.Init()
            Return ProgramInstance
        }
        Return Standalone("", WinID)
    }
    
    Static GetHotkeys(ProgramName) {
        ProgramNumber := Standalone.FindName(ProgramName)
        If ProgramNumber > 0
        Return Standalone.List[ProgramNumber]["Hotkeys"]
        Return Array()
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
    
    Static SetHotkey(ProgramName, KeyName, Action := "", Options := "") {
        ProgramNumber := Standalone.FindName(ProgramName)
        HotkeyNumber := Standalone.FindHotkey(ProgramName, KeyName)
        If ProgramNumber > 0 And HotkeyNumber == 0 {
            BackupAction := Action
            OnOff := ""
            B := ""
            P := ""
            S := ""
            T := ""
            I := ""
            HotkeyOptions := StrSplit(Options, [A_Space, A_Tab])
            Match := ""
            For Option In HotkeyOptions {
                If RegexMatch(Option, "i)^((On)|(Off))$", &Match)
                OnOff := Match[0]
                If RegexMatch(Option, "i)^(B0?)$", &Match)
                B := Match[0]
                If RegexMatch(Option, "i)^((P[1-9][0-9]*)|(P0?))$", &Match)
                P := Match[0]
                If RegexMatch(Option, "i)^(S0?)$", &Match)
                S := Match[0]
                If RegexMatch(Option, "i)^(T([1-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5]))$", &Match)
                T := Match[0]
                If RegexMatch(Option, "i)^(I([0-9]|[1-9][0-9]|100))$", &Match)
                I := Match[0]
            }
            Options := Trim(OnOff . " " . B . " " . P . " " . S . " " . T . " " . I)
            If OnOff = "Off"
            Action := "Off"
            Standalone.List[ProgramNumber]["Hotkeys"].Push(Map("KeyName", KeyName, "Action", Action, "Options", Options, "BackupAction", BackupAction))
        }
        Else {
            If HotkeyNumber > 0 {
                If Action == ""
                Action := Standalone.List[ProgramNumber]["Hotkeys"][HotkeyNumber]["Action"]
                If Options == ""
                Options := Standalone.List[ProgramNumber]["Hotkeys"][HotkeyNumber]["Options"]
                If Action != Standalone.List[ProgramNumber]["Hotkeys"][HotkeyNumber]["Action"] {
                    If Action Is Object {
                        If Standalone.List[ProgramNumber]["Hotkeys"][HotkeyNumber]["Action"] != "Off" {
                            Standalone.List[ProgramNumber]["Hotkeys"][HotkeyNumber]["BackupAction"] := Action
                        }
                        Else {
                            Standalone.List[ProgramNumber]["Hotkeys"][HotkeyNumber]["BackupAction"] := Action
                            Action := "Off"
                        }
                    }
                    Else {
                        If Trim(Action) = "Toggle" {
                            If Standalone.List[ProgramNumber]["Hotkeys"][HotkeyNumber]["Action"] = "Off"
                            Action := "On"
                            Else
                            Action := "Off"
                        }
                        If Trim(Action) = "On"
                        Action := Standalone.List[ProgramNumber]["Hotkeys"][HotkeyNumber]["BackupAction"]
                        If Not Action Is Object And Trim(Action) = "Off"
                        If Standalone.List[ProgramNumber]["Hotkeys"][HotkeyNumber]["Action"] != "On" And Standalone.List[ProgramNumber]["Hotkeys"][HotkeyNumber]["Action"] != "Off"
                        Standalone.List[ProgramNumber]["Hotkeys"][HotkeyNumber]["BackupAction"] := Standalone.List[ProgramNumber]["Hotkeys"][HotkeyNumber]["Action"]
                        If                Not Action Is Object {
                            Action := Trim(Action)
                            If Action != "On" And Action != "Off"
                            Standalone.List[ProgramNumber]["Hotkeys"][HotkeyNumber]["BackupAction"] := Action
                        }
                    }
                }
                If Options != Standalone.List[ProgramNumber]["Hotkeys"][HotkeyNumber]["Options"] {
                    OnOff := ""
                    B := ""
                    P := ""
                    S := ""
                    T := ""
                    I := ""
                    CurrentOptions := StrSplit(Standalone.List[ProgramNumber]["Hotkeys"][HotkeyNumber]["Options"], [A_Space, A_Tab])
                    NewOptions := StrSplit(Options, [A_Space, A_Tab])
                    Match := ""
                    For Option In CurrentOptions {
                        If RegexMatch(Option, "i)^((On)|(Off))$", &Match)
                        OnOff := Match[0]
                        If RegexMatch(Option, "i)^(B0?)$", &Match)
                        B := Match[0]
                        If RegexMatch(Option, "i)^((P[1-9][0-9]*)|(P0?))$", &Match)
                        P := Match[0]
                        If RegexMatch(Option, "i)^(S0?)$", &Match)
                        S := Match[0]
                        If RegexMatch(Option, "i)^(T([1-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5]))$", &Match)
                        T := Match[0]
                        If RegexMatch(Option, "i)^(I([0-9]|[1-9][0-9]|100))$", &Match)
                        I := Match[0]
                    }
                    For Option In NewOptions {
                        If RegexMatch(Option, "i)^((On)|(Off))$", &Match)
                        OnOff := Match[0]
                        If RegexMatch(Option, "i)^(B0?)$", &Match)
                        B := Match[0]
                        If RegexMatch(Option, "i)^((P[1-9][0-9]*)|(P0?))$", &Match)
                        P := Match[0]
                        If RegexMatch(Option, "i)^(S0?)$", &Match)
                        S := Match[0]
                        If RegexMatch(Option, "i)^(T([1-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5]))$", &Match)
                        T := Match[0]
                        If RegexMatch(Option, "i)^(I([0-9]|[1-9][0-9]|100))$", &Match)
                        I := Match[0]
                    }
                    Options := Trim(OnOff . " " . B . " " . P . " " . S . " " . T . " " . I)
                    If OnOff = "On"
                    Action := Standalone.List[ProgramNumber]["Hotkeys"][HotkeyNumber]["BackupAction"]
                    If OnOff = "Off" {
                        Action := "Off"
                        If Standalone.List[ProgramNumber]["Hotkeys"][HotkeyNumber]["Action"] != "On" And Standalone.List[ProgramNumber]["Hotkeys"][HotkeyNumber]["Action"] != "Off"
                        Standalone.List[ProgramNumber]["Hotkeys"][HotkeyNumber]["BackupAction"] := Standalone.List[ProgramNumber]["Hotkeys"][HotkeyNumber]["Action"]
                    }
                }
                Standalone.List[ProgramNumber]["Hotkeys"][HotkeyNumber]["Action"] := Action
                Standalone.List[ProgramNumber]["Hotkeys"][HotkeyNumber]["Options"] := Options
            }
        }
    }
    
    Static SetTimer(ProgramName, Function, Period := "", Priority := "") {
        ProgramNumber := Standalone.FindName(ProgramName)
        TimerNumber := Standalone.FindTimer(ProgramName, Function)
        If ProgramNumber > 0 And TimerNumber == 0 {
            If Period == ""
            Period := 250
            If Priority == ""
            Priority := 0
            Standalone.List[ProgramNumber]["Timers"].Push(Map("Function", Function, "Period", Period, "Priority", Priority, "Enabled", False))
        }
        Else {
            If TimerNumber > 0 {
                If Period == ""
                Period := Standalone.List[ProgramNumber]["Timers"][TimerNumber]["Period"]
                If Priority == ""
                Priority := Standalone.List[ProgramNumber]["Timers"][TimerNumber]["Priority"]
                Standalone.List[ProgramNumber]["Timers"][TimerNumber]["Period"] := Period
                Standalone.List[ProgramNumber]["Timers"][TimerNumber]["Priority"] := Priority
            }
        }
    }
    
    Static Register(ProgramName, WinCriteria, InitFunction := "", Chooser := True) {
        If Standalone.FindName(ProgramName) == False {
            If ProgramName == ""
            ProgramName := Standalone.UnnamedProgramName
            If Chooser != True And Chooser != False
            Chooser := True
            ProgramEntry := Map()
            ProgramEntry["Name"] := ProgramName
            If WinCriteria Is Array
            ProgramEntry["WinCriteria"] := WinCriteria
            Else
            ProgramEntry["WinCriteria"] := Array(WinCriteria)
            ProgramEntry["InitFunction"] := InitFunction
            ProgramEntry["Chooser"] := Chooser
            ProgramEntry["Hotkeys"] := Array()
            ProgramEntry["Overlays"] := Array()
            ProgramEntry["Timers"] := Array()
            Standalone.List.Push(ProgramEntry)
        }
    }
    
    Static RegisterOverlay(ProgramName, ProgramOverlay) {
        ProgramNumber := Standalone.FindName(ProgramName)
        If ProgramNumber > 0
        Standalone.List[ProgramNumber]["Overlays"].Push(ProgramOverlay.Clone())
    }
    
}
