#Requires AutoHotkey v2.0

#MaxThreadsPerHotkey 1
#SingleInstance Force
#Warn
SendMode "Input"
SetTitleMatchMode "RegEx"
SetWorkingDir A_InitialWorkingDir
CoordMode "Mouse", "Window"
CoordMode "Pixel", "Window"

#Include Includes/AccessibilityOverlay.ahk

AppName := "Engine Access"
Standalone_WinCriteria := "Best Service Engine ahk_class Engine"
ReaperFX_WinCriteria := "ahk_exe reaper.exe ahk_class #32770"
ReaperFX_ControlClasses := Array("Plugin00007.*")

A_IconTip := AppName
A_TrayMenu.Delete("&Pause Script")
A_TrayMenu.Rename("E&xit", "&Close")

AccessibilityOverlay.Speak(AppName . " ready")

StandaloneOverlay := AccessibilityOverlay()
StandaloneOverlay.AddHotspotButton("Load Instrument", 112, 180)
StandAloneQuickEditTab := HotspotTab("Quick Edit", 352, 72)
StandAloneProEditTab := HotspotTab("Pro Edit", 424, 72)
StandAloneBrowserTab := HotspotTab("Browser", 488, 72)
StandAloneMixerTab := HotspotTab("Mixer", 528, 72)
StandAlonePreferencesTab := HotspotTab("Preferences", 580, 72)
StandAloneHelpTab := HotspotTab("Help", 600, 72)
StandaloneOverlay.AddTabControl("", StandAloneQuickEditTab, StandAloneProEditTab, StandAloneBrowserTab, StandAloneMixerTab, StandAlonePreferencesTab, StandAloneHelpTab)
StandAloneEngineTab := HotspotTab("Engine", 396, 112)
StandAloneLibrariesTab := HotspotTab("Libraries", 424, 112)
StandAloneUserFolderTab := HotspotTab("User Folder", 488, 112)
StandAloneOutputSurrTab := HotspotTab("Output/Surr", 572, 112)
StandAloneMiscTab := HotspotTab("Misc.", 656, 112)
StandAlonePreferencesTab.AddTabControl("", StandAloneEngineTab, StandAloneLibrariesTab, StandAloneUserFolderTab, StandAloneOutputSurrTab, StandAloneMiscTab)
StandAloneAddLibraryButton := StandAloneLibrariesTab.AddHotspotButton("Add Library", 436, 146)

PluginOverlay := AccessibilityOverlay()
PluginOverlay.AddHotspotButton("Load Instrument", 320, 232)
PluginQuickEditTab := HotspotTab("Quick Edit", 574, 124)
PluginProEditTab := HotspotTab("Pro Edit", 628, 124)
PluginBrowserTab := HotspotTab("Browser", 686, 124)
PluginMixerTab := HotspotTab("Mixer", 744, 124)
PluginPreferencesTab := HotspotTab("Preferences", 800, 124)
PluginHelpTab := HotspotTab("Help", 850, 124)
PluginOverlay.AddTabControl("", PluginQuickEditTab, PluginProEditTab, PluginBrowserTab, PluginMixerTab, PluginPreferencesTab, PluginHelpTab)
PluginEngineTab := HotspotTab("Engine", 576, 168)
PluginLibrariesTab := HotspotTab("Libraries", 650, 168)
PluginUserFolderTab := HotspotTab("User Folder", 716, 168)
PluginOutputSurrTab := HotspotTab("Output/Surr", 788, 168)
PluginMiscTab := HotspotTab("Misc.", 872, 168)
PluginPreferencesTab.AddTabControl("", PluginEngineTab, PluginLibrariesTab, PluginUserFolderTab, PluginOutputSurrTab, PluginMiscTab)
PluginAddLibraryButton := PluginLibrariesTab.AddHotspotButton("Add Library", 652, 204)

#Include Includes/Standalone.ahk
#Include Includes/ReaperFX.ahk
