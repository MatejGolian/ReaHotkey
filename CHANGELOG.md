# ReaHotkey Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- Added support for the Preferences dialog in the Komplete Kontrol plug-in
- Added support for the Content Missing dialog in the plug-in and standalone versions of Kontakt
- Added support for Plogue sforzando
- Added OCR functionality to HotspotHelper

### Changed

- The script should now work properly with 3rd party (non-NI) plug-ins loaded inside Komplete Kontrol
- Updated Kontakt/Komplete Kontrol library browser closing (The script now attempts to close the Library Browser in the standalone version of Komplete Kontrol as well)
- Re-introduced Kontakt library menu buttons labelled as 'LIBRARY Browser On/Off'
- Improved Kontakt menu detection and added hard-coded mouse coordinates as a backup option in case of OCR failure

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

[Unreleased]: https://github.com/MatejGolian/ReaHotkey/compare/0.3.0...HEAD

[0.3.0]: https://github.com/MatejGolian/ReaHotkey/compare/0.2.1...0.3.0

[0.2.1]: https://github.com/MatejGolian/ReaHotkey/compare/0.2.0...0.2.1

[0.2.0]: https://github.com/MatejGolian/ReaHotkey/compare/0.1.0...0.2.0

[0.1.0]: https://github.com/MatejGolian/ReaHotkey/releases/tag/0.1.0
