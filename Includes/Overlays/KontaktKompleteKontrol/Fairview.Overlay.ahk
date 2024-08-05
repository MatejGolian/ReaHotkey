Class Fairview {
    
    Static InitClass(ClassName) {
        FairviewOverlay := AccessibilityOverlay("Fairview")
        FairviewOverlay.Metadata := Map("Vendor", "RS Drums", "Product", "Fairview", "Image", Map("File", "Images/KontaktKompleteKontrol/Fairview/Product.png"))
        FairviewOverlay.AddAccessibilityOverlay()
        FairviewOverlay.AddStaticText("Fairview")
        FairviewOverlay.AddCustomButton("Snare selector", %ClassName%.Fairview.MoveToControl, %ClassName%.Fairview.ActivateControl)
        %ClassName%.PluginOverlays.Push(FairviewOverlay)
    }
    
    Class ActivateControl {
        Static Call(OverlayControl) {
            Switch OverlayControl.Label {
                Case "Snare selector":
                Kontakt.Fairview.MoveToControl(OverlayControl)
                Click
                Kontakt.OpenPluginMenu()
            }
        }
    }
    
    Class MoveToControl {
        Static Call(OverlayControl) {
            Switch OverlayControl.Label {
                Case "Snare selector":
                MouseMove CompensatePluginXCoordinate(476), CompensatePluginYCoordinate(454)
            }
        }
    }
    
}
