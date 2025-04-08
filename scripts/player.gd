extends CharacterBody2D
var health = 100

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@export var bullet_scene: PackedScene
@export var shoot_cooldown := 0.3
var shoot_timer := 0.0

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	if Input.is_action_just_pressed("W") and is_on_floor():
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
		
	# Shooter mechanaics
	shoot_timer -= delta
	if Input.is_action_just_pressed("mouse_left") and shoot_timer <= 0.0:
		shoot_timer = shoot_cooldown
		shoot_bullet()


	move_and_slide()

func shoot_bullet():
	if not bullet_scene:
		print("No bullet scene set!")
		return

	var bullet = bullet_scene.instantiate()

	# Offset the aim slightly downward
	var aim_offset := Vector2(0, 10)
	var mouse_pos = get_global_mouse_position() + aim_offset
	var dir = (mouse_pos - global_position).normalized()

	var spawn_point = get_node("bulletspawn")  # Make sure the path is correct
	bullet.global_position = spawn_point.global_position
	bullet.direction = dir
	get_tree().current_scene.add_child(bullet)
