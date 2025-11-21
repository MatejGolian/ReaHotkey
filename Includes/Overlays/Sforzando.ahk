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
        UIAElement := AccessibilityOverlay.Helpers.GetUIAWindow()
        Catch
        Return False
        If Not UIAElement Is UIA.IUIAutomationElement
        Return False
        Try
        If CheckElement(UIAElement)
        Return UIAElement
        Try
        UIAElement := UIAElement.FindElement({Name: "PlogueXMLGUI"})
        Catch
        Return False
        Try
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
        PluginHeader := PluginOverlay(,, KompleteKontrol.CompensatePluginCoordinates)
        PluginHeader.AddStaticText("sforzando")
        PluginHeader.AddOCRButton("Instrument", "Instrument not detected", "TesseractBest", 90, 22, 200, 36)
        PluginHeader.AddOCRButton("Polyphony", "Polyphony not detected", "TesseractBest", 486, 40, 516, 70)
        PluginHeader.AddOCRButton("Pitchbend range", "Pitchbend range not detected", "TesseractBest", 576, 40, 602, 60)
        PluginInstance.Overlay.Label := "sforzando"
        If PluginInstance.Overlay.ChildControls.Length = 0
        PluginInstance.Overlay.AddPluginOverlay()
        PluginInstance.Overlay.ChildControls[1] := PluginHeader
    }
    
    Static InitStandalone(StandaloneInstance) {
        StandaloneHeader := StandaloneOverlay()
        StandaloneHeader.AddOCRButton("Instrument", "Instrument not detected", "TesseractBest", 90, 22, 200, 36)
        StandaloneHeader.AddOCRButton("Polyphony", "Polyphony not detected", "TesseractBest", 486, 40, 516, 70)
        StandaloneHeader.AddOCRButton("Pitchbend range", "Pitchbend range not detected", "TesseractBest", 576, 40, 602, 60)
        StandaloneInstance.Overlay.Label := "sforzando"
        If StandaloneInstance.Overlay.ChildControls.Length = 0
        StandaloneInstance.Overlay.AddStandaloneOverlay()
        StandaloneInstance.Overlay.ChildControls[1] := StandaloneHeader
    }
    
}
