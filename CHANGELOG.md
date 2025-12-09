# ReaHotkey Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.8.6] - 2025-12-09

### Changed

-   Small configuration dialog improvement

## [0.8.5] - 2025-12-09

### Added

-   The AppsKey Emulator can now be enabled or disabled from the tray menu or by pressing Ctrl+Shift+Windows+E

### Changed

-   Changed the shortcut for opening the configuration dialog to Ctrl+Shift+Windows+F12
-   Various internal enhancements

## [0.8.4] - 2025-12-07

### Changed

-   Kontakt 8: Revert changes introduced in the previous release

## [0.8.3] - 2025-12-06

### Added

-   Kontakt 8: Skip things that shouldn't be focusable

## [0.8.2] - 2025-12-05

### Added/Changed

-   Added support for Kontakt 8.8 (previous versions of Kontakt 8 don't work with this version of the script)
-   Added fallback mouse coordinates for Kontakt 7 header buttons
-   Added overlay for LA Scoring Strings 3 with Look Ahead toggling/monitoring
-   Added functionality for emulating the Applications key (can be set up in the configuration dialog)
-   The library browsers in Kontakt 7 and 8 now don't get closed by default for new 'installations' (delete the INI file for a fresh start)
-   Pressing left/right while a tab control has focus no longer causes the tabs to wrap. Press Ctrl+Tab or Ctrl+Shift+Tab for the wrapping behavior.
-   The script should now remember the last focused controls better.
-   Feedback: Prevent various messages from being cut off by one another
-   Several other fixes and improvements.

## [0.8.1] - 2025-11-06

### Added/Fixed

-   Added support for mix switching in Audio Imperia Glade
-   Fixed a bug with automatic library detection where matching images across several overlays would result in an endless overlay switching loop

## [0.8.0] - 2025-11-04

### Added/Changed

-   Internal: Added another hotkey mode option
-   Internal: When detecting libraries, custom functions can now be specified via the 'DetectionFunction' metadata key
-   Renamed the 'Images/KontaktKompleteKontrol' folder to 'SampleLibraries'

## [0.7.9] - 2025-10-31

### Added/Changed

-   Added basic support for microphone positions in Cinematic Studio Brass
-   Internal: Added new 'Plugin' and 'Standalone' overlay types
-   Internal: Hotkey parameters can now be specified via object constructors as well
-   Internal: The Plugin and Standalone 'Overlays' property now just returns the overlays in the static definitions
-   Internal: Trying to register overlays with taken numbers replaces previously registered overlays
-   Various fixes and enhancements

## [0.7.8] - 2025-09-20

### Added/Changed

-   Added support for opening menus in Kontakt 8.7.0 via fallback mouse coordinates due to accessibility regression (Special thanks to NI for making this possible)
-   Added a separate folder for Komplete Kontrol under images (delete the old Images folder for a clean install)

### Fixed

-   Fixed small menu detection bug in standalone versions of Kontakt

## [0.7.7] - 2025-08-21

### Added

-   Added mix switching support in Dolce by Audio Imperia

## [0.7.6] - 2025-04-09

### Added

-   Added KK property for returning the currently loaded plug-in

### Fixed

-   Fixed Kontakt sometimes not being detected when loaded in KK

## [0.7.5] - 2025-04-09

### Fixed/Changed

-   Ensure that the correct plug-in or standalone is active when setting hotkeys
-   Use UIA for clearing KK search field

## [0.7.4] - 2025-04-08

### Changed

-   Revert plug-in control caching

## [0.7.3] - 2025-04-08

### Changed

-   Make detecting plug-ins in KK more flexible

## [0.7.2] - 2025-04-07

### Added

-   Added ability to access plug-in overlays when these are loaded inside KK (the browser needs to be closed in most cases for this to work)
-   Added button for closing the library browser in the plug-in version of KK

### Changed

-   Revert to not explicitly calling timer functions immediately
-   Improve efficiency when calculating plug-in coordinates in most plug-ins
-   Updated README

## [0.7.1] - 2025-04-02

### Fixed

-   Hopefully fix KK 3.4.1+ not being detected

## [0.7.0] - 2025-03-29

### Added

-   Added option to disable the Raum help message.

## [0.6.9] - 2025-03-28

### Added

-   Added ability to choose presets in Native instruments Raum

### Changed

-   Add checker function to Dubler 2 MIDI Capture plug-in
-   Various internal updates and enhancements

## [0.6.8B] - 2025-03-24

### Added

-   Added basic support for u-HE Repro and Zebra Legacy
-   Added functionality to save presets in u-HE plug-ins

### Changed

-   Consolidate image search options on to one single 'Misc' tab

## [0.6.7] - 2025-03-23

### Added

-   Added basic support for the Hive 2 synthesizer by u-HE (Thanks to Hrvoje Katić)
-   Added checking if Serum instance is indeed version 2

### Changed

-   Make overlay hotkeys only fire actions up on release to prevent eventual multiple triggering
-   Improved manual OCR result correction in Zampler for numeric values
-   Updated README

## [0.6.6] - 2025-03-22

### Added

-   Added basic support for the Diva synthesizer by u-HE (Thanks to Hrvoje Katić)
-   Added basic support for the Serum 2 synthesizer by Xfer Records (Thanks to Hrvoje Katić)

### Changed

-   Revert to using previous behavior when setting hotkeys and timers (May be re-visited later)

## [0.6.5] - 2025-03-18

### Changed

-   Improved Zampler reset behavior

## [0.6.4] - 2025-03-18

### Changed

-   More accessible menu tweaks

## [0.6.3] - 2025-03-18

### Fixed

-   Fixed newly introduced regressions related to accessible menu

## [0.6.2] - 2025-03-18

### Changed/Fixed

-   Simplify checking for updates
-   Avoid setting hotkeys again if the plug-in/standalone did not change

## [0.6.1] - 2025-03-18

### Changed/Fixed

-   The Zampler overlay now resets after closing and re-opening the plug-in
-   Avoid setting timers again if the plug-in/standalone did not change

## [0.6.0] - 2025-03-15

### Fixed

-   Fix library detection being off by default for new users in Kontakt 7

## [0.5.9] - 2025-03-15

### Changed

-   Separate #HotIfs per standalone

## [0.5.8] - 2025-03-13

### Added

-   Added prompt when a Supported plug-in is detected in Ableton
-   Added support for the search field in KK (the browser autoclose feature in configuration must be disabled for it to work)

### Changed

-   Automatically focus plug-ins in REAPER's bridged mode
-   Reworked K7/K8/KK overlays
-   Now the KK browser no longer closes by default
-   All relevant elements now make use of Tesseract OCR instead of UWP
-   Enabled Juggernaut in K8 and KK
-   Updated README

## [0.5.7] - 2025-03-06

### Changed/Fixed

-   Fixed regressions introduced in the last couple of releases
-   updated README

## [0.5.6] - 2025-03-06

### Added

-   Support plug-ins running in Ableton Live 12 (press F6 to enter FX UI)
-   Make the add library dialog in Engine 2 standalone more accessible

### Changed/Fixed

-   Enhanced custom hotkey overrides
-   Only click combo boxes when changing values
-   Fixed mod destination not being reported in Zampler
-   Various code improvements
-   Updated README

## [0.5.5] - 2025-03-01

### Changed

-   More cleanup (See changelog for previous updates)

## [0.5.4] - 2025-03-01

### Changed

-   Improved Zampler and Tesseract OCR
-   Other small updates

## [0.5.3] - 2025-02-28

### Added

-   Added support for Zampler by Synapse Audio
-   Added Tesseract OCR

## [0.5.2] - 2025-02-22

### Added/Changed

-   Added support for bridged mode in Reaper
-   Added Windows version checking on startup
-   Added support for opting out of using specific plugin formats in Komplete Kontrol (recomended KK version is now 3.4.0)
-   Added dedicated settings for each NI product to configuration dialog
-   Libraries can now define multiple images used for automatic detection
-   It's now possible to define multiple overlays per library via the 'Patch' metadata property
-   Added support for preset switching in Juggernaut by Impact Soundworks (Kontakt 7 plug-in only)
-   Added reverb toggling in a couple of Soundiron libraries
-   Automatically close update notice in Kontakt 7 plug-in
-   Changed to client CoordMode
-   Changed message spoken on reload
-   Changed hotkey pass through conditions
-   Added link to README to install a virtual display driver that can enable the necessary screen resolution on machines that don't have a proper display connected
-   Fixed plug-ins not being detected on some systems
-   Fixed/Updated Cerberus, Chorus and Nucleus overlays
-   Made it easier to add/manage configuration settings
-   Removed 'win covered' warning' in standalone applications
-   Retrieve release and version information from GitHub API
-   Split up configuration settings among several tabs
-   Use update dialogs similar to REAPER
-   HotspotHelper: Added function for reporting the color under the mouse cursor
-   HotspotHelper: Added function for retrieving window position and dimensions
-   HotspotHelper: Group several operations on to one hotkey / Free up no longer needed hotkeys
-   HotspotHelper: Changed hotkey modifier from Win+Ctrl+Shift to Shift+Win

## [0.5.1] - 2024-10-20

### Added

-   Added checking for updates

### Changed

-   startup checks are now being suppressed when reloading the script via the menu or hotkey

### Fixed

-   Hopefully fixed a rare bug in AccessibleMenu

## [0.5.0] - 2024-10-18

### Added

-   Added option to disable the 'window may be covered' warning
-   Added Kontakt 8 support
-   Added Kontakt instrument and multi switching

### Changed

-   Changed Kontakt menu handling

## [0.4.9] - 2024-08-16

### Added

-   Recall plug-in instances per track
-   Report an error message periodically when the interface may be covered by other windows
-   Added shortcuts for accessing various overlay buttons

## [0.4.8] - 2024-08-06

### Added

-   Added support for the snapshot menu in the plug-in version of Kontakt

## [0.4.7] - 2024-08-06

### Added

-   Added ability to cycle through snapshots in the plug-in version of Kontakt
-   Added shortcut for opening the tray menu with ctrl+shift+windows+r

### Changed

-   Changed shortcut for viewing readme to ctrl+shift+windows+f1

### Fixed

-   Fixed Kontakt header buttons not activating
-   Fixed Kontakt library browser not always closing

## [0.4.6] - 2024-08-03

### Added

-   Added basic support for the Dubler 2 MIDI Capture Plugin
-   Added support for clicking the presets button in FabFilter plugins
-   Added ability to save new presets in Komplete Kontrol
-   Added experimental support for the microphone mixer feature in several Audio Imperia libraries
-   Added basic support for microphone positions in Cinematic Studio Strings
-   Added function/hotkey for reloading the script
-   Added option to automatically close the library browsers in the standalone versions of Kontakt and Komplete Kontrol
-   Added option to disable automatic library detection in Kontakt and Komplete Kontrol plug-ins
-   HotspotHelper: Added functionality to generate hotspots from OCR results
-   HotspotHelper: Added functionality to use previously defined hotspots in Image Extractor

### Changed

-   Renamed option for automatically closing the library browser in the KK plug-in (also close Kontakt library browser if option is enabled)

## [0.4.5] - 2024-04-28

### Changed

-   Remove screen resolution changing as it seems unstable

## [0.4.4] - 2024-04-25

### Added

-   Added configuration dialog
-   Added option to disable screen resolution check on startup
-   Added option to disable Engine 2 plug-in detection based on image search
-   Added option to disable automatic browser closing in the KK plug-in

### Changed

-   Use UIA for plug-in detection whenever possible
-   Update Kontakt header buttons to use UIA
-   Updated HotspotHelper window layouts

## [0.4.3] - 2024-04-17

### Added

-   Add screen resolution check on ReaHotkey startup
-   Add new functionality and version info to HotspotHelper

### Changed

-   All Audio Imperia libraries except Cerberus now use graphical toggle buttons instead of simple hotspots.

## [0.4.2] - 2024-03-17

### Changed

-   In sforzando, the script now attempts to detect the currently loaded instrument, as well as pitchbend range and polyphony values.

## [0.4.1] - 2024-03-15

### Fixed/Changed

-   Fixed Engine and sforzando plug-ins no longer being detected
-   Added custom version information to the built executables
-   Updated readme

## [0.4.0] - 2023-12-31

### Added

-   Added support for the Preferences dialog in the Komplete Kontrol plug-in
-   Added support for the Content Missing dialog in the plug-in and standalone versions of Kontakt
-   Added support for Plogue sforzando
-   Added OCR functionality to HotspotHelper

### Changed

-   The script should now work properly with 3rd party (non-NI) plug-ins loaded inside Komplete Kontrol
-   Updated Kontakt/Komplete Kontrol library browser closing (The script now attempts to close the Library Browser in the standalone version of Komplete Kontrol as well)
-   Re-introduced Kontakt library menu buttons labelled as 'LIBRARY Browser On/Off'
-   Improved Kontakt menu detection and added hard-coded mouse coordinates as a backup option in case of OCR failure

## [0.3.0] - 2023-12-21

### Added

-   Added functionality to detect the 'Player' version of the Kontakt plug-in

### Changed

-   Change toggle pause announcements
-   Detect Engine plug-in based on ImageSearch
-   Clarify KK and Kontakt menu buttons
-   Remove Kontakt 'LIBRARY' menu buttons, since they don't appear useful to blind users
-   Use OCR for Kontakt menu detection/activation instead of predefined coordinates

## [0.2.1] - 2023-12-09

### Fixed

-   Fix checkboxes in KK standalone preferences

## [0.2.0] - 2023-12-08

### Added

-   Added support for several controls in Komplete Kontrol standalone

### Fixed

-   Fix crash when pressing Ctrl + N while in profile overlay of Dubler 2

## [0.1.0] - 2023-12-06

### Added

-   Initial release

[Unreleased]: https://github.com/MatejGolian/ReaHotkey/compare/0.8.6...HEAD

[0.8.6]: https://github.com/MatejGolian/ReaHotkey/compare/0.8.5...0.8.6

[0.8.5]: https://github.com/MatejGolian/ReaHotkey/compare/0.8.4...0.8.5

[0.8.4]: https://github.com/MatejGolian/ReaHotkey/compare/0.8.3...0.8.4

[0.8.3]: https://github.com/MatejGolian/ReaHotkey/compare/0.8.2...0.8.3

[0.8.2]: https://github.com/MatejGolian/ReaHotkey/compare/0.8.1...0.8.2

[0.8.1]: https://github.com/MatejGolian/ReaHotkey/compare/0.8.0...0.8.1

[0.8.0]: https://github.com/MatejGolian/ReaHotkey/compare/0.7.9...0.8.0

[0.7.9]: https://github.com/MatejGolian/ReaHotkey/compare/0.7.8...0.7.9

[0.7.8]: https://github.com/MatejGolian/ReaHotkey/compare/0.7.7...0.7.8

[0.7.7]: https://github.com/MatejGolian/ReaHotkey/compare/0.7.6...0.7.7

[0.7.6]: https://github.com/MatejGolian/ReaHotkey/compare/0.7.5...0.7.6

[0.7.5]: https://github.com/MatejGolian/ReaHotkey/compare/0.7.4...0.7.5

[0.7.4]: https://github.com/MatejGolian/ReaHotkey/compare/0.7.3...0.7.4

[0.7.3]: https://github.com/MatejGolian/ReaHotkey/compare/0.7.2...0.7.3

[0.7.2]: https://github.com/MatejGolian/ReaHotkey/compare/0.7.1...0.7.2

[0.7.1]: https://github.com/MatejGolian/ReaHotkey/compare/0.7.0...0.7.1

[0.7.0]: https://github.com/MatejGolian/ReaHotkey/compare/0.6.9...0.7.0

[0.6.9]: https://github.com/MatejGolian/ReaHotkey/compare/0.6.8B...0.6.9

[0.6.8B]: https://github.com/MatejGolian/ReaHotkey/compare/0.6.7...0.6.8B

[0.6.8]: https://github.com/MatejGolian/ReaHotkey/compare/0.6.7...0.6.8

[0.6.7]: https://github.com/MatejGolian/ReaHotkey/compare/0.6.6...0.6.7

[0.6.6]: https://github.com/MatejGolian/ReaHotkey/compare/0.6.5...0.6.6

[0.6.5]: https://github.com/MatejGolian/ReaHotkey/compare/0.6.4...0.6.5

[0.6.4]: https://github.com/MatejGolian/ReaHotkey/compare/0.6.3...0.6.4

[0.6.3]: https://github.com/MatejGolian/ReaHotkey/compare/0.6.2...0.6.3

[0.6.2]: https://github.com/MatejGolian/ReaHotkey/compare/0.6.1...0.6.2

[0.6.1]: https://github.com/MatejGolian/ReaHotkey/compare/0.6.0...0.6.1

[0.6.0]: https://github.com/MatejGolian/ReaHotkey/compare/0.5.9...0.6.0

[0.5.9]: https://github.com/MatejGolian/ReaHotkey/compare/0.5.8...0.5.9

[0.5.8]: https://github.com/MatejGolian/ReaHotkey/compare/0.5.7...0.5.8

[0.5.7]: https://github.com/MatejGolian/ReaHotkey/compare/0.5.6...0.5.7

[0.5.6]: https://github.com/MatejGolian/ReaHotkey/compare/0.5.5...0.5.6

[0.5.5]: https://github.com/MatejGolian/ReaHotkey/compare/0.5.4...0.5.5

[0.5.4]: https://github.com/MatejGolian/ReaHotkey/compare/0.5.3...0.5.4

[0.5.3]: https://github.com/MatejGolian/ReaHotkey/compare/0.5.2...0.5.3

[0.5.2]: https://github.com/MatejGolian/ReaHotkey/compare/0.5.1...0.5.2

[0.5.1]: https://github.com/MatejGolian/ReaHotkey/compare/0.5.0...0.5.1

[0.5.0]: https://github.com/MatejGolian/ReaHotkey/compare/0.4.9...0.5.0

[0.4.9]: https://github.com/MatejGolian/ReaHotkey/compare/0.4.8...0.4.9

[0.4.8]: https://github.com/MatejGolian/ReaHotkey/compare/0.4.7...0.4.8

[0.4.7]: https://github.com/MatejGolian/ReaHotkey/compare/0.4.6...0.4.7

[0.4.6]: https://github.com/MatejGolian/ReaHotkey/compare/0.4.5...0.4.6

[0.4.5]: https://github.com/MatejGolian/ReaHotkey/compare/0.4.4...0.4.5

[0.4.4]: https://github.com/MatejGolian/ReaHotkey/compare/0.4.3...0.4.4

[0.4.4]: https://github.com/MatejGolian/ReaHotkey/compare/0.4.5...0.4.4

[0.4.5]: https://github.com/MatejGolian/ReaHotkey/compare/0.4.3...0.4.5

[0.4.5]: https://github.com/MatejGolian/ReaHotkey/compare/0.4.4...0.4.5

[0.4.4]: https://github.com/MatejGolian/ReaHotkey/compare/0.4.3...0.4.4

[0.4.3]: https://github.com/MatejGolian/ReaHotkey/compare/0.4.2...0.4.3

[0.4.2]: https://github.com/MatejGolian/ReaHotkey/compare/0.4.1...0.4.2

[0.4.1]: https://github.com/MatejGolian/ReaHotkey/compare/0.4.0...0.4.1

[0.4.0]: https://github.com/MatejGolian/ReaHotkey/compare/0.3.0...0.4.0

[0.3.0]: https://github.com/MatejGolian/ReaHotkey/compare/0.2.1...0.3.0

[0.2.1]: https://github.com/MatejGolian/ReaHotkey/compare/0.2.0...0.2.1

[0.2.0]: https://github.com/MatejGolian/ReaHotkey/compare/0.1.0...0.2.0

[0.1.0]: https://github.com/MatejGolian/ReaHotkey/releases/tag/0.1.0
