#Requires AutoHotkey v2.0

Tab:: TabHK(ThisHotkey)
+Tab:: ShiftTabHK(ThisHotkey)
^Tab:: ControlTabHK(ThisHotkey)
^+Tab:: ControlShiftTabHK(ThisHotkey)
Left:: LeftRightHK(ThisHotkey)
Right:: LeftRightHK(ThisHotkey)
Up:: UpDownHK(ThisHotkey)
Down:: UpDownHK(ThisHotkey)
Enter:: EnterSpaceHK(ThisHotkey)
Space:: EnterSpaceHK(ThisHotkey)

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
