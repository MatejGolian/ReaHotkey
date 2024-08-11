#Requires AutoHotkey v2.0

#SuspendExempt

Ctrl:: ControlHK(ThisHotkey)
^+#R:: MenuHK(ThisHotkey)
^+#Q:: QuitHK(ThisHotkey)
^+#F5:: ReloadHK(ThisHotkey)
^+#A:: AboutHK(ThisHotkey)
^+#C:: ConfigHK(ThisHotkey)
^+#P:: PauseHK(ThisHotkey)
^+#F1:: ReadmeHK(ThisHotkey)

#SuspendExempt False
