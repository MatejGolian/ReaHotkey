#Requires AutoHotkey v2.0

Class Standalone {
    
    FocusFunction := ""
    Name := ""
    Overlay := AccessibilityOverlay()
    WindowID := ""
    Static ChooserOverlay := AccessibilityOverlay()
    Static DefaultOverlay := AccessibilityOverlay()
    Static Instances := Array()
    Static List := Array()
    Static UnnamedProgramName := "Unnamed Program"
    
    __New(Name, WindowID, FocusFunction := "") {
        If Name == ""
        This.Name := Standalone.UnnamedProgramName
        Else
        This.Name := Name
        This.WindowID := WindowID
        This.FocusFunction := FocusFunction
        Overlays := Standalone.GetOverlays(Name)
        If Overlays.Length == 1 {
            This.Overlay := Overlays[1].Clone()
        }
        Else If Overlays.Length > 1 {
            This.Overlay := AccessibilityOverlay()
            This.Overlay.AddControl(Standalone.ChooserOverlay.Clone())
        }
        Else {
            This.Overlay := AccessibilityOverlay()
            This.Overlay.AddControl(Standalone.DefaultOverlay.Clone())
        }
    }
    
    Focus() {
        If This.FocusFunction != ""
        %this.FocusFunction%()
    }
    
    GetOverlay() {
    Return This.Overlay
    }
    
    GetOverlays() {
    Return Standalone.GetOverlays(This.Name)
    }
    
    Static FindCriteria(WinCriteria) {
    For ProgramNumber, ProgramEntry In Standalone.List {
    If ProgramEntry["WinCriteria"] != ""
    If RegExMatch(WinCriteria, ProgramEntry["WinCriteria"])
    Return ProgramNumber
    }
    Return False
    }
    
    Static FindName(ProgramName) {
    For ProgramNumber, ProgramEntry In Standalone.List
    If ProgramEntry["Name"] == ProgramName
    Return ProgramNumber
    Return False
    }
    
    Static Get(WinCriteria, WinID) {
    For ProgramInstance In Standalone.Instances
    If ProgramInstance.WindowID == WinID
    Return ProgramInstance
    ProgramNumber := Standalone.FindCriteria(WinCriteria)
    If ProgramNumber != False {
    ProgramInstance := Standalone(Standalone.List[ProgramNumber]["Name"], WinGetID("A"), Standalone.List[ProgramNumber]["FocusFunction"])
    Standalone.Instances.Push(ProgramInstance)
    Return ProgramInstance
    }
    Return Standalone("", WinID)
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
    
    Static Register(ProgramName, WinCriteria, FocusFunction := "") {
    If Standalone.FindName(ProgramName) == False {
    If ProgramName == ""
    ProgramName := Standalone.UnnamedProgramName
    ProgramEntry := Map()
    ProgramEntry["Name"] := ProgramName
    ProgramEntry["WinCriteria"] := WinCriteria
    ProgramEntry["FocusFunction"] := FocusFunction
    ProgramEntry["Overlays"] := Array()
    Standalone.List.Push(ProgramEntry)
    }
    }
    
    Static RegisterOverlay(ProgramName, ProgramOverlay) {
    ProgramNumber := Standalone.FindName(ProgramName)
    If ProgramNumber > 0
    Standalone.List[ProgramNumber]["Overlays"].Push(ProgramOverlay)
    }
    
    }
        