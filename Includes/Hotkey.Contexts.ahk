#Requires AutoHotkey v2.0

#HotIf WinActive("ahk_exe Ableton Live 12( (Beta)|(Lite))?.exe ahk_class #32770")
#Include Hotkey.Definitions.ahk

#HotIf WinActive("ahk_exe Ableton Live 12( (Beta)|(Lite))?.exe ahk_class AbletonVstPlugClass")
F6:: F6HK(ThisHotkey)
#IncludeAgain Hotkey.Definitions.ahk

#HotIf WinActive("ahk_exe Ableton Live 12( (Beta)|(Lite))?.exe ahk_class Vst3PlugWindow")
F6:: F6HK(ThisHotkey)
#IncludeAgain Hotkey.Definitions.ahk

#HotIf WinActive("ahk_exe reaper.exe ahk_class #32770")
F6:: F6HK(ThisHotkey)
#IncludeAgain Hotkey.Definitions.ahk

#HotIf WinActive("ahk_exe reaper_host32.exe ahk_class #32770")
F6:: F6HK(ThisHotkey)
#IncludeAgain Hotkey.Definitions.ahk

#HotIf WinActive("ahk_exe reaper_host32.exe ahk_class REAPERb32host")
F6:: F6HK(ThisHotkey)
#IncludeAgain Hotkey.Definitions.ahk

#HotIf WinActive("ahk_exe reaper_host64.exe ahk_class #32770")
F6:: F6HK(ThisHotkey)
#IncludeAgain Hotkey.Definitions.ahk

#HotIf WinActive("ahk_exe reaper_host64.exe ahk_class REAPERb32host")
F6:: F6HK(ThisHotkey)
#IncludeAgain Hotkey.Definitions.ahk

#HotIf WinActive("ahk_exe reaper_host64.exe ahk_class REAPERb32host3")
F6:: F6HK(ThisHotkey)
#IncludeAgain Hotkey.Definitions.ahk

#HotIf
#IncludeAgain Hotkey.Definitions.ahk
