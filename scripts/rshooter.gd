extends CharacterBody2D
var chase
var player
var aggro
var recently_stomped = false
var is_dying = false
var locked_position = Vector2.ZERO
const SPEED = 50.0

var health = 10

@export var bullet_scene: PackedScene
@export var fire_rate := 3
var shoot_timer := 0.0

func _ready() -> void:
	get_node("AnimatedSprite2D").play("idle")


func _physics_process(delta: float) -> void:
	
	# Add the gravity.
	velocity += get_gravity() * delta
	
	# Add player node
	player = get_node("../../player")
	var direction = (player.position - self.position).normalized()
	
	if chase == true:
		get_node("AnimatedSprite2D").play("chase")
		if direction.x > 0:
			velocity.x = direction.x * SPEED
			get_node("AnimatedSprite2D").flip_h = true
			# print("right")
		else :
			velocity.x = direction.x * SPEED
			get_node("AnimatedSprite2D").flip_h = false
			# print("left")
			
	else: #when chase is not true, which is when either the player's outta range or enemy's dead
		if get_node("AnimatedSprite2D").animation != "death":
			get_node("AnimatedSprite2D").play("idle")
		velocity.x = 0 #To make em stop when the player's outta range
	
	if aggro == true:
		shoot_timer -= delta
		if shoot_timer <= 0.0:
			shoot_timer = fire_rate
			shoot_at_player()
		# print("aggro behavior goes here, in this case shooting two bullets in the direction of the player")
		
		if direction.x > 0:
			get_node("AnimatedSprite2D").flip_h = true
		else:
			get_node("AnimatedSprite2D").flip_h = false
	
	if is_dying:
		position = locked_position
		return
	
	if health <= 0:
		death()
	
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


func _on_vulnerability_body_entered(body: Node2D) -> void:
	if body.name == "player":
		recently_stomped = true
		death()

func death():
	is_dying = true
	locked_position = position
	chase = false
	velocity = Vector2.ZERO
	get_node("AnimatedSprite2D").play("death")
	await get_node("AnimatedSprite2D").animation_finished
	queue_free()


func _on_damage_body_entered(body: Node2D) -> void:
	if body.name == "player" and not recently_stomped:
		body.health -= 50
		death()


func shoot_at_player():
	if not bullet_scene or not player or not is_instance_valid(player):
		return
	var bullet = bullet_scene.instantiate()
	var direction = (player.global_position - global_position).normalized()
	bullet.global_position = global_position 
	bullet.direction = direction
	get_tree().current_scene.add_child(bullet)
