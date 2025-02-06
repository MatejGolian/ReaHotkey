#Requires AutoHotkey v2.0

Class Zampler {
    
    Static __New() {
        Plugin.Register("Zampler", "^Plugin[0-9A-F]{1,}$", False, False, False, False, ObjBindMethod(Zampler, "Check"))
        
        ZamplerOverlay := AccessibilityOverlay("Zampler")
        ZamplerTabControl := ZamplerOverlay.AddTabControl()
        MainTab := HotspotTab("Main", 329, 210, CompensatePluginCoordinates)
        MainTab.AddOCRButton("Patch", "Patch not detected", 297, 264, 409, 277,,, CompensatePluginCoordinates,, CompensatePluginCoordinates)
        MainTab.AddHotspotButton("Load bank", 312, 242, CompensatePluginCoordinates,, CompensatePluginCoordinates)
        MainTab.AddHotspotButton("Save bank", 352, 242, CompensatePluginCoordinates,, CompensatePluginCoordinates)
        MainTab.AddHotspotButton("Load patch", 399, 242, CompensatePluginCoordinates,, CompensatePluginCoordinates)
        MainTab.AddHotspotButton("Save patch", 440, 242, CompensatePluginCoordinates,, CompensatePluginCoordinates)
        MainTab.AddOCRComboBox("Polyphony", 320, 369, 349, 379,,, CompensatePluginCoordinates,, CompensatePluginCoordinates)
        ZamplerTabControl.AddTabs(MainTab)
        ModMatrixTab := HotspotTab("Mod matrix", 415, 210, CompensatePluginCoordinates)
        ZamplerTabControl.AddTabs(ModMatrixTab)
        ArpeggiatorTab := HotspotTab("Arpeggiator", 503, 210, CompensatePluginCoordinates)
        ArpeggiatorTab.AddOCRButton("Pattern", "Pattern not detected", 500, 230, 620, 238,,, CompensatePluginCoordinates,, CompensatePluginCoordinates)
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
    
}
