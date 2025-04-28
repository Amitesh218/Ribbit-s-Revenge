extends CharacterBody2D

var chase
var player
var aggro
var recently_stomped = false
var is_dying = false
var is_hit = false
var locked_position = Vector2.ZERO
const SPEED = 100.0

var health = 10

@export var bullet_scene: PackedScene
@export var fire_rate := 1.2
var shoot_timer := 0.0

func _ready() -> void:
	get_node("AnimatedSprite2D").play("idle")

func _physics_process(delta: float) -> void:
	# If the enemy is dying, don't process any further actions
	if is_dying:
		return

	player = get_node("../../player")
	var direction = (player.position - self.position).normalized()

	# Chase the player if in range and not hit
	if chase and not is_hit:
		if !aggro:
			get_node("AnimatedSprite2D").play("idle")
		velocity = direction * SPEED
		get_node("AnimatedSprite2D").flip_h = direction.x > 0
	else:
		if get_node("AnimatedSprite2D").animation != "death" and not is_hit and not aggro:
			get_node("AnimatedSprite2D").play("idle")
		velocity = Vector2.ZERO

	# Shooting logic when in aggro range
	if aggro and not is_hit:
		shoot_timer -= delta
		if shoot_timer <= 0.0:
			shoot_timer = fire_rate
			shoot_at_player()
		get_node("AnimatedSprite2D").play("attack")
		get_node("AnimatedSprite2D").flip_h = direction.x > 0

	move_and_slide()

func _on_playerdetection_body_entered(body: Node2D) -> void:
	if body.name == "player":
		chase = true

func _on_stopnshoot_body_entered(body: Node2D) -> void:
	if body.name == "player":
		chase = false
		aggro = true

func _on_stopnshoot_body_exited(body: Node2D) -> void:
	if body.name == "player":
		chase = true
		aggro = false

func _on_playerdetection_body_exited(body: Node2D) -> void:
	if body.name == "player":
		chase = false

func _on_vulnerability_body_entered(body: Node2D):
	if body.name == "player" and not is_dying:
		recently_stomped = true
		is_dying = true
		death()

func _on_damage_body_entered(body: Node2D):
	if body.name == "player" and not recently_stomped and not is_dying:
		body.health -= 2
		is_dying = true
		death()

func death():
	is_dying = true
	locked_position = position
	chase = false
	aggro = false  # Ensure aggro is reset so it doesn't keep shooting
	velocity = Vector2.ZERO
	get_node("AnimatedSprite2D").play("death")
	$CollisionShape2D.call_deferred("set_disabled",true)
	await get_node("AnimatedSprite2D").animation_finished
	queue_free()  # Remove the enemy from the scene after death animation

func take_damage(amount: int):
	if is_dying or is_hit:
		return
	health -= amount
	if health <= 0:
		is_dying = true  # Block further damage
		death()
	else:
		play_hit_animation()

func play_hit_animation():
	is_hit = true
	var sprite = get_node("AnimatedSprite2D")
	sprite.play("hit")
	sprite.modulate = Color(1, 0.5, 0.5)
	await sprite.animation_finished
	sprite.modulate = Color(1, 1, 1)
	is_hit = false

func shoot_at_player():
	if not bullet_scene or not player or not is_instance_valid(player):
		return
	var bullet = bullet_scene.instantiate()
	var direction = (player.global_position - global_position).normalized()
	bullet.global_position = global_position
	bullet.direction = direction
	get_tree().current_scene.add_child(bullet)
