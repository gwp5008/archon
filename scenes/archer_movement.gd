extends CharacterBody2D

@onready var animations = $AnimationPlayer
				
func _physics_process(_delta):
	velocity.x = Input.get_action_strength("walk_right") - Input.get_action_strength("walk_left")
	velocity.y = Input.get_action_strength("walk_down") - Input.get_action_strength("walk_up")
	velocity = velocity * 200
	move_and_slide()
	updateAnimation()
	
func updateAnimation():
	if velocity.length() == 0:
		animations.stop()
		
	var direction = ""
	if velocity.x < 0 && velocity.y == 0: direction = "left"
	elif velocity.x > 0 && velocity.y == 0: direction = "right"
	elif velocity.y < 0 && velocity.x == 0: direction = "up"
	elif velocity.y > 0 && velocity.x == 0: direction = "down"
	elif velocity.y < 0 && velocity.x < 0: direction = "upleft"
	elif velocity.y < 0 && velocity.x > 0: direction = "upright"
	elif velocity.y > 0 && velocity.x < 0: direction = "downleft"
	elif velocity.y > 0 && velocity.x > 0: direction = "downright"
	
	if (direction != ""):
		animations.play("walk_" + direction)
	
