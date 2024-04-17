#Requires AutoHotkey v2.0

Class Plugin {
    
    CheckerFunction := ""
    Chooser := True
    ControlClass := ""
    InitFunction := ""
    Name := ""
    InstanceNumber := 0
    PluginNumber := 0
    NoHotkeys := False
    Overlay := AccessibilityOverlay()
    Overlays := Array()
    SingleInstance := False
    Static ChooserOverlay := AccessibilityOverlay()
    Static DefaultOverlay := AccessibilityOverlay()
    Static Instances := Array()
    Static List := Array()
    Static UnnamedPluginName := "Unnamed Plugin"
    
    __New(Name, ControlClass) {
        PluginNumber := Plugin.FindName(Name)
        This.InstanceNumber := Plugin.Instances.Length + 1
        This.PluginNumber := PluginNumber
        If Name = ""
        This.Name := Plugin.UnnamedPluginName
        Else
        This.Name := Name
        This.ControlClass := ControlClass
        If PluginNumber > 0 {
            PluginEntry := Plugin.List[PluginNumber]
            This.InitFunction := PluginEntry["InitFunction"]
            This.Chooser := PluginEntry["Chooser"]
            This.NoHotkeys := PluginEntry["NoHotkeys"]
            This.SingleInstance := PluginEntry["SingleInstance"]
            This.CheckerFunction := PluginEntry["CheckerFunction"]
            For OverlayNumber, Overlay In PluginEntry["Overlays"]
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
                This.Overlay.AddControl(Plugin.ChooserOverlay.Clone())
                This.Overlay.OverlayNumber := 0
            }
            Else {
                This.Overlay := AccessibilityOverlay()
                This.Overlay.AddControl(Plugin.DefaultOverlay.Clone())
                This.Overlay.OverlayNumber := 0
            }
            Plugin.Instances.Push(This)
            This.Init()
        }
    }
    
    Check() {
        If This.CheckerFunction Is Func
        Return This.CheckerFunction.Call(This)
        Return True
    }
    
    GetHotkeys() {
        Return Plugin.GetHotkeys(This.Name)
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
    
    RegisterOverlay(PluginOverlay) {
        Plugin.RegisterOverlay(This.Name, PluginOverlay)
    }
    
    RegisterOverlayHotkeys(PluginOverlay) {
        Plugin.RegisterOverlayHotkeys(This.Name, PluginOverlay)
    }
    
    SetHotkey(KeyName, Action := "", Options := "") {
        Plugin.SetHotkey(This.Name, KeyName, Action, Options)
    }
    
    SetTimer(Function, Period := "", Priority := "") {
        Plugin.SetTimer(This.Name, Function, Period, Priority)
    }
    
    Static DefaultChecker(*) {
        Return True
    }
    
    Static FindClass(ClassName) {
        PluginNumbers := Array()
        For PluginNumber, PluginEntry In Plugin.List {
            If PluginEntry["ControlClasses"] Is Array And PluginEntry["ControlClasses"].Length > 0
            For ControlClass In PluginEntry["ControlClasses"]
            If RegExMatch(ClassName, ControlClass)
            PluginNumbers.Push(PluginNumber)
        }
        Return PluginNumbers
    }
    
    Static FindHotkey(PluginName, KeyName) {
        PluginNumber := Plugin.FindName(PluginName)
        If PluginNumber > 0
        For HotkeyNumber, HotkeyParams In Plugin.List[PluginNumber]["Hotkeys"]
        If HotkeyParams["KeyName"] = KeyName
        Return HotkeyNumber
        Return 0
    }
    
    Static FindName(PluginName) {
        For PluginNumber, PluginEntry In Plugin.List
        If PluginEntry["Name"] = PluginName
        Return PluginNumber
        Return 0
    }
    
    Static FindTimer(PluginName, Function) {
        PluginNumber := Plugin.FindName(PluginName)
        If PluginNumber > 0
        For TimerNumber, TimerParams In Plugin.List[PluginNumber]["Timers"]
        If TimerParams["Function"] = Function
        Return TimerNumber
        Return 0
    }
    
    Static GetByClass(ControlClass) {
        PluginNumbers := Plugin.FindClass(ControlClass)
        If PluginNumbers.Length > 0 {
            FirstValidNumber := 0
            For PluginNumber In PluginNumbers {
                If FirstValidNumber = 0
                For ItemNumber In PluginNumbers
                If Plugin.List[ItemNumber]["CheckerFunction"].Call(Plugin.List[ItemNumber]) = True
                FirstValidNumber := ItemNumber
                PluginName := Plugin.List[PluginNumber]["Name"]
                SingleInstance := Plugin.List[PluginNumber]["SingleInstance"]
                If SingleInstance = True {
                    For PluginInstance In Plugin.Instances
                    If PluginInstance.PluginNumber = PluginNumber And PluginInstance.Check() = True {
                        PluginInstance.ControlClass := ControlClass
                        Return PluginInstance
                    }
                }
                Else {
                    For PluginInstance In Plugin.Instances
                    If PluginInstance.PluginNumber = PluginNumber And PluginInstance.ControlClass = ControlClass And PluginInstance.Check() = True {
                        Return PluginInstance
                    }
                }
            }
            If FirstValidNumber > 0 {
                PluginInstance := Plugin(Plugin.List[FirstValidNumber]["Name"], ControlClass)
                Return PluginInstance
            }
        }
        Return False
    }
    
    Static GetHotkeys(PluginName) {
        PluginNumber := Plugin.FindName(PluginName)
        If PluginNumber > 0
        Return Plugin.List[PluginNumber]["Hotkeys"]
        Return Array()
    }
    
    Static GetInstance(ControlClass) {
        For PluginInstance In Plugin.Instances
        If PluginInstance.ControlClass = ControlClass
        Return PluginInstance
        Return False
    }
    
    Static GetList() {
        Return Plugin.List
    }
    
    Static GetOverlays(PluginName) {
        PluginNumber := Plugin.FindName(PluginName)
        If PluginNumber > 0
        Return Plugin.List[PluginNumber]["Overlays"]
        Return Array()
    }
    
    Static GetTimers(PluginName) {
        PluginNumber := Plugin.FindName(PluginName)
        If PluginNumber > 0
        Return Plugin.List[PluginNumber]["Timers"]
        Return Array()
    }
    
    Static Instantiate(PluginName, ControlClass) {
        PluginNumber := Plugin.FindName(PluginName)
        If PluginNumber > 0 {
            SingleInstance := Plugin.List[PluginNumber]["SingleInstance"]
            If SingleInstance = True {
                For PluginInstance In Plugin.Instances
                If PluginInstance.PluginNumber = PluginNumber
                Return PluginInstance
            }
            Else {
                For PluginInstance In Plugin.Instances
                If PluginInstance.PluginNumber = PluginNumber And PluginInstance.ControlClass = ControlClass
                Return PluginInstance
            }
            PluginInstance := Plugin(PluginName, ControlClass)
            Return PluginInstance
        }
        Return False
    }
    
    Static Register(PluginName, ControlClasses, InitFunction := "", Chooser := True, NoHotkeys := False, SingleInstance := True, CheckerFunction := "") {
        If Plugin.FindName(PluginName) = False {
            If PluginName = ""
            PluginName := Plugin.UnnamedPluginName
            If Chooser != True And Chooser != False
            Chooser := False
            If NoHotkeys != True And NoHotkeys != False
            NoHotkeys := False
            If SingleInstance != True And SingleInstance != False
            SingleInstance := True
            If Not CheckerFunction Is Func
            CheckerFunction := ObjBindMethod(Plugin, "DefaultChecker")
            PluginEntry := Map()
            PluginEntry["Name"] := PluginName
            If ControlClasses Is Array
            PluginEntry["ControlClasses"] := ControlClasses
            Else
            PluginEntry["ControlClasses"] := Array(ControlClasses)
            PluginEntry["InitFunction"] := InitFunction
            PluginEntry["Chooser"] := Chooser
            PluginEntry["NoHotkeys"] := NoHotkeys
            PluginEntry["SingleInstance"] := SingleInstance
            PluginEntry["CheckerFunction"] := CheckerFunction
            PluginEntry["Hotkeys"] := Array()
            PluginEntry["Overlays"] := Array()
            PluginEntry["Timers"] := Array()
            Plugin.List.Push(PluginEntry)
        }
    }
    
    Static RegisterOverlay(PluginName, PluginOverlay) {
        PluginNumber := Plugin.FindName(PluginName)
        If PluginNumber > 0 {
            PluginOverlay.OverlayNumber := Plugin.List[PluginNumber]["Overlays"].Length + 1
            Plugin.List[PluginNumber]["Overlays"].Push(PluginOverlay.Clone())
            For PluginInstance In Plugin.Instances
            If PluginName = PluginInstance.Name {
                PluginInstance.Overlays.Push(PluginOverlay.Clone())
                Plugin.RegisterOverlayHotkeys(PluginName, PluginOverlay)
            }
        }
    }
    
    Static RegisterOverlayHotkeys(PluginName, PluginOverlay) {
        PluginNumber := Plugin.FindName(PluginName)
        If PluginNumber > 0 And PluginOverlay Is AccessibilityOverlay
        For OverlayHotkey In PluginOverlay.GetHotkeys()
        Plugin.SetHotkey(PluginName, OverlayHotkey)
    }
    
    Static SetHotkey(PluginName, KeyName, Action := "", Options := "") {
        PluginNumber := Plugin.FindName(PluginName)
        HotkeyNumber := Plugin.FindHotkey(PluginName, KeyName)
        If PluginNumber > 0 And HotkeyNumber = 0 {
            If Action = ""
            Action := Plugin.TriggerOverlayHotkey
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
            Plugin.List[PluginNumber]["Hotkeys"].Push(Map("KeyName", KeyName, "Action", Action, "Options", Options, "BackupAction", BackupAction))
        }
        Else {
            If HotkeyNumber > 0 {
                If Action = ""
                Action := Plugin.List[PluginNumber]["Hotkeys"][HotkeyNumber]["Action"]
                If Options = ""
                Options := Plugin.List[PluginNumber]["Hotkeys"][HotkeyNumber]["Options"]
                If Action != Plugin.List[PluginNumber]["Hotkeys"][HotkeyNumber]["Action"] {
                    If Action Is Object {
                        If Plugin.List[PluginNumber]["Hotkeys"][HotkeyNumber]["Action"] != "Off" {
                            Plugin.List[PluginNumber]["Hotkeys"][HotkeyNumber]["BackupAction"] := Action
                        }
                        Else {
                            Plugin.List[PluginNumber]["Hotkeys"][HotkeyNumber]["BackupAction"] := Action
                            Action := "Off"
                        }
                    }
                    Else {
                        If Trim(Action) = "Toggle" {
                            If Plugin.List[PluginNumber]["Hotkeys"][HotkeyNumber]["Action"] = "Off"
                            Action := "On"
                            Else
                            Action := "Off"
                        }
                        If Trim(Action) = "On"
                        Action := Plugin.List[PluginNumber]["Hotkeys"][HotkeyNumber]["BackupAction"]
                        If Not Action Is Object And Trim(Action) = "Off"
                        If Plugin.List[PluginNumber]["Hotkeys"][HotkeyNumber]["Action"] != "On" And Plugin.List[PluginNumber]["Hotkeys"][HotkeyNumber]["Action"] != "Off"
                        Plugin.List[PluginNumber]["Hotkeys"][HotkeyNumber]["BackupAction"] := Plugin.List[PluginNumber]["Hotkeys"][HotkeyNumber]["Action"]
                        If                Not Action Is Object {
                            Action := Trim(Action)
                            If Action != "On" And Action != "Off"
                            Plugin.List[PluginNumber]["Hotkeys"][HotkeyNumber]["BackupAction"] := Action
                        }
                    }
                }
                If Options != Plugin.List[PluginNumber]["Hotkeys"][HotkeyNumber]["Options"] {
                    OnOff := ""
                    B := ""
                    P := ""
                    S := ""
                    T := ""
                    I := ""
                    CurrentOptions := StrSplit(Plugin.List[PluginNumber]["Hotkeys"][HotkeyNumber]["Options"], [A_Space, A_Tab])
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
                    Action := Plugin.List[PluginNumber]["Hotkeys"][HotkeyNumber]["BackupAction"]
                    If OnOff = "Off" {
                        Action := "Off"
                        If Plugin.List[PluginNumber]["Hotkeys"][HotkeyNumber]["Action"] != "On" And Plugin.List[PluginNumber]["Hotkeys"][HotkeyNumber]["Action"] != "Off"
                        Plugin.List[PluginNumber]["Hotkeys"][HotkeyNumber]["BackupAction"] := Plugin.List[PluginNumber]["Hotkeys"][HotkeyNumber]["Action"]
                    }
                }
                Plugin.List[PluginNumber]["Hotkeys"][HotkeyNumber]["Action"] := Action
                Plugin.List[PluginNumber]["Hotkeys"][HotkeyNumber]["Options"] := Options
            }
        }
    }
    
    Static SetTimer(PluginName, Function, Period := "", Priority := "") {
        PluginNumber := Plugin.FindName(PluginName)
        TimerNumber := Plugin.FindTimer(PluginName, Function)
        If PluginNumber > 0 And TimerNumber = 0 {
            If Period = ""
            Period := 250
            If Priority = ""
            Priority := 0
            Plugin.List[PluginNumber]["Timers"].Push(Map("Function", Function, "Period", Period, "Priority", Priority, "Enabled", False))
        }
        Else {
            If TimerNumber > 0 {
                If Period = ""
                Period := Plugin.List[PluginNumber]["Timers"][TimerNumber]["Period"]
                If Priority = ""
                Priority := Plugin.List[PluginNumber]["Timers"][TimerNumber]["Priority"]
                Plugin.List[PluginNumber]["Timers"][TimerNumber]["Period"] := Period
                Plugin.List[PluginNumber]["Timers"][TimerNumber]["Priority"] := Priority
            }
        }
    }
    
    Class TriggerOverlayHotkey {
        Static Call(HotkeyCommand) {
            If ReaHotkey.FoundPlugin Is Plugin And ReaHotkey.FoundPlugin.Overlay Is AccessibilityOverlay
            ReaHotkey.FoundPlugin.Overlay.TriggerHotkey(HotkeyCommand)
        }
    }
    
}
