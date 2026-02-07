# Oscillody
- - -
## Real-time oscilloscope-based audio visualizer
- - -
Oscillody is an easy-to-use program developed by [Akosmo](https://akosmo.carrd.co) to create audio visualizers, whether it is for music, or recordings.
It displays the waveform of your imported audio. You can customize the visualizer to your taste with plenty of options, export the result as a video, and do whatever you want with it.
[Click here to watch the 1.0.0 trailer](https://www.youtube.com/watch?v=djpyHuEzR0w).
[Click here to watch the 2.0.0 trailer](https://www.youtube.com/watch?v=3HjhKNYai6w).

## How and why it was built
- - -
This project started on July 6, 2024, as a personal challenge to make audio visualization using the [Godot Engine](https://godotengine.org), a free and open-source game engine. Since this is my first project, it served as a learning experience for future game projects.
It was built using Godot's ability to return audio sample data, perform FFT, and export videos.
I've always liked audio visualizers, especially the ones with waveform display. However, it was not easy for me to find a simple program to create such visualizers for my videos, without using high-end video editing software.
Even if there might be options around nowadays, this project also serves as a free and simple alternative for those who just want to create a simple visualizer for any reason, without having to tweak a lot of settings or spending money on a video editor.

## Free and open-source
- - -
This is a free and open-source project distributed under the GPL-3.0-or-later versions. You're free to take a look at the code, fork it, and make suggestions on the GitHub repository, however, I'm not accepting code contributions (pull requests) at the moment.
Oscillody will always be free (here as in 0 cost), but you can find many ways to support me on my [homepage](https://akosmo.carrd.co).

## How to use
- - -
### Files panel:
- Import audio files. Either just a master to use with one waveform displayed, or up to 4 stems of the master to be displayed in 4 different waveforms. The audio output is still going to be the imported master.
- Set FFmpeg path. To export MP4 videos, FFmpeg is needed. Installation guide is available in this README file.
- Export MP4. Resolution can be set in settings.

### Customize panel:
- Load and save presets.
- Change the amount of displayed waveforms and their layout.
- Add text.
- Change the look of the waveform.
- Change the background between solid colors, an image, or shaders.
- Add an image to the middle of the visualizer.
- Use post-processing effect shaders.
- Make things react to audio.

### Settings panel:
- Change output device.
- Change the amount of displayed audio samples (requires the app to be restarted).
- Turn on/off low-specs mode if the framerate is constantly under 50 FPS. Use this if you're noticing weird waveform behavior (requires the app to be restarted).
- Change video resolution for exporting.

For more details, some options have tooltips. Just hover your mouse over it.
Use spacebar to play/pause, F10 to toggle UI visibility, and F11 to fullscreen.
Also note that Oscillody is a Windows-only app.

### Folder structure:
- Log: contains .log files that logs many of Oscillody's events, used for troubleshooting.
- Presets: where your presets are saved (can contain absolute paths, which may contain your real name, so beware of that when sharing presets).
- Render Info: preset and audio information used for video rendering.
- Settings: self-explanatory.
- Temp: where PNG sequences are temporarily saved during rendering.

## Importing audio files
- - -
Oscillody accepts MP3, WAVE, and Ogg Vorbis. In case of WAVE, prefer 16bit. Other bit depths are available, but in a few cases, it won't open, due to unsupported AudioFormat header in the WAVE file (must be uncompressed PCM or IEEE float).
Godot Engine's Audio Server runs at the same sample rate as your computer's playback sample rate. Importing files with a different sample rate results in noticeable but sometimes negligible change due to resampling. The change being the high end being a little quieter. During render, Oscillody's sample rate defaults to 44.1kHz (can't be changed - possible Engine issue), so for better quality, import 44.1kHz audio.

## Exporting video
- - -
Videos are exported first as a sequence of PNG files + WAVE file, to the Temp folder in the app's directory. There is a 1 second delay to allow for waveform loading. Once it's done rendering PNGs, it launches FFmpeg (see how to install below) and encodes all PNG files to MP4, exporting to your chosen path. During the encoding step, the app will be frozen, so to cancel it, try closing the command prompt (FFmpeg). PNGs moved to trash once the encoding finishes or any process is canceled (this may trigger your antivirus). Exporting is slow (especially if your graphics driver forces v-sync), and to see the progress, check the window title of the render window (total amount of frames is written in the main window), or find current frame information in the command prompt during the encoding phase.

## How to install FFmpeg and choose its path in Oscillody
- - -
Access [FFmpeg's download page](https://www.ffmpeg.org/download.html#build-windows), and click on gyan.dev's Windows build (under "Get packages & executable files").
Look for "latest git master branch build" under "git master builds". Download the essentials version, but if you're having issues with export, try full version.
Choose a location and extract the folder.
In the app, select "Files", then select click the button to define FFmpeg path. Navigate to the location where you extracted FFmpeg's zip file, and go in the "bin" folder, and select "FFmpeg.exe".

## Building
- - -
Oscillody 2.0.0 was made using Godot 4.4.1. Simply download the source code, and import the project.godot file from Godot's project manager.

Some notes:
- Oscillody automatically tries to create necessary folders and files in the project's user data folder if they are missing, however if that fails, the alerts about that should show which paths are expected, and you can manually create the folders yourself. They have the same name as the folders included in the Release/Itch.io version, with "Debug" added at the end (no spaces). The settings file won't be found at first and raise an error, that's normal. You can either click "continue" in Godot's debugger, if the project gets paused, and restart Oscillody (close the window, don't click restart in Godot, since Oscillody saves settings on quit), or copy the settings file from another directory (must be the same version). When exporting the project, it'll expect the same folders and files in the same directory the executable is located in, without the "Debug" at the end.
- While exporting is not disabled in editor mode, it'd just launch Godot's project manager, and expect different folders. If you need to do video exporting, export the project first (don't forget to follow the same app folder structure).

## Credits and inspiration
- - -
- [Hash Function by James Harnett](https://www.shadertoy.com/view/MdcfDj)
- [Hash Function by SuboptimalEng](https://github.com/SuboptimalEng/shader-tutorials)
- [Blend Modes by Jamie Owen](https://github.com/jamieowen/glsl-blend)
- [Wave Distortion by JT](https://www.shadertoy.com/view/ltSSWV)
- [Lens Distortion's Scaling Factor by aleklesovoi](https://www.shadertoy.com/view/DldXWS)
- [ALMAMplayer](https://almam.itch.io/almamplayer), [Wav2Bar](https://picorims.github.io/wav2bar-website/), and [The Book of Shaders](https://thebookofshaders.com/13/) for inspirations.
- My partner Gwen Hemoxia!
- All other testers listed below.
- All Oscillody users!
- All [Godot](https://github.com/godotengine/godot) contributors!

## Testers
- - -
- [Gwen Hemoxia](https://bsky.app/profile/gwenhemoxia.bsky.social)
- [Endobear](https://bsky.app/profile/endobear.bsky.social)
- [Emerald](https://bsky.app/profile/emmy2gay.bsky.social)
- [soar](https://www.youtube.com/@soaryoutube)
- [Kefflen R.](https://github.com/kefflen)
- [Similar Outskirts](https://www.similaroutskirts.com)

## App status and planned updates
- - -
The app is not in active development as of June 2, 2025 (save for patches), since I'm taking a break from programming for 1 or 2 months to make more music and art. Version 2.1.0 could come out sometime this year.

### Planned updates:
- Performance mode (captures and displays audio from an input device) (Engine-side, input device capture is currently slow)
- Faster rendering (Engine-side)
- Proper rendering and encoding progress bar (might be Engine-side)
- Audio spectrum (along with smoother audio reaction) (Engine-side)
- New background and post-processing shaders
- Improve existing shaders
- Option for multi-colored waveform
- Option for video background
- Allow reactions to happen at element's 0 strength
- Make shader speed framerate-independent
- Font preview
- Option for fade in/out
- More export quality options
- New icon controls
- New shadow controls for title and icon
- Option for background shader rotation
- New reaction controls
- Undo and redo
- Waveform optimization
- More advanced title controls
- Linux support
- Allow importing with drag & drop
- New themes and theme swapper

## Support
- - -
If you need help in using the app, feel free to contact me via any links [here](https://akosmo.carrd.co).

## Known issues
- - -
- Waveform display may look incomplete depending on your output device and audio settings (e.g. some wireless headsets).
- Spectrum data (used for audio reaction) returns jittered values.
- Audio in exported videos are always 44.1kHz.
- MP4 videos may have some small audio artifacts (you have the option to encode yourself).
- Stutters (in preview only - doesn't happen on all computers)