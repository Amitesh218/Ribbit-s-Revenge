extends Control

var music_muted: bool = false

func _ready() -> void:
	$AnimationPlayer.play("RESET")
	visible = false  # Hide pause menu at start

func resume():
	get_tree().paused = false
	$AnimationPlayer.play_backwards("blur")
	visible = false

func pause():
	get_tree().paused = true
	visible = true
	$AnimationPlayer.play("blur")

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("esc"):
		if get_tree().paused:
			resume()
		else:
			pause()

func _on_resume_pressed() -> void:
	resume()

func _on_restart_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_main_menu_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://mainmenu.tscn")

func _on_mute_music_pressed() -> void:
	if not GlobalMusic.current_track:
		return  # No music playing

	if music_muted:
		GlobalMusic.unmute_music()
		music_muted = false
		resume()
	else:
		GlobalMusic.mute_music()
		music_muted = true
		resume()
