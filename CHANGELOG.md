# ReaHotkey Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

-   Added support for clicking the presets button in FabFilter plugins

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

[Unreleased]: https://github.com/MatejGolian/ReaHotkey/compare/0.4.5...HEAD

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
