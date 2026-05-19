#Requires AutoHotkey v2.0

Class Plugin {
    
    Static __New() {
        Plugin.Register("OverlayDesigner", ".*", False, False, 1, True, ObjBindMethod(This, "CheckEditorState"))
    }
    
    Static CheckEditorState(*) {
        If Editor.Active
        Return True
    }
    
}
