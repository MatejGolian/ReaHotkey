#Requires AutoHotkey v2.0

Class AudioImperia {
    
    Static KontaktXOffset := 0
    Static KontaktYOffset := 0
    Static KompleteKontrolXOffset := 107
    Static KompleteKontrolYOffset := 111
    Static PluginClass := ""
    
    __New() {
        ClassNames := StrSplit(This.__Class, ".")
        PluginClass := ClassNames[1]
        VendorClass := ClassNames[2]
        %PluginClass%.%VendorClass%.PluginClass := PluginClass
    }
    
    Static __New() {
        This()
        PluginClass := This.PluginClass
        
        AreiaOverlay := AccessibilityOverlay("Areia")
        AreiaOverlay.Metadata := Map("Vendor", "Audio Imperia", "Product", "Areia", "Image", Map("File", "Images/KontaktKompleteKontrol/Areia/Product.png"))
        AreiaOverlay.AddAccessibilityOverlay()
        AreiaOverlay.AddStaticText("Areia")
        AreiaOverlay.AddGraphicalHorizontalSlider("Close/Mid/Far", This.%PluginClass%XOffset + 64, This.%PluginClass%YOffset + 290, This.%PluginClass%XOffset + 224, This.%PluginClass%YOffset + 298, ["Images/KontaktKompleteKontrol/Areia/EZMixerOff.png", "Images/KontaktKompleteKontrol/Areia/EZMixerOn.png"], This.%PluginClass%XOffset + 72, This.%PluginClass%XOffset + 216, [CompensatePluginRegionCoordinates, CompensateGraphicalHorizontalPluginSlider])
        AreiaOverlay.AddGraphicalButton("Classic Mix", This.%PluginClass%XOffset + 70, This.%PluginClass%YOffset + 350, This.%PluginClass%XOffset + 140, This.%PluginClass%YOffset + 370, "Images/KontaktKompleteKontrol/Areia/ClassicMixOn.png", ["Images/KontaktKompleteKontrol/Areia/ClassicMixOff1.png", "Images/KontaktKompleteKontrol/Areia/ClassicMixOff2.png"], CompensatePluginRegionCoordinates, CompensatePluginRegionCoordinates)
        AreiaOverlay.AddGraphicalButton("Modern Mix", This.%PluginClass%XOffset + 140, This.%PluginClass%YOffset + 350, This.%PluginClass%XOffset + 240, This.%PluginClass%YOffset + 370, "Images/KontaktKompleteKontrol/Areia/ModernMixOn.png", ["Images/KontaktKompleteKontrol/Areia/ModernMixOff1.png", "Images/KontaktKompleteKontrol/Areia/ModernMixOff2.png"], CompensatePluginRegionCoordinates, CompensatePluginRegionCoordinates)
        %PluginClass%.PluginOverlays.Push(AreiaOverlay)
        
        CerberusOverlay := AccessibilityOverlay("Cerberus")
        CerberusOverlay.Metadata := Map("Vendor", "Audio Imperia", "Product", "Cerberus", "Image", Map("File", "Images/KontaktKompleteKontrol/Cerberus/Product.png"))
        CerberusOverlay.AddAccessibilityOverlay()
        CerberusOverlay.AddStaticText("Cerberus")
        CerberusComboBox := CerberusOverlay.AddCustomComboBox("Patch type:", ObjBindMethod(This, "SelectCerberusPatchType"), ObjBindMethod(This, "SelectCerberusPatchType"))
        CerberusComboBox.SetOptions(["Normal", "Epic Mix"])
        CerberusOverlay.AddAccessibilityOverlay()
        CerberusOverlay.AddCustomControl(ObjBindMethod(This, "RedirectCerberusKeyPress"))
        %PluginClass%.PluginOverlays.Push(CerberusOverlay)
        
        ChorusOverlay := AccessibilityOverlay("Chorus")
        ChorusOverlay.Metadata := Map("Vendor", "Audio Imperia", "Product", "Chorus", "Image", Map("File", "Images/KontaktKompleteKontrol/Chorus/Product.png"))
        ChorusOverlay.AddAccessibilityOverlay()
        ChorusOverlay.AddStaticText("Chorus")
        ChorusOverlay.AddGraphicalButton("Classic Mix", This.%PluginClass%XOffset + 70, This.%PluginClass%YOffset + 350, This.%PluginClass%XOffset + 140, This.%PluginClass%YOffset + 370, "Images/KontaktKompleteKontrol/Chorus/ClassicMixOn.png", ["Images/KontaktKompleteKontrol/Chorus/ClassicMixOff1.png", "Images/KontaktKompleteKontrol/Chorus/ClassicMixOff2.png"], CompensatePluginRegionCoordinates, CompensatePluginRegionCoordinates)
        ChorusOverlay.AddGraphicalButton("Modern Mix", This.%PluginClass%XOffset + 140, This.%PluginClass%YOffset + 350, This.%PluginClass%XOffset + 240, This.%PluginClass%YOffset + 370, "Images/KontaktKompleteKontrol/Chorus/ModernMixOn.png", ["Images/KontaktKompleteKontrol/Chorus/ModernMixOff1.png", "Images/KontaktKompleteKontrol/Chorus/ModernMixOff2.png"], CompensatePluginRegionCoordinates, CompensatePluginRegionCoordinates)
        %PluginClass%.PluginOverlays.Push(ChorusOverlay)
        
        JaegerOverlay := AccessibilityOverlay("Jaeger")
        JaegerOverlay.Metadata := Map("Vendor", "Audio Imperia", "Product", "Jaeger", "Image", Map("File", "Images/KontaktKompleteKontrol/Jaeger/Product.png"))
        JaegerOverlay.AddAccessibilityOverlay()
        JaegerOverlay.AddStaticText("Jaeger")
        JaegerOverlay.AddGraphicalHorizontalSlider("Close/Mid/Far", This.%PluginClass%XOffset + 64, This.%PluginClass%YOffset + 290, This.%PluginClass%XOffset + 224, This.%PluginClass%YOffset + 298, ["Images/KontaktKompleteKontrol/Jaeger/EZMixerOff.png", "Images/KontaktKompleteKontrol/Jaeger/EZMixerOn.png"], This.%PluginClass%XOffset + 72, This.%PluginClass%XOffset + 216, [CompensatePluginRegionCoordinates, CompensateGraphicalHorizontalPluginSlider])
        JaegerOverlay.AddGraphicalButton("Classic Mix", This.%PluginClass%XOffset + 70, This.%PluginClass%YOffset + 350, This.%PluginClass%XOffset + 140, This.%PluginClass%YOffset + 370, "Images/KontaktKompleteKontrol/Jaeger/ClassicMixOn.png", ["Images/KontaktKompleteKontrol/Jaeger/ClassicMixOff1.png", "Images/KontaktKompleteKontrol/Jaeger/ClassicMixOff2.png"], CompensatePluginRegionCoordinates, CompensatePluginRegionCoordinates)
        JaegerOverlay.AddGraphicalButton("Modern Mix", This.%PluginClass%XOffset + 140, This.%PluginClass%YOffset + 350, This.%PluginClass%XOffset + 240, This.%PluginClass%YOffset + 370, "Images/KontaktKompleteKontrol/Jaeger/ModernMixOn.png", ["Images/KontaktKompleteKontrol/Jaeger/ModernMixOff1.png", "Images/KontaktKompleteKontrol/Jaeger/ModernMixOff2.png"], CompensatePluginRegionCoordinates, CompensatePluginRegionCoordinates)
        %PluginClass%.PluginOverlays.Push(JaegerOverlay)
        
        NucleusOverlay := AccessibilityOverlay("Nucleus")
        NucleusOverlay.Metadata := Map("Vendor", "Audio Imperia", "Product", "Nucleus", "Image", Map("File", "Images/KontaktKompleteKontrol/Nucleus/Product.png"))
        NucleusOverlay.AddAccessibilityOverlay()
        NucleusOverlay.AddStaticText("Nucleus")
        NucleusOverlay.AddGraphicalButton("Classic Mix", This.%PluginClass%XOffset + 110, This.%PluginClass%YOffset + 300, This.%PluginClass%XOffset + 190, This.%PluginClass%YOffset + 360, "Images/KontaktKompleteKontrol/Nucleus/ClassicMixOn.png", "Images/KontaktKompleteKontrol/Nucleus/ClassicMixOff.png", CompensatePluginRegionCoordinates, CompensatePluginRegionCoordinates)
        NucleusOverlay.AddGraphicalButton("Modern Mix", This.%PluginClass%XOffset + 110, This.%PluginClass%YOffset + 330, This.%PluginClass%XOffset + 190, This.%PluginClass%YOffset + 360, "Images/KontaktKompleteKontrol/Nucleus/ModernMixOn.png", "Images/KontaktKompleteKontrol/Nucleus/ModernMixOff.png", CompensatePluginRegionCoordinates, CompensatePluginRegionCoordinates)
        %PluginClass%.PluginOverlays.Push(NucleusOverlay)
        
        SoloOverlay := AccessibilityOverlay("Solo")
        SoloOverlay.Metadata := Map("Vendor", "Audio Imperia", "Product", "Solo", "Image", Map("File", "Images/KontaktKompleteKontrol/Solo/Product.png"))
        SoloOverlay.AddAccessibilityOverlay()
        SoloOverlay.AddStaticText("Solo")
        SoloOverlay.AddGraphicalButton("Classic Mix", This.%PluginClass%XOffset + 70, This.%PluginClass%YOffset + 350, This.%PluginClass%XOffset + 140, This.%PluginClass%YOffset + 370, "Images/KontaktKompleteKontrol/Solo/ClassicMixOn.png", ["Images/KontaktKompleteKontrol/Solo/ClassicMixOff1.png", "Images/KontaktKompleteKontrol/Solo/ClassicMixOff2.png"], CompensatePluginRegionCoordinates, CompensatePluginRegionCoordinates)
        SoloOverlay.AddGraphicalButton("Modern Mix", This.%PluginClass%XOffset + 140, This.%PluginClass%YOffset + 350, This.%PluginClass%XOffset + 240, This.%PluginClass%YOffset + 370, "Images/KontaktKompleteKontrol/Solo/ModernMixOn.png", ["Images/KontaktKompleteKontrol/Solo/ModernMixOff1.png", "Images/KontaktKompleteKontrol/Solo/ModernMixOff2.png"], CompensatePluginRegionCoordinates, CompensatePluginRegionCoordinates)
        %PluginClass%.PluginOverlays.Push(SoloOverlay)
        
        TalosOverlay := AccessibilityOverlay("Talos")
        TalosOverlay.Metadata := Map("Vendor", "Audio Imperia", "Product", "Talos", "Image", Map("File", "Images/KontaktKompleteKontrol/Talos/Product.png"))
        TalosOverlay.AddAccessibilityOverlay()
        TalosOverlay.AddStaticText("Talos")
        TalosOverlay.AddGraphicalHorizontalSlider("Close/Mid/Far", This.%PluginClass%XOffset + 64, This.%PluginClass%YOffset + 290, This.%PluginClass%XOffset + 224, This.%PluginClass%YOffset + 298, ["Images/KontaktKompleteKontrol/Talos/EZMixerOff.png", "Images/KontaktKompleteKontrol/Talos/EZMixerOn.png"], This.%PluginClass%XOffset + 72, This.%PluginClass%XOffset + 216, [CompensatePluginRegionCoordinates, CompensateGraphicalHorizontalPluginSlider])
        TalosOverlay.AddGraphicalButton("Classic Mix", This.%PluginClass%XOffset + 70, This.%PluginClass%YOffset + 350, This.%PluginClass%XOffset + 140, This.%PluginClass%YOffset + 370, "Images/KontaktKompleteKontrol/Talos/ClassicMixOn.png", ["Images/KontaktKompleteKontrol/Talos/ClassicMixOff1.png", "Images/KontaktKompleteKontrol/Talos/ClassicMixOff2.png"], CompensatePluginRegionCoordinates, CompensatePluginRegionCoordinates)
        TalosOverlay.AddGraphicalButton("Modern Mix", This.%PluginClass%XOffset + 140, This.%PluginClass%YOffset + 350, This.%PluginClass%XOffset + 240, This.%PluginClass%YOffset + 370, "Images/KontaktKompleteKontrol/Talos/ModernMixOn.png", ["Images/KontaktKompleteKontrol/Talos/ModernMixOff1.png", "Images/KontaktKompleteKontrol/Talos/ModernMixOff2.png"], CompensatePluginRegionCoordinates, CompensatePluginRegionCoordinates)
        %PluginClass%.PluginOverlays.Push(TalosOverlay)
    }
    
    Static RedirectCerberusKeyPress(OverlayControl) {
        ParentOverlay := OverlayControl.GetSuperordinateControl()
        MasterOverlay := ParentOverlay.GetSuperordinateControl()
        If A_PriorHotkey = "+Tab" {
            TypeCombo := ParentOverlay.ChildControls[3]
            This.SelectCerberusPatchType(TypeCombo)
            MasterOverlay.FocusPreviousControl()
        }
        Else If GetKeyState("Shift") And A_PriorHotkey = "Tab" {
            TypeCombo := ParentOverlay.ChildControls[3]
            This.SelectCerberusPatchType(TypeCombo)
            MasterOverlay.FocusPreviousControl()
        }
        Else {
            If A_PriorHotkey = "Tab" {
                MasterOverlay.FocusNextControl()
            }
        }
    }
    
    Static SelectCerberusPatchType(TypeCombo) {
        ParentOverlay := TypeCombo.GetSuperordinateControl()
        PluginClass := This.PluginClass
        If TypeCombo.GetValue() = "Normal" {
            ChildOverlay := AccessibilityOverlay()
            ChildOverlay.AddHotspotButton("C", This.%PluginClass%XOffset + 216, This.%PluginClass%YOffset + 364, CompensatePluginPointCoordinates, CompensatePluginPointCoordinates)
            ChildOverlay.AddHotspotButton("M", This.%PluginClass%XOffset + 235, This.%PluginClass%YOffset + 364, CompensatePluginPointCoordinates, CompensatePluginPointCoordinates)
            ParentOverlay.ChildControls[4] := ChildOverlay
        }
        Else If TypeCombo.GetValue() = "Epic Mix" {
            ChildOverlay := AccessibilityOverlay()
            ChildOverlay.AddHotspotButton("C", This.%PluginClass%XOffset + 121, This.%PluginClass%YOffset + 364, CompensatePluginPointCoordinates, CompensatePluginPointCoordinates)
            ChildOverlay.AddHotspotButton("F", This.%PluginClass%XOffset + 151, This.%PluginClass%YOffset + 364, CompensatePluginPointCoordinates, CompensatePluginPointCoordinates)
            ChildOverlay.AddHotspotButton("R", This.%PluginClass%XOffset + 181, This.%PluginClass%YOffset + 364, CompensatePluginPointCoordinates, CompensatePluginPointCoordinates)
            ParentOverlay.ChildControls[4] := ChildOverlay
        }
        Else {
            ChildOverlay := AccessibilityOverlay()
            ChildOverlay.AddStaticText("Invalid patch type")
            ParentOverlay.ChildControls[4] := ChildOverlay
        }
    }
    
}
