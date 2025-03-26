extends CharacterBody2D
var player
var chase = false
var SPEED = 100

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if chase == true :
		player = get_node("../../Player/Player")
		var direction = (player.position - self.position).normalized()
		if direction.x > 0:
			#get_node("Sprite2D").flip_h = true                 #for flipping the sprite animation
			print("right")
		else :
			#get_node("Sprite2D").flip_h = false                #for flipping the sprite animation
			print("left")
		velocity.x = direction.x * SPEED
		
	else :
		velocity.x = 0

	move_and_slide()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		chase = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		chase = false


func _on_vulnerability_body_entered(body: Node2D) -> void:
	if body.name == "Player" :
		self.queue_free()
