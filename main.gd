extends Node2D


func _on_quitbut_pressed() -> void:
	get_tree().quit()

func _on_playbut_pressed() -> void:
	get_tree().change_scene_to_file("res://world.tscn") # Replace with function body.
