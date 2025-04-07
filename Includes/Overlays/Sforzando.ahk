#Requires AutoHotkey v2.0

Class Sforzando {
    
    Static __New() {
        Plugin.Register("sforzando", "^Plugin[0-9A-F]{1,}$", ObjBindMethod(This, "InitPlugin"), False, 1, False, ObjBindMethod(This, "CheckPlugin"))
        Standalone.Register("sforzando", "Plogue Art et Technologie, Inc sforzando ahk_class PLGWindowClass ahk_exe sforzando( x64)?.exe", ObjBindMethod(This, "InitStandalone"), False, 1)
    }
    
    Static CheckPlugin(PluginInstance) {
        Thread "NoTimers"
        If PluginInstance Is Plugin And PluginInstance.ControlClass = ReaHotkey.GetPluginControl()
        If PluginInstance.Name = "sforzando"
        Return True
        If PluginInstance Is Plugin And PluginInstance.ControlClass = KompleteKontrol.GetPluginControl()
        If PluginInstance.Name = "sforzando"
        Return True
        UIAElement := This.GetPluginUIAElement()
        If UIAElement
        Return True
        Return False
    }
    
    Static GetPluginUIAElement() {
        Critical
        If Not ReaHotkey.PluginWinCriteria Or Not WinActive(ReaHotkey.PluginWinCriteria)
        Return False
        Try
        UIAElement := GetUIAWindow()
        Catch
        Return False
        If Not UIAElement Is UIA.IUIAutomationElement
        Return False
        If CheckElement(UIAElement)
        Return UIAElement
        Try
        UIAElement := UIAElement.FindElement({Name:"PlogueXMLGUI"})
        Catch
        Return False
        If CheckElement(UIAElement)
        Return UIAElement
        Return False
        CheckElement(UIAElement) {
            If UIAElement Is UIA.IUIAutomationElement And UIAElement.Type = 50033
            Return True
            Return False
        }
    }
    
    Static InitPlugin(PluginInstance) {
        PluginHeader := AccessibilityOverlay()
        PluginHeader.AddStaticText("sforzando")
        PluginHeader.AddOCRButton("Instrument", "Instrument not detected", "TesseractBest", 90, 22, 200, 36,,, KompleteKontrol.CompensatePluginCoordinates,, KompleteKontrol.CompensatePluginCoordinates)
        PluginHeader.AddOCRButton("Polyphony", "Polyphony not detected", "TesseractBest", 486, 40, 516, 70,,, KompleteKontrol.CompensatePluginCoordinates,, KompleteKontrol.CompensatePluginCoordinates)
        PluginHeader.AddOCRButton("Pitchbend range", "Pitchbend range not detected", "TesseractBest", 576, 40, 602, 60,,, KompleteKontrol.CompensatePluginCoordinates,, KompleteKontrol.CompensatePluginCoordinates)
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
