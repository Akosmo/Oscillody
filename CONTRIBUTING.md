# Contributing
- - -
Thank you for your interest in contributing! However, I'm not accepting any code contributions (pull requests), at least for now. Instead, you'll find here how to report bugs and make suggestions.
If you REALLY want to contribute with code, there's a section for that below.

## Before opening an issue
- - -
Make sure the bug you want to report, or your suggestion, isn't already an opened issue. You can add to that issue instead of opening a new one.
Also make sure you're using the latest version.

## How to report a bug
- - -
When reporting a bug, make sure:
- That it isn't already mentioned on README.
- To include log file, and mention the relevant timestamp if there's one (keep in mind, the log file may include personal information such as your real name. Redact if needed).
- To mention your computer specs, most importantly your monitor resolution, GPU, CPU, audio devices, OS, and drivers.
- To include a screenshot or preferably a video if possible.
- To include a video output and audio file imported if necessary.
- To include steps to reproduce if you can.

## How to make suggestions
- - -
These suggestions can be about new features or improvements. Don't forget to include the "enhancement" label on your issue.
When making a suggestion, make sure:
- That it fits the scope of this app (for example, don't suggest video editing capabilities or fully customizable particle system), but you can err on the side that your suggestion fits the scope
- To describe the current and wanted behaviors, if the suggestion is an improvement

## Pull requests
- - -
For now, if you really wanna help with pull requests, you can help by making improvements to key features in the Godot Engine that would be really beneficial to Oscillody. Me and other Godot users would appreciate it a lot!
- Related to performance mode (captures and displays audio from an input device):
	- https://github.com/godotengine/godot/issues/80173
	- https://github.com/godotengine/godot/pull/75628
	- https://github.com/godotengine/godot/pull/105244
	- https://github.com/godotengine/godot-proposals/issues/11347
	- Note: performance mode was already added during the development of 2.0.0, however, it had to be reverted due to audio getting delayed over time.
- Related to fast rendering:
	- https://github.com/godotengine/godot-proposals/issues/4751
	- https://github.com/godotengine/godot-proposals/issues/3726
	- https://github.com/godotengine/godot/pull/80768
	- https://github.com/godotengine/godot/pull/91263
	- https://github.com/godotengine/godot/pull/74324
	- Note: these are the closest to being implemented into the engine, meaning out of all items in the list, this update may come sooner than others. Still, inputs are helpful. Also, there is an issue open for uncapped AVI exporting, however I don't know if I'd end up using that, despite being faster. Link: https://github.com/godotengine/godot-proposals/issues/4752
- Related to audio spectrum and FFT (used for audio reaction):
	- https://github.com/godotengine/godot/issues/67650
	- https://github.com/godotengine/godot/issues/38215
	- https://github.com/godotengine/godot/pull/52626
	- Note: I've already made an audio spectrum prototype, this is very doable, however, the results are unacceptable because of FFT problems. Also, for a result that looks more like the audio spectrum of A Certain VFX Software, spectrum reassignment might be needed. Learn more about it here: https://www.youtube.com/watch?v=8J4LE9UpxYU
- Related to progress bar:
	- I'd use the function ``OS.execute_with_pipe()``, however, I'm having issues which I described here: https://forum.godotengine.org/t/os-execute-with-pipe-not-working-as-expected/111156
- Related to video background:
	- Godot currently only supports the Ogg Theora video format. A more popular format could be added to the core Engine, if it's valid for them (in terms of licensing, for example). Regardless, I could try adding video background while Ogg Theora is the only acceptable format.
- Others (Engine):
	- Get sample rate information from MP3 and Ogg imports.
	- Fix mix rate during movie writing process