#Requires AutoHotkey v2.0

Class SinePlayer {
    
    Static __New() {
        Plugin.Register("SINE Player", "^JUCE_[0-9a-f]+$",, False, 2, False, ObjBindMethod(This, "CheckInstance"))
        Plugin.SetTimer("SINE Player", This.ClickUI, -1)
        Plugin.SetHotkey("SINE Player", "^F6", ObjBindMethod(This, "ToggleFocus"))
    }
    
    Static CheckInstance(Instance) {
        Thread "NoTimers"
        If Instance Is Plugin And Instance.ControlClass = GetCurrentControlClass()
        If Instance.Name = "SINE Player"
        Return True
        RootElement := This.GetRootElement()
        If RootElement Is UIA.IUIAutomationElement
        Return True
        Return False
    }
    
    Static GetRootElement() {
        Critical
        If Not ReaHotkey.PluginWinCriteria Or Not WinActive(ReaHotkey.PluginWinCriteria)
        Return False
        Try
        RootElement := GetUIAWindow()
        Catch
        Return False
        If Not RootElement Is UIA.IUIAutomationElement
        Return False
        If CheckElement(RootElement)
        Return RootElement
        Try
        RootElement := RootElement.FindElement({Name:"SINE Player"})
        Catch
        Return False
        If CheckElement(RootElement)
        Return RootElement
        Return False
        CheckElement(UIAElement) {
            If UIAElement Is UIA.IUIAutomationElement And UIAElement.Type = 50025
            Return True
            Return False
        }
    }
    
    Static ToggleFocus(ToggleHK) {
        Critical
        RootElement := This.GetRootElement()
        If Not RootElement Is UIA.IUIAutomationElement
        Return
        GroupToFocus := 2
        Try
        FocusedElement := UIA.GetFocusedElement()
        Catch
        FocusedElement := False
        If FocusedElement Is UIA.IUIAutomationElement {
            Try
            PathItems := RootElement.GetNumericPath(FocusedElement)
            Catch
            PathItems := Array()
            If PathItems.Length > 1 And PathItems[2] = 32
            GroupToFocus := 1
            Else
            GroupToFocus := 2
        }
        Switch GroupToFocus {
            Case 1:
            Try
            TargetElement := RootElement.FindElement({Type:"Edit"})
            Catch
            TargetElement := False
            If TargetElement Is UIA.IUIAutomationElement
            TargetElement.SetFocus()
            Case 2:
            Try
            TargetElement := RootElement.FindElement({ClassName:"Chrome_WidgetWin_1"})
            Catch
            TargetElement := False
            If TargetElement Is UIA.IUIAutomationElement
            TargetElement.SetFocus()
        }
    }
    
    Class ClickUI {
        Static Call() {
            Static PreviousControlClass := ""
            CurrentControlClass := ReaHotkey.FoundPlugin.ControlClass
            RootElement := SinePlayer.GetRootElement()
            If RootElement Is UIA.IUIAutomationElement {
                RootElement.Click("Left")
                If Not CurrentControlClass = PreviousControlClass
                AccessibilityOverlay.Speak("Use Ctrl+F6 to switch between different parts of the UI.")
                PreviousControlClass := CurrentControlClass
            }
        }
    }
    
}
