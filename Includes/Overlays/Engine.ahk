#Requires AutoHotkey v2.0

Class Engine {
    
    Static __New() {
        
        Plugin.Register("Engine", "^Plugin[0-9A-F]{17}$",, True)
        Standalone.Register("Engine", "Best Service Engine ahk_class Engine ahk_exe Engine 2.exe")
        
        EnginePluginOverlay := AccessibilityOverlay("Engine")
        EnginePluginOverlay.Metadata := Map("Vendor", "Best Service", "Product", "Engine")
        EnginePluginOverlay.AddHotspotButton("Load instrument", 170, 185, CompensatePluginPointCoordinates, CompensatePluginPointCoordinates)
        EnginePluginQuickEditTab := HotspotTab("Quick edit", 352, 72, CompensatePluginPointCoordinates)
        EnginePluginProEditTab := HotspotTab("Pro edit", 424, 72, CompensatePluginPointCoordinates)
        EnginePluginBrowserTab := HotspotTab("Browser", 488, 72, CompensatePluginPointCoordinates)
        EnginePluginMixerTab := HotspotTab("Mixer", 528, 72, CompensatePluginPointCoordinates)
        EnginePluginPreferencesTab := HotspotTab("Preferences", 580, 72, CompensatePluginPointCoordinates)
        EnginePluginHelpTab := HotspotTab("Help", 600, 72, CompensatePluginPointCoordinates)
        EnginePluginOverlay.AddTabControl(, EnginePluginQuickEditTab, EnginePluginProEditTab, EnginePluginBrowserTab, EnginePluginMixerTab, EnginePluginPreferencesTab, EnginePluginHelpTab)
        EnginePluginEngineTab := HotspotTab("Engine", 396, 112, CompensatePluginPointCoordinates)
        EnginePluginLibrariesTab := HotspotTab("Libraries", 424, 112, CompensatePluginPointCoordinates)
        EnginePluginAddLibraryButton := EnginePluginLibrariesTab.AddHotspotButton("Add library", 436, 146, CompensatePluginPointCoordinates, [CompensatePluginPointCoordinates, ObjBindMethod(Engine, "ActivatePluginAddLibraryButton")])
        EnginePluginUserFolderTab := HotspotTab("User folder", 488, 112, CompensatePluginPointCoordinates)
        EnginePluginOutputSurrTab := HotspotTab("Output/Surr", 572, 112, CompensatePluginPointCoordinates)
        EnginePluginMiscTab := HotspotTab("Misc.", 656, 112, CompensatePluginPointCoordinates)
        EnginePluginPreferencesTab.AddTabControl(, EnginePluginEngineTab, EnginePluginLibrariesTab, EnginePluginUserFolderTab, EnginePluginOutputSurrTab, EnginePluginMiscTab)
        Plugin.RegisterOverlay("Engine", EnginePluginOverlay)
        
        EngineStandaloneOverlay := AccessibilityOverlay("Engine")
        EngineStandaloneOverlay.Metadata := Map("Vendor", "Best Service", "Product", "Engine")
        EngineStandaloneOverlay.AddHotspotButton("Load instrument", 170, 185)
        EngineStandaloneQuickEditTab := HotspotTab("Quick edit", 352, 72)
        EngineStandaloneProEditTab := HotspotTab("Pro edit", 424, 72)
        EngineStandaloneBrowserTab := HotspotTab("Browser", 488, 72)
        EngineStandaloneMixerTab := HotspotTab("Mixer", 528, 72)
        EngineStandalonePreferencesTab := HotspotTab("Preferences", 580, 72)
        EngineStandaloneHelpTab := HotspotTab("Help", 600, 72)
        EngineStandaloneOverlay.AddTabControl(, EngineStandaloneQuickEditTab, EngineStandaloneProEditTab, EngineStandaloneBrowserTab, EngineStandaloneMixerTab, EngineStandalonePreferencesTab, EngineStandaloneHelpTab)
        EngineStandaloneEngineTab := HotspotTab("Engine", 396, 112)
        EngineStandaloneLibrariesTab := HotspotTab("Libraries", 424, 112)
        EngineStandaloneAddLibraryButton := EngineStandaloneLibrariesTab.AddHotspotButton("Add library", 436, 146)
        EngineStandaloneUserFolderTab := HotspotTab("User folder", 488, 112)
        EngineStandaloneOutputSurrTab := HotspotTab("Output/Surr", 572, 112)
        EngineStandaloneMiscTab := HotspotTab("Misc.", 656, 112)
        EngineStandalonePreferencesTab.AddTabControl(, EngineStandaloneEngineTab, EngineStandaloneLibrariesTab, EngineStandaloneUserFolderTab, EngineStandaloneOutputSurrTab, EngineStandaloneMiscTab)
        Standalone.RegisterOverlay("Engine", EngineStandaloneOverlay)
        
    }
    
    Static ActivatePluginAddLibraryButton(EngineAddLibraryButton) {
        EngineLibrariesTab := EngineAddLibraryButton.GetSuperordinateControl()
        EnginePreferencesTab := EngineLibrariesTab.GetSuperordinateControl()
        EnginePreferencesTab.Focus(EnginePreferencesTab.ControlID)
        EngineLibrariesTab.Focus(EngineLibrariesTab.ControlID)
        EngineAddLibraryButton.Focus(EngineAddLibraryButton.ControlID)
        AccessibilityOverlay.Speak("")
    }
    
}
