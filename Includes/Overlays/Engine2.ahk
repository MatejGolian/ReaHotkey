#Requires AutoHotkey v2.0

Class Engine2 {
    
    Static __New() {
        This.InitConfig()
        
        Plugin.Register("Engine 2", "^Plugin[0-9A-F]{1,}$",, False, False, False, ObjBindMethod(This, "CheckPlugin"))
        Standalone.Register("Engine 2", "Best Service Engine ahk_class Engine ahk_exe Engine 2.exe",, False, False)
        Standalone.Register("Engine 2 Add Library Dialog", "add library... ahk_class #32770 ahk_exe Engine 2.exe", ObjBindMethod(This, "InitAddLibraryDialog"), False, True)
        
        Engine2PluginOverlay := AccessibilityOverlay("Engine 2")
        Engine2PluginOverlay.Metadata := Map("Vendor", "Best Service", "Product", "Engine 2")
        Engine2PluginOverlay.AddHotspotButton("Load instrument", 162, 134, CompensatePluginCoordinates,, CompensatePluginCoordinates)
        Engine2PluginQuickEditTab := HotspotTab("Quick edit", 344, 21, CompensatePluginCoordinates)
        Engine2PluginProEditTab := HotspotTab("Pro edit", 416, 21, CompensatePluginCoordinates)
        Engine2PluginBrowserTab := HotspotTab("Browser", 480, 21, CompensatePluginCoordinates)
        Engine2PluginMixerTab := HotspotTab("Mixer", 520, 21, CompensatePluginCoordinates)
        Engine2PluginPreferencesTab := HotspotTab("Preferences", 572, 21, CompensatePluginCoordinates)
        Engine2PluginHelpTab := HotspotTab("Help", 592, 21, CompensatePluginCoordinates)
        Engine2PluginOverlay.AddTabControl(, Engine2PluginQuickEditTab, Engine2PluginProEditTab, Engine2PluginBrowserTab, Engine2PluginMixerTab, Engine2PluginPreferencesTab, Engine2PluginHelpTab)
        Engine2PluginEngineTab := HotspotTab("Engine", 388, 61, CompensatePluginCoordinates)
        Engine2PluginLibrariesTab := HotspotTab("Libraries", 416, 61, CompensatePluginCoordinates)
        Engine2PluginLibrariesTab.AddHotspotButton("Add library", 428, 95, CompensatePluginCoordinates,, [CompensatePluginCoordinates, ObjBindMethod(This, "ActivatePluginAddLibraryButton")])
        Engine2PluginUserFolderTab := HotspotTab("User folder", 480, 61, CompensatePluginCoordinates)
        Engine2PluginOutputSurrTab := HotspotTab("Output/Surr", 564, 61, CompensatePluginCoordinates)
        Engine2PluginMiscTab := HotspotTab("Misc.", 648, 61, CompensatePluginCoordinates)
        Engine2PluginPreferencesTab.AddTabControl(, Engine2PluginEngineTab, Engine2PluginLibrariesTab, Engine2PluginUserFolderTab, Engine2PluginOutputSurrTab, Engine2PluginMiscTab)
        Plugin.RegisterOverlay("Engine 2", Engine2PluginOverlay)
        
        Engine2StandaloneOverlay := AccessibilityOverlay("Engine 2")
        Engine2StandaloneOverlay.Metadata := Map("Vendor", "Best Service", "Product", "Engine 2")
        Engine2StandaloneOverlay.AddHotspotButton("Load instrument", 162, 134)
        Engine2StandaloneQuickEditTab := HotspotTab("Quick edit", 344, 21)
        Engine2StandaloneProEditTab := HotspotTab("Pro edit", 416, 21)
        Engine2StandaloneBrowserTab := HotspotTab("Browser", 480, 21)
        Engine2StandaloneMixerTab := HotspotTab("Mixer", 520, 21)
        Engine2StandalonePreferencesTab := HotspotTab("Preferences", 572, 21)
        Engine2StandaloneHelpTab := HotspotTab("Help", 592, 21)
        Engine2StandaloneOverlay.AddTabControl(, Engine2StandaloneQuickEditTab, Engine2StandaloneProEditTab, Engine2StandaloneBrowserTab, Engine2StandaloneMixerTab, Engine2StandalonePreferencesTab, Engine2StandaloneHelpTab)
        Engine2StandaloneEngineTab := HotspotTab("Engine", 388, 61)
        Engine2StandaloneLibrariesTab := HotspotTab("Libraries", 416, 61)
        Engine2StandaloneLibrariesTab.AddHotspotButton("Add library", 428, 95)
        Engine2StandaloneUserFolderTab := HotspotTab("User folder", 480, 61)
        Engine2StandaloneOutputSurrTab := HotspotTab("Output/Surr", 564, 61)
        Engine2StandaloneMiscTab := HotspotTab("Misc.", 648, 61)
        Engine2StandalonePreferencesTab.AddTabControl(, Engine2StandaloneEngineTab, Engine2StandaloneLibrariesTab, Engine2StandaloneUserFolderTab, Engine2StandaloneOutputSurrTab, Engine2StandaloneMiscTab)
        Standalone.RegisterOverlay("Engine 2", Engine2StandaloneOverlay)
    }
    
    Static ActivatePluginAddLibraryButton(Engine2AddLibraryButton) {
        Engine2LibrariesTab := Engine2AddLibraryButton.GetSuperordinateControl()
        Engine2PreferencesTab := Engine2LibrariesTab.GetSuperordinateControl()
        Engine2PreferencesTab.Focus(False)
        Engine2LibrariesTab.Focus(False)
        Engine2AddLibraryButton.Focus(False)
        AccessibilityOverlay.Speak("")
    }
    
    Static AltOHK(ThisHotkey) {
        Try {
            ControlFocus "Button2", "A"
            TargetControl := "Button2"
        }
        Catch {
            TargetControl := 0
        }
        Try
        If TargetControl = "Button2"
        ControlClick TargetControl, "A"
        Else
        PassThroughHotkey(ThisHotkey)
    }
    
    Static CheckPlugin(PluginInstance) {
        Thread "NoTimers"
        If PluginInstance Is Plugin And PluginInstance.ControlClass = GetCurrentControlClass()
        If PluginInstance.Name = "Engine 2"
        Return True
        If ReaHotkey.Config.Get("Engine2ImageSearch") = 1 And FindImage("Images/Engine2/Engine2.png", GetPluginXCoordinate() + 492, GetPluginYCoordinate(), GetPluginXCoordinate() + 892, GetPluginYCoordinate() + 100) Is Object
        Return True
        If ReaHotkey.AbletonPlugin {
            If RegExMatch(WinGetTitle("A"), "^Engine 2/[1-9][0-9]*-Engine 2$")
            Return True
        }
        If ReaHotkey.ReaperPluginNative {
            ReaperPluginNames := ["VSTi: ENGINE (Best Service) (24 out)"]
            Try
            ReaperListItem := ListViewGetContent("Focused", "SysListView321", ReaHotkey.PluginWinCriteria)
            Catch
            ReaperListItem := ""
            If Not ReaperListItem = ""
            For ReaperPluginName In ReaperPluginNames
            If ReaperListItem = ReaperPluginName
            Return True
        }
        If ReaHotkey.ReaperPluginBridged {
            Try
            If RegExMatch(WinGetTitle("A"), "^ENGINE \(x(64|86) bridged\)$")
            Return True
            Catch
            Return False
        }
        Return False
    }
    
    Static EnterSpaceHK(ThisHotkey) {
        Try
        CurrentControl := ControlGetClassNN(ControlGetFocus("A"))
        Catch
        CurrentControl := 0
        Try
        If CurrentControl = "Button2"
        ControlClick CurrentControl, "A"
        Else
        PassThroughHotkey(ThisHotkey)
    }
    
    Static InitAddLibraryDialog(StandaloneInstance) {
        ReaHotkey.OverrideStandaloneHotkey("Engine 2 Add Library Dialog", "Enter", ObjBindMethod(This, "EnterSpaceHK"))
        ReaHotkey.OverrideStandaloneHotkey("Engine 2 Add Library Dialog", "Space", ObjBindMethod(This, "EnterSpaceHK"))
        ReaHotkey.OverrideStandaloneHotkey("Engine 2 Add Library Dialog", "!O", ObjBindMethod(This, "AltOHK"))
    }
    
    Static InitConfig() {
        ReaHotkey.Config.Add("ReaHotkey.ini", "Config", "Engine2ImageSearch", 1, "Use image search for plug-in detection", "Engine 2")
    }
    
}
