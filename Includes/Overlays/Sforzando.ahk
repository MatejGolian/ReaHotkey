#Requires AutoHotkey v2.0

Class Sforzando {
    
    Static __New() {
        Plugin.Register("sforzando", "^Plugin[0-9A-F]{1,}$", ObjBindMethod(Sforzando, "InitPlugin"), False, False, False, ObjBindMethod(Sforzando, "CheckPlugin"))
        Standalone.Register("sforzando", "Plogue Art et Technologie, Inc sforzando ahk_class PLGWindowClass ahk_exe sforzando( x64)?.exe", ObjBindMethod(Sforzando, "InitStandalone"), False, False)
    }
    
    Static CheckPlugin(*) {
        Thread "NoTimers"
        PluginInstance := Plugin.GetInstance(GetCurrentControlClass())
        If PluginInstance Is Plugin And PluginInstance.Name = "sforzando"
        Return True
        StartingPath := Sforzando.GetPluginStartingPath()
        If StartingPath
        Return True
        Return False
    }
    
    Static GetPluginStartingPath() {
        Static UIAPath := False
        Try
        UIAElement := UIA.ElementFromHandle("ahk_id " . WinGetID("A"))
        Catch
        UIAElement := False
        If UIAElement And UIAPath And CheckPath(UIAElement, UIAPath)
        Return UIAPath
        If UIAElement
        Try
        For Index, ChildElement In UIAElement.Children {
            UIAPaths := [Index, Index . ",1"]
            For UIAPath In UIAPaths
            If CheckPath(UIAElement, UIAPath)
            Return UIAPath
        }
        UIAPath := False
        Return ""
        CheckPath(UIAElement, UIAPath) {
            Try
            TestElement := UIAElement.ElementFromPath(UIAPath)
            Catch
            TestElement := False
            If TestElement And TestElement.Name = "PlogueXMLGUI"
            Return True
            Return False
        }
    }
    
    Static InitPlugin(PluginInstance) {
        PluginHeader := AccessibilityOverlay()
        PluginHeader.AddOCRButton("Instrument", "Instrument (value not detected)", "Tesseract", 90, 22, 200, 36,,, CompensatePluginCoordinates,, CompensatePluginCoordinates)
        PluginHeader.AddOCRButton("Polyphony", "Polyphony (value not detected)", "Tesseract", 478, 39, 512, 69,,, CompensatePluginCoordinates,, CompensatePluginCoordinates)
        PluginHeader.AddOCRButton("Pitchbend range", "Pitchbend range (value not detected)", "Tesseract", 576, 39, 602, 59,,, CompensatePluginCoordinates,, CompensatePluginCoordinates)
        PluginInstance.Overlay.Label := "sforzando"
        If PluginInstance.Overlay.ChildControls.Length = 0
        PluginInstance.Overlay.AddAccessibilityOverlay()
        PluginInstance.Overlay.ChildControls[1] := PluginHeader
    }
    
    Static InitStandalone(StandaloneInstance) {
        StandaloneHeader := AccessibilityOverlay()
        StandaloneHeader.AddOCRButton("Instrument", "Instrument (value not detected)", "Tesseract", 90, 22, 200, 36)
        StandaloneHeader.AddOCRButton("Polyphony", "Polyphony (value not detected)", "Tesseract", 478, 39, 512, 69)
        StandaloneHeader.AddOCRButton("Pitchbend range", "Pitchbend range (value not detected)", "Tesseract", 576, 39, 602, 59)
        StandaloneInstance.Overlay.Label := "sforzando"
        If StandaloneInstance.Overlay.ChildControls.Length = 0
        StandaloneInstance.Overlay.AddAccessibilityOverlay()
        StandaloneInstance.Overlay.ChildControls[1] := StandaloneHeader
    }
    
}
