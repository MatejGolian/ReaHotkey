#Requires AutoHotkey v2.0

Class Zampler {
    
    Static __New() {
        Zampler.InitConfig()
        
        Plugin.Register("Zampler", "^Plugin[0-9A-F]{1,}$", False, False, False, False, ObjBindMethod(Zampler, "Check"))
        
        ZamplerOverlay := AccessibilityOverlay("Zampler")
        FilterBox := CustomComboBox("Filter", [ObjBindMethod(This, "MoveToFilter"), ObjBindMethod(This, "GetFilter")],, ObjBindMethod(This, "ChangeFilter"))
        ZamplerTabControl := ZamplerOverlay.AddTabControl()
        MainTab := HotspotTab("Main", 329, 210, CompensatePluginCoordinates)
        MainTab.AddOCRButton("Patch", "Patch not detected", "Tesseract", 297, 264, 409, 277,,, CompensatePluginCoordinates,, CompensatePluginCoordinates)
        MainTab.AddHotspotButton("Load bank", 312, 242, CompensatePluginCoordinates,, CompensatePluginCoordinates)
        MainTab.AddHotspotButton("Save bank", 352, 242, CompensatePluginCoordinates,, CompensatePluginCoordinates)
        MainTab.AddHotspotButton("Load patch", 399, 242, CompensatePluginCoordinates,, CompensatePluginCoordinates)
        MainTab.AddHotspotButton("Save patch", 440, 242, CompensatePluginCoordinates,, CompensatePluginCoordinates)
        MainTab.AddHotspotButton("SFZ/REX", 499, 244, [CompensatePluginCoordinates, ObjBindMethod(This, "ResetLabel"), ObjBindMethod(This, "GetSFZREXInstrument")],, [CompensatePluginCoordinates, ObjBindMethod(This, "ResetLabel")])
        MainTab.AddOCRComboBox("Polyphony", "not detected", "Tesseract", 332, 364, 348, 380,,, CompensatePluginCoordinates,, [CompensatePluginCoordinates, ObjBindMethod(This, "SendWheel")])
        MainTab.AddOCRComboBox("Bend up", "not detected", "Tesseract", 337, 392, 369, 408,,, CompensatePluginCoordinates,, [CompensatePluginCoordinates, ObjBindMethod(This, "SendWheel")])
        MainTab.AddOCRComboBox("Bend down", "not detected", "Tesseract", 428, 392, 460, 408,,, CompensatePluginCoordinates,, [CompensatePluginCoordinates, ObjBindMethod(This, "SendWheel")])
        MainTab.AddControl(FilterBox)
        ZamplerTabControl.AddTabs(MainTab)
        ModMatrixTab := HotspotTab("Mod matrix", 415, 210, CompensatePluginCoordinates)
        ModMatrixTab.AddHotspotButton("SOURCE", 344, 246, [CompensatePluginCoordinates, ObjBindMethod(This, "ResetLabel"), ObjBindMethod(This, "GetModSource")],, [CompensatePluginCoordinates, ObjBindMethod(This, "ResetLabel")])
        ModMatrixTab.AddOCRComboBox("AMOUNT", "not detected", "Tesseract", 400, 240, 440, 260,,, CompensatePluginCoordinates,, [CompensatePluginCoordinates, ObjBindMethod(This, "SendWheel")])
        ModMatrixTab.AddHotspotButton("DESTINATION", 503, 246, [CompensatePluginCoordinates, ObjBindMethod(This, "ResetLabel"), ObjBindMethod(This, "GetModDestination")],, [CompensatePluginCoordinates, ObjBindMethod(This, "ResetLabel")])
        ModMatrixTab.AddControl(FilterBox)
        ZamplerTabControl.AddTabs(ModMatrixTab)
        ArpeggiatorTab := HotspotTab("Arpeggiator", 503, 210, CompensatePluginCoordinates)
        ArpeggiatorTab.AddOCRButton("Pattern", "Pattern not detected", "Tesseract", 500, 224, 580, 240,,, CompensatePluginCoordinates,, CompensatePluginCoordinates)
        ArpeggiatorTab.AddControl(FilterBox)
        ZamplerTabControl.AddTabs(ArpeggiatorTab)
        
        Plugin.RegisterOverlay("Zampler", ZamplerOverlay)
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
        Click CompensatePluginXCoordinate(707), CompensatePluginYCoordinate(102)
        Sleep 250
        Click CompensatePluginXCoordinate(OptionCoordinates[Options[CurrentOption]].X), CompensatePluginYCoordinate(OptionCoordinates[Options[CurrentOption]].Y)
        Sleep 250
        Click CompensatePluginXCoordinate(OptionCoordinates[Options[TargetOption]].X), CompensatePluginYCoordinate(OptionCoordinates[Options[TargetOption]].Y)
        Sleep 250
        MouseMove CompensatePluginXCoordinate(707), CompensatePluginYCoordinate(102)
        This.GetFilter(OverlayObj)
    }
    
    Static Check(*) {
        Thread "NoTimers"
        ReaperPluginNames := ["VSTi: Zampler (Synapse Audio)"]
        PluginInstance := Plugin.GetInstance(GetCurrentControlClass())
        If PluginInstance Is Plugin And PluginInstance.Name = "Zampler"
        Return True
        If ReaHotkey.Config.Get("ZamplerImageSearch") = 1 And FindImage("Images/Zampler/Zampler.png", GetPluginXCoordinate() + 0, GetPluginYCoordinate() + 140, GetPluginXCoordinate() + 230, GetPluginYCoordinate() + 170) Is Object
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
    
    Static GetFilter(OverlayObj) {
        Result := Trim(AccessibilityOverlay.OCR("Tesseract", CompensatePluginXCoordinate(700), CompensatePluginYCoordinate(96), CompensatePluginXCoordinate(756), CompensatePluginYCoordinate(108)))
        OverlayObj.Value := Result
    }
    
    Static GetModDestination(OverlayObj) {
        Static InitialLabel := OverlayObj.Label
        Result := Trim(AccessibilityOverlay.OCR("Tesseract", CompensatePluginXCoordinate(466), CompensatePluginYCoordinate(240), CompensatePluginXCoordinate(536), CompensatePluginYCoordinate(260)))
        If Not Result
        Result := "not detected"
        OverlayObj.Label := InitialLabel . " " . Result
    }
    
    Static GetModSource(OverlayObj) {
        Static InitialLabel := OverlayObj.Label
        Result := Trim(AccessibilityOverlay.OCR("Tesseract", CompensatePluginXCoordinate(310), CompensatePluginYCoordinate(240), CompensatePluginXCoordinate(370), CompensatePluginYCoordinate(260)))
        If Not Result
        Result := "not detected"
        OverlayObj.Label := InitialLabel . " " . Result
    }
    
    Static GetSFZREXInstrument(OverlayObj) {
        Static InitialLabel := OverlayObj.Label
        Result := Trim(AccessibilityOverlay.OCR("Tesseract", CompensatePluginXCoordinate(436), CompensatePluginYCoordinate(226), CompensatePluginXCoordinate(636), CompensatePluginYCoordinate(236)))
        If Not Result
        Result := "not detected"
        OverlayObj.Label := InitialLabel . " " . Result
    }
    
    Static InitConfig() {
        ReaHotkey.Config.Add("ReaHotkey.ini", "Config", "ZamplerImageSearch", 1, "Use image search for plug-in detection", "Zampler")
    }
    
    Static MoveToFilter(OverlayObj) {
        MouseMove CompensatePluginXCoordinate(707), CompensatePluginYCoordinate(102)
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
