extends RigidBody2D

@export var speed := 400.0
@export var max_bounces := 3
var direction: Vector2 = Vector2.RIGHT
var bounce_count := 0

func _ready():
	linear_velocity = direction.normalized() * speed
	contact_monitor = true
	max_contacts_reported = 1

func _on_body_entered(body: Node) -> void:
	if body.name == "player":
		body.health -= 5
		queue_free()
	elif body.name != "bullet" and body.name != "shooter":
		bounce_count += 1
		if bounce_count >= max_bounces:
			queue_free()
