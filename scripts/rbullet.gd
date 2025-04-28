extends CharacterBody2D

@export var speed := 400.0
@export var max_bounces := 3
@export var lifetime := 10.0  # Seconds before bullet disappears

var direction: Vector2 = Vector2.RIGHT
var bounce_count := 0
var life_timer := 0.0

func _ready():
	direction = direction.normalized()
	life_timer = lifetime

func _physics_process(delta):
	# Lifetime expiration
	life_timer -= delta
	if life_timer <= 0:
		queue_free()
		return

	var collision = move_and_collide(direction * speed * delta)
	
	if collision:
		var collider = collision.get_collider()

		if collider.name == "player":
			collider.take_damage(2)
			queue_free()
			return

		# Reflect off surface
		var normal = collision.get_normal()
		direction = direction.bounce(normal).normalized()
		bounce_count += 1

		if bounce_count >= max_bounces:
			queue_free()
