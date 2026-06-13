# ReaHotkey

## What's This And Who Is It For?

This is an AutoHotkey script which aims to make certain virtual instruments/sample libraries  and related programs at least a little more accessible to blind users. It is based on the accessibilityOverlay script available [here](https://github.com/MatejGolian/accessibilityOverlay/) and has originally been designed to run in tandem with the REAPER digital audio workstation. While the primary focus still lies on making things work in REAPER, more recent versions provide the exact same amount of functionality in Ableton Live as well. Support for standalone  counterparts of the compatible plug-ins is also included. Apart from that, the script also supports other standalone pieces of software.

## What's new?

Our changelog can be found [in our dedicated changelog file](https://github.com/MatejGolian/ReaHotkey/blob/main/CHANGELOG.md).

## Features

The following list contains the gist of what ReaHotkey has to offer. There may be some features not specifically mentioned here - either because they are experimental or self-explanatory.

* Adds basic support for the u-HE Diva, Hive 2, Repro and Zebra Legacy synthesizers inside REAPER and Ableton Live 12.
  - Currently supported Features include preset browsing/saving and accessing the vendor menus.
* Enables accessibility for Dubler 2.2 by Vochlea
  - standalone and MIDI capture plugin support
  - not all features are supported, nor do we know if they ever will be (see [below](#dubler2))
* Makes it possible to load instruments and add libraries in Best Service Engine 2.
  - Works inside REAPER and Ableton Live 12. The standalone version of Engine 2 is also supported.
* Allows to click the presets button in various FabFilter plugins
  - The keyboard bindings only work with the unified interfaces of e.g. C-2, Q-3 etc, but not with the newer R-2 yet
* Enables basic usage of the GTune plug-in by GVST
* Makes it possible to  access the menus and save new presets in Komplete Kontrol. It's also possible to change a number of settings in Preferences and add new user library folders and perform library and plug-in rescans.
  - Works inside REAPER, Ableton Live 12 and in the standalone version of Komplete Kontrol.
  - The overlay for the plug-in also provides basic support for the search function in the library Browser as an extra Feature.
  - Note that Komplete Kontrol version 3 or above is absolutely required in case of the plug-in.
  - Version 3.4 is highly recommended, although most of the above functionality may work in older versions as well. That being said, ReaHotkey may be unable to obtain and report the correct information in certain situations. Note that going forward, bacquard compatibility with older versions of the program may change and is not guaranteed.
  - The standalone version may provide a more stable and reliable user experience overall.
* Makes it possible to interact with Kontakt menus, switch Between instruments, multis and snapshots. There's also support for the 'Browse' button in the Content Missing dialog.
  - Works inside REAPER and Ableton Live 12. In case of Kontakt 7, version 7.10 or higher is required and in case of Kontakt 8, the current version of the script requires at least version 8.9 to be installed.
  - Switching Between instruments/multis/snapshots Only works inside REAPER and Ableton Live 12 - ReaHotkey does not support these features in the standalone versions of Kontakt.
  - The Content Missing dialog may not be accessible when running Kontakt inside Komplete Kontrol.
* Includes support for interacting with various sample libraries for Kontakt. Reffer to the [list of supported sample libraries](#kontakt-libraries) toward the end of this document for the full list.
  - Only works inside REAPER and Ableton Live 12.
* Adds ability to choose presets in Raum by Native instruments.
* Adds basic support for the Xfer Records Serum 2 synthesizer inside REAPER and Ableton Live 12.
  - Currently supported Features include preset browsing/saving and accessing the vendor menu.
  - Serum version 2 or later is required, as the overlay won't work properly in Serum 1.X.
  - Note that the demo version of Serum does not support saving presets.
* Makes it possible to load instruments, set polyphony and pitchbend range in Plogue sforzando.
  - Works inside REAPER, Ableton Live 12 and in the standalone version of sforzando.
* Makes it possible to use the Zampler plug-in by Synapse Audio in REAPER and Ableton Live 12.
* Provides means to emulate pressing the Applications key via a custom keyboard shortcut

## Getting Started

Just extract the downloaded archive and run one of the ReaHotkey executables depending on your OS architecture - 'ReaHotkey_x64.exe' if you're on a 64-bit version of Windows and 'ReaHotkey_x86.exe' if your build of Windows is 32-bit. If you then launch one of the supported plug-ins or applications, you will be able to interact with it simiilarly to how you would interact with any accessible application, like moving Between controls with Tab and Shift+Tab, switching tabs with the left or right arrows and so on. In case you want to use ReaHotkey together with one of the supported VST plug-ins in REAPER or Ableton, you can press the F6 key to move the focus inside the given plug-in's user interface. Note that for REAPER this is standard behavior - even without ReaHotkey being active.

## General Notes

* ReaHotkey requires a screen resolution of 1920 x 1080 to operate properly. Shouldn't you have a display connected, or your display doesn't support the required screen resolution, you can either buy a cheap HDMI display simulation dongle (usually about $10), or try the following free software-based solution which installs a virtual display driver that can emulate screen resolutions without having to have an actual display connected: [Click here to visit the latest GitHub release of Virtual Display Driver](https://github.com/VirtualDisplay/Virtual-Display-Driver/releases/latest)
* In order to make ReaHotkey work successfully with a certain application such as REAPER, ReaHotkey should be run with at least the same user privileges as the application to be controlled, otherwise ReaHotkey keyboard commands may not get enabled. For instance, if you are running REAPER as administrator, you should run ReaHotkey as administrator as well.
* Because ReaHotkey may pass through some keys to the active application in specific cases, you can try enabling the 'Send all keyboard input to plug-in' option in REAPER's FX menu when interacting with a supported plug-in interface, should you find that you're dropping out of the plug-in window unexpectedly.
* The default ReaHotkey behavior may not be optimal for everyone. It's therefore advised to explore the configuration dialog to see what settings are available.

## Keyboard Shortcuts

| Shortcut | Description |
| --- | --- |
| `F6` | Focus plug-in window/interface |
| `Ctrl + Shift + Windows + A` | About |
| `Ctrl + Shift + Windows + E` | Toggle AppsKey Emulator enabled/disabled |
| `Ctrl + Shift + Windows + P` | Pause |
| `Ctrl + Shift + Windows + Q` | Quit |
| `Ctrl + Shift + Windows + R` | Open ReaHotkey menu |
| `Ctrl + Shift + Windows + U` | Check for updates |
| `Ctrl + Shift + Windows + F1` | View readme |
| `Ctrl + Shift + Windows + F5` | Reload |
| `Ctrl + Shift + Windows + F12` | Configuration |
| `Shift + Windows + L` | Load custom overlay in the OverlayLoader (see the OverlayDesigner/Loader section [below](#overlaydesignerloader) for more details) |
| `Shift + Windows + U` | Unload custom overlay |
| `Shift + Windows + O` | Toggle OverlayLoader enabled/disabled |

## Known Issues

* The ReaHotkey script can crash while In Dubler 2 audio calibration view. In that case just start the script again.
* After adding a plug-in, the plug-in window may not get automatically focused - not even if its user interface is visible and on top. To get around this behavior, press F6 while ReaHotkey is running to make the plug-in interface active.
* If you're using NVDA with the SIBIAC or LBL add-ons in REAPER, ReaHotkey and SIBIAC/LBL may collide in the plug-ins that ReaHotkey also supports. For that reason, either pause ReaHotkey while interacting with one of the plug-ins in question, or disable SIBIAC/LBL.
* Using any other zoom value in Kontakt and Serum than 100% will result in ReaHotkey not operating as expected. Certain parts of the Kontakt overlays will still work, as not every single of its controls depends on mouse coordinates, that, however, is not the case in Serum.
* At present library-specific overlays may not always behave correctly when used directly in the Kontakt 8 plug-in. In such case try using Kontakt 7 or open the given library from within Komplete Kontrol instead.
* Due to OCR limitations, OCR-based elements may not report completely accurate information.
* The state of the controls that work based on color detection, such as the checkboxes in Komplete Kontrol or the 'Close', 'Main' and 'Room' mic toggles in CSB, may not get identified correctly in all scenarios. With that in mind, as far as Komplete Kontrol goes, if ReaHotkey reports a particular checkbox as either  being "checked" or "not checked", the provided info is most likely correct.
* In case several overlay elements use the same keyboard Shortcut, the given Shortcut will always trigger the first relevant element.

## <a name="dubler2"></a>Dubler 2 Accessibility

We try to make as many features of Dubler 2 accessible through ReaHotkey.

### Accessible Features

This is a rather incomplete list of features we already support.

* [Create and load profiles](#dubler2-profiles)
* Built-in audio controls like enable/disable and synth preset control
* Enable/disable MIDI output
* Full trigger support, including creation, renaming, deletion, recording and more
* Full pitch and pitch bend support
* Basic chords support, including enable/disable, voicing control and octave shifting
* Vowel envelopes are entirely configurable
* Audio Calibration support to use other microphones other than the Dubler Microphone

### Inaccessible Features

The following list also is a rather incomplete list of features that aren't currently supported, but we're aware of and might happen in the future.

* Extended chords support, like building custom chords presets
* User account settings aren't accessible
* Some random pop-ups might not be accessible and disturb the workflow. Please let us know if you encounter one and tell us how to make them appear so that we can add support for them.

### <a name="dubler2-profiles"></a>About profiles in Dubler 2

ReaHotkey allows you to create as many profiles as you want. It however only allows you to load one of the first 5 profiles in the list of all profiles, which therefore get suffixed with a tag that indicates if its an active profile which can be loaded, or a passive one which needs to be moved to an active slot first.
This is not how Dubler 2 behaves in general, but its a limitation we have to put onto the script because of how the GUI is designed. Thus, in order to make a profile loadable which isn't currently amongst the 5 active profiles, you'll have to push its button and use the move menu to switch it with a currently active profile. This process will restart Dubler for the changes to take effect. Just wait a few seconds until Dubler opens up again and you will be able to load the profile just fine.

### <a href="dubler2-midi-capture-plugin"></a>Dubler 2 MIDI Capture Plugin

ReaHotkey provides basic support for the Dubler 2 MIDI Capture Plugin. Please note the following:

* the copy clip to REAPER action will drag and drop a clip from the plugin UI into REAPER. That is currently the only way export clips from the plugin into REAPER and comes with the drawback that we cannot explicitly tell REAPER where to insert the clip within the project. If you've got too many tracks in a project (something about 8 tracks), the clip will start to show up at random places throughout the project. We therefore recommend you to use the plugin in projects that are as clean and small as possible. Maybe just have a project tab open which is only responsible for capturing ideas, you'll be able to copy clips around between REAPER instances as soon as they got copied into REAPER.
* the Select key of clip action will focus the semi-accessible dropdown box with the two possible options, which are the key suggestion by Dubler and the Dubler 2 standalone setting you've chosen. To select either of those options, make sure to pull the mouse to the corresponding position and simulate a left mouse click to select it. We'll try to further improve the process in a future version.

## <a name="kontakt-libraries"></a>List of Supported Kontakt Sample Libraries

These are the sample libraries that ReaHotkey has some support for. Every attempt has been made to get the overlays to work regardless of whether one's using Kontakt 7, 8 or Komplete Kontrol, but in practice there may still be differences in how the individual overlays perform in each of these scenarios. Generally, the overlays tend to behave more reliable in Kontakt 7 and Komplete Kontrol as opposed to using them with Kontakt 8 directly.

* Audio Imperia
  - Areia - Switching between mixes / microphone positions
  - Cerberus - Switching between mixes / microphone positions
  - Chorus - Switching between the 3 available mixes
  - Dolce - Switching between the classic and modern mix
  - Glade - Switching between the classic and modern mix of 'Pyramid' instruments
  - Jaeger - Switching between mixes / microphone positions
  - Nucleus - Switching between the classic and modern mix
  - Solo - Switching between the classic and modern mix
  - Talos - Switching between mixes / microphone positions
* Audiobro
  - LA Scoring Strings 3 - Toggling the look ahead on/off and reporting the current look ahead value
* Cinematic Studio Series
  - Cinematic Studio Brass - Switching between mixes / microphone positions
  - Cinematic Studio Strings - Switching between mixes / microphone positions
* Impact Soundworks
  - Juggernaut - Switching presets
* Soundiron
  - Mimi Page Light & Shadow - Toggling the reverb on/off
  - Voices Of Gaia - Toggling the reverb on/off
  - Voices of Wind Collection - Toggling the reverb on/off

## Emulating the Applications Key

If your keyboard does not have an Applications key, you can configure your own keyboard shortcut to use as an alternative.
To set up this functionality, open the configuration dialog and navigate to the AppsKey Emulator tab. The first checkbox toggles the emulator on/off. Whenever that checkbox is enabled, the settings for customizing your keyboard shortcut will become active. The hotkey field after the first checkbox is for entering the desired key combination itself. The second checkbox controls whether the Windows key should be added to the entered hotkey as an extra modifier. In other words, when that checkbox is checked, you will also have to press the Windows key in addition to the key combination in the hotkey field to emulate the Applications key.
Note that the shortcut configured here is considered global and will thus function in all windows and even when most other functions of the script are paused. Key presses that would result in a blank value cause the hotkey field to reset to its initial default value. Furthermore, in case the resulting shortcut collides with one of the main hotkeys used by the script, the emulator will not become active - not even if the first checkbox on the AppsKey Emulator tab is checked.

## <a name="overlaydesignerloader"></a>About OverlayDesigner/Loader

OverlayDesigner is a special utility that can create basic overlays in an interactive fashion and generate AutoHotkey code. It also assists with optaining various information that can come in handy when writing overlays, such as information about the active window or its controls. It can be used to create simple overlays for plug-ins or applications that ReaHotkey does not support out-of-the-box.
The resulting files can be used directly in the designer, but they can also be loaded in ReaHotkey's OverlayLoader to make the user experience more hassle-free. Note that the OverlayLoader component included in ReaHotkey does not possess the editing capabilities of the full OverlayDesigner script. Also, at present the OverlayLoader component is only active in the Ableton and REAPER plug-in windows - using it in conjunction with standalone applications is not supported at this time. Apart from that, while the simplified OverlayLoader component only gets activated when the plug-in control gains focus, the OverlayDesigner editor becomes active whenever the target window itself becomes active. This difference is there to ensure consistency and predictability when using the editor, but it can also result in differences in behavior compared to when the ReaHotkey OverlayLoader component is used. Therefore it’s recommended to run finished overlays in the ReaHotkey OverlayLoader whenever possible.

### Getting Started with Designing Overlays

Here are basic instructions how to use OverlayDesigner to create overlays.

1. To activate the overlay designing/editing feature:
   - Focus the window you want to create an overlay for.
   - Press `Shift + Windows + D` to make the overlay designer/editor feature active in that particular window.
   - The script will switch to designing/editing mode, allowing you to add/edit overlay elements and move between them using standard navigation commands such as Tab and Shift + Tab.

2. To add items:
   - Use the Applications key to open the OverlayDesigner context menu. Note that the overlay designing/editing feature needs to be active in order for this command to work.
   - Select the control type you want to add from the Add submenu (e.g., HotspotButton, HotspotCheckbox, TabControl). The available choices depend on the currently focused control. This ensures that controls only get added to the parents they're supposed to. For instance, Tabs can only be added if a TabControl is currently focused. Likewise, you won't be able to add a HotspotButton when a TabControl object has focus.
   - Items relying on mouse coordinates will be placed at the current mouse position.
   - Hotspot objects have a single coordinate set; Graphical and OCR objects have two coordinate sets coresponding to the top-left and bottom-right corners respectively in order to define a region/rectangle on the screen.

3. To edit items:
   - Focus an item using `Tab` or `Shift + Tab`.
   - Press `F2` to edit the selected item or choose 'Item properties…' from the Edit submenu.
   - For mouse coordinate adjustments, you can:
     - Move your mouse to the desired position.
     - Use shortcuts:
       - `Shift + Windows + S` — To set Hotspot coordinates to the current mouse position.
       - `Shift + Windows + T` — To set top-left corner coordinates of Graphical/OCR objects to the current mouse position.
       - `Shift + Windows + B` — To set bottom-right corner coordinates of Graphical/OCR objects to the current mouse position.

4. To save your work:
   - To save your overlay to a file that you can reopen later, select 'Save' or 'Save as…' from OverlayDesigner's File submenu.

#### Additional Notes

To edit container objects (e.g., AccessibilityOverlays, PluginOverlays, Tabs), navigate to the start or end of the object in question and press `F2`.
Opening `Item properties` while a TabControl has focus will edit the TabControl object itself and not the currently selected tab.
After adding container objects, focus will move to the start of that newly added object so that you can begin adding controls to it right away.
When `Treat as expression` is checked next to a field in `Item properties`, OverlayDesigner will try to interpret parts of your input as AutoHotkey code. This feature is aimed at advanced use and therefore whenever you have the choice and you're unsure of what to select, keep that option unchecked to avoid potentially unexpected results.

### Available Overlay Types

ReaHotkey/OverlayDesigner supports creating 3 overlay types:

1. AccessibilityOverlay:
   - Basic overlay type not geared towards anything specific.
   - This is the overlay type created by default. To make the root item a different type, create a new overlay (File > New…).

2. PluginOverlay:
   - Similar to the basic AccessibilityOverlay type, but it makes things easier when creating overlays for plug-ins.
   - Simplifies hotkey management and automatically adds coordinate compensation to overlay elements.
   - Allows specifying a plug-in name. This should be one of the plug-in names defined by ReaHotkey.

3. StandaloneOverlay:
   - Designed for overlays targeting standalone applications.
   - Simplifies hotkey management.
   - Allows specifying a standalone application name. This should be one of the standalone names defined by ReaHotkey.

#### About PluginOverlays and Plug-in Coordinate Compensation

Coordinate compensation adjusts overlay controls based on the current plug-in position in the active window. It does so by adding compensation functions to the properties of overlay elements that depend on mouse coordinates. The plug-in position can vary depending on how and in which DAW the given plug-in is loaded (REAPER vs. Ableton, REAPER native vs. bridged plug-in modes). Coordinate compensation functions determine the plugin control location dynamically during runtime and automatically update mouse coordinates of applicable controls, ensuring that the script performs actions at the right mouse coordinates in the end.
When creating a full/proper ReaHotkey overlay it's not necessary to explicitly specify these compensation functions when adding elements to PluginOverlays as they get added automatically. So if your aim is to export AutoHotkey code, you can delete the compensation functions from the properties of your elements prior to export to make your code cleaner. That being said, if you want your elements to account for the location of the control containing the plug-in in REAPER or Ableton when using OverlayDesigner or OverlayLoader, you should keep the compensation functions in the properties of the items that can utilize them.

#### Additional Notes

Technically you can create any kind of overlay using the basic AccessibilityOverlay type, but the other context specific overlay variants perform certain tasks automatically making it possible to use shorter and simpler code. Most notably they are able to link  overlays to particular ReaHotkey plug-ins or standalone programs and make their hotkeys work in their designated contexts. The plug-in or standalone names do however only serve their true purpose when writing a full ReaHotkey overlay in the form of AutoHotkey code. Even if you enter valid plug-in or standalone names in Item properties, these overlays won't be linked to the plug-in or standalone program you specified when just using OverlayDesigner or the overlay loader component that's part of the main ReaHotkey script. However, any hotkeys you define in your overlay will still work.

### About Control Types

OverlayDesigner supports adding button, checkbox, edit field, list box, tab control, text and marker elements. Many of them can come in several variants:

1. Basic/Custom Objects:
   - Can create item announcements, but depend on user-supplied functions to tell them what more to do when focused or activated.

2. Graphical Objects:
   - Create item announcements, search for images within a given region of the screen and perform mouse clicks at the found image positions when focused or activated.

3. Hotspot Objects:
   - Create item announcements and perform mouse clicks at the coordinates specified when focused or activated.

4. OCR Objects:
- Create item announcements based on OCR results and perform mouse clicks in their given screen regions when focused or activated.

#### Markers vs. HotspotButtons

Markers are special objects recognized only by OverlayDesigner. They are ignored by the ReaHotkey overlay loader.
They behave similar to HotspotButtons, they have X and Y coordinates and they perform mouse clicks once activated, but they don't offer all the functionality that normal HotspotButtons do. Their main purpose is to provide means to record mouse coordinates for later/temporary usage.

### List of Item Properties

| Name | Applies to | Description |
| --- | --- | --- |
| `Variable Name` | All | Sets the variable name to use in generated AutoHotkey code. |
| `Label` | Button, ToggleButton, Checkbox, Edit, ListBox, Tab, TabControl, CustomButton, CustomToggleButton, CustomCheckbox, CustomEdit, CustomListBox, GraphicalButton, GraphicalToggleButton, GraphicalCheckbox, GraphicalTab, HotspotButton, HotspotToggleButton, HotspotCheckbox, HotspotEdit, HotspotListBox, HotspotTab, OCREdit, OCRListBox, AccessibilityOverlay, PluginOverlay, StandaloneOverlay, Marker | Sets the control label, in case the control is focusable, the value will be reported on focus. |
`Value` | StaticText | Sets the value that will be reported on focus. |
| `Pre-exec Focus Functions` | Button, ToggleButton, Checkbox, Edit, ListBox, Tab, CustomButton, CustomToggleButton, CustomCheckbox, CustomEdit, CustomListBox, GraphicalButton, GraphicalToggleButton, GraphicalCheckbox, GraphicalTab, HotspotButton, HotspotToggleButton, HotspotCheckbox, HotspotEdit, HotspotListBox, HotspotTab, OCRButton, OCREdit, OCRListBox, OCRTab, OCRText, StaticText | A comma separated list of unquoted function names: Executed after the control gets focused but before the control executes its own focus code. |
| `Post-exec Focus Functions` | Button, ToggleButton, Checkbox, Edit, ListBox, Tab, CustomButton, CustomToggleButton, CustomCheckbox, CustomEdit, CustomListBox, GraphicalButton, GraphicalToggleButton, GraphicalCheckbox, GraphicalTab, HotspotButton, HotspotToggleButton, HotspotCheckbox, HotspotEdit, HotspotListBox, HotspotTab, OCRButton, OCREdit, OCRListBox, OCRTab, OCRText, StaticText | A comma separated list of unquoted function names: Executed if the control gains focus successfully and after it finishes executing its own focus code. |
| `Pre-exec Activation Functions` | Button, ToggleButton, Checkbox, CustomButton, CustomToggleButton, CustomCheckbox, GraphicalButton, GraphicalToggleButton, GraphicalCheckbox, HotspotButton, HotspotToggleButton, HotspotCheckbox, OCRButton | A comma separated list of unquoted function names: Executed after the control gets activated, but before the control executes its own activation code. |
| `Post-exec Activation Functions` | Button, ToggleButton, Checkbox, CustomButton, CustomToggleButton, CustomCheckbox, GraphicalButton, GraphicalToggleButton, GraphicalCheckbox, HotspotButton, HotspotToggleButton, HotspotCheckbox, OCRButton | A comma separated list of unquoted function names: Executed if the control gets activated successfully and after it finishes executing its own activation code. |
| `Hotkey Command` | Button, ToggleButton, Checkbox, Edit, ListBox, Tab, CustomButton, CustomToggleButton, CustomCheckbox, CustomEdit, CustomListBox, GraphicalButton, GraphicalToggleButton, GraphicalCheckbox, GraphicalTab, HotspotButton, HotspotToggleButton, HotspotCheckbox, HotspotEdit, HotspotListBox, HotspotTab, OCRButton, OCREdit, OCRListBox, OCRTab, OCRText, StaticText, Marker | Sets a custom hotkey for triggering the control. |
| `Hotkey Label` | Button, ToggleButton, Checkbox, Edit, ListBox, Tab, CustomButton, CustomToggleButton, CustomCheckbox, CustomEdit, CustomListBox, GraphicalButton, GraphicalToggleButton, GraphicalCheckbox, GraphicalTab, HotspotButton, HotspotToggleButton, HotspotCheckbox, HotspotEdit, HotspotListBox, HotspotTab, OCRButton, OCREdit, OCRListBox, OCRTab, OCRText, StaticText, Marker | Allows specifying a custom label to inform the user of the custom hotkey that triggers the control. |
| `Hotkey Functions` | Button, ToggleButton, Checkbox, Edit, ListBox, Tab, CustomButton, CustomToggleButton, CustomCheckbox, CustomEdit, CustomListBox, GraphicalButton, GraphicalToggleButton, GraphicalCheckbox, GraphicalTab, HotspotButton, HotspotToggleButton, HotspotCheckbox, HotspotEdit, HotspotListBox, HotspotTab, OCRButton, OCREdit, OCRListBox, OCRTab, OCRText, StaticText | A comma separated list of unquoted function names: Executed whenever the control is focused or activated via its associated hotkey. |
| `Check State Function` | CustomToggleButton, CustomCheckbox | An unquoted function name: Used to determine the state of the control. |
| `Image Files` | GraphicalButton, GraphicalTab | A comma separated list of quoted paths to image files that the control will search for within its screen region. |
| `Colors when the control is on` | HotspotToggleButton | A comma separated list of quoted color values as reported by the script: If any of the specified colors is detected at the control coordinates, the control will be reported as being on. |
| `Colors when the control is off` | HotspotToggleButton | A comma separated list of quoted color values as reported by the script: If any of the specified colors is detected at the control coordinates, the control will be reported as being off. |
| `Image files when the control is on` | GraphicalToggleButton | A comma separated list of quoted paths to image files: If any of the specified images is detected within the boundaries of the control's screen region, the control will be reported as being on. |
| `Image files when the control is off` | GraphicalToggleButton | A comma separated list of quoted paths to image files: If any of the specified images is detected within the boundaries of the control's screen region, the control will be reported as being off. |
| `Colors when the control is checked` | HotspotCheckbox | A comma separated list of quoted color values as reported by the script: If any of the specified colors is detected at the control coordinates, the control will be reported as being checked. |
| `Colors when the control is unchecked` | HotspotCheckbox | A comma separated list of quoted color values as reported by the script: If any of the specified colors is detected at the control coordinates, the control will be reported as being unchecked. |
| `Image files when the control is checked` | GraphicalCheckbox | A comma separated list of quoted paths to image files: If any of the specified images is detected within the boundaries of the control's screen region, the control will be reported as being on. |
| `Image files when the control is unchecked` | GraphicalCheckbox | A comma separated list of quoted paths to image files: If any of the specified images is detected within the boundaries of the control's screen region, the control will be reported as being off. |
| `Options` | ListBox, CustomListBox, HotspotListBox | A comma separated list of quoted values defining the available options of the control. |
| `Functions when the value of the control changes` | ListBox, CustomListBox, HotspotListBox, OCRListBox | A comma separated list of unquoted function names: Triggered when the value of the control is changed via arrow keys. |
| `Label Prefix` | OCRButton | Sets the string to be spoken before reporting the OCR result within the control's screen region. |
| `Default Label` | OCRButton, OCRTab | The string to be spoken when the OCR result is blank. |
| `Value Prefix` | OCRText | Sets the string to be spoken before reporting the OCR result within the control's screen region. |
| `Default Value` | OCRListBox, OCRText | The string to be spoken when the OCR result is blank. |
| `OCR Type` | OCRButton, OCREdit, OCRListBox, OCRTab, OCRText | Sets the OCR type to use. Possible values are "Tesseract", "TesseractBest", "TesseractFast", "TesseractLegacy" and "UWP". |
| `OCR Language` | OCRButton, OCREdit, OCRListBox, OCRTab, OCRText | The language to use when performing OCR. |
| `OCR Scale` | OCRButton, OCREdit, OCRListBox, OCRTab, OCRText | Sets OCR scaling. |
| `X Coordinate` | HotspotButton, HotspotToggleButton, HotspotCheckbox, HotspotEdit, HotspotListBox, HotspotTab, Marker | Sets the X coordinate of the control. |
| `Y Coordinate` | HotspotButton, HotspotToggleButton, HotspotCheckbox, HotspotEdit, HotspotListBox, HotspotTab, Marker | Sets the Y coordinate of the control. |
| `X1 Coordinate` | GraphicalButton, GraphicalToggleButton, GraphicalCheckbox, GraphicalTab, OCRButton, OCREdit, OCRListBox, OCRTab, OCRText | Sets the top-left corner X coordinate. |
| `Y1 Coordinate` | GraphicalButton, GraphicalToggleButton, GraphicalCheckbox, GraphicalTab, OCRButton, OCREdit, OCRListBox, OCRTab, OCRText | Sets the top-left corner Y coordinate. |
| `X2 Coordinate` | GraphicalButton, GraphicalToggleButton, GraphicalCheckbox, GraphicalTab, OCRButton, OCREdit, OCRListBox, OCRTab, OCRText | Sets the bottom-right corner X coordinate. |
| `Y2 Coordinate` | GraphicalButton, GraphicalToggleButton, GraphicalCheckbox, GraphicalTab, OCRButton, OCREdit, OCRListBox, OCRTab, OCRText | Sets the bottom-right corner Y coordinate. |
| `Plug-in Name` | PluginOverlay | Specifies the name of the plug-in that the overlay is made for. |
| `Compensation Function` | PluginOverlay | An unquoted function name: Used to compensate the coordinates of added controls. |
| `Standalone Name` | StandaloneOverlay | Specifies the name of the standalone program that the overlay is made for. |

#### Additional Notes

When Specifying functions, use function names from `Includes/Overlay.Functions.ahk` found in the ReaHotkey source code. Not all the functions defined in that file can be used with overlay objects directly as that file contains other helper functions too, but generally that's the place where most functions that can be passed to overlay objects live.
  
### Keyboard Shortcuts

Many of the available keyboard shortcuts are disabled when the overlay designing/editing feature is inactive, although general functions (mostly the ones found in the script's Tools submenu) remain accessible unless the script is paused.

#### Always Active (including when the script is paused):

| Shortcut | Description |
| --- | --- |
| `Shift + Windows + P` | Toggle pause |
| `Shift + Windows + F1` | Open the About window |
| `Shift + Windows + Q` | Quit the script |

#### Active when the script is not paused:

| Shortcut | Description |
| --- | --- |
| `Shift + Windows + D` | Toggle the designing/editing feature active/inactive |
| `Shift + Windows + Insert` | Add marker at mouse cursor |
| `Shift + Windows + Del` | Delete all markers |
| `Shift + Windows + F` | Focus window control |
| `Shift + Windows + U` | Route mouse to focused control |
| `Shift + Windows + PrintScreen` | Capture active window region to image |
| `Shift + Windows + I` | Search for image on screen |
| `Shift + Windows + R` | Repeat last image search |
| `Shift + Windows + O` | Perform OCR on the active window |
| `Shift + Windows + G` | Generate markers from OCR results |
| `Shift + Windows + W` | Show info about the active window |
| `Shift + Windows + C` | Show info about the focused control |
| `Shift + Windows + L` | List all controls of the active window |
| `Shift + Windows + M` | Show mouse and caret info |
| `Shift + Windows + V` | Show clipboard contents |
| `Shift + Windows + K` | Report pixel color under mouse |
| `Shift + Windows + Arrow Keys` | Move mouse within the active window (Left, Right, Up, Down) |
| `Shift + Windows + X` | Set mouse X position |
| `Shift + Windows + Y` | Set mouse Y position |
| `Shift + Windows + Z` | Report mouse position |
| `Shift + Windows + Enter` | Perform a click at current mouse position |

#### When the designer/editor is Active:

| Shortcut | Description |
| --- | --- |
| `Applications` | Open editor context menu |
| `Ctrl + N` | Create new project |
| `Ctrl + O` | Open existing project |
| `Ctrl + S` | Save project |
| `Ctrl + Alt + S` | Save project as... |
| `Shift + Windows + E` | Export overlay as AutoHotkey code |
| `Ctrl + Z` | Undo last action |
| `Ctrl + X` | Cut selected item |
| `Ctrl + C` | Copy selected item |
| `Ctrl + V` | Paste item |
| `Del` | Delete selected item |
| `F2` | Edit item properties |
| `Shift + Windows + N` | Nudge/recalculate item coordinates |
| `Shift + Windows + H` | Add HotspotButton at mouse position |
| `Shift + Windows + S` | Set Hotspot object coordinates to mouse position |
| `Shift + Windows + T` | Set top-left corner coordinates of Graphical/OCR objects to mouse position |
| `Shift + Windows + B` | Set bottom-right corner coordinates of Graphical/OCR objects to mouse position |

## Roadmap

This is an incomplete list of features we're planning to look into in the future or are currently developing. Noone can guarantee that they will ever become reality, but they might at some point, and you can always open an issue to either offer help or request a new entry on this list. This list doesn't necessarily include bugfixes or additional features for entries above, except if they require special treatment and time to investigate them.

* Melodyne accessibility
