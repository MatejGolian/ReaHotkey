#Requires AutoHotkey v2.0

Class Helpers {
    
    Static GetControlChildNumber(ItemID, OverlayObj) {
        If OverlayObj Is TabControl
        PropName := "Tabs"
        Else
        PropName := "ChildControls"
        For ChildControl In OverlayObj.%PropName%
        If ItemID = ChildControl.ControlID
        Return A_Index
        Return False
    }
    
    Static MapToObj(MapToConvert) {
        Converted := Object()
        For Key, Value In MapToConvert
        Converted.DefineProp(Key, {Value: Value})
        Return Converted
    }
    
    Static ObjToMap(ObjToConvert) {
        Converted := Map()
        For PropName, PropValue In ObjToConvert.OwnProps()
        Converted.Set(PropName, PropValue)
        Return Converted
    }
    
}
