#Requires AutoHotkey v2.0

Class GenericPlugin1 Extends PluginLoader {
    
    Static __New() {
        Plugin.Register("Generic Plug-in 1", "^Plugin[0-9A-F]{17}$",, True, False, True)
        Plugin.RegisterOverlay("Generic Plug-in 1", AccessibilityOverlay())
        PluginLoader.AddImageCheck("Engine 2", "Images/Engine2/Engine2.png")
        PluginLoader.AddImageCheck("sforzando", "Images/Sforzando/Sforzando.png")
        Plugin.SetTimer("Generic Plug-in 1", ObjBindMethod(PluginLoader, "DetectPlugin", "Generic Plug-in 1"), 200)
    }
    
}
