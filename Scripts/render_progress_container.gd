# Oscillody
# Copyright (C) 2025 Akosmo

# This file is part of Oscillody. Unless specified otherwise, it is under the license below:

# Oscillody is free software: you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by the Free Software Foundation,
# either version 3 of the License, or any later version.

# Oscillody is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the GNU General Public License for more details.

# You should have received a copy of the GNU General Public License along with Oscillody.
# If not, see <https://www.gnu.org/licenses/>.

extends CenterContainer

# This script handles the pop-up for the render progress.

#region NODES ##################################

@onready var total_frames_label: Label = %TotalFramesLabel
@onready var render_p_cancel: Button = %RenderPCancel

@onready var ui_anim_player: AnimationPlayer = %UIAnimPlayer
@onready var render_finished_sfx: AudioStreamPlayer = %RenderFinishedSFX

#endregion ##################################

#region RENDER PROGRESS VARIABLES ##################################

const FPS: int = 60

var total_frames: int
var thread: Thread
var thread_finished: bool = true
var render_canceled: bool = false

#endregion ##################################

func _ready() -> void:
	MainUtils.pid_opened.connect(on_pid_opened)

func _process(_delta: float) -> void:
	# Closing thread.
	if thread != null and not thread.is_alive() and not thread_finished:
		thread.wait_to_finish()
		thread_finished = true

func on_pid_opened() -> void:
	render_canceled = false
	ui_anim_player.play("progress_in")
	total_frames = FPS * int(MainUtils.audio_duration) + 60 # 1 second for waveform loading time
	
	total_frames_label.text = \
	"Total amount of frames to be rendered: a little over " + str(total_frames) \
+ "\nTo check progress, look at the title of the render window.\nCheck README for more info on the process."
	
	thread_finished = false
	thread = Thread.new()
	thread.start(thread_func)
	
	MainUtils.logger("New process ID for render found, and new thread started.")

func thread_func() -> void:
	while OS.is_process_running(MainUtils.process_id):
		continue
	call_deferred("finished_render")

func finished_render() -> void:
	ui_anim_player.play("progress_out")
	render_finished_sfx.set_volume_db(MainUtils.new_volume_in_db)
	render_finished_sfx.play()
	MainUtils.logger("Rendering finished (progress bar has reached 100%) or canceled.")
	
	if not render_canceled:
		var frames_directory: String = MainUtils.temp_path + MainUtils.video_filename + "/"
		if frames_directory.contains(".mp4"):
			frames_directory = frames_directory.replace(".mp4", "")
		var video_frames: String = frames_directory + MainUtils.video_filename + "%08d.png"
		if video_frames.contains(".mp4"):
			video_frames = video_frames.replace(".mp4", "")
		var wav_file: String = frames_directory + MainUtils.video_filename + ".wav"
		if wav_file.contains(".mp4"):
			wav_file = wav_file.replace(".mp4", "")
		var mp4_video_output: String = MainUtils.video_output_full_path
		if not mp4_video_output.contains(".mp4"):
			mp4_video_output += ".mp4"
		mp4_video_output = mp4_video_output.replace("\\", "/")
		
		# Broken, leaving this here because it shouldn't be broken
		render_p_cancel.text = "Frozen app - close CMD instead"
		render_p_cancel.disabled = true
		
		# -r sets framerate
		# -start_number sets starting frame (searches from input files)
		# -i sets input
		# -ss sets starting time (audio)
		# -c:a sets audio codec (AAC is the most supported codec for mp4, though FFmpeg's encoder is not the best)
		# -b:a sets Constant Bit Rate (CBR) (256kbps should be transparent)
		# -ar sets sample rate (it's impossible to change sample rate in runtime)
		# -channel_layout is self explanatory, though FFmpeg still guesses the layout
		# +faststart moves audio stream to beginning of file for faster playback (maybe not needed)
		# -preset sets encoding speed (slower = better compression)
		# -crf sets Constant Rate Factor (basically quality)
		# -pix_fmt sets pixel format (used for "dumb players")
		# Last parameter is output (the .mp4 extension implies libx264 codec)
		
		var ffmpeg_args: PackedStringArray = [
			"-r", "60",
			"-start_number", "60",
			"-i", video_frames,
			"-ss", "00:00:01.00",
			"-i", wav_file,
			"-c:a", "aac",
			"-b:a", "256k",
			"-ar", "44100",
			"-channel_layout", "stereo",
			"-movflags", "+faststart",
			"-preset", "slower",
			"-crf", "17",
			"-pix_fmt", "yuv420p",
			mp4_video_output
			]
		MainUtils.logger("Starting FFmpeg with the args: " + str(ffmpeg_args))
		var exit_code: int = OS.execute(MainUtils.ffmpeg_path, ffmpeg_args, [], false, true)
		if exit_code:
			MainUtils.logger("Failed to execute FFmpeg, or FFmpeg was canceled.", true, true)
			delete_png_folder("Failed or canceled.")
		else:
			render_finished_sfx.play()
			delete_png_folder("Finished.")
		MainUtils.logger("Command Prompt exit code: " + str(exit_code))
		
		render_p_cancel.text = "Cancel"
		render_p_cancel.disabled = false
	else:
		delete_png_folder("Canceled.")

func delete_png_folder(reason: String) -> void:
	if MainUtils.free_up_space:
		var png_folder_to_delete: String = MainUtils.temp_path + MainUtils.video_filename + "/"
		if png_folder_to_delete.contains(".mp4"):
			png_folder_to_delete = png_folder_to_delete.replace(".mp4", "")
		await get_tree().create_timer(1.0).timeout
		var err_2: Error = OS.move_to_trash(png_folder_to_delete)
		if err_2:
			MainUtils.logger(
				"Could not move the PNG folder (" + png_folder_to_delete + ") to trash. Delete manually in Temp folder.",
				true
				)
		else:
			MainUtils.logger("PNG folder moved to trash (or permanently removed if recycle bin is disabled). \
Reason: " + reason)
	else:
		MainUtils.logger("PNG sequence not deleted since user chose not to delete them.")

#region RENDER PROGRESS BUILT-IN SIGNAL FUNCTIONS ##################################

func _on_render_p_cancel_pressed() -> void:
	render_canceled = true
	thread_finished = true
	ui_anim_player.play("progress_out")
	MainUtils.logger("Render process killed / Session closed (render process).")
	if OS.is_process_running(MainUtils.process_id):
		var err_1: Error = OS.kill(MainUtils.process_id)
		if err_1:
			MainUtils.logger("Could not kill render process. Error: " + error_string(err_1), true, true)

#endregion ##################################
