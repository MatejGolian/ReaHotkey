NoProductOverlay := AccessibilityOverlay("None")
NoProductOverlay.Metadata := Map("Product", "None")
NoProductOverlay.AddAccessibilityOverlay()
KompleteKontrol.PluginOverlays.Push(NoProductOverlay)

AreiaOverlay := AccessibilityOverlay("Areia")
AreiaOverlay.Metadata := Map("Vendor", "Audio Imperia", "Product", "Areia", "Image", Map("File", "Images/KontaktKompleteKontrol/Areia/Product.png"))
AreiaOverlay.AddAccessibilityOverlay()
AreiaOverlay.AddStaticText("Areia")
AreiaOverlay.AddGraphicalButton("Classic Mix", KompleteKontrol.XOffset + 70, KompleteKontrol.YOffset + 350, KompleteKontrol.XOffset + 140, KompleteKontrol.YOffset + 370, "Images/KontaktKompleteKontrol/Areia/ClassicMixOn.png",, ["Images/KontaktKompleteKontrol/Areia/ClassicMixOff1.png", "Images/KontaktKompleteKontrol/Areia/ClassicMixOff2.png"],, CompensatePluginRegionCoordinates, CompensatePluginRegionCoordinates)
AreiaOverlay.AddGraphicalButton("Modern Mix", KompleteKontrol.XOffset + 140, KompleteKontrol.YOffset + 350, KompleteKontrol.XOffset + 240, KompleteKontrol.YOffset + 370, "Images/KontaktKompleteKontrol/Areia/ModernMixOn.png",, ["Images/KontaktKompleteKontrol/Areia/ModernMixOff1.png", "Images/KontaktKompleteKontrol/Areia/ModernMixOff2.png"],, CompensatePluginRegionCoordinates, CompensatePluginRegionCoordinates)
KompleteKontrol.PluginOverlays.Push(AreiaOverlay)

CerberusOverlay := AccessibilityOverlay("Cerberus")
CerberusOverlay.Metadata := Map("Vendor", "Audio Imperia", "Product", "Cerberus", "Image", Map("File", "Images/KontaktKompleteKontrol/Cerberus/Product.png"))
CerberusOverlay.AddAccessibilityOverlay()
CerberusOverlay.AddStaticText("Cerberus")
CerberusComboBox := CerberusOverlay.AddCustomComboBox("Patch type:", SelectPluginCerberusPatchType, SelectPluginCerberusPatchType)
CerberusComboBox.SetOptions(["Normal", "Epic Mix"])
CerberusOverlay.AddAccessibilityOverlay()
CerberusOverlay.AddCustomControl(RedirectPluginCerberusKeyPress)
KompleteKontrol.PluginOverlays.Push(CerberusOverlay)
RedirectPluginCerberusKeyPress(OverlayControl) {
    ParentOverlay := OverlayControl.GetSuperordinateControl()
    MasterOverlay := ParentOverlay.GetSuperordinateControl()
    If A_PriorHotkey = "+Tab" {
        TypeCombo := ParentOverlay.ChildControls[3]
        SelectPluginCerberusPatchType(TypeCombo)
        MasterOverlay.FocusPreviousControl()
    }
    Else If GetKeyState("Shift") And A_PriorHotkey = "Tab" {
        TypeCombo := ParentOverlay.ChildControls[3]
        SelectPluginCerberusPatchType(TypeCombo)
        MasterOverlay.FocusPreviousControl()
    }
    Else {
        If A_PriorHotkey = "Tab" {
            MasterOverlay.FocusNextControl()
        }
    }
}
SelectPluginCerberusPatchType(TypeCombo) {
    ParentOverlay := TypeCombo.GetSuperordinateControl()
    If TypeCombo.GetValue() = "Normal" {
        ChildOverlay := AccessibilityOverlay()
        ChildOverlay.AddHotspotButton("C", KompleteKontrol.XOffset + 216, KompleteKontrol.YOffset + 364, CompensatePluginPointCoordinates, CompensatePluginPointCoordinates)
        ChildOverlay.AddHotspotButton("M", KompleteKontrol.XOffset + 235, KompleteKontrol.YOffset + 364, CompensatePluginPointCoordinates, CompensatePluginPointCoordinates)
        ParentOverlay.ChildControls[4] := ChildOverlay
    }
    Else If TypeCombo.GetValue() = "Epic Mix" {
        ChildOverlay := AccessibilityOverlay()
        ChildOverlay.AddHotspotButton("C", KompleteKontrol.XOffset + 121, KompleteKontrol.YOffset + 364, CompensatePluginPointCoordinates, CompensatePluginPointCoordinates)
        ChildOverlay.AddHotspotButton("F", KompleteKontrol.XOffset + 151, KompleteKontrol.YOffset + 364, CompensatePluginPointCoordinates, CompensatePluginPointCoordinates)
        ChildOverlay.AddHotspotButton("R", KompleteKontrol.XOffset + 181, KompleteKontrol.YOffset + 364, CompensatePluginPointCoordinates, CompensatePluginPointCoordinates)
        ParentOverlay.ChildControls[4] := ChildOverlay
    }
    Else {
        ChildOverlay := AccessibilityOverlay()
        ChildOverlay.AddStaticText("Invalid patch type")
        ParentOverlay.ChildControls[4] := ChildOverlay
    }
}

ChorusOverlay := AccessibilityOverlay("Chorus")
ChorusOverlay.Metadata := Map("Vendor", "Audio Imperia", "Product", "Chorus", "Image", Map("File", "Images/KontaktKompleteKontrol/Chorus/Product.png"))
ChorusOverlay.AddAccessibilityOverlay()
ChorusOverlay.AddStaticText("Chorus")
ChorusOverlay.AddGraphicalButton("Classic Mix", KompleteKontrol.XOffset + 70, KompleteKontrol.YOffset + 350, KompleteKontrol.XOffset + 140, KompleteKontrol.YOffset + 370, "Images/KontaktKompleteKontrol/Chorus/ClassicMixOn.png",, ["Images/KontaktKompleteKontrol/Chorus/ClassicMixOff1.png", "Images/KontaktKompleteKontrol/Chorus/ClassicMixOff2.png"],, CompensatePluginRegionCoordinates, CompensatePluginRegionCoordinates)
ChorusOverlay.AddGraphicalButton("Modern Mix", KompleteKontrol.XOffset + 140, KompleteKontrol.YOffset + 350, KompleteKontrol.XOffset + 240, KompleteKontrol.YOffset + 370, "Images/KontaktKompleteKontrol/Chorus/ModernMixOn.png",, ["Images/KontaktKompleteKontrol/Chorus/ModernMixOff1.png", "Images/KontaktKompleteKontrol/Chorus/ModernMixOff2.png"],, CompensatePluginRegionCoordinates, CompensatePluginRegionCoordinates)
KompleteKontrol.PluginOverlays.Push(ChorusOverlay)

JaegerOverlay := AccessibilityOverlay("Jaeger")
JaegerOverlay.Metadata := Map("Vendor", "Audio Imperia", "Product", "Jaeger", "Image", Map("File", "Images/KontaktKompleteKontrol/Jaeger/Product.png"))
JaegerOverlay.AddAccessibilityOverlay()
JaegerOverlay.AddStaticText("Jaeger")
JaegerOverlay.AddGraphicalButton("Classic Mix", KompleteKontrol.XOffset + 70, KompleteKontrol.YOffset + 350, KompleteKontrol.XOffset + 140, KompleteKontrol.YOffset + 370, "Images/KontaktKompleteKontrol/Jaeger/ClassicMixOn.png",, ["Images/KontaktKompleteKontrol/Jaeger/ClassicMixOff1.png", "Images/KontaktKompleteKontrol/Jaeger/ClassicMixOff2.png"],, CompensatePluginRegionCoordinates, CompensatePluginRegionCoordinates)
JaegerOverlay.AddGraphicalButton("Modern Mix", KompleteKontrol.XOffset + 140, KompleteKontrol.YOffset + 350, KompleteKontrol.XOffset + 240, KompleteKontrol.YOffset + 370, "Images/KontaktKompleteKontrol/Jaeger/ModernMixOn.png",, ["Images/KontaktKompleteKontrol/Jaeger/ModernMixOff1.png", "Images/KontaktKompleteKontrol/Jaeger/ModernMixOff2.png"],, CompensatePluginRegionCoordinates, CompensatePluginRegionCoordinates)
KompleteKontrol.PluginOverlays.Push(JaegerOverlay)

NucleusOverlay := AccessibilityOverlay("Nucleus")
NucleusOverlay.Metadata := Map("Vendor", "Audio Imperia", "Product", "Nucleus", "Image", Map("File", "Images/KontaktKompleteKontrol/Nucleus/Product.png"))
NucleusOverlay.AddAccessibilityOverlay()
NucleusOverlay.AddStaticText("Nucleus")
NucleusOverlay.AddGraphicalButton("Classic Mix", KompleteKontrol.XOffset + 110, KompleteKontrol.YOffset + 300, KompleteKontrol.XOffset + 190, KompleteKontrol.YOffset + 360, "Images/KontaktKompleteKontrol/Nucleus/ClassicMixOn.png",, "Images/KontaktKompleteKontrol/Nucleus/ClassicMixOff.png",, CompensatePluginRegionCoordinates, CompensatePluginRegionCoordinates)
NucleusOverlay.AddGraphicalButton("Modern Mix", KompleteKontrol.XOffset + 110, KompleteKontrol.YOffset + 330, KompleteKontrol.XOffset + 190, KompleteKontrol.YOffset + 360, "Images/KontaktKompleteKontrol/Nucleus/ModernMixOn.png",, "Images/KontaktKompleteKontrol/Nucleus/ModernMixOff.png",, CompensatePluginRegionCoordinates, CompensatePluginRegionCoordinates)
KompleteKontrol.PluginOverlays.Push(NucleusOverlay)

SoloOverlay := AccessibilityOverlay("Solo")
SoloOverlay.Metadata := Map("Vendor", "Audio Imperia", "Product", "Solo", "Image", Map("File", "Images/KontaktKompleteKontrol/Solo/Product.png"))
SoloOverlay.AddAccessibilityOverlay()
SoloOverlay.AddStaticText("Solo")
SoloOverlay.AddGraphicalButton("Classic Mix", KompleteKontrol.XOffset + 70, KompleteKontrol.YOffset + 350, KompleteKontrol.XOffset + 140, KompleteKontrol.YOffset + 370, "Images/KontaktKompleteKontrol/Solo/ClassicMixOn.png",, ["Images/KontaktKompleteKontrol/Solo/ClassicMixOff1.png", "Images/KontaktKompleteKontrol/Solo/ClassicMixOff2.png"],, CompensatePluginRegionCoordinates, CompensatePluginRegionCoordinates)
SoloOverlay.AddGraphicalButton("Modern Mix", KompleteKontrol.XOffset + 140, KompleteKontrol.YOffset + 350, KompleteKontrol.XOffset + 240, KompleteKontrol.YOffset + 370, "Images/KontaktKompleteKontrol/Solo/ModernMixOn.png",, ["Images/KontaktKompleteKontrol/Solo/ModernMixOff1.png", "Images/KontaktKompleteKontrol/Solo/ModernMixOff2.png"],, CompensatePluginRegionCoordinates, CompensatePluginRegionCoordinates)
KompleteKontrol.PluginOverlays.Push(SoloOverlay)

TalosOverlay := AccessibilityOverlay("Talos")
TalosOverlay.Metadata := Map("Vendor", "Audio Imperia", "Product", "Talos", "Image", Map("File", "Images/KontaktKompleteKontrol/Talos/Product.png"))
TalosOverlay.AddAccessibilityOverlay()
TalosOverlay.AddStaticText("Talos")
TalosOverlay.AddGraphicalButton("Classic Mix", KompleteKontrol.XOffset + 70, KompleteKontrol.YOffset + 350, KompleteKontrol.XOffset + 140, KompleteKontrol.YOffset + 370, "Images/KontaktKompleteKontrol/Talos/ClassicMixOn.png",, ["Images/KontaktKompleteKontrol/Talos/ClassicMixOff1.png", "Images/KontaktKompleteKontrol/Talos/ClassicMixOff2.png"],, CompensatePluginRegionCoordinates, CompensatePluginRegionCoordinates)
TalosOverlay.AddGraphicalButton("Modern Mix", KompleteKontrol.XOffset + 140, KompleteKontrol.YOffset + 350, KompleteKontrol.XOffset + 240, KompleteKontrol.YOffset + 370, "Images/KontaktKompleteKontrol/Talos/ModernMixOn.png",, ["Images/KontaktKompleteKontrol/Talos/ModernMixOff1.png", "Images/KontaktKompleteKontrol/Talos/ModernMixOff2.png"],, CompensatePluginRegionCoordinates, CompensatePluginRegionCoordinates)
KompleteKontrol.PluginOverlays.Push(TalosOverlay)

