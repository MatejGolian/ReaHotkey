# ReaHotkey

## What's This And Who Is It For?
This is an AutoHotkey scripth which aims to make certain virtual instruments/sample libraries  and related programs at least a little more accessible to blind users. It is based on the accessibilityOverlay script available [here](https://github.com/MatejGolian/accessibilityOverlay/) and is primarily designed to run in tandem with the REAPER digital audio workstation, although in particular cases standalone versions of programs/instruments may be supported as well.

## Features
* Makes it possible to load instruments and add libraries in Best Service Engine 2.
  - Works both inside REAPER and in the standalone version of Engine 2.
* Makes it possible to interact with Komplete Kontrol menus.
  - Works both inside REAPER and in the standalone version of Komplete Kontrol. Note that Komplete Kontrol version 3 is required.
* Makes it possible to interact with Kontakt menus.
  - Works both inside REAPER and in the standalone version of Kontakt. Note that Kontakt version 7.7.0 or higher is required.
* Makes it possible to switch between the classic and modern mixes in Audio Imperia's Areia, Cerberus, Chorus, Jaeger, Nucleus, Solo and Talos libraries.
  - Only works inside REAPER.

## Keyboard Shortcuts
* ctrl+shift+windows+a - about
* ctrl+shift+windows+p - pause
* ctrl+shift+windows+q - quit
* ctrl+shift+windows+r - view readme

## Known Issues
* If you find that your keyboard or ReaHotkey itself is not responding as expected after interacting with Kontakt menus, press the Escape key.
* Using any other zoom value in Kontakt than 100% may result in ReaHotkey not working correctly and the Kontakt plugin not being detected.

## About HotspotHelper
HotspotHelper is a special utility to make developing these kind of scripts a little easier. It retrieves window and control info and creates labelled hotspots that can be copied to clipboard for subsequent use.
