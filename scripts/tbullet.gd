extends RigidBody2D

@export var speed := 400.0
var direction: Vector2 = Vector2.RIGHT

func _ready():
	# Force direction to horizontal (preserves sign, but removes vertical movement)
	
	linear_velocity = direction * speed
	contact_monitor = true
	max_contacts_reported = 1

func _on_body_entered(body: Node) -> void:
	if body.name == "player":
		body.take_damage(2)
		queue_free()
	elif body.name != "bullet":
		queue_free()
	elif body.name != "shooter":
		queue_free()
