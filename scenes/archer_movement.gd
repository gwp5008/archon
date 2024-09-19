extends CharacterBody2D

@onready var animations = $AnimationPlayer

const TILE_SIZE = 64
@onready var ray = $RayCast2D
var last_position = Vector2() # last idle position
var target_position = Vector2() # desired position to move towards
var movedir = Vector2() # move direction
	
func _process(delta: float) -> void:
	rayCode()
	
func rayCode():
	if ray.is_colliding():
		var collision = ray.get_collider()
		if collision is TileMapLayer:
			var tile_name = get_tile(collision)
			print (tile_name)
			if !(tile_name.begins_with("Walkable")):                
				position = last_position
				target_position = last_position
				
func get_tile(tile_map):    
	if tile_map is TileMap:
		var v = Vector2(TILE_SIZE / 2 , TILE_SIZE /2)
		var tile_pos = tile_map.world_to_map(position + v + ray.cast_to)
		var tile_id = tile_map.get_cellv(tile_pos)
		if (tile_id == -1):
			return "None"
		else:
			return tile_map.tile_set.tile_get_name(tile_id)
				
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
