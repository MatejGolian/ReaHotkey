#Requires AutoHotkey v2.0

Class AutoKey2 {
    
    Static __New() {
        Plugin.Register("Auto-Key 2", "^JUCE_[0-9a-f]{1,}$", ObjBindMethod(This, "CheckPlugin"), False, False, False, 1, False)
        AutoKey2Overlay := PluginOverlay("Auto-Key 2", "Auto-Key 2")
        AutoKey2Overlay.AddOCRButton("", "", "TesseractBest", 225, 55, 310, 80, , , , , , , "!f", "Alt + F")
        AutoKey2Overlay.AddOCRButton("", "", "TesseractBest", 205, 305, 325, 330, , 2, , , , , "!s", "Alt + S")
    }
    
    Static CheckPlugin(PluginInstance) {
        Thread "NoTimers"
        If PluginInstance Is Plugin And PluginInstance.ControlClass = ReaHotkey.GetPluginControl()
        If PluginInstance.Name = "Auto-Key 2"
        Return True
        If ReaHotkey.AbletonPlugin {
            If RegExMatch(WinGetTitle("A"), "^Auto-Key/[1-9][0-9]*")
            Return True
            If RegExMatch(WinGetTitle("A"), "^Auto-Key 2/[1-9][0-9]*")
            Return True
        }
        If ReaHotkey.ReaperPluginNative {
            ReaperPluginNames := ["VST3: Auto-Key (Antares)", "VST3: Auto-Key 2 (Antares)"]
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
            Try {
                If RegExMatch(WinGetTitle("A"), "^Auto-Key \(x(64|86) bridged\)$")
                Return True
                If RegExMatch(WinGetTitle("A"), "^Auto-Key 2 \(x(64|86) bridged\)$")
                Return True
            }
            Catch {
                Return False
            }
        }
        Return False
    }
    
}
