# Changelog
- - -
## 1.0.0 (February 23, 2025)
### Added:
- Everything that is in the app!

### Removed:
- A lot of things that are not in the app!

### Changed:
- Many things!

### Fixed:
- Many things!

## 2.0.0 (June 2, 2025)
### Additions:
- WAVE (.wav) and Ogg Vorbis (.ogg) support
- Option to change render resolution
- New background and post-processing shaders
- New presets
- Auto-update checker (checks for newer releases on launch)
- Option for background shake
- Option to change output device
- Option to change brightness, invert colors, and shift hue of some shaders
- New reactive elements
- Option to change audio data source for audio reaction
- Option to disable deletion of temp files, to allow for manual encoding
- Added antialiasing option to waveform
- Option to rotate icon
- Option to remove audio files from Oscillody
- FFmpeg Status label
- Option to not show the welcome message again
- Troubleshooting file
- Hardware info to logger for better debugging

### Removals:
- Silent beginning of exported videos
- Unnecessary folders and files
- Redundant tooltips
- Unused project setting changes

### Changes:
- Improved audio in exported videos
- Separated Reaction Strength to individual reactive element
- Making invisible waveforms skips drawing steps
- Updated shader licenses
- Updated existing presets
- Order of post-processing layers
- Sliders to spin boxes for better control
- Updated UI theme (also with better contrast)
- Some element ranges
- Step amount for some elements
- How Icon Size scales
- How Waveform Height scales
- Some default values
- Updated README, CONTRIBUTING and CHANGELOG
- Updated tooltips
- Increased tooltip timer
- Updated greetings text
- UI structure
- Renamed UI elements
- Order of UI elements
- Adds Default preset if one is missing
- Disable export button when there's no master imported
- Repositioned audio position hint
- App version number
- Warning message window
- Logger messages
- Preset saving behavior
- Code organization
- Visualizer tree
- How grain is generated
- Project settings

### Fixes:
- Fixed video freezes when app is minimized during rendering
- Made title scale in render match preview
- Fixed bug where adjusting seek slider then playing keeps the grabber in place
- Fixed bug where grabber doesn't move when spacebar is pressed
- Fixed bug where grabber gets stuck if its position is greater than a newly imported track
- Fixed inaccurate audio position hint
- Solved maximizing window issue
- Fixed bug where shader speed becomes faster just from enabling reaction
- Removed unnecessary ``update_visualizer`` signal emissions (should improve performance slightly)
- Fixed inaccurate tooltips
- Updated resizing of player control sliders
- Fixed links in Settings
- Fixed app name not showing in the window title
- Fixed wrong UI separation values
- Removed ability to save presets with a blank name
- Updated some default values not matching default preset
- Fixed very minor chromatic aberration scaling issue

**...and more changes that I forgot to log.**