#Requires AutoHotkey v2.0

Class ImpactSoundworks {
    
    Static __New() {
        PluginClass := SubStr(This.Prototype.__Class, 1, InStr(This.Prototype.__Class, ".") - 1)
        
        JuggernautOverlay := AccessibilityOverlay("Juggernaut")
        JuggernautOverlay.Metadata := Map("Vendor", "Impact Soundworks", "Product", "Juggernaut", "Image", [Map("File", "Images/KontaktKompleteKontrol/Juggernaut/Bass.png"), Map("File", "Images/KontaktKompleteKontrol/Juggernaut/DrumsAndFX.png")])
        JuggernautOverlay.AddAccessibilityOverlay()
        JuggernautOverlay.AddStaticText("Juggernaut")
        JuggernautOverlay.AddActivatableCustom("", ObjBindMethod(This, "FocusPresetButton"),, ObjBindMethod(This, "ActivatePresetButton"))
        %PluginClass%.PluginOverlays.Push(JuggernautOverlay)
    }
    
    Static CreateElement() {
        Try {
            If ImageSearch(&FoundX, &FoundY, GetPluginXCoordinate(), GetPluginYCoordinate(), A_ScreenWidth, A_ScreenHeight, "Images/KontaktKompleteKontrol/Juggernaut/Bass.png") {
                Element := Create("Bass")
                Return Element
            }
            If ImageSearch(&FoundX, &FoundY, GetPluginXCoordinate(), GetPluginYCoordinate(), A_ScreenWidth, A_ScreenHeight, "Images/KontaktKompleteKontrol/Juggernaut/DrumsAndFX.png") {
                Element := Create("DrumsAndFX")
                Return Element
            }
        }
        Element := Create()
        Return Element
        Create(What := "") {
            PluginClass := SubStr(This.Prototype.__Class, 1, InStr(This.Prototype.__Class, ".") - 1)
            Kontakt7XOffset := 0
            Kontakt7YOffset := 0
            Kontakt8XOffset := 0
            Kontakt8YOffset := 29
            KompleteKontrolXOffset := 190
            KompleteKontrolYOffset := 111
            Switch What {
                Case "Bass":
                Return This.OCRButton("Preset", "Unknown", %PluginClass%XOffset + 354, %PluginClass%YOffset + 125, %PluginClass%XOffset + 562, %PluginClass%YOffset + 175,,, CompensatePluginCoordinates,, CompensatePluginCoordinates)
                Case "DrumsAndFX":
                Return This.OCRButton("Preset", "Unknown", %PluginClass%XOffset + 150, %PluginClass%YOffset + 132, %PluginClass%XOffset + 360, %PluginClass%YOffset + 170,,, CompensatePluginCoordinates,, CompensatePluginCoordinates)
                Default:
                Return StaticText("NKI file not detected")
            }
        }
    }
    
    Static ActivatePresetButton(*) {
        Element := This.CreateElement()
        If Element.HasMethod("Activate") {
            PluginClass := SubStr(This.Prototype.__Class, 1, InStr(This.Prototype.__Class, ".") - 1)
            Element.Activate(False)
            %PluginClass%.CheckPluginMenu()
        }
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
