#Requires AutoHotkey v2.0

#HotIf WinActive("ahk_exe Ableton Live 12(.*).exe ahk_class #32770")
#Include Hotkeys.Common.ahk

#HotIf WinActive("ahk_exe Ableton Live 12(.*).exe ahk_class AbletonVstPlugClass")
#Include Hotkeys.Plugin.ahk
#IncludeAgain Hotkeys.Common.ahk
#HotIf WinActive("ahk_exe Ableton Live 12(.*).exe ahk_class Vst3PlugWindow")
#IncludeAgain Hotkeys.Plugin.ahk
#IncludeAgain Hotkeys.Common.ahk

#HotIf WinActive("ahk_exe reaper.exe ahk_class #32770")
#IncludeAgain Hotkeys.Plugin.ahk
#IncludeAgain Hotkeys.Common.ahk
#HotIf WinActive("ahk_exe reaper_host32.exe ahk_class #32770")
#IncludeAgain Hotkeys.Plugin.ahk
#IncludeAgain Hotkeys.Common.ahk
#HotIf WinActive("ahk_exe reaper_host32.exe ahk_class REAPERb32host")
#IncludeAgain Hotkeys.Plugin.ahk
#IncludeAgain Hotkeys.Common.ahk
#HotIf WinActive("ahk_exe reaper_host64.exe ahk_class #32770")
#IncludeAgain Hotkeys.Plugin.ahk
#IncludeAgain Hotkeys.Common.ahk
#HotIf WinActive("ahk_exe reaper_host64.exe ahk_class REAPERb32host")
#IncludeAgain Hotkeys.Plugin.ahk
#IncludeAgain Hotkeys.Common.ahk
#HotIf WinActive("ahk_exe reaper_host64.exe ahk_class REAPERb32host3")
#IncludeAgain Hotkeys.Plugin.ahk
#IncludeAgain Hotkeys.Common.ahk

#HotIf WinActive("Vochlea\sDubler\s2\.2 ahk_class Qt5155QWindowOwnDCIcon")
#IncludeAgain Hotkeys.Common.ahk

#HotIf WinActive("Best Service Engine ahk_class Engine ahk_exe Engine 2.exe")
#IncludeAgain Hotkeys.Common.ahk
#HotIf WinActive("add library... ahk_class #32770 ahk_exe Engine 2.exe")
#IncludeAgain Hotkeys.Common.ahk

#HotIf WinActive("Kontakt 7 ahk_class NINormalWindow* ahk_exe Kontakt 7.exe")
#IncludeAgain Hotkeys.Common.ahk
#HotIf WinActive("Content Missing ahk_class #32770 ahk_exe Kontakt 7.exe")
#IncludeAgain Hotkeys.Common.ahk

#HotIf WinActive("Kontakt 8 ahk_class NINormalWindow* ahk_exe Kontakt 8.exe")
#IncludeAgain Hotkeys.Common.ahk
#HotIf WinActive("Content Missing ahk_class #32770 ahk_exe Kontakt 8.exe")
#IncludeAgain Hotkeys.Common.ahk

#HotIf WinActive("Komplete Kontrol ahk_class NINormalWindow* ahk_exe Komplete Kontrol.exe")
#IncludeAgain Hotkeys.Common.ahk
#HotIf WinActive("Preferences ahk_class #32770 ahk_exe Komplete Kontrol.exe")
#IncludeAgain Hotkeys.Common.ahk
#HotIf WinActive("ahk_class #32770 ahk_exe Komplete Kontrol.exe")
#IncludeAgain Hotkeys.Common.ahk

#HotIf WinActive("Plogue Art et Technologie, Inc sforzando ahk_class PLGWindowClass ahk_exe sforzando( x64)?.exe")
#IncludeAgain Hotkeys.Common.ahk

#HotIf
#Include Hotkeys.Global.ahk
