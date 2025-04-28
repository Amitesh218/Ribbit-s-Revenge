extends Node

# Music player variables
var current_track: AudioStreamPlayer
var fade_tween: Tween
var current_volume: float = 0.0  # Default volume (0dB)

# Play a new track with optional fade-in/out
func play_music(track: AudioStream, volume_db: float = 0.0, fade_time: float = 1.0) -> void:
	# Skip if the same track is already playing
	if current_track and current_track.stream == track:
		return

	# Fade out existing track
	if current_track:
		_fade_out_current_track(fade_time)

	# Load and play the new track
	if track:
		if track.has_method("set_loop"):
			track.set_loop(true)
		elif "loop" in track:
			track.loop = true
		
		current_track = AudioStreamPlayer.new()
		current_track.stream = track
		current_track.volume_db = -80.0  # Start muted
		current_track.bus = "Music"      # Assign to a dedicated audio bus (optional)
		add_child(current_track)
		current_track.play()
		_fade_in(current_track, volume_db, fade_time)
	else:
		current_track = null

# Helper: Fade out the current track
func _fade_out_current_track(fade_time: float) -> void:
	if fade_tween and fade_tween.is_running():
		fade_tween.kill()
	
	fade_tween = create_tween()
	fade_tween.tween_property(current_track, "volume_db", -80.0, fade_time)
	fade_tween.tween_callback(current_track.queue_free)

# Helper: Fade in a new track
func _fade_in(player: AudioStreamPlayer, volume_db: float, fade_time: float) -> void:
	current_volume = volume_db
	fade_tween = create_tween()
	fade_tween.tween_property(player, "volume_db", volume_db, fade_time)

# GlobalMusic.gd

# Mute current track without freeing it
func mute_music(fade_time: float = 0.5):
	if current_track:
		if fade_tween and fade_tween.is_running():
			fade_tween.kill()
		fade_tween = create_tween()
		fade_tween.tween_property(current_track, "volume_db", -80.0, fade_time)

# Unmute current track back to original volume
func unmute_music(fade_time: float = 0.5):
	if current_track:
		if fade_tween and fade_tween.is_running():
			fade_tween.kill()
		fade_tween = create_tween()
		fade_tween.tween_property(current_track, "volume_db", current_volume, fade_time)
