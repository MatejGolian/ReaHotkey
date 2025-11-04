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
        
        AreiaOverlay := PluginOverlay("Areia")
        AreiaOverlay.Metadata := Map("Vendor", "Audio Imperia", "Product", "Areia", "Image", Map("File", "Images/SampleLibraries/Areia/Product.png"))
        AreiaOverlay.AddPluginOverlay()
        AreiaOverlay.AddStaticText("Areia")
        AreiaOverlay.AddGraphicalHorizontalSlider("Close/Mid/Far", This.%PluginClass%XOffset + 56, This.%PluginClass%YOffset + 239, This.%PluginClass%XOffset + 216, This.%PluginClass%YOffset + 247, ["Images/SampleLibraries/Areia/EZMixerOff.png", "Images/SampleLibraries/Areia/EZMixerOn.png"], This.%PluginClass%XOffset + 63, This.%PluginClass%XOffset + 209)
        AreiaOverlay.AddGraphicalToggleButton("Classic Mix", This.%PluginClass%XOffset + 62, This.%PluginClass%YOffset + 299, This.%PluginClass%XOffset + 132, This.%PluginClass%YOffset + 319, "Images/SampleLibraries/Areia/ClassicMixOn.png", ["Images/SampleLibraries/Areia/ClassicMixOff1.png", "Images/SampleLibraries/Areia/ClassicMixOff2.png"])
        AreiaOverlay.AddGraphicalToggleButton("Modern Mix", This.%PluginClass%XOffset + 132, This.%PluginClass%YOffset + 299, This.%PluginClass%XOffset + 232, This.%PluginClass%YOffset + 319, "Images/SampleLibraries/Areia/ModernMixOn.png", ["Images/SampleLibraries/Areia/ModernMixOff1.png", "Images/SampleLibraries/Areia/ModernMixOff2.png"])
        %PluginClass%.PluginOverlays.Push(AreiaOverlay)
        
        CerberusOverlay := PluginOverlay("Cerberus")
        CerberusOverlay.Metadata := Map("Vendor", "Audio Imperia", "Product", "Cerberus", "Image", Map("File", "Images/SampleLibraries/Cerberus/Product.png"))
        CerberusOverlay.AddPluginOverlay()
        CerberusOverlay.AddStaticText("Cerberus")
        CerberusComboBox := CerberusOverlay.AddCustomComboBox("Patch type:", ObjBindMethod(This, "SelectCerberusPatchType"),, ObjBindMethod(This, "SelectCerberusPatchType"))
        CerberusComboBox.SetOptions(["Normal", "Epic Mix"])
        CerberusOverlay.AddPluginOverlay()
        This.SelectCerberusPatchType(CerberusComboBox)
        %PluginClass%.PluginOverlays.Push(CerberusOverlay)
        
        ChorusOverlay := PluginOverlay("Chorus")
        ChorusOverlay.Metadata := Map("Vendor", "Audio Imperia", "Product", "Chorus", "Image", Map("File", "Images/SampleLibraries/Chorus/Product.png"))
        ChorusOverlay.AddPluginOverlay()
        ChorusOverlay.AddStaticText("Chorus")
        ChorusOverlay.AddGraphicalToggleButton("Classic Mix", This.%PluginClass%XOffset + 62, This.%PluginClass%YOffset + 299, This.%PluginClass%XOffset + 92, This.%PluginClass%YOffset + 319, "Images/SampleLibraries/Chorus/ClassicMixOn.png", ["Images/SampleLibraries/Chorus/ClassicMixOff1.png", "Images/SampleLibraries/Chorus/ClassicMixOff2.png"])
        ChorusOverlay.AddGraphicalToggleButton("Modern Mix", This.%PluginClass%XOffset + 100, This.%PluginClass%YOffset + 299, This.%PluginClass%XOffset + 128, This.%PluginClass%YOffset + 319, "Images/SampleLibraries/Chorus/ModernMixOn.png", ["Images/SampleLibraries/Chorus/ModernMixOff1.png", "Images/SampleLibraries/Chorus/ModernMixOff2.png"])
        ChorusOverlay.AddGraphicalToggleButton("Scott Smith Mix", This.%PluginClass%XOffset + 132, This.%PluginClass%YOffset + 299, This.%PluginClass%XOffset + 220, This.%PluginClass%YOffset + 319, "Images/SampleLibraries/Chorus/ScottSmithMixOn.png", ["Images/SampleLibraries/Chorus/ScottSmithMixOff1.png", "Images/SampleLibraries/Chorus/ScottSmithMixOff2.png"])
        %PluginClass%.PluginOverlays.Push(ChorusOverlay)
        
        DolceOverlay := PluginOverlay("Dolce")
        DolceOverlay.Metadata := Map("Vendor", "Audio Imperia", "Product", "Dolce", "Image", Map("File", "Images/SampleLibraries/Dolce/Product.png"))
        DolceOverlay.AddPluginOverlay()
        DolceOverlay.AddStaticText("Dolce")
        DolceOverlay.AddGraphicalToggleButton("Classic Mix", This.%PluginClass%XOffset + 92, This.%PluginClass%YOffset + 239, This.%PluginClass%XOffset + 192, This.%PluginClass%YOffset + 319, "Images/SampleLibraries/Dolce/ClassicMixOn.png", "Images/SampleLibraries/Dolce/ClassicMixOff.png")
        DolceOverlay.AddGraphicalToggleButton("Modern Mix", This.%PluginClass%XOffset + 92, This.%PluginClass%YOffset + 269, This.%PluginClass%XOffset + 192, This.%PluginClass%YOffset + 319, "Images/SampleLibraries/Dolce/ModernMixOn.png", "Images/SampleLibraries/Dolce/ModernMixOff.png")
        %PluginClass%.PluginOverlays.Push(DolceOverlay)
        
        JaegerOverlay := PluginOverlay("Jaeger")
        JaegerOverlay.Metadata := Map("Vendor", "Audio Imperia", "Product", "Jaeger", "Image", Map("File", "Images/SampleLibraries/Jaeger/Product.png"))
        JaegerOverlay.AddPluginOverlay()
        JaegerOverlay.AddStaticText("Jaeger")
        JaegerOverlay.AddGraphicalHorizontalSlider("Close/Mid/Far", This.%PluginClass%XOffset + 56, This.%PluginClass%YOffset + 239, This.%PluginClass%XOffset + 216, This.%PluginClass%YOffset + 247, ["Images/SampleLibraries/Jaeger/EZMixerOff.png", "Images/SampleLibraries/Jaeger/EZMixerOn.png"], This.%PluginClass%XOffset + 63, This.%PluginClass%XOffset + 209)
        JaegerOverlay.AddGraphicalToggleButton("Classic Mix", This.%PluginClass%XOffset + 62, This.%PluginClass%YOffset + 299, This.%PluginClass%XOffset + 132, This.%PluginClass%YOffset + 319, "Images/SampleLibraries/Jaeger/ClassicMixOn.png", ["Images/SampleLibraries/Jaeger/ClassicMixOff1.png", "Images/SampleLibraries/Jaeger/ClassicMixOff2.png"])
        JaegerOverlay.AddGraphicalToggleButton("Modern Mix", This.%PluginClass%XOffset + 132, This.%PluginClass%YOffset + 299, This.%PluginClass%XOffset + 232, This.%PluginClass%YOffset + 319, "Images/SampleLibraries/Jaeger/ModernMixOn.png", ["Images/SampleLibraries/Jaeger/ModernMixOff1.png", "Images/SampleLibraries/Jaeger/ModernMixOff2.png"])
        %PluginClass%.PluginOverlays.Push(JaegerOverlay)
        
        NucleusOverlay := PluginOverlay("Nucleus")
        NucleusOverlay.Metadata := Map("Vendor", "Audio Imperia", "Product", "Nucleus", "Image", Map("File", "Images/SampleLibraries/Nucleus/Product.png"))
        NucleusOverlay.AddPluginOverlay()
        NucleusOverlay.AddStaticText("Nucleus")
        NucleusOverlay.AddGraphicalToggleButton("Classic Mix", This.%PluginClass%XOffset + 92, This.%PluginClass%YOffset + 239, This.%PluginClass%XOffset + 192, This.%PluginClass%YOffset + 319, "Images/SampleLibraries/Nucleus/ClassicMixOn.png", "Images/SampleLibraries/Nucleus/ClassicMixOff.png")
        NucleusOverlay.AddGraphicalToggleButton("Modern Mix", This.%PluginClass%XOffset + 92, This.%PluginClass%YOffset + 269, This.%PluginClass%XOffset + 192, This.%PluginClass%YOffset + 319, "Images/SampleLibraries/Nucleus/ModernMixOn.png", "Images/SampleLibraries/Nucleus/ModernMixOff.png")
        %PluginClass%.PluginOverlays.Push(NucleusOverlay)
        
        SoloOverlay := PluginOverlay("Solo")
        SoloOverlay.Metadata := Map("Vendor", "Audio Imperia", "Product", "Solo", "Image", Map("File", "Images/SampleLibraries/Solo/Product.png"))
        SoloOverlay.AddPluginOverlay()
        SoloOverlay.AddStaticText("Solo")
        SoloOverlay.AddGraphicalToggleButton("Classic Mix", This.%PluginClass%XOffset + 62, This.%PluginClass%YOffset + 299, This.%PluginClass%XOffset + 132, This.%PluginClass%YOffset + 319, "Images/SampleLibraries/Solo/ClassicMixOn.png", ["Images/SampleLibraries/Solo/ClassicMixOff1.png", "Images/SampleLibraries/Solo/ClassicMixOff2.png"])
        SoloOverlay.AddGraphicalToggleButton("Modern Mix", This.%PluginClass%XOffset + 132, This.%PluginClass%YOffset + 299, This.%PluginClass%XOffset + 232, This.%PluginClass%YOffset + 319, "Images/SampleLibraries/Solo/ModernMixOn.png", ["Images/SampleLibraries/Solo/ModernMixOff1.png", "Images/SampleLibraries/Solo/ModernMixOff2.png"])
        %PluginClass%.PluginOverlays.Push(SoloOverlay)
        
        TalosOverlay := PluginOverlay("Talos")
        TalosOverlay.Metadata := Map("Vendor", "Audio Imperia", "Product", "Talos", "Image", Map("File", "Images/SampleLibraries/Talos/Product.png"))
        TalosOverlay.AddPluginOverlay()
        TalosOverlay.AddStaticText("Talos")
        TalosOverlay.AddGraphicalHorizontalSlider("Close/Mid/Far", This.%PluginClass%XOffset + 56, This.%PluginClass%YOffset + 239, This.%PluginClass%XOffset + 216, This.%PluginClass%YOffset + 247, ["Images/SampleLibraries/Talos/EZMixerOff.png", "Images/SampleLibraries/Talos/EZMixerOn.png"], This.%PluginClass%XOffset + 63, This.%PluginClass%XOffset + 209)
        TalosOverlay.AddGraphicalToggleButton("Classic Mix", This.%PluginClass%XOffset + 62, This.%PluginClass%YOffset + 299, This.%PluginClass%XOffset + 132, This.%PluginClass%YOffset + 319, "Images/SampleLibraries/Talos/ClassicMixOn.png", ["Images/SampleLibraries/Talos/ClassicMixOff1.png", "Images/SampleLibraries/Talos/ClassicMixOff2.png"])
        TalosOverlay.AddGraphicalToggleButton("Modern Mix", This.%PluginClass%XOffset + 132, This.%PluginClass%YOffset + 299, This.%PluginClass%XOffset + 232, This.%PluginClass%YOffset + 319, "Images/SampleLibraries/Talos/ModernMixOn.png", ["Images/SampleLibraries/Talos/ModernMixOff1.png", "Images/SampleLibraries/Talos/ModernMixOff2.png"])
        %PluginClass%.PluginOverlays.Push(TalosOverlay)
    }
    
    Static SelectCerberusPatchType(TypeCombo, Speak := True) {
        ParentOverlay := TypeCombo.SuperordinateControl
        PluginClass := SubStr(This.Prototype.__Class, 1, InStr(This.Prototype.__Class, ".") - 1)
        If TypeCombo.GetValue() = "Normal" {
            ChildOverlay := PluginOverlay()
            ChildOverlay.AddHotspotButton("C", This.%PluginClass%XOffset + 208, This.%PluginClass%YOffset + 313)
            ChildOverlay.AddHotspotButton("M", This.%PluginClass%XOffset + 227, This.%PluginClass%YOffset + 313)
            ParentOverlay.ChildControls[4] := ChildOverlay
        }
        Else If TypeCombo.GetValue() = "Epic Mix" {
            ChildOverlay := PluginOverlay()
            ChildOverlay.AddHotspotButton("C", This.%PluginClass%XOffset + 113, This.%PluginClass%YOffset + 313)
            ChildOverlay.AddHotspotButton("F", This.%PluginClass%XOffset + 143, This.%PluginClass%YOffset + 313)
            ChildOverlay.AddHotspotButton("R", This.%PluginClass%XOffset + 173, This.%PluginClass%YOffset + 313)
            ParentOverlay.ChildControls[4] := ChildOverlay
        }
        Else {
            ChildOverlay := PluginOverlay()
            ChildOverlay.AddStaticText("Invalid patch type")
            ParentOverlay.ChildControls[4] := ChildOverlay
        }
    }
    
}
