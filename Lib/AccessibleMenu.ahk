#Requires AutoHotkey v2.0

Class AccessibleMenu {
    
    CurrentItem := 0
    Items := Array()
    ParrentMenu := Object()
    Static CurrentMenu := False
    CheckedString := "checked"
    ContextMenuString := "context menu"
    DisabledString := "unavailable"
    LeavingMenuString := "leaving menu"
    SubmenuString := "submenu"
    Static Translations := AccessibleMenu.SetupTranslations()
    
    Add(MenuItemName, CallbackOrSubmenu := "", Options := "") {
        MenuItemName := Trim(MenuItemName)
        If MenuItemName != "" {
            If This.FindItem(MenuItemName) = 0 {
                If CallbackOrSubmenu Is AccessibleMenu
                CallbackOrSubmenu.ParrentMenu := This
                This.Items.Push(Map("Name", MenuItemName, "CallbackOrSubmenu", CallbackOrSubmenu, "Checked", 0, "Enabled", 1))
            }
            Else {
                This.Items[This.FindItem(MenuItemName)]["CallbackOrSubmenu"] := CallbackOrSubmenu
            }
        }
    }
    
    Check(MenuItemName) {
        If This.FindItem(MenuItemName) > 0 {
        }
        This.Items[This.FindItem(MenuItemName)]["Checked"] := 1
    }
    
    CloseSubmenu() {
        If This.Items.Length > 0 {
            If This.ParrentMenu Is AccessibleMenu {
                This := This.ParrentMenu
                This.FocusCurrentItem()
                AccessibleMenu.CurrentMenu := This
            }
        }
    }
    
    ChooseItem() {
        If This.Items.Length > 0 {
            CurrentItem := This.GetCurrentItem()
            If CurrentItem Is Object And CurrentItem["Enabled"] = 1
            If CurrentItem["CallbackOrSubmenu"] Is AccessibleMenu {
                This.OpenSubmenu()
            }
            Else {
                This.Hide()
                CurrentItem["CallbackOrSubmenu"](CurrentItem["Name"], This.CurrentItem, This)
            }
            Else
            This.Hide()
        }
        Return 0
    }
    
    Delete(MenuItemName) {
        If This.FindItem(MenuItemName) > 0 {
            This.Items.RemoveAt(This.FindItem(MenuItemName))
        }
    }
    
    Disable(MenuItemName) {
        If This.FindItem(MenuItemName) > 0 {
            This.Items[This.FindItem(MenuItemName)]["Enabled"] := 0
        }
    }
    
    Enable(MenuItemName) {
        If This.FindItem(MenuItemName) > 0 {
            This.Items[This.FindItem(MenuItemName)]["Enabled"] := 1
        }
    }
    
    FindItem(MenuItemName) {
        MenuItemName := Trim(MenuItemName)
        If MenuItemName != "" And This.Items.Length > 0
        If MenuItemName Is Integer And MenuItemName <= 0 {
            Return 0
        }
        Else If MenuItemName Is Integer And MenuItemName > 0 {
            If MenuItemName <= This.Items.Length
            Return MenuItemName
        }
        Else {
            For Position, Item In This.Items
            If Item["Name"] = MenuItemName
            Return Position
        }
        Return 0
    }
    
    FocusCurrentItem() {
        If This.Items.Length > 0 And This.CurrentItem > 0 {
            Return This.SpeakItem(This.CurrentItem)
        }
        Return 0
    }
    
    FocusFirstItem() {
        If This.Items.Length > 0 {
            This.CurrentItem := 1
            Return This.SpeakItem(This.CurrentItem)
        }
        Return 0
    }
    
    FocusNextItem() {
        If This.Items.Length > 0 {
            This.CurrentItem++
            If This.CurrentItem > This.Items.Length
            This.CurrentItem := 1
            Return This.SpeakItem(This.CurrentItem)
        }
        Return 0
    }
    
    FocusPreviousItem() {
        If This.Items.Length > 0 {
            This.CurrentItem--
            If This.CurrentItem <= 0
            This.CurrentItem := This.Items.Length
            Return This.SpeakItem(This.CurrentItem)
        }
        Return 0
    }
    
    GetCurrentItem() {
        If This.Items.Length >0 And This.CurrentItem > 0 And This.CurrentItem <= This.Items.Length
        Return This.Items[This.CurrentItem]
        Return 0
    }
    
    Hide(Speak := 0) {
        If AccessibleMenu.CurrentMenu = This {
            If Speak
            AccessibilityOverlay.Speak(This.LeavingMenuString)
            AccessibleMenu.CurrentMenu := False
        }
    }
    
    Insert(ItemToInsertBefore, NewItemName, CallbackOrSubmenu := "", Options := "") {
        NewItemName := Trim(NewItemName)
        If This.FindItem(ItemToInsertBefore) > 0 And NewItemName != "" {
            If CallbackOrSubmenu Is AccessibleMenu
            CallbackOrSubmenu.ParrentMenu := This
            This.Items.InsertAt(This.FindItem(ItemToInsertBefore), Map("Name", NewItemName, "CallbackOrSubmenu", CallbackOrSubmenu, "Checked", 0, "Enabled", 1))
        }
    }
    
    OpenSubmenu() {
        If This.Items.Length > 0 And This.CurrentItem > 0 {
            If This.Items[This.CurrentItem]["CallbackOrSubmenu"] Is AccessibleMenu And This.Items[This.CurrentItem]["Enabled"] = 1 {
                This := This.Items[This.CurrentItem]["CallbackOrSubmenu"]
                This.FocusFirstItem()
                AccessibleMenu.CurrentMenu := This
            }
        }
    }
    
    Rename(MenuItemName, NewName := "") {
        NewName := Trim(NewName)
        If This.FindItem(MenuItemName) > 0 And NewName != "" {
            This.Items[This.FindItem(MenuItemName)]["Name"] := NewName
        }
    }
    
    Show() {
        AccessibilityOverlay.Speak(This.ContextMenuString)
        AccessibleMenu.CurrentMenu := This
    }
    
    SpeakItem(Item) {
        If This.Items.Length > 0 And Item > 0 And Item <= This.Items.Length {
            If This.Items[Item]["Enabled"] = 0 And This.Items[Item]["Checked"] = 1 {
                If Not This.Items[Item]["CallbackOrSubmenu"] Is AccessibleMenu
                AccessibilityOverlay.Speak(This.Items[Item]["Name"] . " " . This.DisabledString . " " . This.CheckedString)
                Else
                AccessibilityOverlay.Speak(This.Items[Item]["Name"] . " " . This.DisabledString . " " . This.CheckedString . " " This.SubmenuString)
                Return 1
            }
            Else If This.Items[Item]["Enabled"] = 0 {
                If Not This.Items[Item]["CallbackOrSubmenu"] Is AccessibleMenu
                AccessibilityOverlay.Speak(This.Items[Item]["Name"] . " " . This.DisabledString)
                Else
                AccessibilityOverlay.Speak(This.Items[Item]["Name"] . " " . This.DisabledString . " " This.SubmenuString)
                Return 1
            }
            Else If This.Items[Item]["Checked"] = 1 {
                If Not This.Items[Item]["CallbackOrSubmenu"] Is AccessibleMenu
                AccessibilityOverlay.Speak(This.Items[Item]["Name"] . " " . This.CheckedString)
                Else
                AccessibilityOverlay.Speak(This.Items[Item]["Name"] . " " . This.CheckedString . " " This.SubmenuString)
                Return 1
            }
            Else {
                If Not This.Items[Item]["CallbackOrSubmenu"] Is AccessibleMenu
                AccessibilityOverlay.Speak(This.Items[Item]["Name"])
                Else
                AccessibilityOverlay.Speak(This.Items[Item]["Name"] . " " . This.SubmenuString)
                Return 1
            }
        }
        Return 0
    }
    
    ToggleCheck(MenuItemName) {
        If This.FindItem(MenuItemName) > 0 {
            If This.Items[This.FindItem(MenuItemName)]["Checked"] = 0
            This.Items[This.FindItem(MenuItemName)]["Checked"] := 1
            Else
            This.Items[This.FindItem(MenuItemName)]["Checked"] := 0
        }
    }
    
    ToggleEnable(MenuItemName) {
        If This.FindItem(MenuItemName) > 0 {
            If This.Items[This.FindItem(MenuItemName)]["Enabled"] = 0
            This.Items[This.FindItem(MenuItemName)]["Enabled"] := 1
            Else
            This.Items[This.FindItem(MenuItemName)]["Enabled"] := 0
        }
    }
    
    Translate(Translation := "") {
        If Translation != "" {
            If Not Translation Is Map
            Translation := AccessibleMenu.Translations[Translation]
            If Translation Is Map {
                For Key, Value In Translation
                This.%Key% := Value
                For Item In This.Items
                If Item["CallbackOrSubmenu"] Is AccessibleMenu
                Item["CallbackOrSubmenu"].Translate(Translation)
            }
        }
    }
    
    Uncheck(MenuItemName) {
        If This.FindItem(MenuItemName) > 0 {
            This.Items[This.FindItem(MenuItemName)]["Checked"] := 0
        }
    }
    
    Static SetupTranslations() {
        English := Map(
        "CheckedString", "checked",
        "ContextMenuString", "context menu",
        "DisabledString", "unavailable",
        "LeavingMenuString", "leaving menu",
        "SubmenuString", "submenu"
        )
        English.Default := ""
        Slovak := Map(
        "CheckedString", "začiarknuté",
        "ContextMenuString", "kontext ponuka",
        "DisabledString", "nedostupné",
        "LeavingMenuString", "opúšťam ponuku",
        "SubmenuString", "podmenu"
        )
        Slovak.Default := ""
        Swedish := Map(
        "CheckedString", "kryssad",
        "ContextMenuString", "kontextmeny",
        "DisabledString", "otillgänglig",
        "LeavingMenuString", "lämnar menyn",
        "SubmenuString", "undermeny"
        )
        Swedish.Default := ""
        Translations := Map()
        Translations["English"] := English
        Translations["Slovak"] := Slovak
        Translations["Swedish"] := Swedish
        Translations.Default := ""
        Return Translations
    }
    
}
