extends CharacterBody2D

@export var speed := 500.0
var direction: Vector2 = Vector2.RIGHT

func _ready():
	direction = direction.normalized()

func _physics_process(delta):
	var collision = move_and_collide(direction * speed * delta)
	if collision:
		var collider = collision.get_collider()

		if collider.name.begins_with("shooter") or collider.name == "suicidechaser" :
			collider.health -= 5

		queue_free()
