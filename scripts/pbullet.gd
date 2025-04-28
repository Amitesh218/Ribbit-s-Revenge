extends CharacterBody2D

@export var speed := 300.0
@export var lifespan := 3.0  # seconds
var direction: Vector2 = Vector2.RIGHT
var life_timer := 0.0

func _ready():
	direction = direction.normalized()

func _physics_process(delta):
	life_timer += delta
	if life_timer >= lifespan:
		queue_free()

	var vel = direction * speed
	var collision = move_and_collide(vel * delta)
	if collision:
		var collider = collision.get_collider()

		if collider.name.contains("shooter") or collider.name.contains("suicidechaser"):
			if "take_damage" in collider:
				collider.take_damage(5)
			queue_free()
			return

		var normal = collision.get_normal()
		direction = direction.bounce(normal).normalized()
