# Troubleshooting
- - -
## How to use this file
- - -
This file will contain several issues you might encounter, and a guide on fixing them. If none of these solutions help, submit a bug report (read: CONTRIBUTING).
Oscillody will also show you an alert if you encounter an error and how to fix it, but it might not be available for every error.

## Known issues
- - -
- Waveform display may look broken
- Audio in exported videos are always 44.1kHz (only a "problem" if you've imported a 48kHz audio).
- MP4 videos may have some small audio artifacts (you have the option to encode yourself). (TODO: Add option to not delete temp files).

## Possible issues
- - -
### Oscillody won't launch
- Update your graphics driver. If that doesn't help, launch Oscillody in compatibility renderer mode, by going to the Oscillody folder, replacing directory path by "cmd" and pressing Enter, pressing Tab until Oscillody.exe appears on the command prompt, then pressing space and typing "--rendering-driver opengl3" or "--rendering-method compatibility". If that doesn't work, submit a bug report. No quotes for any of the commands.

### Waveform looks broken (missing chunks or parts don't connect)
- This can be caused by your output device/driver and audio settings. But it can also be caused by low frame rate. These should only be a problem in preview, not for exports. To fix the problem, aside from trying to improve framerate, make sure your number of output channels is equal to 2. To check, go to **Settings > Debug Panel > General** and look for the "Number of Channels" item.

### Can't set FFmpeg path
- Make sure the FFmpeg executable is named "ffmpeg.exe".

### Audio reaction doesn't work
- Audio reaction uses low frequency data for its function. Make sure that the selected source has bass frequencies, and that goes above the defined threshold (see the property "Minimum Decibels")

### One of the post-processing or backgrounds types appear broken
- Try "Oscillody won't launch". Make sure the "Rendering Method" item in **Settings > Debug Panel > General** doesn't say "forward_plus".
- Restart Oscillody if it's been open for a long time.

### Exporting doesn't start (progress is stuck at 0%)
- Make sure you have a decent amount of available space and memory.

### The exported video is frozen in some places
- Avoid pressing the minimizing button on the export window (you can still click on other windows).

### The video looks bad on YouTube, despite looking fine on local video players
- YouTube applies heavy compression in videos with resolutions equal or below 1080p, so you're limited to using 1440p (4K) if you want good quality.

### Oscillody can't create/delete folders/files
- Make sure your antivirus isn't blocking Oscillody. If an antivirus warning appeared when launching Oscillody, relaunch it. If it's performing a scan, wait for it to finish.
- Place the Oscillody directory somewhere that doesn't need admin permissions.

### There are volume artifacts in the exported video
- It's probably the player you're using (this has happened in Media Player).