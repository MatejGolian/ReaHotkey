Class Fairview {
    
    Static InitClass(ClassName) {
        FairviewOverlay := AccessibilityOverlay("Fairview")
        FairviewOverlay.Metadata := Map("Vendor", "RS Drums", "Product", "Fairview", "Image", Map("File", "Images/KontaktKompleteKontrol/Fairview/Product.png"))
        FairviewOverlay.AddAccessibilityOverlay()
        FairviewOverlay.AddStaticText("Fairview")
        FairviewOverlay.AddCustomButton("Snare selector", %ClassName%.Fairview.MoveToControl, %ClassName%.Fairview.ActivateControl).ClassName := ClassName
        %ClassName%.PluginOverlays.Push(FairviewOverlay)
    }
    
    Class ActivateControl {
        Static Call(OverlayControl) {
            ClassName := OverlayControl.ClassName
            Switch OverlayControl.Label {
                Case "Snare selector":
                %ClassName%.Fairview.MoveToControl(OverlayControl)
                Click
                Kontakt.OpenPluginMenu()
            }
        }
    }
    
    Class MoveToControl {
        Static Call(OverlayControl) {
            ClassName := OverlayControl.ClassName
            XOffset := 0
            YOffset := 0
            If ClassName = "KompleteKontrol" {
                XOffset := 0
                YOffset := 0
            }
            Switch OverlayControl.Label {
                Case "Snare selector":
                MouseMove CompensatePluginXCoordinate(XOffset + 476), CompensatePluginYCoordinate(YOffset + 454)
            }
        }
    }
    
}
