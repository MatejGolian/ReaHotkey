Class Fairview {
    
    Static InitClass(ParentClassName) {
        FairviewOverlay := AccessibilityOverlay("Fairview")
        FairviewOverlay.Metadata := Map("Vendor", "RS Drums", "Product", "Fairview", "Image", Map("File", "Images/KontaktKompleteKontrol/Fairview/Product.png"))
        FairviewOverlay.AddAccessibilityOverlay()
        FairviewOverlay.AddStaticText("Fairview")
        FairviewOverlay.AddCustomButton("Snare selector", %ParentClassName%.Fairview.MoveToControl, %ParentClassName%.Fairview.ActivateControl).ParentClassName := ParentClassName
        %ParentClassName%.PluginOverlays.Push(FairviewOverlay)
    }
    
    Class ActivateControl {
        Static Call(OverlayControl) {
            Switch OverlayControl.Label {
                Case "Snare selector":
                %OverlayControl.ParentClassName%.Fairview.MoveToControl(OverlayControl)
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
