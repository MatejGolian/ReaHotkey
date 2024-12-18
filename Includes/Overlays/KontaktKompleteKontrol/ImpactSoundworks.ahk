#Requires AutoHotkey v2.0

Class ImpactSoundworks {
    
    Static __New() {
        PluginClass := SubStr(This.Prototype.__Class, 1, InStr(This.Prototype.__Class, ".") - 1)
        
        JuggernautOverlay := AccessibilityOverlay("Juggernaut")
        JuggernautOverlay.Metadata := Map("Vendor", "Impact Soundworks", "Product", "Juggernaut", "Image", [Map("File", "Images/KontaktKompleteKontrol/Juggernaut/Bass1.png"), Map("File", "Images/KontaktKompleteKontrol/Juggernaut/Bass2.png"), Map("File", "Images/KontaktKompleteKontrol/Juggernaut/DrumsAndFX.png")])
        JuggernautOverlay.AddAccessibilityOverlay()
        JuggernautOverlay.AddStaticText("Juggernaut")
        JuggernautOverlay.AddActivatableCustom("", ObjBindMethod(This, "FocusPresetButton"),, ObjBindMethod(This, "ActivatePresetButton"))
        %PluginClass%.PluginOverlays.Push(JuggernautOverlay)
    }
    
    Static CreateElement() {
        PluginClass := SubStr(This.Prototype.__Class, 1, InStr(This.Prototype.__Class, ".") - 1)
        Kontakt7XOffset := 0
        Kontakt7YOffset := 0
        Kontakt8XOffset := 0
        Kontakt8YOffset := 29
        KompleteKontrolXOffset := 190
        KompleteKontrolYOffset := 111
        Try {
            If ImageSearch(&FoundX, &FoundY, GetPluginXCoordinate(), GetPluginYCoordinate(), A_ScreenWidth, A_ScreenHeight, "Images/KontaktKompleteKontrol/Juggernaut/Bass1.png") {
                Element := StaticText("This NKI file is not supported yet")
                Return Element
            }
            If ImageSearch(&FoundX, &FoundY, GetPluginXCoordinate(), GetPluginYCoordinate(), A_ScreenWidth, A_ScreenHeight, "Images/KontaktKompleteKontrol/Juggernaut/Bass2.png") {
                Element := StaticText("This NKI file is not supported yet")
                Return Element
            }
            If ImageSearch(&FoundX, &FoundY, GetPluginXCoordinate(), GetPluginYCoordinate(), A_ScreenWidth, A_ScreenHeight, "Images/KontaktKompleteKontrol/Juggernaut/DrumsAndFX.png") {
                Element := This.OCRButton("Preset", "Unknown", %PluginClass%XOffset + 100, %PluginClass%YOffset + 130, %PluginClass%XOffset + 400, %PluginClass%YOffset + 150,,, CompensatePluginCoordinates,, CompensatePluginCoordinates)
                Return Element
            }
        }
        Element := StaticText("NKI file not detected")
        Return Element
    }
    
    Static ActivatePresetButton(*) {
        Element := This.CreateElement()
        If Element.HasMethod("Activate")
        Element.Activate(False)
    }
    
    Static FocusPresetButton(*) {
        Element := This.CreateElement()
        Element.Focus()
    }
    
    Class OCRButton Extends OCRButton {
        
        DefaultLabel := ""
        DefaultOCRString := ""
        
        __New(Label, DefaultOCRString, X1Coordinate, Y1Coordinate, X2Coordinate, Y2Coordinate, OCRLanguage := "", OCRScale := 1, PreExecFocusFunctions := "", PostExecFocusFunctions := "", PreExecActivationFunctions := "", PostExecActivationFunctions := "") {
            Super.__New(X1Coordinate, Y1Coordinate, X2Coordinate, Y2Coordinate, OCRLanguage, OCRScale, PreExecFocusFunctions, PostExecFocusFunctions, PreExecActivationFunctions, PostExecActivationFunctions)
            This.Label := Label
            This.DefaultOCRString := DefaultOCRString
        }
        
        SpeakOnActivation(Speak := True) {
            Message := ""
            CheckResult := This.GetState()
            LabelString := This.Label
            If LabelString = ""
            LabelString := This.DefaultLabel
            OCRString := AccessibilityOverlay.OCR(This.X1Coordinate, This.Y1Coordinate, This.X2Coordinate, This.Y2Coordinate, This.OCRLanguage, This.OCRScale)
            If OCRString = ""
            OCRString := This.DefaultOCRString
            StateString := ""
            If This.States.Has(CheckResult)
            StateString := This.States[CheckResult]
            If not This.ControlID = AccessibilityOverlay.PreviousControlID
            Message := LabelString . " " . OCRString . " " . This.ControlTypeLabel . " " . StateString
            Else
            If This.States.Count > 1
            Message := StateString
            If Speak
            AccessibilityOverlay.Speak(Message)
        }
        
        SpeakOnFocus(Speak := True) {
            Message := ""
            CheckResult := This.GetState()
            LabelString := This.Label
            If LabelString = ""
            LabelString := This.DefaultLabel
            OCRString := AccessibilityOverlay.OCR(This.X1Coordinate, This.Y1Coordinate, This.X2Coordinate, This.Y2Coordinate, This.OCRLanguage, This.OCRScale)
            If OCRString = ""
            OCRString := This.DefaultOCRString
            StateString := ""
            If This.States.Has(CheckResult)
            StateString := This.States[CheckResult]
            If not This.ControlID = AccessibilityOverlay.PreviousControlID Or (This.GetMasterControl() Is AccessibilityOverlay And This.GetMasterControl().GetFocusableControlIDs().Length = 1)
            Message := LabelString . " " . OCRString . " " . This.ControlTypeLabel . " " . StateString . " " . This.HotkeyLabel
            If Speak
            AccessibilityOverlay.Speak(Message)
        }
        
    }
    
}
