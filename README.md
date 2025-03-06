# ReaHotkey

## What's This And Who Is It For?

This is an AutoHotkey scripth which aims to make certain virtual instruments/sample libraries  and related software at least a little more accessible to blind users. It is based on the accessibilityOverlay script available [here](https://github.com/MatejGolian/accessibilityOverlay/) and is primarily designed to run in tandem with the REAPER digital audio workstation, although other programs/instruments are supported as well.

## What's new?

Our changelog can be found [in our dedicated changelog file](https://github.com/MatejGolian/ReaHotkey/blob/main/CHANGELOG.md).

## Features

* Enables accessibility for Dubler 2.2 by Vochlea
  - standalone and MIDI capture plugin support
  - not all features are supported, nor do we know if they ever will be (see [below](#dubler2))
* Makes it possible to load instruments and add libraries in Best Service Engine 2.
  - Works inside REAPER and Ableton Live 12. The standalone version of Engine 2 is also supported.
* Allows to click the presets button in various FabFilter plugins
  - The keyboard bindings only work with the unified interfaces of e.g. C-2, Q-3 etc, but not with the newer R-2 yet
* Makes it possible to  access the menus and save new presets in Komplete Kontrol. It's also possible to change a number of settings in Preferences and add new user library folders and perform library and plug-in rescans.
  - Works inside REAPER, Ableton Live 12 and in the standalone version of Komplete Kontrol.
  - Note that Komplete Kontrol version 3 or above is absolutely required in case of the plug-in.
  - Version 3.4 is highly recommended, although most of the above functionality may work in older versions as well. That being said, ReaHotkey may be unable to obtain and report the correct information in certain situations. Note that going forward, bacquard compatibility with older versions of the program may change and is not guaranteed.
  - The standalone version may provide a more stable and reliable user experience overall.
* Makes it possible to interact with Kontakt menus, switch Between instruments, multis and snapshots. There's also support for the 'Browse' button in the Content Missing dialog.
  - Works inside REAPER and Ableton Live 12. Note that Kontakt version 7.10 or higher is required.
  - Switching Between instruments/multis/snapshots Only works inside REAPER and Ableton Live 12 - ReaHotkey does not support these features in the standalone versions of Kontakt.
  - The Content Missing dialog may not be accessible when running Kontakt inside Komplete Kontrol.
* Makes it possible to switch Between various mixes and microphone positions in Audio Imperia's Areia, Cerberus, Chorus, Jaeger, Nucleus, Solo and Talos libraries. There is also support for toggling microphone positions in Cinematic Studio Strings, switching presets in the 'Juggernaut' library by Impact Soundworks and toggling the reverb on/off in a couple of Soundiron libraries.
  - Only works inside REAPER and Ableton Live 12.
  - The overlay for Juggernaut is only accessible when using Kontakt 7, but otherwise everything else works both in Kontakt and Komplete Kontrol.
* Makes it possible to load instruments, set polyphony and pitchbend range in Plogue sforzando.
  - Works inside REAPER, Ableton Live 12 and in the standalone version of sforzando.
* Makes it possible to use the Zampler plug-in by Synapse Audio in REAPER and Ableton Live 12.

## General Notes

* ReaHotkey requires a screen resolution of 1920 x 1080 to operate properly. Shouldn't you have a display connected, or your display doesn't support the required screen resolution, you can either buy a cheap HDMI display simulation dongle (usually about $10), or try the following free software-based solution which installs a virtual display driver that can emulate screen resolutions without having to have an actual display connected: [Click here to visit the latest GitHub release of Virtual Display Driver](https://github.com/VirtualDisplay/Virtual-Display-Driver/releases/latest)
* In order to make ReaHotkey work successfully with a certain application such as REAPER, ReaHotkey should be run with at least the same user privileges as the application to be controlled, otherwise ReaHotkey keyboard commands may not get enabled. For instance, if you are running REAPER as administrator, you should run ReaHotkey as administrator as well.
* Because ReaHotkey may pass through some keys to the active application in specific cases, you can try enabling the 'Send all keyboard input to plug-in' option in REAPER's FX menu when interacting with a supported plug-in interface, should you find that you're dropping out of the plug-in window unexpectedly.

## Keyboard Shortcuts

* f6 - focus plug-in window/interface
* ctrl+shift+windows+a - about
* ctrl+shift+windows+c - configuration
* ctrl+shift+windows+p - pause
* ctrl+shift+windows+q - quit
* ctrl+shift+windows+r - open ReaHotkey menu
* ctrl+shift+windows+u - check for updates
* ctrl+shift+windows+f1 - view readme
* ctrl+shift+windows+f5 - reload

## Known Issues

* The ReaHotkey script can crash while In Dubler 2 audio calibration view. In that case just start the script again.
* After adding a plug-in, the plug-in window may not get automatically focused - not even if its user interface is visible and on top. To get around this behavior, press F6 while ReaHotkey is running to make the plug-in interface active.
* If you're using NVDA with the SIBIAC or LBL add-ons in REAPER, ReaHotkey and SIBIAC/LBL may collide in the plug-ins that ReaHotkey also supports. For that reason, either pause ReaHotkey while interacting with one of the plug-ins in question, or disable SIBIAC/LBL.
* Using any other zoom value in Kontakt than 100% may result in ReaHotkey not operating as expected.
* At present library-specific overlays may not always behave correctly when used directly in the Kontakt 8 plug-in. In such case try using Kontakt 7 or open the given library from within Komplete Kontrol instead.
* Due to OCR limitations the Komplete Kontrol Save Preset dialog may display incorrect preset names.

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

## About HotspotHelper

HotspotHelper is a special utility to make developing these kind of scripts a little easier. It retrieves window and control info and creates labelled hotspots that can be copied to clipboard for subsequent use.

## Roadmap

This is an incomplete list of features we're planning to look into in the future or are currently developing. Noone can guarantee that they will ever become reality, but they might at some point, and you can always open an issue to either offer help or request a new entry on this list. This list doesn't necessarily include bugfixes or additional features for entries above, except if they require special treatment and time to investigate them.

* Melodyne accessibility
