extends CharacterBody2D

var chase = false
var player
var recently_stomped = false
var is_dying = false
var is_hit = false
var locked_position = Vector2.ZERO

var health = 10
const SPEED = 100.0

func _ready() -> void:
	get_node("AnimatedSprite2D").play("idle")

func _physics_process(delta: float) -> void:
	if is_dying:
		position = locked_position
		return
	
	if is_hit:
		return
	
	velocity += get_gravity() * delta

	if not player or not is_instance_valid(player):
		player = get_node("../../player")
	
	var direction = (player.position - position).normalized()

	if chase:
		get_node("AnimatedSprite2D").play("chase")
		velocity.x = direction.x * SPEED
		get_node("AnimatedSprite2D").flip_h = direction.x > 0
	else:
		if get_node("AnimatedSprite2D").animation != "death":
			get_node("AnimatedSprite2D").play("idle")
		velocity.x = 0

	move_and_slide()

func _on_player_detection_body_entered(body: Node2D) -> void:
	if body.name == "player":
		chase = true

func _on_player_detection_body_exited(body: Node2D) -> void:
	if body.name == "player":
		chase = false

func _on_vulnerability_body_entered(body: Node2D) -> void:
	if body.name == "player" and not is_dying:
		recently_stomped = true
		death()

func _on_damage_body_entered(body: Node2D) -> void:
	if body.name == "player" and not recently_stomped and not is_dying:
		body.take_damage(2)
		death()

func death():
	if is_dying:
		return
	is_dying = true
	locked_position = position
	chase = false
	velocity = Vector2.ZERO
	get_node("AnimatedSprite2D").play("death")
	$CollisionShape2D.call_deferred("set_disabled",true)
	await get_node("AnimatedSprite2D").animation_finished
	queue_free()

func take_damage(amount: int):
	if is_dying or is_hit:
		return
	health -= amount
	if health <= 0:
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
