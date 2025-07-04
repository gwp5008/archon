extends CharacterBody2D

var duelComplete = false
#var boardData = BoardData.new()
@onready var animations = $AnimationPlayer
				
func _physics_process(_delta):
	if duelComplete == false:
		velocity.x = Input.get_action_strength("walk_right") - Input.get_action_strength("walk_left")
		velocity.y = Input.get_action_strength("walk_down") - Input.get_action_strength("walk_up")
		velocity = velocity * 200
		move_and_slide()
		updateAnimation()
	else:
		#print("changing back to board")
		get_tree().change_scene_to_file("res://scenes/levels/board/board.tscn")
	
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
		
func _input(event):
	if event is InputEventMouseButton and event.pressed:
		duelComplete = true
		#boardData.setDuelNeeded(false)
		
	
