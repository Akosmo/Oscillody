# Troubleshooting
- - -
## How to use this file
- - -
This file will contain several issues you might encounter, and a guide on fixing them. You should read the README file before this one, since it already mentions solutions to some problems, and if none of these solutions help, submit a bug report (read: CONTRIBUTING).
Oscillody will also show you an alert if you encounter an error and how to fix it, but it might not be available for every error.

## Issues
- - -
### Oscillody won't launch
- Launch it in compatibility renderer mode, by going to the Oscillody folder, replacing directory path by "cmd" and pressing Enter, pressing Tab until Oscillody.exe appears on the command prompt, then pressing space and typing "--rendering-driver opengl3" or "--rendering-method compatibility". If that doesn't work, submit a bug report. No quotes for any of these.

### Can't define FFmpeg
- Make sure the FFmpeg executable is named "ffmpeg.exe".

### Audio reaction doesn't work after clearing files
- Reselect one of the sources, make sure it has sub frequencies.

### One of the post-processing or backgrounds types appear broken
- Try "Oscillody won't launch".
- Avoid leaving Oscillody open for too long.

### The exported video is frozen in some places
- Avoid pressing the minimizing button on the render window (you can still click on other windows).

### The video looks bad on YouTube, despite looking fine on local video players
- YouTube applies heavy compression in videos with resolutions equal or below 1080p, so you're limited to using 1440p if you want good quality.

### Oscillody can't create/delete folders/files
- Make sure your antivirus isn't blocking Oscillody.
- Place the Oscillody directory somewhere that doesn't need admin permissions.

### FFmpeg (cmd) opens but doesn't do anything
- One of the last lines on cmd might be asking you if you want to replace an existing MP4 file, press 'y' if you do, or 'N' if you don't, then press Enter.

### There are volume artifacts in the exported video
- It's probably the player you're using (this has happened in Media Player).