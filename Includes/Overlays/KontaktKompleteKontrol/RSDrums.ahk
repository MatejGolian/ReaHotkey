#Requires AutoHotkey v2.0

Class RSDrums {
    
    Static __New() {
        PluginClass := SubStr(This.Prototype.__Class, 1, InStr(This.Prototype.__Class, ".") - 1)
        Kontakt7XOffset := 0
        Kontakt7YOffset := 0
        KompleteKontrolXOffset := 0
        KompleteKontrolYOffset := 0
        
        FairviewOverlay := AccessibilityOverlay("Fairview")
        FairviewOverlay.Metadata := Map("Vendor", "RS Drums", "Product", "Fairview", "Image", Map("File", "Images/KontaktKompleteKontrol/Fairview/Product.png"))
        FairviewOverlay.AddAccessibilityOverlay()
        FairviewOverlay.AddStaticText("Fairview")
        FairviewOverlay.AddHotspotButton("Snare selector", %PluginClass%XOffset + 476, %PluginClass%YOffset + 454, CompensatePluginCoordinates,, CompensatePluginCoordinates, This.OpenMenu)
        %PluginClass%.PluginOverlays.Push(FairviewOverlay)
    }
    
    Class CloseMenu {
        Static Call(ThisHotkey) {
            Thread "NoTimers"
            PluginClass := SubStr(This.Prototype.__Class, 1, InStr(This.Prototype.__Class, ".") - 1)
            If PluginClass = "Kontakt7"
            Name := "Kontakt 7"
            Else
            Name := "Komplete Kontrol"
            SendCommand := ""
            If ThisHotkey = "Escape"
            SendCommand := "{Escape}"
            If ThisHotkey = "!F4"
            SendCommand := "!{F4}"
            HotIfWinActive(ReaHotkey.PluginWinCriteria)
            If ReaHotkey.FoundPlugin Is Plugin And ReaHotkey.FoundPlugin.Name = Name And ReaHotkey.FoundPlugin.NoHotkeys = True {
                ReaHotkey.FoundPlugin.SetNoHotkeys(False)
                TurnHotkeysOff()
                If Not SendCommand = ""
                Send SendCommand
            }
            Else {
                TurnHotkeysOff()
                If Not SendCommand = ""
                Send SendCommand
                TurnHotkeysOn()
            }
            TurnHotkeysOff() {
                ReaHotkey.OverridePluginHotkey(Name, "Escape", "Off")
                ReaHotkey.OverridePluginHotkey(Name, "!F4", "Off")
            }
            TurnHotkeysOn() {
                ReaHotkey.OverridePluginHotkey(Name, "Escape", "On")
                ReaHotkey.OverridePluginHotkey(Name, "!F4", "On")
            }
        }
    }
    
    Class OpenMenu {
        Static Call(*) {
            PluginClass := SubStr(This.Prototype.__Class, 1, InStr(This.Prototype.__Class, ".") - 1)
            VendorClass := SubStr(SubStr(This.Prototype.__Class, InStr(This.Prototype.__Class, ".") + 1), 1, InStr(SubStr(This.Prototype.__Class, InStr(This.Prototype.__Class, ".") + 1), ".") - 1)
            If PluginClass = "Kontakt7"
            Name := "Kontakt 7"
            Else
            Name := "Komplete Kontrol"
            If ReaHotkey.FoundPlugin Is Plugin
            ReaHotkey.FoundPlugin.SetNoHotkeys(True)
            HotIfWinActive(ReaHotkey.PluginWinCriteria)
            ReaHotkey.OverridePluginHotkey(Name, "Escape", %PluginClass%.%VendorClass%.CloseMenu, "On")
            ReaHotkey.OverridePluginHotkey(Name, "!F4", %PluginClass%.%VendorClass%.CloseMenu, "On")
        }
    }
    
}
