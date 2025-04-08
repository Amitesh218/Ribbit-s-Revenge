extends CharacterBody2D
var health = 100

const SPEED = 300.0
const JUMP_VELOCITY = -400.0


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("A", "D")
	if direction:
		if direction > 0:
			velocity.x = direction * SPEED
			get_node("AnimatedSprite2D").play("running")
			get_node("AnimatedSprite2D").flip_h = false

		if direction < 0:
			velocity.x = direction * SPEED
			get_node("AnimatedSprite2D").play("running")
			get_node("AnimatedSprite2D").flip_h = true

	else:
		get_node("AnimatedSprite2D").play("idle")
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
