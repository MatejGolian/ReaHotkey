#Requires AutoHotkey v2.0

Class AudioImperia {
    
    Static Kontakt7XOffset := 0
    Static Kontakt7YOffset := 0
    Static Kontakt8XOffset := 0
    Static Kontakt8YOffset := 29
    Static KompleteKontrolXOffset := 107
    Static KompleteKontrolYOffset := 111
    
    Static __New() {
        PluginClass := SubStr(This.Prototype.__Class, 1, InStr(This.Prototype.__Class, ".") - 1)
        
        AreiaOverlay := AccessibilityOverlay("Areia")
        AreiaOverlay.Metadata := Map("Vendor", "Audio Imperia", "Product", "Areia", "Image", Map("File", "Images/KontaktKompleteKontrol/Areia/Product.png"))
        AreiaOverlay.AddAccessibilityOverlay()
        AreiaOverlay.AddStaticText("Areia")
        AreiaOverlay.AddGraphicalHorizontalSlider("Close/Mid/Far", This.%PluginClass%XOffset + 56, This.%PluginClass%YOffset + 239, This.%PluginClass%XOffset + 216, This.%PluginClass%YOffset + 247, ["Images/KontaktKompleteKontrol/Areia/EZMixerOff.png", "Images/KontaktKompleteKontrol/Areia/EZMixerOn.png"], This.%PluginClass%XOffset + 63, This.%PluginClass%XOffset + 209, CompensatePluginCoordinates)
        AreiaOverlay.AddGraphicalToggleButton("Classic Mix", This.%PluginClass%XOffset + 62, This.%PluginClass%YOffset + 299, This.%PluginClass%XOffset + 132, This.%PluginClass%YOffset + 319, "Images/KontaktKompleteKontrol/Areia/ClassicMixOn.png", ["Images/KontaktKompleteKontrol/Areia/ClassicMixOff1.png", "Images/KontaktKompleteKontrol/Areia/ClassicMixOff2.png"], CompensatePluginCoordinates,, CompensatePluginCoordinates)
        AreiaOverlay.AddGraphicalToggleButton("Modern Mix", This.%PluginClass%XOffset + 132, This.%PluginClass%YOffset + 299, This.%PluginClass%XOffset + 232, This.%PluginClass%YOffset + 319, "Images/KontaktKompleteKontrol/Areia/ModernMixOn.png", ["Images/KontaktKompleteKontrol/Areia/ModernMixOff1.png", "Images/KontaktKompleteKontrol/Areia/ModernMixOff2.png"], CompensatePluginCoordinates,, CompensatePluginCoordinates)
        %PluginClass%.PluginOverlays.Push(AreiaOverlay)
        
        CerberusOverlay := AccessibilityOverlay("Cerberus")
        CerberusOverlay.Metadata := Map("Vendor", "Audio Imperia", "Product", "Cerberus", "Image", Map("File", "Images/KontaktKompleteKontrol/Cerberus/Product.png"))
        CerberusOverlay.AddAccessibilityOverlay()
        CerberusOverlay.AddStaticText("Cerberus")
        CerberusComboBox := CerberusOverlay.AddCustomComboBox("Patch type:", ObjBindMethod(This, "SelectCerberusPatchType"),, ObjBindMethod(This, "SelectCerberusPatchType"))
        CerberusComboBox.SetOptions(["Normal", "Epic Mix"])
        CerberusOverlay.AddAccessibilityOverlay()
        CerberusOverlay.ChildControls[CerberusOverlay.ChildControls.Length] := This.SelectCerberusPatchType(CerberusComboBox)
        %PluginClass%.PluginOverlays.Push(CerberusOverlay)
        
        ChorusOverlay := AccessibilityOverlay("Chorus")
        ChorusOverlay.Metadata := Map("Vendor", "Audio Imperia", "Product", "Chorus", "Image", Map("File", "Images/KontaktKompleteKontrol/Chorus/Product.png"))
        ChorusOverlay.AddAccessibilityOverlay()
        ChorusOverlay.AddStaticText("Chorus")
        ChorusOverlay.AddGraphicalToggleButton("Classic Mix", This.%PluginClass%XOffset + 62, This.%PluginClass%YOffset + 299, This.%PluginClass%XOffset + 92, This.%PluginClass%YOffset + 319, "Images/KontaktKompleteKontrol/Chorus/ClassicMixOn.png", ["Images/KontaktKompleteKontrol/Chorus/ClassicMixOff1.png", "Images/KontaktKompleteKontrol/Chorus/ClassicMixOff2.png"], CompensatePluginCoordinates,, CompensatePluginCoordinates)
        ChorusOverlay.AddGraphicalToggleButton("Modern Mix", This.%PluginClass%XOffset + 100, This.%PluginClass%YOffset + 299, This.%PluginClass%XOffset + 128, This.%PluginClass%YOffset + 319, "Images/KontaktKompleteKontrol/Chorus/ModernMixOn.png", ["Images/KontaktKompleteKontrol/Chorus/ModernMixOff1.png", "Images/KontaktKompleteKontrol/Chorus/ModernMixOff2.png"], CompensatePluginCoordinates,, CompensatePluginCoordinates)
        ChorusOverlay.AddGraphicalToggleButton("Scott Smith Mix", This.%PluginClass%XOffset + 132, This.%PluginClass%YOffset + 299, This.%PluginClass%XOffset + 220, This.%PluginClass%YOffset + 319, "Images/KontaktKompleteKontrol/Chorus/ScottSmithMixOn.png", ["Images/KontaktKompleteKontrol/Chorus/ScottSmithMixOff1.png", "Images/KontaktKompleteKontrol/Chorus/ScottSmithMixOff2.png"], CompensatePluginCoordinates,, CompensatePluginCoordinates)
        %PluginClass%.PluginOverlays.Push(ChorusOverlay)
        
        JaegerOverlay := AccessibilityOverlay("Jaeger")
        JaegerOverlay.Metadata := Map("Vendor", "Audio Imperia", "Product", "Jaeger", "Image", Map("File", "Images/KontaktKompleteKontrol/Jaeger/Product.png"))
        JaegerOverlay.AddAccessibilityOverlay()
        JaegerOverlay.AddStaticText("Jaeger")
        JaegerOverlay.AddGraphicalHorizontalSlider("Close/Mid/Far", This.%PluginClass%XOffset + 56, This.%PluginClass%YOffset + 239, This.%PluginClass%XOffset + 216, This.%PluginClass%YOffset + 247, ["Images/KontaktKompleteKontrol/Jaeger/EZMixerOff.png", "Images/KontaktKompleteKontrol/Jaeger/EZMixerOn.png"], This.%PluginClass%XOffset + 63, This.%PluginClass%XOffset + 209, CompensatePluginCoordinates)
        JaegerOverlay.AddGraphicalToggleButton("Classic Mix", This.%PluginClass%XOffset + 62, This.%PluginClass%YOffset + 299, This.%PluginClass%XOffset + 132, This.%PluginClass%YOffset + 319, "Images/KontaktKompleteKontrol/Jaeger/ClassicMixOn.png", ["Images/KontaktKompleteKontrol/Jaeger/ClassicMixOff1.png", "Images/KontaktKompleteKontrol/Jaeger/ClassicMixOff2.png"], CompensatePluginCoordinates,, CompensatePluginCoordinates)
        JaegerOverlay.AddGraphicalToggleButton("Modern Mix", This.%PluginClass%XOffset + 132, This.%PluginClass%YOffset + 299, This.%PluginClass%XOffset + 232, This.%PluginClass%YOffset + 319, "Images/KontaktKompleteKontrol/Jaeger/ModernMixOn.png", ["Images/KontaktKompleteKontrol/Jaeger/ModernMixOff1.png", "Images/KontaktKompleteKontrol/Jaeger/ModernMixOff2.png"], CompensatePluginCoordinates,, CompensatePluginCoordinates)
        %PluginClass%.PluginOverlays.Push(JaegerOverlay)
        
        NucleusOverlay := AccessibilityOverlay("Nucleus")
        NucleusOverlay.Metadata := Map("Vendor", "Audio Imperia", "Product", "Nucleus", "Image", Map("File", "Images/KontaktKompleteKontrol/Nucleus/Product.png"))
        NucleusOverlay.AddAccessibilityOverlay()
        NucleusOverlay.AddStaticText("Nucleus")
        NucleusOverlay.AddGraphicalToggleButton("Classic Mix", This.%PluginClass%XOffset + 92, This.%PluginClass%YOffset + 239, This.%PluginClass%XOffset + 192, This.%PluginClass%YOffset + 319, "Images/KontaktKompleteKontrol/Nucleus/ClassicMixOn.png", "Images/KontaktKompleteKontrol/Nucleus/ClassicMixOff.png", CompensatePluginCoordinates,, CompensatePluginCoordinates)
        NucleusOverlay.AddGraphicalToggleButton("Modern Mix", This.%PluginClass%XOffset + 92, This.%PluginClass%YOffset + 269, This.%PluginClass%XOffset + 192, This.%PluginClass%YOffset + 319, "Images/KontaktKompleteKontrol/Nucleus/ModernMixOn.png", "Images/KontaktKompleteKontrol/Nucleus/ModernMixOff.png", CompensatePluginCoordinates,, CompensatePluginCoordinates)
        %PluginClass%.PluginOverlays.Push(NucleusOverlay)
        
        SoloOverlay := AccessibilityOverlay("Solo")
        SoloOverlay.Metadata := Map("Vendor", "Audio Imperia", "Product", "Solo", "Image", Map("File", "Images/KontaktKompleteKontrol/Solo/Product.png"))
        SoloOverlay.AddAccessibilityOverlay()
        SoloOverlay.AddStaticText("Solo")
        SoloOverlay.AddGraphicalToggleButton("Classic Mix", This.%PluginClass%XOffset + 62, This.%PluginClass%YOffset + 299, This.%PluginClass%XOffset + 132, This.%PluginClass%YOffset + 319, "Images/KontaktKompleteKontrol/Solo/ClassicMixOn.png", ["Images/KontaktKompleteKontrol/Solo/ClassicMixOff1.png", "Images/KontaktKompleteKontrol/Solo/ClassicMixOff2.png"], CompensatePluginCoordinates,, CompensatePluginCoordinates)
        SoloOverlay.AddGraphicalToggleButton("Modern Mix", This.%PluginClass%XOffset + 132, This.%PluginClass%YOffset + 299, This.%PluginClass%XOffset + 232, This.%PluginClass%YOffset + 319, "Images/KontaktKompleteKontrol/Solo/ModernMixOn.png", ["Images/KontaktKompleteKontrol/Solo/ModernMixOff1.png", "Images/KontaktKompleteKontrol/Solo/ModernMixOff2.png"], CompensatePluginCoordinates,, CompensatePluginCoordinates)
        %PluginClass%.PluginOverlays.Push(SoloOverlay)
        
        TalosOverlay := AccessibilityOverlay("Talos")
        TalosOverlay.Metadata := Map("Vendor", "Audio Imperia", "Product", "Talos", "Image", Map("File", "Images/KontaktKompleteKontrol/Talos/Product.png"))
        TalosOverlay.AddAccessibilityOverlay()
        TalosOverlay.AddStaticText("Talos")
        TalosOverlay.AddGraphicalHorizontalSlider("Close/Mid/Far", This.%PluginClass%XOffset + 56, This.%PluginClass%YOffset + 239, This.%PluginClass%XOffset + 216, This.%PluginClass%YOffset + 247, ["Images/KontaktKompleteKontrol/Talos/EZMixerOff.png", "Images/KontaktKompleteKontrol/Talos/EZMixerOn.png"], This.%PluginClass%XOffset + 63, This.%PluginClass%XOffset + 209, CompensatePluginCoordinates)
        TalosOverlay.AddGraphicalToggleButton("Classic Mix", This.%PluginClass%XOffset + 62, This.%PluginClass%YOffset + 299, This.%PluginClass%XOffset + 132, This.%PluginClass%YOffset + 319, "Images/KontaktKompleteKontrol/Talos/ClassicMixOn.png", ["Images/KontaktKompleteKontrol/Talos/ClassicMixOff1.png", "Images/KontaktKompleteKontrol/Talos/ClassicMixOff2.png"], CompensatePluginCoordinates,, CompensatePluginCoordinates)
        TalosOverlay.AddGraphicalToggleButton("Modern Mix", This.%PluginClass%XOffset + 132, This.%PluginClass%YOffset + 299, This.%PluginClass%XOffset + 232, This.%PluginClass%YOffset + 319, "Images/KontaktKompleteKontrol/Talos/ModernMixOn.png", ["Images/KontaktKompleteKontrol/Talos/ModernMixOff1.png", "Images/KontaktKompleteKontrol/Talos/ModernMixOff2.png"], CompensatePluginCoordinates,, CompensatePluginCoordinates)
        %PluginClass%.PluginOverlays.Push(TalosOverlay)
    }
    
    Static SelectCerberusPatchType(TypeCombo, Speak := True) {
        ParentOverlay := TypeCombo.GetSuperordinateControl()
        PluginClass := SubStr(This.Prototype.__Class, 1, InStr(This.Prototype.__Class, ".") - 1)
        If TypeCombo.GetValue() = "Normal" {
            ChildOverlay := AccessibilityOverlay()
            ChildOverlay.AddHotspotButton("C", This.%PluginClass%XOffset + 208, This.%PluginClass%YOffset + 313, CompensatePluginCoordinates,, CompensatePluginCoordinates)
            ChildOverlay.AddHotspotButton("M", This.%PluginClass%XOffset + 227, This.%PluginClass%YOffset + 313, CompensatePluginCoordinates,, CompensatePluginCoordinates)
            ParentOverlay.ChildControls[4] := ChildOverlay
        }
        Else If TypeCombo.GetValue() = "Epic Mix" {
            ChildOverlay := AccessibilityOverlay()
            ChildOverlay.AddHotspotButton("C", This.%PluginClass%XOffset + 113, This.%PluginClass%YOffset + 313, CompensatePluginCoordinates,, CompensatePluginCoordinates)
            ChildOverlay.AddHotspotButton("F", This.%PluginClass%XOffset + 143, This.%PluginClass%YOffset + 313, CompensatePluginCoordinates,, CompensatePluginCoordinates)
            ChildOverlay.AddHotspotButton("R", This.%PluginClass%XOffset + 173, This.%PluginClass%YOffset + 313, CompensatePluginCoordinates,, CompensatePluginCoordinates)
            ParentOverlay.ChildControls[4] := ChildOverlay
        }
        Else {
            ChildOverlay := AccessibilityOverlay()
            ChildOverlay.AddStaticText("Invalid patch type")
            ParentOverlay.ChildControls[4] := ChildOverlay
        }
        Return ChildOverlay
    }
    
}
