extends CharacterBody2D
var chase
var player
var recently_stomped = false
var is_dying = false
var locked_position = Vector2.ZERO

var health = 10

const SPEED = 100.0

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
			print("left")
			
	else: #when chase is not true, which is when either the player's outta range or enemy's dead
		if get_node("AnimatedSprite2D").animation != "death":
			get_node("AnimatedSprite2D").play("idle")
		velocity.x = 0 #To make em stop when the player's outta range
	
	if is_dying:
		position = locked_position
		return
	if health <=0:
		death()
	move_and_slide()
	
func _on_player_detection_body_entered(body: Node2D) -> void:
	if body.name == "player":
		chase = true

func _on_player_detection_body_exited(body: Node2D) -> void:
	if body.name == "player":
		chase = false

func _on_vulnerability_body_entered(body: Node2D) -> void:
	if body.name == "player":
		print("vulnerable")
		recently_stomped = true
		death()

func _on_damage_body_entered(body: Node2D) -> void:
	if body.name == "player" and not recently_stomped:
		print("damage")
		body.health-=5
		death()

func death():
	is_dying = true
	locked_position = position
	chase = false
	velocity = Vector2.ZERO
	get_node("AnimatedSprite2D").play("death")
	await get_node("AnimatedSprite2D").animation_finished
	queue_free()
