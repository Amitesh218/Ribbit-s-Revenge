extends CharacterBody2D

var health = 10
var max_health = 10
var ammo = 0
var max_ammo = 20
var is_hit = false
var invincible = false

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const INVINCIBILITY_DURATION = 1.0
const HIT_ANIM_DURATION = 0.3

@export var bullet_scene: PackedScene
@export var shoot_cooldown := 0.25
var shoot_timer := 0.0

@onready var shoot_sound = $ShootSound
@onready var walk_sound = $WalkSound


func _physics_process(delta: float) -> void:
	# Apply gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Get input
	var direction := Input.get_axis("A", "D")
	
	# Jump
	if (Input.is_action_just_pressed("ui_accept") or Input.is_action_just_pressed("W")) and is_on_floor() and not is_hit:
		velocity.y = JUMP_VELOCITY

	# Flip sprite
	if direction != 0:
		get_node("AnimatedSprite2D").flip_h = direction < 0

	# Movement
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	# Walking sound
	if is_on_floor() and abs(velocity.x) > 0:
		if not walk_sound.playing:
			walk_sound.play()
	else:
		if walk_sound.playing:
			walk_sound.stop()


	# Animations
	update_animations()
	
	# Shooting
	shoot_timer -= delta
	if Input.is_action_just_pressed("mouse_left") and shoot_timer <= 0.0 and not is_hit and ammo > 0:
		shoot_timer = shoot_cooldown
		shoot_bullet()
		ammo -= 1
		# Optional: Play ammo UI update here

	move_and_slide()

func update_animations():
	var sprite = get_node("AnimatedSprite2D")
	if is_hit:
		sprite.play("hit")
	elif not is_on_floor():
		sprite.play("jump" if velocity.y < 0 else "fall")
	elif velocity.x != 0:
		sprite.play("running")
	else:
		sprite.play("idle")


func play_hit_animation():
	is_hit = true
	invincible = true
	
	var sprite = get_node("AnimatedSprite2D")
	sprite.play("hit")
	sprite.modulate = Color(1, 0.5, 0.5)
	
	await get_tree().create_timer(HIT_ANIM_DURATION).timeout
	sprite.modulate = Color(1, 1, 1)
	is_hit = false
	
	await get_tree().create_timer(INVINCIBILITY_DURATION - HIT_ANIM_DURATION).timeout
	invincible = false


func shoot_bullet():
	if not bullet_scene or ammo <= 0:
		return
	
	var bullet = bullet_scene.instantiate()
	var mouse_pos = get_global_mouse_position() + Vector2(0, 10)
	var dir = (mouse_pos - global_position).normalized()
	bullet.global_position = get_node("bulletspawn").global_position
	bullet.direction = dir
	get_tree().current_scene.add_child(bullet)

	if shoot_sound:
		shoot_sound.play()


func take_damage(amount: int):
	if invincible:
		return
	
	health -= amount
	health = max(health, 0)
	
	if health <= 0:
		die()
	else:
		play_hit_animation()

func die():
	print("Player died!")

	var sprite = get_node("AnimatedSprite2D")
	sprite.play("death")

	velocity = Vector2.ZERO
	set_physics_process(false)

	await sprite.animation_finished

	# Fade to black before reloading
	if has_node("../UI/FadeRect"):
		var fade_rect = get_node("../UI/FadeRect")
		var tween = create_tween()
		tween.tween_property(fade_rect, "modulate:a", 1.0, 1.0)  # Fade to full black in 1 second
		await tween.finished

	call_deferred("_reload_scene")

func _reload_scene() -> void:
	get_tree().reload_current_scene()


func add_health(amount: int):
	health = min(health + amount, max_health)
	# Optional: Play health pickup effect

func add_ammo(amount: int):
	ammo = min(ammo + amount, max_ammo)
	# Optional: Play ammo pickup effect
