#Requires AutoHotkey v2.0

Class ExpansionManager {
    
    Static Init() {
        Standalone.Register("Expansion Manager", "Yamaha Expansion Manager ahk_class Qt51511QWindowIcon ahk_exe Expansion Manager.exe", ObjBindMethod(ExpansionManager, "InitStandalone"))
        InitialOverlay := AccessibilityOverlay()
        InitialOverlay.AddUIAControl("MainWindow.centralwidget.styleSheetArea.screens.packManager.styleSheetArea.homeFrame.leftPane.globalNavigation.installTargetMenu.installTargetToolBarArea.installTargetToolBar.installTargetButtonArea.installTargetAddButton", "Add instrument button",, ObjBindMethod(ExpansionManager, "ActivateAddInstrumentButton"))
        Standalone.RegisterOverlay("Expansion Manager", InitialOverlay)
    }
    
    Static ActivateAddInstrumentButton(Button) {
        If button.GetControl() {
            Button.GetControl().Highlight()
            Button.GetControl().Click()
        }
    }
    
}

ExpansionManager.Init()
