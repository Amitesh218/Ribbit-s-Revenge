extends Node2D

@onready var fade_rect = $UI/FadeRect

func _ready():
	fade_rect.modulate.a = 3.0
	fade_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var tween = create_tween()
	tween.tween_property(fade_rect, "modulate:a", 0.0, 1.0)
	
	# Play music respecting saved mute state
	GlobalMusic.play_music(preload("res://audio/bgm2.mp3"), -10.0, 1.0)


func _on_worldbound_body_entered(body: Node2D) -> void:
	if body.name == "player":
		call_deferred("_reload_scene")

func _reload_scene() -> void:
	get_tree().reload_current_scene()


func _on_spikes_body_entered(body: Node2D) -> void:
	if body.name == "player":
		body.take_damage(100)
