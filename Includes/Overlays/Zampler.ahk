#Requires AutoHotkey v2.0

Class Zampler {
    
    Static __New() {
        This.InitConfig()
        
        Plugin.Register("Zampler", "^Plugin[0-9A-F]{1,}$", False, False, 1, False, ObjBindMethod(This, "Check"))
        
        ZamplerOverlay := AccessibilityOverlay("Zampler")
        FilterBox := CustomComboBox("Filter", [ObjBindMethod(This, "MoveToFilter"), ObjBindMethod(This, "GetFilter")],, ObjBindMethod(This, "ChangeFilter"))
        ZamplerTabControl := ZamplerOverlay.AddTabControl()
        MainTab := HotspotTab("Main", 329, 210, KompleteKontrol.CompensatePluginCoordinates)
        MainTab.AddOCRButton("Patch", "Patch not detected", "TesseractBest", 296, 264, 496, 277,,, CompensatePluginCoordinates,, CompensatePluginCoordinates)
        MainTab.AddHotspotButton("Load bank", 312, 242, KompleteKontrol.CompensatePluginCoordinates,, KompleteKontrol.CompensatePluginCoordinates)
        MainTab.AddHotspotButton("Save bank", 352, 242, KompleteKontrol.CompensatePluginCoordinates,, KompleteKontrol.CompensatePluginCoordinates)
        MainTab.AddHotspotButton("Load patch", 399, 242, KompleteKontrol.CompensatePluginCoordinates,, KompleteKontrol.CompensatePluginCoordinates)
        MainTab.AddHotspotButton("Save patch", 440, 242, KompleteKontrol.CompensatePluginCoordinates,, KompleteKontrol.CompensatePluginCoordinates)
        MainTab.AddHotspotButton("SFZ/REX", 499, 244, [CompensatePluginCoordinates, ObjBindMethod(This, "ResetLabel"), ObjBindMethod(This, "GetSFZREXInstrument")],, [KompleteKontrol.CompensatePluginCoordinates, ObjBindMethod(This, "ResetLabel")])
        MainTab.AddControl(This.PolyphonyBox("Polyphony", "not detected", "TesseractBest", 332, 364, 348, 380,,, KompleteKontrol.CompensatePluginCoordinates,, [KompleteKontrol.CompensatePluginCoordinates, ObjBindMethod(This, "SendWheel"), ObjBindMethod(This, "FixPolyphony")]))
        MainTab.AddOCRComboBox("Bend up", "not detected", "TesseractBest", 337, 392, 369, 408,,, KompleteKontrol.CompensatePluginCoordinates,, [KompleteKontrol.CompensatePluginCoordinates, ObjBindMethod(This, "SendWheel")])
        MainTab.AddOCRComboBox("Bend down", "not detected", "TesseractBest", 428, 392, 460, 408,,, KompleteKontrol.CompensatePluginCoordinates,, [KompleteKontrol.CompensatePluginCoordinates, ObjBindMethod(This, "SendWheel")])
        MainTab.AddControl(FilterBox)
        ZamplerTabControl.AddTabs(MainTab)
        ModMatrixTab := HotspotTab("Mod matrix", 415, 210, CompensatePluginCoordinates)
        ModMatrixTab.AddHotspotButton("SOURCE", 344, 246, [KompleteKontrol.CompensatePluginCoordinates, ObjBindMethod(This, "ResetLabel"), ObjBindMethod(This, "GetModSource")],, [KompleteKontrol.CompensatePluginCoordinates, ObjBindMethod(This, "ResetLabel")])
        ModMatrixTab.AddOCRComboBox("AMOUNT", "not detected", "TesseractBest", 400, 240, 440, 260,,, KompleteKontrol.CompensatePluginCoordinates,, [KompleteKontrol.CompensatePluginCoordinates, ObjBindMethod(This, "SendWheel")])
        ModMatrixTab.AddHotspotButton("DESTINATION", 503, 246, [KompleteKontrol.CompensatePluginCoordinates, ObjBindMethod(This, "ResetLabel"), ObjBindMethod(This, "GetModDestination")],, [KompleteKontrol.CompensatePluginCoordinates, ObjBindMethod(This, "ResetLabel")])
        ModMatrixTab.AddControl(FilterBox)
        ZamplerTabControl.AddTabs(ModMatrixTab)
        ArpeggiatorTab := HotspotTab("Arpeggiator", 503, 210, CompensatePluginCoordinates)
        ArpeggiatorTab.AddOCRButton("Pattern", "Pattern not detected", "TesseractBest", 500, 224, 580, 240,,, KompleteKontrol.CompensatePluginCoordinates,, KompleteKontrol.CompensatePluginCoordinates)
        ArpeggiatorTab.AddControl(FilterBox)
        ZamplerTabControl.AddTabs(ArpeggiatorTab)
        
        Plugin.RegisterOverlay("Zampler", ZamplerOverlay)
        Plugin.SetTimer("Zampler", ObjBindMethod(This, "ResetOverlay"), -1)
    }
    
    Static ChangeFilter(OverlayObj) {
        Static Options := Array("Highpass", "Bandstop", "Bandpass", "Lowpass", "Off")
        Static OptionCoordinates := Map("Highpass", {X: 687, Y: 216}, "Bandstop", {X: 687, Y: 193}, "Bandpass", {X: 687, Y: 170}, "Lowpass", {X: 687, Y: 147}, "Off", {X: 687, Y: 124})
        CurrentOption := 0
        For Key, Value In Options
        If Value = OverlayObj.Value {
            CurrentOption := Key
            Break
        }
        If not CurrentOption
        Return
        If A_ThisHotkey = "Up" And CurrentOption = 1
        Return
        If A_ThisHotkey = "down" And CurrentOption = Options.Length
        Return
        If A_ThisHotkey = "up"
        TargetOption := CurrentOption - 1
        Else
        TargetOption := CurrentOption + 1
        PluginControlPos := KompleteKontrol.GetPluginControlPos()
        Click PluginControlPos.X + 707, PluginControlPos.Y + 102
        Sleep 250
        Click PluginControlPos.X + OptionCoordinates[Options[CurrentOption]].X, PluginControlPos.Y + OptionCoordinates[Options[CurrentOption]].Y
        Sleep 250
        Click PluginControlPos.X + OptionCoordinates[Options[TargetOption]].X, PluginControlPos.Y + OptionCoordinates[Options[TargetOption]].Y
        Sleep 250
        MouseMove PluginControlPos.X + 707, PluginControlPos.Y + 102
        This.GetFilter(OverlayObj)
    }
    
    Static Check(PluginInstance) {
        Thread "NoTimers"
        If PluginInstance Is Plugin And PluginInstance.ControlClass = ReaHotkey.GetPluginControl()
        If PluginInstance.Name = "Zampler"
        Return True
        If PluginInstance Is Plugin And PluginInstance.ControlClass = KompleteKontrol.GetPluginControl()
        If PluginInstance.Name = "Zampler"
        Return True
        PluginControlPos := KompleteKontrol.GetPluginControlPos()
        If ReaHotkey.Config.Get("ZamplerImageSearch") = 1 And FindImage("Images/Zampler/Zampler.png", PluginControlPos.X, PluginControlPos.Y + 140, PluginControlPos.X + 230, PluginControlPos.Y + 170) Is Object
        Return True
        If ReaHotkey.AbletonPlugin {
            If RegExMatch(WinGetTitle("A"), "^Zampler-RX/[1-9][0-9]*-Zampler-RX$")
            Return True
        }
        If ReaHotkey.ReaperPluginNative {
            ReaperPluginNames := ["VSTi: Zampler (Synapse Audio)"]
            Try
            ReaperListItem := ListViewGetContent("Focused", "SysListView321", ReaHotkey.PluginWinCriteria)
            Catch
            ReaperListItem := ""
            If Not ReaperListItem = ""
            For ReaperPluginName In ReaperPluginNames
            If ReaperListItem = ReaperPluginName
            Return True
        }
        If ReaHotkey.ReaperPluginBridged {
            Try
            If RegExMatch(WinGetTitle("A"), "^Zampler \(x(64|86) bridged\)$")
            Return True
            Catch
            Return False
        }
        Return False
    }
    
    Static FixPolyphony(OverlayObj) {
        If OverlayObj.Value And RegExMatch(OverlayObj.Value, "\+|\-?[0-9]+") And OverlayObj.Value < 8
        OverlayObj.Value := 8
    }
    
    Static GetFilter(OverlayObj) {
        PluginControlPos := KompleteKontrol.GetPluginControlPos()
        Result := Trim(AccessibilityOverlay.OCR("TesseractBest", PluginControlPos.X + 700, PluginControlPos.Y + 96, PluginControlPos.X + 756, PluginControlPos.Y + 108))
        OverlayObj.Value := Result
    }
    
    Static GetModDestination(OverlayObj) {
        PluginControlPos := KompleteKontrol.GetPluginControlPos()
        Static InitialLabel := OverlayObj.Label
        Result := Trim(AccessibilityOverlay.OCR("TesseractBest", PluginControlPos.X + 466, PluginControlPos.Y + 240, PluginControlPos.X + 536, PluginControlPos.Y + 260))
        If Result = ""
        Result := "not detected"
        OverlayObj.Label := InitialLabel . " " . Result
    }
    
    Static GetModSource(OverlayObj) {
        PluginControlPos := KompleteKontrol.GetPluginControlPos()
        Static InitialLabel := OverlayObj.Label
        Result := Trim(AccessibilityOverlay.OCR("TesseractBest", PluginControlPos.X + 310, PluginControlPos.Y + 240, PluginControlPos.X + 370, PluginControlPos.Y + 260))
        If Result = ""
        Result := "not detected"
        OverlayObj.Label := InitialLabel . " " . Result
    }
    
    Static GetSFZREXInstrument(OverlayObj) {
        PluginControlPos := KompleteKontrol.GetPluginControlPos()
        Static InitialLabel := OverlayObj.Label
        Result := Trim(AccessibilityOverlay.OCR("TesseractBest", PluginControlPos.X + 448, PluginControlPos.Y + 226, PluginControlPos.X + 648, PluginControlPos.Y + 236))
        If Result = ""
        Result := "not detected"
        OverlayObj.Label := InitialLabel . " " . Result
    }
    
    Static InitConfig() {
        ReaHotkey.Config.Add("ReaHotkey.ini", "Config", "ZamplerImageSearch", 1, "Use image search for Zampler plug-in detection", "Misc")
    }
    
    Static MoveToFilter(OverlayObj) {
        PluginControlPos := KompleteKontrol.GetPluginControlPos()
        MouseMove PluginControlPos.X + 707, PluginControlPos.Y + 102
    }
    
    Static ResetLabel(OverlayObj) {
        Static InitialLabels := Map()
        If Not InitialLabels.Has(OverlayObj.ControlID)
        InitialLabels.Set(OverlayObj.ControlID, OverlayObj.Label)
        OverlayObj.Label := InitialLabels[OverlayObj.ControlID]
    }
    
    Static ResetOverlay() {
        Static PreviousWinID := False
        CurrentWinID := WinGetID("A")
        If Not CurrentWinID = PreviousWinID And ReaHotkey.FoundPlugin Is Plugin {
            PreviousWinID := CurrentWinID
            ReaHotkey.FoundPlugin.Overlay.Reset()
            ReaHotkey.FoundPlugin.Overlay.FocusControlNumber(1)
        }
    }
    
    Static SendWheel(OverlayObj) {
        StepSize := 1
        If OverlayObj.Label = "Polyphony"
        StepSize := 2
        If A_ThisHotkey = "Up"
        Send "{WheelUp " . StepSize . "}"
        If A_ThisHotkey = "Down"
        Send "{WheelDown " . StepSize . "}"
        Sleep 100
        OverlayObj.Value := OverlayObj.GetValue()
    }
    
    Class PolyphonyBox Extends OCRComboBox {
        ExecuteOnFocusPreSpeech() {
            If This.Value And RegExMatch(This.Value, "\+|\-?[0-9]+") And This.Value < 8
            This.Value := 8
        }
    }
    
}
