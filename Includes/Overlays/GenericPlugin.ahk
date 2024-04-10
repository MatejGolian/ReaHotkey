#Requires AutoHotkey v2.0

Class GenericPlugin {
    
    Static __New() {
        Plugin.Register("Generic Plug-in", "^Plugin[0-9A-F]{17}$",, True, False, True)
        Plugin.RegisterOverlay("Generic Plug-in", AccessibilityOverlay())
        PluginLoader.AddImageCheck("Generic Plug-in", "Engine 2", "Images/Engine2/Engine2.png")
        PluginLoader.AddImageCheck("Generic Plug-in", "sforzando", "Images/Sforzando/Sforzando.png")
        Plugin.SetTimer("Generic Plug-in", ObjBindMethod(PluginLoader, "DetectPlugin", "Generic Plug-in"), 200)
    }
    
}
