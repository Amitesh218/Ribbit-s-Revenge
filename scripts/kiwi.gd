extends Area2D

@export var ammo_amount := 5
@onready var animated_sprite = $AnimatedSprite2D
@onready var collision_shape = $CollisionShape2D

func _on_body_entered(body: Node) -> void:
	if body.name == "player":
		body.add_ammo(ammo_amount)
		collect()

func collect():
	# Disable collision immediately
	collision_shape.set_deferred("disabled", true)
	
	# Play collect animation
	animated_sprite.play("collected")
	
	# Wait for animation to finish
	await animated_sprite.animation_finished
	
	# Remove from scene
	queue_free()
