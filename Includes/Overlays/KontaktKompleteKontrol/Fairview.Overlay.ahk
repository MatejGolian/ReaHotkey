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
    ClassName := OverlayControl.ClassName
        Static Call(OverlayControl) {
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
            Switch OverlayControl.Label {
                Case "Snare selector":
                MouseMove CompensatePluginXCoordinate(476), CompensatePluginYCoordinate(454)
            }
        }
    }
    
}
