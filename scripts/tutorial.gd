extends Node2D

@onready var fade_rect = $UI/FadeRect

func _ready():
	fade_rect.modulate.a = 1.0
	fade_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var tween = create_tween()
	tween.tween_property(fade_rect, "modulate:a", 0.0, 1.0)
	GlobalMusic.play_music(preload("res://audio/tutorial.mp3"), -10.0, 2.0)
