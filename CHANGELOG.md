# ReaHotkey Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added/Changed

-   Added support for bridged mode in Reaper
-   Added Windows version checking on startup
-   Added dedicated settings for each NI product
-   Libraries can now define multiple images used for automatic detection
-   Added reverb toggling in a couple of Soundiron libraries
-   Automatically close update notice in Kontakt 7 plug-in
-   Changed to client CoordMode
-   Changed message spoken on reload
-   Fix plug-ins not being detected on some systems
-   Fix/Update Chorus and Nucleus overlays
-   Make it easier to add/manage configuration settings
-   Remove 'win covered' warning' in standalone applications
-   Retrieve release and version information from GitHub API
-   Split up configuration settings among several tabs
-   Use update dialogs similar to REAPER
-   HotspotHelper: Add function for reporting the color under the mouse cursor
-   HotspotHelper: Add function for retrieving window position and dimensions
-   HotspotHelper: Group several operations on to one hotkey / Free up no longer needed hotkeys
-   HotspotHelper: Change hotkey modifier from Win+Ctrl+Shift to Shift+Win

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

[Unreleased]: https://github.com/MatejGolian/ReaHotkey/compare/0.5.1...HEAD

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
