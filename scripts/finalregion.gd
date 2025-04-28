extends Area2D

@export var limit_left: int
@export var limit_right: int
@export var limit_top: int
@export var limit_bottom: int

@export var reset_limits_on_exit: bool = true

@onready var camera = $"../player/Camera2D" # Path to your player’s camera$

# Store original limits to restore them later
var original_limits = {}

func _ready():
	if camera:
		original_limits = {
			"left": camera.limit_left,
			"right": camera.limit_right,
			"top": camera.limit_top,
			"bottom": camera.limit_bottom,
		}

func _on_body_entered(body: Node2D) -> void:
	if body.name == "player" and camera:
		camera.limit_left = 3392
		camera.limit_right = 4160
		camera.limit_top = -95
		camera.limit_bottom = 847

func _on_body_exited(body: Node2D) -> void:
	if body.name == "player" and reset_limits_on_exit and camera:
		camera.limit_left = original_limits["left"]
		camera.limit_right = original_limits["right"]
		camera.limit_top = original_limits["top"]
		camera.limit_bottom = original_limits["bottom"]
