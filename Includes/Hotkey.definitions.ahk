#Requires AutoHotkey v2.0

#HotIf WinActive("ahk_exe reaper.exe ahk_class #32770")

F6:: F6HK(ThisHotkey)

#Include Contextual.Hotkeys.ahk
#Include Global.Hotkeys.ahk

#HotIf

#IncludeAgain Contextual.Hotkeys.ahk
#IncludeAgain Global.Hotkeys.ahk
