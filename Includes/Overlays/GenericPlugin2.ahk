#Requires AutoHotkey v2.0

Class GenericPlugin2 Extends PluginLoader {
    
    Static __New() {
        Plugin.Register("Generic Plug-in 2", "^Qt6[0-9][0-9]QWindowIcon\{[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\}1$",, True, False, True)
        Plugin.RegisterOverlay("Generic Plug-in 2", AccessibilityOverlay())
        PluginLoader.AddImageCheck("Kontakt/Komplete Kontrol", "Images/KontaktKompleteKontrol/KontaktFull.png")
        PluginLoader.AddImageCheck("Kontakt/Komplete Kontrol", "Images/KontaktKompleteKontrol/KontaktPlayer.png")
        PluginLoader.AddImageCheck("Kontakt/Komplete Kontrol", "Images/KontaktKompleteKontrol/KompleteKontrol.png")
        Plugin.SetTimer("Generic Plug-in 2", ObjBindMethod(PluginLoader, "DetectPlugin", "Generic Plug-in 2"), 250)
    }
    
}
