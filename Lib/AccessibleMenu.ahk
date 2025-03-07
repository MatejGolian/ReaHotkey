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
    Static Translations := Map()
    
    Static __New() {
        This.Translations := This.SetupTranslations()
    }
    
    Add(MenuItemName, CallbackOrSubmenu := "", Options := "") {
        MenuItemName := Trim(MenuItemName)
        If Not MenuItemName = "" {
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
        If This.Items.Length > 0 And This.CurrentItem > 0 And This.CurrentItem <= This.Items.Length {
            CurrentItem := This.GetCurrentItem()
            If CurrentItem Is Map And CurrentItem["Enabled"] = 1
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
        If Not MenuItemName = "" And This.Items.Length > 0
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
    
    FocusByFirstCharacter(Character) {
        If This.Items.Length > 0 {
            Character := StrUpper(Character)
            FirstCharacters := Map()
            For Index, Value In This.Items
            If Value["Enabled"] = 1 {
                If FirstCharacters.Has(StrUpper(SubStr(Value["Name"], 1, 1)))
                FirstCharacters[StrUpper(SubStr(Value["Name"], 1, 1))].Push(Index)
                Else
                FirstCharacters.Set(StrUpper(SubStr(Value["Name"], 1, 1)), Array(Index))
            }
            If FirstCharacters.Has(Character) {
                If FirstCharacters[Character].Length = 1 {
                    This.CurrentItem := FirstCharacters[Character][1]
                    This.ChooseItem()
                    Return 1
                }
                Else {
                    CurrentItem := This.GetCurrentItem()
                    If Not CurrentItem Is Map {
                        This.CurrentItem := FirstCharacters[Character][1]
                        This.SpeakItem(This.CurrentItem)
                        Return 1
                    }
                    Else {
                        For Index, Value In FirstCharacters[Character]
                        If Value > This.CurrentItem {
                            This.CurrentItem := Value
                            This.SpeakItem(This.CurrentItem)
                            Return 1
                        }
                        This.CurrentItem := FirstCharacters[Character][1]
                        This.SpeakItem(This.CurrentItem)
                        Return 1
                    }
                }
            }
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
        If This.FindItem(ItemToInsertBefore) > 0 And Not NewItemName = "" {
            If CallbackOrSubmenu Is AccessibleMenu
            CallbackOrSubmenu.ParrentMenu := This
            This.Items.InsertAt(This.FindItem(ItemToInsertBefore), Map("Name", NewItemName, "CallbackOrSubmenu", CallbackOrSubmenu, "Checked", 0, "Enabled", 1))
        }
    }
    
    KeyWaitCombo() {
        IH := InputHook()
        IH.VisibleNonText := True
        IH.KeyOpt("{All}", "E")
        IH.KeyOpt("{LCtrl}{RCtrl}{LAlt}{RAlt}{LShift}{RShift}{LWin}{RWin}", "-E")
        IH.Timeout := 0.125
        IH.Start()
        IH.Wait(0.125)
        Return RegExReplace(IH.EndMods . IH.EndKey, "[<>](.)(?:>\1)?", "$1")
    }
    
    KeyWaitSingle() {
        IH := InputHook()
        IH.VisibleNonText := True
        IH.KeyOpt("{All}", "E")
        IH.Start()
        IH.Wait()
        Return IH.EndKey
    }
    
    Manage() {
        If AccessibleMenu.CurrentMenu Is AccessibleMenu {
            KeyCombo := AccessibleMenu.CurrentMenu.KeyWaitCombo()
            If KeyCombo = "!F4" {
                If AccessibleMenu.CurrentMenu Is AccessibleMenu
                AccessibleMenu.CurrentMenu.Hide(True)
                Return
            }
            Else If KeyCombo = "!Tab" {
                If AccessibleMenu.CurrentMenu Is AccessibleMenu
                AccessibleMenu.CurrentMenu.Hide(True)
                Return
            }
            Else If KeyCombo = "^Tab" {
                Return
            }
            Else If KeyCombo = "+F10" {
                If AccessibleMenu.CurrentMenu Is AccessibleMenu
                AccessibleMenu.CurrentMenu.Hide(True)
                Return
            }
            Else If KeyCombo = "+Tab" {
                If AccessibleMenu.CurrentMenu Is AccessibleMenu
                SoundPlay "*48"
                Return
            }
            Else {
                SingleKey := ""
                If SubStr(KeyCombo, 1, 1) = "+" And StrLen(SubStr(KeyCombo, 2)) = 1
                SingleKey := SubStr(KeyCombo, 2)
                Else
                If AccessibleMenu.CurrentMenu Is AccessibleMenu
                SingleKey := AccessibleMenu.CurrentMenu.KeyWaitSingle()
                If SubStr(SingleKey, 1, 6) = "Numpad"
                SingleKey := SubStr(SingleKey, 7)
                If SingleKey = "AppsKey" Or SingleKey = "LAlt" Or SingleKey = "RAlt" Or SingleKey = "LWin" Or SingleKey = "RWin" {
                    If AccessibleMenu.CurrentMenu Is AccessibleMenu
                    AccessibleMenu.CurrentMenu.Hide(True)
                    Return
                }
                If SingleKey = "Escape" {
                    If AccessibleMenu.CurrentMenu Is AccessibleMenu
                    AccessibleMenu.CurrentMenu.Hide(True)
                    Return
                }
                If SingleKey = "Down" {
                    If AccessibleMenu.CurrentMenu Is AccessibleMenu
                    AccessibleMenu.CurrentMenu.FocusNextItem()
                    Return
                }
                If SingleKey = "Up" {
                    If AccessibleMenu.CurrentMenu Is AccessibleMenu
                    AccessibleMenu.CurrentMenu.FocusPreviousItem()
                    Return
                }
                If SingleKey = "Right" {
                    If AccessibleMenu.CurrentMenu Is AccessibleMenu
                    AccessibleMenu.CurrentMenu.OpenSubmenu()
                    Return
                }
                If SingleKey = "Left" {
                    If AccessibleMenu.CurrentMenu Is AccessibleMenu
                    AccessibleMenu.CurrentMenu.CloseSubmenu()
                    Return
                }
                If SingleKey = "Enter" {
                    If AccessibleMenu.CurrentMenu Is AccessibleMenu
                    AccessibleMenu.CurrentMenu.ChooseItem()
                    Return
                }
                If AccessibleMenu.CurrentMenu Is AccessibleMenu {
                    If SingleKey = "Space" Or SingleKey = "Tab"
                    SoundPlay "*48"
                    Else
                    If StrLen(SingleKey) = 1 And Not AccessibleMenu.CurrentMenu.FocusByFirstCharacter(SingleKey)
                    SoundPlay "*48"
                    Return
                }
            }
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
        If This.FindItem(MenuItemName) > 0 And Not NewName = "" {
            This.Items[This.FindItem(MenuItemName)]["Name"] := NewName
        }
    }
    
    Show() {
        AccessibilityOverlay.Speak(This.ContextMenuString)
        AccessibleMenu.CurrentMenu := This
        Loop {
            If Not AccessibleMenu.CurrentMenu Is AccessibleMenu
            Break
            AccessibleMenu.CurrentMenu.Manage()
        }
    }
    
    SpeakItem(Item) {
        If This.Items.Length > 0 And Item > 0 And Item <= This.Items.Length {
            FirstChar := StrUpper(SubStr(This.Items[Item]["Name"], 1, 1))
            If This.Items[Item]["Enabled"] = 0 And This.Items[Item]["Checked"] = 1 {
                If Not This.Items[Item]["CallbackOrSubmenu"] Is AccessibleMenu
                AccessibilityOverlay.Speak(This.Items[Item]["Name"] . " " . This.DisabledString . " " . This.CheckedString . " " . FirstChar)
                Else
                AccessibilityOverlay.Speak(This.Items[Item]["Name"] . " " . This.DisabledString . " " . This.CheckedString . " " This.SubmenuString . " " . FirstChar)
                Return 1
            }
            Else If This.Items[Item]["Enabled"] = 0 {
                If Not This.Items[Item]["CallbackOrSubmenu"] Is AccessibleMenu
                AccessibilityOverlay.Speak(This.Items[Item]["Name"] . " " . This.DisabledString . " " . FirstChar)
                Else
                AccessibilityOverlay.Speak(This.Items[Item]["Name"] . " " . This.DisabledString . " " This.SubmenuString . " " . FirstChar)
                Return 1
            }
            Else If This.Items[Item]["Checked"] = 1 {
                If Not This.Items[Item]["CallbackOrSubmenu"] Is AccessibleMenu
                AccessibilityOverlay.Speak(This.Items[Item]["Name"] . " " . This.CheckedString . " " . FirstChar)
                Else
                AccessibilityOverlay.Speak(This.Items[Item]["Name"] . " " . This.CheckedString . " " This.SubmenuString . " " . FirstChar)
                Return 1
            }
            Else {
                If Not This.Items[Item]["CallbackOrSubmenu"] Is AccessibleMenu
                AccessibilityOverlay.Speak(This.Items[Item]["Name"] . " " . FirstChar)
                Else
                AccessibilityOverlay.Speak(This.Items[Item]["Name"] . " " . This.SubmenuString . " " . FirstChar)
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
        If Not Translation = "" {
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
