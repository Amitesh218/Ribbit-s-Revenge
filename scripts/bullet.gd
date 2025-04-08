extends RigidBody2D

var direction: Vector2 = Vector2.ZERO
@export var speed: float = 500.0

func _ready():
	linear_velocity = direction * speed

func _integrate_forces(state):
	# Optionally rotate bullet to face direction
	rotation = direction.angle()

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
