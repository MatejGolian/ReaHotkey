#Requires AutoHotkey v2.0

Class Zampler {
    
    Static __New() {
        Plugin.Register("Zampler", "^Plugin[0-9A-F]{1,}$", False, False, False, False, ObjBindMethod(Zampler, "Check"))
        
        ZamplerOverlay := AccessibilityOverlay("Zampler")
        ZamplerTabControl := ZamplerOverlay.AddTabControl()
        MainTab := HotspotTab("Main", 329, 210, CompensatePluginCoordinates)
        MainTab.AddOCRButton("Patch", "Patch not detected", "TesseractBest", 297, 264, 409, 277,,, CompensatePluginCoordinates,, CompensatePluginCoordinates)
        MainTab.AddHotspotButton("Load bank", 312, 242, CompensatePluginCoordinates,, CompensatePluginCoordinates)
        MainTab.AddHotspotButton("Save bank", 352, 242, CompensatePluginCoordinates,, CompensatePluginCoordinates)
        MainTab.AddHotspotButton("Load patch", 399, 242, CompensatePluginCoordinates,, CompensatePluginCoordinates)
        MainTab.AddHotspotButton("Save patch", 440, 242, CompensatePluginCoordinates,, CompensatePluginCoordinates)
        MainTab.AddHotspotButton("SFZ/REX", 499, 244, [CompensatePluginCoordinates, ObjBindMethod(This, "ResetLabel"), ObjBindMethod(This, "GetSFZREXInstrument")],, [CompensatePluginCoordinates, ObjBindMethod(This, "ResetLabel")])
        MainTab.AddOCRComboBox("Polyphony", "not detected", "TesseractBest", 332, 364, 348, 380,,, CompensatePluginCoordinates,, [CompensatePluginCoordinates, ObjBindMethod(This, "SendWheel")])
        MainTab.AddOCRComboBox("Bend up", "not detected", "TesseractBest", 337, 392, 369, 408,,, CompensatePluginCoordinates,, [CompensatePluginCoordinates, ObjBindMethod(This, "SendWheel")])
        MainTab.AddOCRComboBox("Bend down", "not detected", "TesseractBest", 428, 392, 460, 408,,, CompensatePluginCoordinates,, [CompensatePluginCoordinates, ObjBindMethod(This, "SendWheel")])
        ZamplerTabControl.AddTabs(MainTab)
        ModMatrixTab := HotspotTab("Mod matrix", 415, 210, CompensatePluginCoordinates)
        ModMatrixTab.AddHotspotButton("SOURCE", 344, 246, [CompensatePluginCoordinates, ObjBindMethod(This, "ResetLabel"), ObjBindMethod(This, "GetModSource")],, [CompensatePluginCoordinates, ObjBindMethod(This, "ResetLabel")])
        ModMatrixTab.AddOCRComboBox("AMOUNT", "not detected", "TesseractBest", 400, 240, 440, 260,,, CompensatePluginCoordinates,, [CompensatePluginCoordinates, ObjBindMethod(This, "SendWheel")])
        ModMatrixTab.AddHotspotButton("DESTINATION", 503, 246, [CompensatePluginCoordinates, ObjBindMethod(This, "ResetLabel"), ObjBindMethod(This, "GetModDestination")],, [CompensatePluginCoordinates, ObjBindMethod(This, "ResetLabel")])
        ZamplerTabControl.AddTabs(ModMatrixTab)
        ArpeggiatorTab := HotspotTab("Arpeggiator", 503, 210, CompensatePluginCoordinates)
        ArpeggiatorTab.AddOCRButton("Pattern", "Pattern not detected", "TesseractBest", 500, 224, 580, 240,,, CompensatePluginCoordinates,, CompensatePluginCoordinates)
        ZamplerTabControl.AddTabs(ArpeggiatorTab)
        
        Plugin.RegisterOverlay("Zampler", ZamplerOverlay)
    }
    
    Static Check(*) {
        Thread "NoTimers"
        ReaperPluginNames := ["VSTi: Zampler (Synapse Audio)"]
        PluginInstance := Plugin.GetInstance(GetCurrentControlClass())
        If PluginInstance Is Plugin And PluginInstance.Name = "Zampler"
        Return True
        If ReaHotkey.PluginNative {
            Try
            ReaperListItem := ListViewGetContent("Focused", "SysListView321", ReaHotkey.PluginWinCriteria)
            Catch
            ReaperListItem := ""
            If Not ReaperListItem = ""
            For ReaperPluginName In ReaperPluginNames
            If ReaperListItem = ReaperPluginName
            Return True
        }
        If ReaHotkey.PluginBridged {
            Try
            If RegExMatch(WinGetTitle("A"), "^Zampler \(x(64)|(86) bridged\)$")
            Return True
            Catch
            Return False
        }
        Return False
    }
    
    Static GetModDestination(OverlayObj) {
        Static InitialLabel := OverlayObj.Label
        Result := AccessibilityOverlay.OCR("TesseractBest", CompensatePluginXCoordinate(466), CompensatePluginYCoordinate(240), CompensatePluginXCoordinate(536), CompensatePluginYCoordinate(260))
        If Not Result
        Result := "Empty"
        OverlayObj.Label := InitialLabel . " " . Result
    }
    
    Static GetModSource(OverlayObj) {
        Static InitialLabel := OverlayObj.Label
        Result := AccessibilityOverlay.OCR("TesseractBest", CompensatePluginXCoordinate(310), CompensatePluginYCoordinate(240), CompensatePluginXCoordinate(370), CompensatePluginYCoordinate(260))
        If Not Result
        Result := "Empty"
        OverlayObj.Label := InitialLabel . " " . Result
    }
    
    Static GetSFZREXInstrument(OverlayObj) {
        Static InitialLabel := OverlayObj.Label
        Result := AccessibilityOverlay.OCR("TesseractBest", CompensatePluginXCoordinate(436), CompensatePluginYCoordinate(226), CompensatePluginXCoordinate(636), CompensatePluginYCoordinate(236))
        If Not Result
        Result := "Empty"
        OverlayObj.Label := InitialLabel . " " . Result
    }
    
    Static ResetLabel(OverlayObj) {
        Static InitialLabels := Map()
        If Not InitialLabels.Has(OverlayObj.ControlID)
        InitialLabels.Set(OverlayObj.ControlID, OverlayObj.Label)
        OverlayObj.Label := InitialLabels[OverlayObj.ControlID]
    }
    
    Static SendWheel(OverlayObj) {
        If A_ThisHotkey = "Up"
        Send "{WheelUp 1}"
        If A_ThisHotkey = "Down"
        Send "{WheelDown 1}"
        Sleep 100
    }
    
}
