#Requires AutoHotkey v2.0

Class KontaktKompleteKontrol {
    
    Static Init() {
        
        Plugin.Register("Kontakt/Komplete Kontrol", ["^NIVSTChildWindow00007.*", "^Qt6[0-9][0-9]QWindowIcon\{[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\}1"],, True)
        
        AreiaOverlay := AccessibilityOverlay("Areia")
        AreiaOverlay.Metadata := Map("Vendor", "Audio Imperia", "Product", "Areia", "Image", "Images/KontaktKompleteKontrol/Areia.png")
        AreiaOverlay.AddHotspotButton("Classic Mix", 468, 395, CompensatePluginPointCoordinates, CompensatePluginPointCoordinates)
        AreiaOverlay.AddHotspotButton("Modern Mix", 565, 395, CompensatePluginPointCoordinates, CompensatePluginPointCoordinates)
        Plugin.RegisterOverlay("Kontakt/Komplete Kontrol", AreiaOverlay)
        
        JaegerOverlay := AccessibilityOverlay("Jaeger")
        JaegerOverlay.Metadata := Map("Vendor", "Audio Imperia", "Product", "Jaeger", "Image", "Images/KontaktKompleteKontrol/Jaeger.png")
        JaegerOverlay.AddHotspotButton("Classic Mix", 468, 395, CompensatePluginPointCoordinates, CompensatePluginPointCoordinates)
        JaegerOverlay.AddHotspotButton("Modern Mix", 565, 395, CompensatePluginPointCoordinates, CompensatePluginPointCoordinates)
        Plugin.RegisterOverlay("Kontakt/Komplete Kontrol", JaegerOverlay)
        
        NucleusOverlay := AccessibilityOverlay("Nucleus")
        NucleusOverlay.Metadata := Map("Vendor", "Audio Imperia", "Product", "Nucleus", "Image", "Images/KontaktKompleteKontrol/Nucleus.png")
        NucleusOverlay.AddHotspotButton("Classic Mix", 480, 349, CompensatePluginPointCoordinates, CompensatePluginPointCoordinates)
        NucleusOverlay.AddHotspotButton("Modern Mix", 480, 379, CompensatePluginPointCoordinates, CompensatePluginPointCoordinates)
        Plugin.RegisterOverlay("Kontakt/Komplete Kontrol", NucleusOverlay)
        
        TalosOverlay := AccessibilityOverlay("Talos")
        TalosOverlay.Metadata := Map("Vendor", "Audio Imperia", "Product", "Talos", "Image", "Images/KontaktKompleteKontrol/Talos.png")
        TalosOverlay.AddHotspotButton("Classic Mix", 468, 395, CompensatePluginPointCoordinates, CompensatePluginPointCoordinates)
        TalosOverlay.AddHotspotButton("Modern Mix", 565, 395, CompensatePluginPointCoordinates, CompensatePluginPointCoordinates)
        Plugin.RegisterOverlay("Kontakt/Komplete Kontrol", TalosOverlay)
        
        ShreddageOverlay := AccessibilityOverlay("Shreddage Series")
        ShreddageOverlay.Metadata := Map("Vendor", "Impact Soundworks", "Product", "Shreddage Series")
        ShreddageOverlay.AddHotspotButton("Guitar Number 1", 842, 471, CompensatePluginPointCoordinates, CompensatePluginPointCoordinates)
        ShreddageOverlay.AddHotspotButton("Guitar Number 2", 866, 471, CompensatePluginPointCoordinates, CompensatePluginPointCoordinates)
        ShreddageOverlay.AddHotspotButton("Guitar Number 3", 890, 471, CompensatePluginPointCoordinates, CompensatePluginPointCoordinates)
        ShreddageOverlay.AddHotspotButton("Guitar Number 4", 914, 471, CompensatePluginPointCoordinates, CompensatePluginPointCoordinates)
        Plugin.RegisterOverlay("Kontakt/Komplete Kontrol", ShreddageOverlay)
        
        Plugin.SetTimer("Kontakt/Komplete Kontrol", ObjBindMethod(KontaktKompleteKontrol, "DetectLibrary"), 200)
        
    }
    
    Static DetectLibrary() {
        OverlayList := Plugin.GetOverlays("Kontakt/Komplete Kontrol")
        UnknownProductCounter := 1
        For OverlayNumber, OverlayEntry In OverlayList {
            FoundX := ""
            FoundY := ""
            If HasProp(OverlayEntry, "Metadata") And OverlayEntry.Metadata.Has("Product") And OverlayEntry.Metadata["Product"] != "" {
                Product := OverlayEntry.Metadata["Product"]
            }
            Else If OverlayEntry.Label != "" {
                Product := OverlayEntry.Label
            }
            Else {
                Product := "unknown product " . UnknownProductCounter
                UnknownProductCounter++
            }
            If ReaHotkey.FoundPlugin.Overlay.OverlayNumber != OverlayEntry.OverlayNumber
            If HasProp(OverlayEntry, "Metadata") And OverlayEntry.Metadata.Has("Image") And OverlayEntry.Metadata["Image"] != ""
            If FileExist(OverlayEntry.Metadata["Image"])
            If ImageSearch(&FoundX, &FoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, OverlayEntry.Metadata["Image"])
            If ReaHotkey.FoundPlugin.Chooser == True {
                ReaHotkey.FoundPlugin.Overlay := AccessibilityOverlay(OverlayEntry.Label)
                ReaHotkey.FoundPlugin.Overlay.OverlayNumber := OverlayNumber
                If HasProp(OverlayEntry, "Metadata")
                ReaHotkey.FoundPlugin.Overlay.Metadata := OverlayEntry.Metadata
                ReaHotkey.FoundPlugin.Overlay.AddControl(OverlayEntry.Clone())
                ReaHotkey.FoundPlugin.Overlay.AddControl(Plugin.ChooserOverlay.Clone())
                ReaHotkey.FoundPlugin.Overlay.ChildControls[2].ChildControls[1].Label := "Overlay: " . Product
                AccessibilityOverlay.Speak(Product . " overlay active")
                Break
            }
            Else {
                ReaHotkey.FoundPlugin.Overlay := OverlayEntry.Clone()
                AccessibilityOverlay.Speak(Product . " overlay active")
                Break
                }
        }
    }
    
}

KontaktKompleteKontrol.Init()
