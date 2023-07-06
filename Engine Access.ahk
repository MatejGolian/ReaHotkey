#requires autoHotkey v2.0

#maxThreadsPerHotkey 1
#singleInstance Force
#warn
sendMode "input"
setTitleMatchMode "regEx"
setWorkingDir A_InitialWorkingDir
coordMode "mouse", "window"
coordMode "pixel", "window"

#include Includes/accessibilityOverlay.ahk

appName := "Engine Access"
standalone_winCriteria := "Best Service Engine ahk_class Engine"
reaperFX_winCriteria := "ahk_exe reaper.exe ahk_class #32770"
reaperFX_controlClasses := array("Plugin00007.*")

A_IconTip := appName
A_TrayMenu.rename("E&xit", "&Close")

accessibilityOverlay.speak(appName . " ready")

standaloneOverlay := accessibilityOverlay()
standaloneOverlay.addHotspotButton("Load instrument", 112, 180)
standAloneQuickEditTab := hotspotTab("Quick edit", 352, 72)
standAloneProEditTab := hotspotTab("Pro edit", 424, 72)
standAloneBrowserTab := hotspotTab("Browser", 488, 72)
standAloneMixerTab := hotspotTab("Mixer", 528, 72)
standAlonePreferencesTab := hotspotTab("Preferences", 580, 72)
standAloneHelpTab := hotspotTab("Help", 600, 72)
standaloneOverlay.addTabControl("", standAloneQuickEditTab, standAloneProEditTab, standAloneBrowserTab, standAloneMixerTab, standAlonePreferencesTab, standAloneHelpTab)
standAloneEngineTab := hotspotTab("Engine", 396, 112)
standAloneLibrariesTab := hotspotTab("Libraries", 424, 112)
standAloneUserFolderTab := hotspotTab("User folder", 488, 112)
standAloneOutputSurrTab := hotspotTab("Output/Surr", 572, 112)
standAloneMiscTab := hotspotTab("Misc.", 656, 112)
standAlonePreferencesTab.AddTabControl("", standAloneEngineTab, standAloneLibrariesTab, standAloneUserFolderTab, standAloneOutputSurrTab, standAloneMiscTab)
standAloneAddLibraryButton := standAloneLibrariesTab.AddHotspotButton("Add library", 436, 146)

pluginOverlay := accessibilityOverlay()
pluginOverlay.addHotspotButton("Load instrument", 320, 232)
pluginQuickEditTab := hotspotTab("Quick edit", 574, 124)
pluginProEditTab := hotspotTab("Pro edit", 628, 124)
pluginBrowserTab := hotspotTab("Browser", 686, 124)
pluginMixerTab := hotspotTab("Mixer", 744, 124)
pluginPreferencesTab := hotspotTab("Preferences", 800, 124)
pluginHelpTab := hotspotTab("Help", 850, 124)
pluginOverlay.addTabControl("", pluginQuickEditTab, pluginProEditTab, pluginBrowserTab, pluginMixerTab, pluginPreferencesTab, pluginHelpTab)
pluginEngineTab := hotspotTab("Engine", 576, 168)
pluginLibrariesTab := hotspotTab("Libraries", 650, 168)
pluginUserFolderTab := hotspotTab("User folder", 716, 168)
pluginOutputSurrTab := hotspotTab("Output/Surr", 788, 168)
pluginMiscTab := hotspotTab("Misc.", 872, 168)
pluginPreferencesTab.AddTabControl("", pluginEngineTab, pluginLibrariesTab, pluginUserFolderTab, pluginOutputSurrTab, pluginMiscTab)
pluginAddLibraryButton := pluginLibrariesTab.AddHotspotButton("Add library", 652, 204)

#include Includes/standalone.ahk
#include Includes/reaperFX.ahk
