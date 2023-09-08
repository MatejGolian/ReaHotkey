# What's This And Who Is It For?
This is an AutoHotkey scripth which aims to make certain virtual instruments/sample libraries  and related programs at least a little more accessible to blind users. It is based on the accessibilityOverlay script available [here](https://github.com/MatejGolian/accessibilityOverlay/) and is primarily designed to run in tandem with the REAPER digital audio workstation, although in particular cases standalone versions of programs/instruments may be supported as well.
## Features
* Makes it possible to switch between the classic and modern mixes in Audio Imperia's Areia library.
  - Only works inside REAPER.
* Makes it possible to switch between the classic and modern mixes in Audio Imperia's Jaeger library.
  - Only works inside REAPER.
* Makes it possible to switch between the classic and modern mixes in Audio Imperia's Nucleus library.
  - Only works inside REAPER.
* Makes it possible to switch between the classic and modern mixes in Audio Imperia's Talos library.
  - Only works inside REAPER.
* Makes it possible to activate/deactivate multitracked guitars/basses in Impact Soundworks Shreddage-series instruments.
  - Only works inside REAPER.
* Makes it possible to load instruments and add libraries in Best Service Engine 2.
  - Works both inside REAPER and in the standalone version of Engine 2.
* Enables accessibility for Dubler 2.1 by Vochlea
  - only standalone support for now
  - not all features are supported, nor do we know if they ever will be (see [below](#dubler2))

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

### Inaccessible Features

The following list also is a rather incomplete list of features that aren't currently supported, but we're aware of and might happen in the future.

* Extended chords support, like building custom chords presets
* Dubler Companion Plug-in is currently not accessible
* Audio settings are currently entirely inaccessible
* Vowel envelopes are currently not controllable
* User account settings aren't accessible
* Some random pop-ups might not be accessible and disturb the workflow. Please let us know if you encounter one and tell us how to make them appear so that we can add support for them.

### <a name="dubler2-profiles"></a>About profiles in Dubler 2

ReaHotkey allows you to create as many profiles as you want. It however only allows you to load one of the first 5 profiles in the list of all profiles, which therefore get suffixed with a tag that indicates if its an active profile which can be loaded, or a passive one which needs to be moved to an active slot first.
This is not how Dubler 2 behaves in general, but its a limitation we have to put onto the script because of how the GUI is designed. Thus, in order to make a profile loadable which isn't currently amongst the 5 active profiles, you'll have to push its button and use the move menu to switch it with a currently active profile. This process will restart Dubler for the changes to take effect. Just wait a few seconds until Dubler opens up again and you will be able to load the profile just fine.

## About HotspotHelper
HotspotHelper is a special utility to make developing these kind of scripts a little easier. It retrieves window and control info and creates labelled hotspots that can be copied to clipboard for subsequent use.
