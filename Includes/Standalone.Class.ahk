#Requires AutoHotkey v2.0

Class Standalone {
    
    Chooser := True
    Name := ""
    Overlay := AccessibilityOverlay()
    Overlays := Array()
    WindowID := ""
    Static ChooserOverlay := AccessibilityOverlay()
    Static DefaultOverlay := AccessibilityOverlay()
    Static Instances := Array()
    Static List := Array()
    Static UnnamedProgramName := "Unnamed Program"
    
    __New(Name, WindowID, Chooser := True) {
        If Name == ""
        This.Name := Standalone.UnnamedProgramName
        Else
        This.Name := Name
        This.WindowID := WindowID
        If Chooser == True Or Chooser == False
        This.Chooser := Chooser
        Else
        This.Chooser := True
        This.Overlays := Standalone.GetOverlays(Name)
        If This.Overlays.Length == 1 {
            This.Overlay := This.Overlays[1].Clone()
        }
        Else If This.Overlays.Length > 1 And This.Chooser == False {
            This.Overlay := This.Overlays[1].Clone()
        }
        Else If This.Overlays.Length > 1 And This.Chooser == True {
            This.Overlay := AccessibilityOverlay()
            This.Overlay.AddControl(Standalone.ChooserOverlay.Clone())
        }
        Else {
            This.Overlay := AccessibilityOverlay()
            This.Overlay.AddControl(Standalone.DefaultOverlay.Clone())
        }
    }
    
    GetOverlay() {
        Return This.Overlay
    }
    
    GetOverlays() {
        Return This.Overlays
    }
    
    Static FindCriteria(WinCriteria) {
        For ProgramNumber, ProgramEntry In Standalone.List {
            If ProgramEntry["WinCriteria"] != ""
            If RegExMatch(WinCriteria, ProgramEntry["WinCriteria"])
            Return ProgramNumber
        }
        Return 0
    }
    
    Static FindName(ProgramName) {
        For ProgramNumber, ProgramEntry In Standalone.List
        If ProgramEntry["Name"] == ProgramName
        Return ProgramNumber
        Return 0
    }
    
    Static Get(WinCriteria, WinID) {
        For ProgramInstance In Standalone.Instances
        If ProgramInstance.WindowID == WinID
        Return ProgramInstance
        ProgramNumber := Standalone.FindCriteria(WinCriteria)
        If ProgramNumber != False {
            ProgramInstance := Standalone(Standalone.List[ProgramNumber]["Name"], WinGetID("A"), Standalone.List[ProgramNumber]["Chooser"])
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
    
    Static Register(ProgramName, WinCriteria, Chooser := True) {
        If Standalone.FindName(ProgramName) == False {
            If ProgramName == ""
            ProgramName := Standalone.UnnamedProgramName
            If Chooser != True And Chooser != False
            Chooser := True
            ProgramEntry := Map()
            ProgramEntry["Name"] := ProgramName
            ProgramEntry["WinCriteria"] := WinCriteria
            ProgramEntry["Chooser"] := Chooser
            ProgramEntry["Overlays"] := Array()
            Standalone.List.Push(ProgramEntry)
        }
    }
    
    Static RegisterOverlay(ProgramName, ProgramOverlay) {
        ProgramNumber := Standalone.FindName(ProgramName)
        If ProgramNumber > 0
        Standalone.List[ProgramNumber]["Overlays"].Push(ProgramOverlay.Clone())
    }
    
}
