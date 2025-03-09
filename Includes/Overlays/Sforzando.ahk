#Requires AutoHotkey v2.0

Class Sforzando {
    
    Static __New() {
        Plugin.Register("sforzando", "^Plugin[0-9A-F]{1,}$", ObjBindMethod(This, "InitPlugin"), False, False, False, ObjBindMethod(This, "CheckPlugin"))
        Standalone.Register("sforzando", "Plogue Art et Technologie, Inc sforzando ahk_class PLGWindowClass ahk_exe sforzando( x64)?.exe", ObjBindMethod(This, "InitStandalone"), False, False)
    }
    
    Static CheckPlugin(PluginInstance) {
        Thread "NoTimers"
        If PluginInstance Is Plugin And PluginInstance.ControlClass = GetCurrentControlClass()
        If PluginInstance.Name = "sforzando"
        Return True
        StartingPath := This.GetPluginStartingPath()
        If StartingPath
        Return True
        Return False
    }
    
    Static GetPluginStartingPath() {
        Critical
        Static CachedPath := False
        Try
        UIAElement := UIA.ElementFromHandle("ahk_id " . WinGetID("A"))
        Catch
        UIAElement := False
        If UIAElement And CachedPath And CheckPath(UIAElement, CachedPath)
        Return CachedPath
        If UIAElement
        Try
        For Index, ChildElement In UIAElement.Children {
            UIAPaths := [Index, Index . ",1"]
            For UIAPath In UIAPaths
            If CheckPath(UIAElement, UIAPath) {
                CachedPath := UIAPath
                Return UIAPath
            }
        }
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
        PluginHeader.AddOCRButton("Instrument", "Instrument not detected", "TesseractBest", 90, 22, 200, 36,,, CompensatePluginCoordinates,, CompensatePluginCoordinates)
        PluginHeader.AddOCRButton("Polyphony", "Polyphony not detected", "TesseractBest", 486, 40, 516, 70,,, CompensatePluginCoordinates,, CompensatePluginCoordinates)
        PluginHeader.AddOCRButton("Pitchbend range", "Pitchbend range not detected", "TesseractBest", 576, 40, 602, 60,,, CompensatePluginCoordinates,, CompensatePluginCoordinates)
        PluginInstance.Overlay.Label := "sforzando"
        If PluginInstance.Overlay.ChildControls.Length = 0
        PluginInstance.Overlay.AddAccessibilityOverlay()
        PluginInstance.Overlay.ChildControls[1] := PluginHeader
    }
    
    Static InitStandalone(StandaloneInstance) {
        StandaloneHeader := AccessibilityOverlay()
        StandaloneHeader.AddOCRButton("Instrument", "Instrument not detected", "TesseractBest", 90, 22, 200, 36)
        StandaloneHeader.AddOCRButton("Polyphony", "Polyphony not detected", "TesseractBest", 486, 40, 516, 70)
        StandaloneHeader.AddOCRButton("Pitchbend range", "Pitchbend range not detected", "TesseractBest", 576, 40, 602, 60)
        StandaloneInstance.Overlay.Label := "sforzando"
        If StandaloneInstance.Overlay.ChildControls.Length = 0
        StandaloneInstance.Overlay.AddAccessibilityOverlay()
        StandaloneInstance.Overlay.ChildControls[1] := StandaloneHeader
    }
    
}
