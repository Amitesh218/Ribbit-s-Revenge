extends Node2D

@onready var fade_rect = $CanvasLayer/FadeRect

func _ready():
	fade_rect.modulate.a = 1.0
	fade_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var tween = create_tween()
	tween.tween_property(fade_rect, "modulate:a", 0.0, 1.0)
	GlobalMusic.play_music(preload("res://audio/mainmenu2.mp3"), -10.0, 2.0)

func _on_texture_button_pressed():
	var tween = create_tween()
	tween.tween_property(fade_rect, "modulate:a", 1.0, 1.0)
	await tween.finished
	GlobalMusic.play_music(null, 0.0, 1.0)
	get_tree().change_scene_to_file("res://tutorial.tscn")
