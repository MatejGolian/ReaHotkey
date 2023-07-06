#requires AutoHotkey v2.0

class accessibilityOverlay {
    
    controlID := 0
    controlType := "overlay"
    controlTypeLabel := "overlay"
    label := ""
    allFocusableControls := array()
    childControls := array()
    currentControlID := 0
    superordinateControlID := 0
    unlabelledString := ""
    static allControls := array()
    static totalNumberOfControls := 0
    static SAPI := comObject("SAPI.spVoice")
    static translations := accessibilityOverlay.setupTranslations()
    
    __new(label := "") {
        accessibilityOverlay.totalNumberOfControls++
        this.controlID := accessibilityOverlay.totalNumberOfControls
        this.label := label
        accessibilityOverlay.allControls.push(this)
    }
    
    activateControl(controlID) {
        if this.childControls.length > 0 {
            this.allFocusableControls := this.getAllFocusableControls()
            found := this.findFocusableControl(controlID)
            if found > 0 {
                currentControl := accessibilityOverlay.getControl(controlID)
                if hasMethod(currentControl, "focus") and controlID != this.currentControlID {
                    currentControl.focus()
                    this.setCurrentControlID(controlID)
                }
                if hasMethod(currentControl, "activate") {
                    currentControl.activate(controlID)
                    this.setCurrentControlID(controlID)
                    return 1
                }
            }
        }
        return 0
    }
    
    activateCurrentControl() {
        if this.childControls.length > 0 {
            this.allFocusableControls := this.getAllFocusableControls()
            found := this.findFocusableControl(this.currentControlID)
            if found > 0 {
                currentControl := accessibilityOverlay.getControl(this.currentControlID)
                if hasMethod(currentControl, "activate")
                currentControl.activate(currentControl.controlID)
                return 1
            }
        }
        return 0
    }
    
    addControl(control) {
        this.childControls.push(control)
        return this.childControls[this.childControls.length]
    }
    
    findFocusableControl(controlID) {
        allFocusableControls := this.getAllFocusableControls()
        if allFocusableControls.length > 0
        for index, value in allFocusableControls
        if value == controlID
        return index
        return 0
    }
    
    focusControl(controlID) {
        if this.childControls.length > 0 {
            this.allFocusableControls := this.getAllFocusableControls()
            found := this.findFocusableControl(controlID)
            if found > 0 {
                currentControl := accessibilityOverlay.getControl(controlID)
                if hasMethod(currentControl, "focus")
                if controlID != this.currentControlID {
                    currentControl.focus()
                    this.setCurrentControlID(controlID)
                }
                else {
                    currentControl.focus(controlID)
                }
                return 1
            }
        }
        return 0
    }
    
    focusCurrentControl() {
        if this.childControls.length > 0 {
            this.allFocusableControls := this.getAllFocusableControls()
            found := this.findFocusableControl(this.currentControlID)
            if found > 0 {
                currentControl := accessibilityOverlay.getControl(this.currentControlID)
                if hasMethod(currentControl, "focus")
                currentControl.focus()
                return 1
            }
        }
        return 0
    }
    
    focusNextControl() {
        if this.childControls.length > 0 {
            this.allFocusableControls := this.getAllFocusableControls()
            found := this.findFocusableControl(this.currentControlID)
            if found == 0 or found == this.allFocusableControls.length
            this.currentControlID := this.allFocusableControls[1]
            else
            this.currentControlID := this.allFocusableControls[found + 1]
            this.setCurrentControlID(this.currentControlID)
            currentControl := accessibilityOverlay.getControl(this.currentControlID)
            if hasMethod(currentControl, "focus") {
                if this.allFocusableControls.length > 1
                currentControl.focus()
                else
                currentControl.focus(currentControl.controlID)
                return 1
            }
        }
        return 0
    }
    
    focusPreviousControl() {
        if this.childControls.length > 0 {
            this.allFocusableControls := this.getAllFocusableControls()
            found := this.findFocusableControl(this.currentControlID)
            if found <= 1
            this.currentControlID := this.allFocusableControls[this.allFocusableControls.length]
            else
            this.currentControlID := this.allFocusableControls[found - 1]
            this.setCurrentControlID(this.currentControlID)
            currentControl := accessibilityOverlay.getControl(this.currentControlID)
            if hasMethod(currentControl, "focus") {
                if this.allFocusableControls.length > 1
                currentControl.focus()
                else
                currentControl.focus(currentControl.controlID)
                return 1
            }
        }
        return 0
    }
    
    focusNextTab() {
        if this.childControls.length > 0 and this.currentControlID > 0 {
            this.allFocusableControls := this.getAllFocusableControls()
            found := this.findFocusableControl(this.currentControlID)
            if found > 0 {
                currentControl := accessibilityOverlay.getControl(this.allFocusableControls[found])
                if currentControl is tabControl {
                    if currentControl.currentTab < currentControl.tabs.length
                    tab := currentControl.currentTab + 1
                    else
                    tab := 1
                    currentControl.currentTab := tab
                    currentControl.focus(currentControl.controlID)
                    return 1
                }
            }
        }
        return 0
    }
    
    focusPreviousTab() {
        if this.childControls.length > 0 and this.currentControlID > 0 {
            this.allFocusableControls := this.getAllFocusableControls()
            found := this.findFocusableControl(this.currentControlID)
            if found > 0 {
                currentControl := accessibilityOverlay.getControl(this.allFocusableControls[found])
                if currentControl is tabControl {
                    if currentControl.currentTab <= 1
                    tab := currentControl.tabs.length
                    else
                    tab := currentControl.currentTab - 1
                    currentControl.currentTab := tab
                    currentControl.focus(currentControl.controlID)
                    return 1
                }
            }
        }
        return 0
    }
    
    getAllFocusableControls() {
        allFocusableControls := array()
        if this.childControls.length > 0
        for currentControl in this.childControls {
            switch(currentControl.__class) {
                case "accessibilityOverlay":
                if currentControl.childControls.length > 0 {
                    currentControl.allFocusableControls := currentControl.getAllFocusableControls()
                    for currentControlID in currentControl.allFocusableControls
                    allFocusableControls.push(currentControlID)
                }
                case "tabControl":
                allFocusableControls.push(currentControl.controlID)
                if currentControl.tabs.length > 0 {
                    currentTab := currentControl.tabs[currentControl.currentTab]
                    if currentTab.childControls.length > 0 {
                        currentTab.allFocusableControls := currentTab.getAllFocusableControls()
                        for currentTabControlID in currentTab.allFocusableControls
                        allFocusableControls.push(currentTabControlID)
                    }
                }
                default:
                allFocusableControls.push(currentControl.controlID)
            }
        }
        return allFocusableControls
    }
    
    getCurrentControl() {
        return accessibilityOverlay.getControl(this.currentControlID)
    }
    
    getCurrentControlID() {
        return this.currentControlID
    }
    
    reset() {
        this.currentControlID := 0
        if this.childControls.length > 0 {
            for currentControl in this.childControls
            switch(currentControl.__class) {
                case "accessibilityOverlay":
                if currentControl.childControls.length > 0 {
                    currentControl.currentControlID := 0
                    currentControl.reset()
                }
                case "tabControl":
                if currentControl.tabs.length > 0 {
                    currentControl.currentTab := 1
                    for currentTab in currentControl.tabs
                    if currentTab.childControls.length > 0 {
                        currentTab.currentControlID := 0
                        currentTab.reset()
                    }
                }
            }
        }
    }
    
    setCurrentControlID(controlID) {
        if this.childControls.length > 0 {
            this.currentControlID := controlID
            for currentControl in this.childControls {
                switch(currentControl.__class) {
                    case "accessibilityOverlay":
                    if currentControl.childControls.length > 0 {
                        found := currentControl.findFocusableControl(controlID)
                        if found > 0
                        currentControl.setCurrentControlID(controlID)
                        else
                        currentControl.currentControlID := 0
                    }
                    else {
                        currentControl.currentControlID := 0
                    }
                    case "tabControl":
                    if currentControl.tabs.length > 0 {
                        currentTab := currentControl.tabs[currentControl.currentTab]
                        if currentTab.childControls.length > 0 {
                            found := currentTab.findFocusableControl(controlID)
                            if found > 0
                            currentTab.setCurrentControlID(controlID)
                            else
                            currentTab.currentControlID := 0
                        }
                        else {
                            currentTab.currentControlID := 0
                        }
                    }
                }
            }
        }
        else {
            this.currentControlID := 0
        }
    }
    
    translate(translation := "") {
        if translation != "" {
            if !(translation is map)
            translation := accessibilityOverlay.translations[translation]
            if translation is map {
                if translation[this.__class] is map
                for key, value in translation[this.__class]
                this.%Key% := value
                if this.childControls.length > 0
                for currentControl in this.childControls {
                    if translation[currentControl.__class] is map
                    for key, value in translation[currentControl.__class]
                    currentControl.%Key% := value
                    switch(currentControl.__class) {
                        case "accessibilityOverlay":
                        if currentControl.childControls.length > 0 {
                            currentControl.translate(translation)
                        }
                        case "tabControl":
                        if currentControl.tabs.length > 0
                        for currentTab in currentControl.tabs {
                            if translation[currentTab.__class] is map
                            for key, value in translation[currentTab.__class]
                            currentTab.%Key% := value
                            if currentTab.childControls.length > 0
                            currentTab.translate(translation)
                        }
                    }
                }
            }
        }
    }
    
    static getAllControls() {
        return accessibilityOverlay.allControls
    }
    
    static getControl(controlID) {
        if controlID > 0 and accessibilityOverlay.allControls.length > 0 and accessibilityOverlay.allControls.length >= controlID
        return accessibilityOverlay.allControls[controlID]
        return 0
    }
    
    static setupTranslations() {
        english := map(
        "accessibilityOverlay", map(
        "controlTypeLabel", "overlay",
        "unlabelledString", ""),
        "customButton", map(
        "controlTypeLabel", "button",
        "unlabelledString", "unlabelled"),
        "customTab", map(
        "controlTypeLabel", "tab",
        "unlabelledString", "unlabelled"),
        "graphicButton", map(
        "controlTypeLabel", "button",
        "notFoundString", "not found",
        "offString", "off",
        "onString", "on",
        "unlabelledString", "unlabelled"),
        "graphicTab", map(
        "controlTypeLabel", "tab",
        "unlabelledString", "unlabelled"),
        "hotspotButton", map(
        "controlTypeLabel", "button",
        "unlabelledString", "unlabelled"),
        "hotspotTab", map(
        "controlTypeLabel", "tab",
        "unlabelledString", "unlabelled"),
        "tabControl", map(
        "controlTypeLabel", "tab control",
        "selectedString", "selected",
        "notFoundString", "not found",
        "unlabelledString", ""))
        english.default := ""
        slovak := map(
        "accessibilityOverlay", map(
        "controlTypeLabel", "pokrývka",
        "unlabelledString", ""),
        "customButton", map(
        "controlTypeLabel", "tlačidlo",
        "unlabelledString", "bez názvu"),
        "customTab", map(
        "controlTypeLabel", "záložka",
        "unlabelledString", "bez názvu"),
        "graphicButton", map(
        "controlTypeLabel", "tlačidlo",
        "notFoundString", "nenájdené",
        "offString", "vypnuté",
        "onString", "zapnuté",
        "unlabelledString", "bez názvu"),
        "graphicTab", map(
        "controlTypeLabel", "záložka",
        "unlabelledString", "bez názvu"),
        "hotspotButton", map(
        "controlTypeLabel", "tlačidlo",
        "unlabelledString", "bez názvu"),
        "hotspotTab", map(
        "controlTypeLabel", "záložka",
        "unlabelledString", "bez názvu"),
        "tabControl", map(
        "controlTypeLabel", "zoznam záložiek",
        "selectedString", "vybraté",
        "notFoundString", "nenájdené",
        "unlabelledString", ""))
        slovak.default := ""
        swedish := map(
        "accessibilityOverlay", map(
        "controlTypeLabel", "täcke",
        "unlabelledString", ""),
        "customButton", map(
        "controlTypeLabel", "knapp",
        "unlabelledString", "namnlös"),
        "customTab", map(
        "controlTypeLabel", "flik",
        "unlabelledString", "namnlös"),
        "graphicButton", map(
        "controlTypeLabel", "knapp",
        "notFoundString", "hittades ej",
        "offString", "av",
        "onString", "på",
        "unlabelledString", "namnlös"),
        "graphicTab", map(
        "controlTypeLabel", "flik",
        "unlabelledString", "namnlös"),
        "hotspotButton", map(
        "controlTypeLabel", "knapp",
        "unlabelledString", "namnlös"),
        "hotspotTab", map(
        "controlTypeLabel", "flik",
        "unlabelledString", "namnlös"),
        "tabControl", map(
        "controlTypeLabel", "flikar",
        "selectedString", "markerad",
        "notFoundString", "hittades ej",
        "unlabelledString", ""))
        swedish.default := ""
        translations := map()
        translations["English"] := english
        translations["Slovak"] := slovak
        translations["Swedish"] := swedish
        translations.default := ""
        return translations
    }
    
    static speak(message) {
        if fileExist("nvdaControllerClient" . A_PtrSize * 8 . ".dll") and !DllCall("nvdaControllerClient" . A_PtrSize * 8 . ".dll\nvdaController_testIfRunning") {
            dllCall("nvdaControllerClient" . A_PtrSize * 8 . ".dll\nvdaController_cancelSpeech")
            dllCall("nvdaControllerClient" . A_PtrSize * 8 . ".dll\nvdaController_speakText", "wstr", message)
        }
        else {
            accessibilityOverlay.SAPI.speak("", 0x1|0x2)
            accessibilityOverlay.SAPI.speak(message, 0x1)
        }
    }
    
    static stopSpeech() {
        if !FileExist("nvdaControllerClient" . A_PtrSize * 8 . ".dll") or dllCall("nvdaControllerClient" . A_PtrSize * 8 . ".dll\nvdaController_testIfRunning")
        accessibilityOverlay.SAPI.speak("", 0x1|0x2)
    }
    
    addAccessibilityOverlay(label := "") {
        control := accessibilityOverlay(label)
        control.superordinateControlID := this.controlID
        return this.addControl(control)
    }
    
    addCustomButton(label, onFocusFunction := "", onActivateFunction := "") {
        control := customButton(label, onFocusFunction, onActivateFunction)
        control.superordinateControlID := this.controlID
        return this.addControl(control)
    }
    
    addCustomControl(onFocusFunction := "", onActivateFunction := "") {
        control := customControl(onFocusFunction, onActivateFunction)
        control.superordinateControlID := this.controlID
        return this.addControl(control)
    }
    
    addGraphicButton(label, regionX1Coordinate, regionY1Coordinate, regionX2Coordinate, regionY2Coordinate, onImage, offImage := "", onHoverImage := "", offHoverImage := "", onFocusFunction := "", onActivateFunction := "") {
        control := graphicButton(label, regionX1Coordinate, regionY1Coordinate, regionX2Coordinate, regionY2Coordinate, onImage, offImage, onHoverImage, offHoverImage, onFocusFunction, onActivateFunction)
        control.superordinateControlID := this.controlID
        return this.addControl(control)
    }
    
    addHotspotButton(label, xCoordinate, yCoordinate, onFocusFunction := "", onActivateFunction := "") {
        control := hotspotButton(label, xCoordinate, yCoordinate, onFocusFunction, onActivateFunction)
        control.superordinateControlID := this.controlID
        return this.addControl(control)
    }
    
    addTabControl(label := "", tabs*) {
        control := tabControl(label)
        control.superordinateControlID := this.controlID
        if tabs.length > 0
        for tab in tabs
        control.addTabs(tab)
        return this.addControl(control)
    }
    
}

class customButton {
    
    controlID := 0
    controlType := "button"
    controlTypeLabel := "button"
    onFocusFunction := ""
    onActivateFunction := ""
    label := ""
    superordinateControlID := 0
    unlabelledString := "unlabelled"
    
    __new(label, onFocusFunction := "", onActivateFunction := "") {
        accessibilityOverlay.totalNumberOfControls++
        this.controlID := accessibilityOverlay.totalNumberOfControls
        this.label := label
        this.onFocusFunction := onFocusFunction
        this.onAcTivateFunction := onActivateFunction
        accessibilityOverlay.allControls.push(this)
    }
    
    activate(currentControlID := 0) {
        if this.controlID != currentControlID {
            if this.label == ""
            accessibilityOverlay.speak(this.unlabelledString . " " . this.controlTypeLabel)
            else
            accessibilityOverlay.speak(this.label . " " . this.controlTypeLabel)
        }
        if this.onActivateFunction != ""
        %this.onActivateFunction%(this)
        return 1
    }
    
    focus(currentControlID := 0) {
        if this.controlID != currentControlID {
            if this.label == ""
            accessibilityOverlay.speak(this.unlabelledString . " " . this.controlTypeLabel)
            else
            accessibilityOverlay.speak(this.label . " " . this.controlTypeLabel)
        }
        if this.onFocusFunction != ""
        %this.onFocusFunction%(this)
        return 1
    }
    
}

class customControl {
    
    controlID := 0
    controlType := "custom"
    controlTypeLabel := "custom"
    onFocusFunction := ""
    onActivateFunction := ""
    superordinateControlID := 0
    
    __new(onFocusFunction := "", onActivateFunction := "") {
        accessibilityOverlay.totalNumberOfControls++
        this.controlID := accessibilityOverlay.totalNumberOfControls
        this.onFocusFunction := onFocusFunction
        this.onAcTivateFunction := onActivateFunction
        accessibilityOverlay.allControls.push(this)
    }
    
    activate(*) {
        if this.onActivateFunction != ""
        %this.onActivateFunction%(this)
        return 1
    }
    
    focus(*) {
        if this.onFocusFunction != ""
        %this.onFocusFunction%(this)
        return 1
    }
    
}

class customTab extends accessibilityOverlay {
    
    controlType := "tab"
    controlTypeLabel := "tab"
    onFocusFunction := ""
    unlabelledString := "unlabelled"
    
    __new(label, onFocusFunction := "") {
        accessibilityOverlay.totalNumberOfControls++
        this.controlID := accessibilityOverlay.totalNumberOfControls
        this.label := label
        this.onFocusFunction := onFocusFunction
        accessibilityOverlay.allControls.push(this)
    }
    
    focus(controlID := 0) {
        if this.controlID != controlID {
            if this.label == ""
            accessibilityOverlay.speak(this.unlabelledString . " " . this.controlTypeLabel)
            else
            accessibilityOverlay.speak(this.label . " " . this.controlTypeLabel)
        }
        if this.onFocusFunction != ""
        %this.onFocusFunction%(this)
        return 1
    }
    
}

class graphicButton {
    
    controlID := 0
    controlType := "button"
    controlTypeLabel := "button"
    label := ""
    superordinateControlID := 0
    onImage := ""
    offImage := ""
    onHoverImage := ""
    offHoverImage := ""
    regionX1Coordinate := 0
    regionY1Coordinate := 0
    regionX2Coordinate := 0
    regionY2Coordinate := 0
    onFocusFunction := ""
    onActivateFunction := ""
    foundXCoordinate := 0
    foundYCoordinate := 0
    isToggle := 0
    toggleState := 0
    notFoundString := "not found"
    offString := "off"
    onString := "on"
    unlabelledString := "unlabelled"
    
    __new(label, regionX1Coordinate, regionY1Coordinate, regionX2Coordinate, regionY2Coordinate, onImage, offImage := "", onHoverImage := "", offHoverImage := "", onFocusFunction := "", onActivateFunction := "") {
        accessibilityOverlay.totalNumberOfControls++
        this.controlID := accessibilityOverlay.totalNumberOfControls
        this.label := label
        this.regionX1Coordinate := regionX1Coordinate
        this.regionY1Coordinate := regionY1Coordinate
        this.regionX2Coordinate := regionX2Coordinate
        this.regionY2Coordinate := regionY2Coordinate
        if onImage == "" or !FileExist(onImage)
        onImage := ""
        if offImage == "" or !FileExist(offImage)
        offImage := ""
        if onHoverImage == "" or !FileExist(onHoverImage)
        onHoverImage := ""
        if offHoverImage == "" or !FileExist(offHoverImage)
        offHoverImage := ""
        if onImage != "" and offImage != "" and onImage != offImage
        this.isToggle := 1
        this.onImage := onImage
        this.offImage := offImage
        this.onHoverImage := onHoverImage
        this.offHoverImage := offHoverImage
        this.onFocusFunction := onFocusFunction
        this.onActivateFunction := onActivateFunction
        accessibilityOverlay.allControls.push(this)
    }
    
    activate(currentControlID := 0) {
        if this.isToggle == 1 and this.toggleState == 0 {
            if this.checkIfInactive() == 1 {
                this.toggleState := 1
                click this.foundXCoordinate, this.foundYCoordinate
                if this.controlID != currentControlID {
                    if this.label == ""
                    accessibilityOverlay.speak(this.unlabelledString . " " . this.onString)
                    else
                    accessibilityOverlay.speak(this.label . " " . this.onString)
                }
                if this.onActivateFunction != ""
                %this.onActivateFunction%(this)
                return 1
            }
            if this.checkIfActive() == 1 {
                this.toggleState := 0
                click this.foundXCoordinate, this.foundYCoordinate
                if this.controlID != currentControlID {
                    if this.label == ""
                    accessibilityOverlay.speak(this.unlabelledString . " " . this.offString)
                    else
                    accessibilityOverlay.speak(this.label . " " . this.offString)
                }
                if this.onActivateFunction != ""
                %this.onActivateFunction%(this)
                return 1
            }
        }
        else if this.isToggle == 1 and this.toggleState == 1 {
            if this.checkIfActive() == 1 {
                this.toggleState := 0
                click this.foundXCoordinate, this.foundYCoordinate
                if this.controlID != currentControlID {
                    if this.label == ""
                    accessibilityOverlay.speak(this.unlabelledString . " " . this.offString)
                    else
                    accessibilityOverlay.speak(this.label . " " . this.offString)
                }
                if this.onActivateFunction != ""
                %this.onActivateFunction%(this)
                return 1
            }
            if this.checkIfInactive() == 1 {
                this.toggleState := 1
                click this.foundXCoordinate, this.foundYCoordinate
                if this.controlID != currentControlID {
                    if this.label == ""
                    accessibilityOverlay.speak(this.unlabelledString . " " . this.onString)
                    else
                    accessibilityOverlay.speak(this.label . " " . this.onString)
                }
                if this.onActivateFunction != ""
                %this.onActivateFunction%(this)
                return 1
            }
        }
        else {
            if this.checkIfActive() == 1 {
                click this.foundXCoordinate, this.foundYCoordinate
                if this.onActivateFunction != ""
                %this.onActivateFunction%(this)
                return 1
            }
        }
        if this.controlID != currentControlID {
            if this.label == ""
            accessibilityOverlay.speak(this.unlabelledString . " " . this.controlTypeLabel . " " . this.notFoundString)
            else
            accessibilityOverlay.speak(this.label . " " . this.controlTypeLabel . " " . this.notFoundString)
        }
        return 0
    }
    
    checkIfActive() {
        foundXCoordinate := 0
        foundYCoordinate := 0
        if this.onImage != "" and imageSearch(&FoundXCoordinate, &FoundYCoordinate, this.regionX1Coordinate, this.regionY1Coordinate, this.regionX2Coordinate, this.regionY2Coordinate, this.onImage) == 1 {
            this.foundXCoordinate := foundXCoordinate
            this.foundYCoordinate := foundYCoordinate
            return 1
        }
        if this.onHoverImage != "" and imageSearch(&FoundXCoordinate, &FoundYCoordinate, this.regionX1Coordinate, this.regionY1Coordinate, this.regionX2Coordinate, this.regionY2Coordinate, this.onHoverImage) == 1 {
            this.foundXCoordinate := foundXCoordinate
            this.foundYCoordinate := foundYCoordinate
            return 1
        }
        this.foundXCoordinate := 0
        this.foundYCoordinate := 0
        return 0
    }
    
    checkIfInactive() {
        foundXCoordinate := 0
        foundYCoordinate := 0
        if this.offImage != "" and imageSearch(&FoundXCoordinate, &FoundYCoordinate, this.regionX1Coordinate, this.regionY1Coordinate, this.regionX2Coordinate, this.regionY2Coordinate, this.offImage) == 1 {
            this.foundXCoordinate := foundXCoordinate
            this.foundYCoordinate := foundYCoordinate
            return 1
        }
        if this.offHoverImage != "" and imageSearch(&FoundXCoordinate, &FoundYCoordinate, this.regionX1Coordinate, this.regionY1Coordinate, this.regionX2Coordinate, this.regionY2Coordinate, this.offHoverImage) == 1 {
            this.foundXCoordinate := foundXCoordinate
            this.foundYCoordinate := foundYCoordinate
            return 1
        }
        this.foundXCoordinate := 0
        this.foundYCoordinate := 0
        return 0
    }
    
    focus(currentControlID := 0) {
        if this.isToggle == 1 and this.toggleState == 0 {
            if this.checkIfInactive() == 1 {
                this.toggleState := 0
                mouseMove this.foundXCoordinate, this.foundYCoordinate
                if this.controlID != currentControlID {
                    if this.label == ""
                    accessibilityOverlay.speak(this.unlabelledString . " " . this.controlTypeLabel)
                    else
                    accessibilityOverlay.speak(this.label . " " . this.controlTypeLabel)
                }
                if this.onFocusFunction != ""
                %this.onFocusFunction%(this)
                return 1
            }
            if this.checkIfActive() == 1 {
                this.toggleState := 1
                mouseMove this.foundXCoordinate, this.foundYCoordinate
                if this.controlID != currentControlID {
                    if this.label == ""
                    accessibilityOverlay.speak(this.unlabelledString . " " . this.controlTypeLabel)
                    else
                    accessibilityOverlay.speak(this.label . " " . this.controlTypeLabel)
                }
                if this.onFocusFunction != ""
                %this.onFocusFunction%(this)
                return 1
            }
        }
        else if this.isToggle == 1 and this.toggleState == 1 {
            if this.checkIfActive() == 1 {
                this.toggleState := 1
                mouseMove this.foundXCoordinate, this.foundYCoordinate
                if this.controlID != currentControlID {
                    if this.label == ""
                    accessibilityOverlay.speak(this.unlabelledString . " " . this.controlTypeLabel)
                    else
                    accessibilityOverlay.speak(this.label . " " . this.controlTypeLabel)
                }
                if this.onFocusFunction != ""
                %this.onFocusFunction%(this)
                return 1
            }
            if this.checkIfInactive() == 1 {
                this.toggleState := 0
                mouseMove this.foundXCoordinate, this.foundYCoordinate
                if this.controlID != currentControlID {
                    if this.label == ""
                    accessibilityOverlay.speak(this.unlabelledString . " " . this.controlTypeLabel)
                    else
                    accessibilityOverlay.speak(this.label . " " . this.controlTypeLabel)
                }
                if this.onFocusFunction != ""
                %this.onFocusFunction%(this)
                return 1
            }
        }
        else {
            if this.checkIfActive() == 1 {
                mouseMove this.foundXCoordinate, this.foundYCoordinate
                if this.controlID != currentControlID {
                    if this.label == ""
                    accessibilityOverlay.speak(this.unlabelledString . " " . this.controlTypeLabel)
                    else
                    accessibilityOverlay.speak(this.label . " " . this.controlTypeLabel)
                }
                if this.onFocusFunction != ""
                %this.onFocusFunction%(this)
                return 1
            }
        }
        if this.controlID != currentControlID {
            if this.label == ""
            accessibilityOverlay.speak(this.unlabelledString . " " . this.controlTypeLabel . " " . this.notFoundString)
            else
            accessibilityOverlay.speak(this.label . " " . this.controlTypeLabel . " " . this.notFoundString)
        }
        return 0
    }
    
}

class graphicTab extends accessibilityOverlay {
    
    controlType := "tab"
    controlTypeLabel := "tab"
    onImage := ""
    offImage := ""
    onHoverImage := ""
    offHoverImage := ""
    regionX1Coordinate := 0
    regionY1Coordinate := 0
    regionX2Coordinate := 0
    regionY2Coordinate := 0
    onFocusFunction := ""
    foundXCoordinate := 0
    foundYCoordinate := 0
    isToggle := 0
    toggleState := 0
    unlabelledString := "unlabelled"
    
    __new(label, regionX1Coordinate, regionY1Coordinate, regionX2Coordinate, regionY2Coordinate, onImage, offImage := "", onHoverImage := "", offHoverImage := "", onFocusFunction := "") {
        accessibilityOverlay.totalNumberOfControls++
        this.controlID := accessibilityOverlay.totalNumberOfControls
        this.label := label
        this.regionX1Coordinate := regionX1Coordinate
        this.regionY1Coordinate := regionY1Coordinate
        this.regionX2Coordinate := regionX2Coordinate
        this.regionY2Coordinate := regionY2Coordinate
        if onImage == "" or !FileExist(onImage)
        onImage := ""
        if offImage == "" or !FileExist(offImage)
        offImage := ""
        if onHoverImage == "" or !FileExist(onHoverImage)
        onHoverImage := ""
        if offHoverImage == "" or !FileExist(offHoverImage)
        offHoverImage := ""
        if onImage != "" and offImage != "" and onImage != offImage
        this.isToggle := 1
        this.onImage := onImage
        this.offImage := offImage
        this.onHoverImage := onHoverImage
        this.offHoverImage := offHoverImage
        this.onFocusFunction := onFocusFunction
        accessibilityOverlay.allControls.push(this)
    }
    
    checkIfActive() {
        foundXCoordinate := 0
        foundYCoordinate := 0
        if this.onImage != "" and imageSearch(&FoundXCoordinate, &FoundYCoordinate, this.regionX1Coordinate, this.regionY1Coordinate, this.regionX2Coordinate, this.regionY2Coordinate, this.onImage) == 1 {
            this.foundXCoordinate := foundXCoordinate
            this.foundYCoordinate := foundYCoordinate
            return 1
        }
        if this.onHoverImage != "" and imageSearch(&FoundXCoordinate, &FoundYCoordinate, this.regionX1Coordinate, this.regionY1Coordinate, this.regionX2Coordinate, this.regionY2Coordinate, this.onHoverImage) == 1 {
            this.foundXCoordinate := foundXCoordinate
            this.foundYCoordinate := foundYCoordinate
            return 1
        }
        this.foundXCoordinate := 0
        this.foundYCoordinate := 0
        return 0
    }
    
    checkIfInactive() {
        foundXCoordinate := 0
        foundYCoordinate := 0
        if this.offImage != "" and imageSearch(&FoundXCoordinate, &FoundYCoordinate, this.regionX1Coordinate, this.regionY1Coordinate, this.regionX2Coordinate, this.regionY2Coordinate, this.offImage) == 1 {
            this.foundXCoordinate := foundXCoordinate
            this.foundYCoordinate := foundYCoordinate
            return 1
        }
        if this.offHoverImage != "" and imageSearch(&FoundXCoordinate, &FoundYCoordinate, this.regionX1Coordinate, this.regionY1Coordinate, this.regionX2Coordinate, this.regionY2Coordinate, this.offHoverImage) == 1 {
            this.foundXCoordinate := foundXCoordinate
            this.foundYCoordinate := foundYCoordinate
            return 1
        }
        this.foundXCoordinate := 0
        this.foundYCoordinate := 0
        return 0
    }
    
    focus(controlID := 0) {
        if this.isToggle == 1 and this.toggleState == 0 {
            if this.checkIfInactive() == 1 {
                this.toggleState := 0
                click this.foundXCoordinate, this.foundYCoordinate
                if this.controlID != controlID {
                    if this.label == ""
                    accessibilityOverlay.speak(this.unlabelledString . " " . this.controlTypeLabel)
                    else
                    accessibilityOverlay.speak(this.label . " " . this.controlTypeLabel)
                }
                if this.onFocusFunction != ""
                %this.onFocusFunction%(this)
                return 1
            }
            if this.checkIfActive() == 1 {
                this.toggleState := 1
                click this.foundXCoordinate, this.foundYCoordinate
                if this.controlID != controlID {
                    if this.label == ""
                    accessibilityOverlay.speak(this.unlabelledString . " " . this.controlTypeLabel)
                    else
                    accessibilityOverlay.speak(this.label . " " . this.controlTypeLabel)
                }
                if this.onFocusFunction != ""
                %this.onFocusFunction%(this)
                return 1
            }
        }
        else if this.isToggle == 1 and this.toggleState == 1 {
            if this.checkIfActive() == 1 {
                this.toggleState := 1
                click this.foundXCoordinate, this.foundYCoordinate
                if this.controlID != controlID {
                    if this.label == ""
                    accessibilityOverlay.speak(this.unlabelledString . " " . this.controlTypeLabel)
                    else
                    accessibilityOverlay.speak(this.label . " " . this.controlTypeLabel)
                }
                if this.onFocusFunction != ""
                %this.onFocusFunction%(this)
                return 1
            }
            if this.checkIfInactive() == 1 {
                this.toggleState := 0
                click this.foundXCoordinate, this.foundYCoordinate
                if this.controlID != controlID {
                    if this.label == ""
                    accessibilityOverlay.speak(this.unlabelledString . " " . this.controlTypeLabel)
                    else
                    accessibilityOverlay.speak(this.label . " " . this.controlTypeLabel)
                }
                if this.onFocusFunction != ""
                %this.onFocusFunction%(this)
                return 1
            }
        }
        else {
            if this.checkIfActive() == 1 {
                click this.foundXCoordinate, this.foundYCoordinate
                if this.controlID != controlID {
                    if this.label == ""
                    accessibilityOverlay.speak(this.unlabelledString . " " . this.controlTypeLabel)
                    else
                    accessibilityOverlay.speak(this.label . " " . this.controlTypeLabel)
                }
                if this.onFocusFunction != ""
                %this.onFocusFunction%(this)
                return 1
            }
        }
        return 0
    }
    
}

class hotspotButton {
    
    controlID := 0
    controlType := "button"
    controlTypeLabel := "button"
    onFocusFunction := ""
    onActivateFunction := ""
    label := ""
    superordinateControlID := 0
    xCoordinate := 0
    yCoordinate := 0
    unlabelledString := "unlabelled"
    
    __new(label, xCoordinate, yCoordinate, onFocusFunction := "", onActivateFunction := "") {
        accessibilityOverlay.totalNumberOfControls++
        this.controlID := accessibilityOverlay.totalNumberOfControls
        this.label := label
        this.xCoordinate := xCoordinate
        this.yCoordinate := yCoordinate
        this.onFocusFunction := onFocusFunction
        this.onAcTivateFunction := onActivateFunction
        accessibilityOverlay.allControls.push(this)
    }
    
    activate(currentControlID := 0) {
        click this.xCoordinate, this.yCoordinate
        if this.controlID != currentControlID {
            if this.label == ""
            accessibilityOverlay.speak(this.unlabelledString . " " . this.controlTypeLabel)
            else
            accessibilityOverlay.speak(this.label . " " . this.controlTypeLabel)
        }
        if this.onActivateFunction != ""
        %this.onActivateFunction%(this)
        return 1
    }
    
    focus(currentControlID := 0) {
        mouseMove this.xCoordinate, this.yCoordinate
        if this.controlID != currentControlID {
            if this.label == ""
            accessibilityOverlay.speak(this.unlabelledString . " " . this.controlTypeLabel)
            else
            accessibilityOverlay.speak(this.label . " " . this.controlTypeLabel)
        }
        if this.onFocusFunction != ""
        %this.onFocusFunction%(this)
        return 1
    }
    
}

class hotspotTab extends accessibilityOverlay {
    
    controlType := "tab"
    controlTypeLabel := "tab"
    onFocusFunction := ""
    xCoordinate := 0
    yCoordinate := 0
    unlabelledString := "unlabelled"
    
    __new(label, xCoordinate, yCoordinate, onFocusFunction := "") {
        accessibilityOverlay.totalNumberOfControls++
        this.controlID := accessibilityOverlay.totalNumberOfControls
        this.label := label
        this.xCoordinate := xCoordinate
        this.yCoordinate := yCoordinate
        this.onFocusFunction := onFocusFunction
        accessibilityOverlay.allControls.push(this)
    }
    
    focus(controlID := 0) {
        click this.xCoordinate, this.yCoordinate
        if this.controlID != controlID {
            if this.label == ""
            accessibilityOverlay.speak(this.unlabelledString . " " . this.controlTypeLabel)
            else
            accessibilityOverlay.speak(this.label . " " . this.controlTypeLabel)
        }
        if this.onFocusFunction != ""
        %this.onFocusFunction%(this)
        return 1
    }
    
}

class tabControl {
    
    controlID := 0
    controlType := "tabControl"
    controlTypeLabel := "tab control"
    label := ""
    superordinateControlID := 0
    currentTab := 1
    tabs := array()
    selectedString := "selected"
    notFoundString := "not found"
    unlabelledString := ""
    
    __new(label := "", tabs*) {
        accessibilityOverlay.totalNumberOfControls++
        this.controlID := accessibilityOverlay.totalNumberOfControls
        this.label := label
        if tabs.length > 0
        for tab in tabs
        this.addTabs(tab)
        accessibilityOverlay.allControls.push(this)
    }
    
    addTabs(tabs*) {
        if tabs.length > 0
        for tab in tabs {
            tab.superordinateControlID := this.controlID
            this.tabs.push(tab)
        }
    }
    
    focus(currentControlID := 0) {
        if this.tabs.length > 0 {
            if this.tabs[this.currentTab].focus(this.tabs[this.currentTab].controlID) == 1 {
                if this.controlID == currentControlID {
                    if this.tabs[this.currentTab].label == ""
                    accessibilityOverlay.speak(this.tabs[this.currentTab].unlabelledString . " " . this.tabs[this.currentTab].controlTypeLabel . " " . this.selectedString)
                    else
                    accessibilityOverlay.speak(this.tabs[this.currentTab].label . " " . this.tabs[this.currentTab].controlTypeLabel . " " . this.selectedString)
                }
                else {
                    if this.label == "" {
                        if this.tabs[this.currentTab].label == ""
                        accessibilityOverlay.speak(this.unlabelledString . " " . this.tabs[this.currentTab].unlabelledString . " " . this.tabs[this.currentTab].controlTypeLabel . " " . this.selectedString)
                        else
                        accessibilityOverlay.speak(this.unlabelledString . " " . this.controlTypeLabel . " " . this.tabs[this.currentTab].label . " " . this.tabs[this.currentTab].controlTypeLabel . " " . this.selectedString)
                    }
                    else {
                        if this.tabs[this.currentTab].label == ""
                        accessibilityOverlay.speak(this.label . " " . this.controlTypeLabel . " " . this.tabs[this.currentTab].unlabelledString . " " . this.tabs[this.currentTab].controlTypeLabel . " " . this.selectedString)
                        else
                        accessibilityOverlay.speak(this.label . " " . this.controlTypeLabel . " " . this.tabs[this.currentTab].label . " " . this.tabs[this.currentTab].controlTypeLabel . " " . this.selectedString)
                    }
                }
            }
            else {
                if this.controlID == currentControlID {
                    if this.tabs[this.currentTab].label == ""
                    accessibilityOverlay.speak(this.tabs[this.currentTab].unlabelledString . " " . this.tabs[this.currentTab].controlTypeLabel . " " . this.notFoundString)
                    else
                    accessibilityOverlay.speak(this.tabs[this.currentTab].label . " " . this.tabs[this.currentTab].controlTypeLabel . " " . this.notFoundString)
                }
                else {
                    if this.label == "" {
                        if this.tabs[this.currentTab].label == ""
                        accessibilityOverlay.speak(this.unlabelledString . " " . this.controlTypeLabel . " " . this.tabs[this.currentTab].unlabelledString . " " . this.tabs[this.currentTab].controlTypeLabel . " " . this.notFoundString)
                        else
                        accessibilityOverlay.speak(this.unlabelledString . " " . this.controlTypeLabel . " " . this.tabs[this.currentTab].label . " " . this.tabs[this.currentTab].controlTypeLabel . " " . this.notFoundString)
                    }
                    else {
                        if this.tabs[this.currentTab].label == ""
                        accessibilityOverlay.speak(this.label . " " . this.controlTypeLabel . " " . this.tabs[this.currentTab].unlabelledString . " " . this.tabs[this.currentTab].controlTypeLabel . " " . this.notFoundString)
                        else
                        accessibilityOverlay.speak(this.label . " " . this.controlTypeLabel . " " . this.tabs[this.currentTab].label . " " . this.tabs[this.currentTab].controlTypeLabel . " " . this.notFoundString)
                    }
                }
            }
        }
        else {
            if this.label == ""
            accessibilityOverlay.speak(this.unlabelledString . " " . this.controlTypeLabel)
            else
            accessibilityOverlay.speak(this.label . " " . this.controlTypeLabel)
        }
        return 1
    }
    
}
