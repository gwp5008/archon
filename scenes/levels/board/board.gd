extends Node2D

var GRID_DIM = 9
var OFFSET_VALUE = 3
var colorTurn = "light"
var touchingGameTile = false
var tile = Vector2i(0, 0)
@onready var tileMap = $TileMap
@onready var archer = preload("res://scenes/archer_movement.tscn")
@onready var topArcher = $TopArcher
#@export var archer_movement: PackedScene
#@onready var archer = $Archer

var SQUARES = [
	{"coordinates" : Vector2i(0, 0), "piece" : "valkyrie", "attribute" : "fly", "square" : "dark", "movement_units" : 3}, 
	{"coordinates" : Vector2i(0, 1), "piece" : "golem", "attribute" : "ground", "square" : "light", "movement_units" : 3}, 
	{"coordinates" : Vector2i(0, 2), "piece" : "unicorn", "attribute" : "ground", "square" : "dark", "movement_units" : 4}, 
	{"coordinates" : Vector2i(0, 3), "piece" : "djinn", "attribute" : "fly", "square" : "neutral", "movement_units" : 4}, 
	{"coordinates" : Vector2i(0, 4), "piece" : "wizard", "attribute" : "teleport", "square" : "light", "movement_units" : 3}, 
	{"coordinates" : Vector2i(0, 5), "piece" : "phoenix", "attribute" : "fly", "square" : "neutral", "movement_units" : 5}, 
	{"coordinates" : Vector2i(0, 6), "piece" : "unicorn", "attribute" : "ground", "square" : "dark", "movement_units" : 4}, 
	{"coordinates" : Vector2i(0, 7), "piece" : "golem", "attribute" : "ground", "square" : "light", "movement_units" : 3}, 
	{"coordinates" : Vector2i(0, 8), "piece" : "valkyrie", "attribute" : "fly", "square" : "dark", "movement_units" : 3}, 
	{"coordinates" : Vector2i(1, 0), "piece" : "archer", "attribute" : "ground", "square" : "light", "movement_units" : 3}, 
	{"coordinates" : Vector2i(1, 1), "piece" : "knight", "attribute" : "ground", "square" : "dark", "movement_units" : 3}, 
	{"coordinates" : Vector2i(1, 2), "piece" : "knight", "attribute" : "ground", "square" : "neutral", "movement_units" : 3}, 
	{"coordinates" : Vector2i(1, 3), "piece" : "knight", "attribute" : "ground", "square" : "light", "movement_units" : 3}, 
	{"coordinates" : Vector2i(1, 4), "piece" : "knight", "attribute" : "ground", "square" : "neutral", "movement_units" : 3}, 
	{"coordinates" : Vector2i(1, 5), "piece" : "knight", "attribute" : "ground", "square" : "light", "movement_units" : 3}, 
	{"coordinates" : Vector2i(1, 6), "piece" : "knight", "attribute" : "ground", "square" : "neutral", "movement_units" : 3}, 
	{"coordinates" : Vector2i(1, 7), "piece" : "knight", "attribute" : "ground", "square" : "dark", "movement_units" : 3}, 
	{"coordinates" : Vector2i(1, 8), "piece" : "archer", "attribute" : "ground", "square" : "light", "movement_units" : 3}, 
	{"coordinates" : Vector2i(2, 0), "piece" : null, "attribute" : null, "square" : "dark", "movement_units" : null}, 
	{"coordinates" : Vector2i(2, 1), "piece" : null, "attribute" : null, "square" : "neutral", "movement_units" : null}, 
	{"coordinates" : Vector2i(2, 2), "piece" : null, "attribute" : null, "square" : "light", "movement_units" : null}, 
	{"coordinates" : Vector2i(2, 3), "piece" : null, "attribute" : null, "square" : "dark", "movement_units" : null}, 
	{"coordinates" : Vector2i(2, 4), "piece" : null, "attribute" : null, "square" : "neutral", "movement_units" : null}, 
	{"coordinates" : Vector2i(2, 5), "piece" : null, "attribute" : null, "square" : "dark", "movement_units" : null}, 
	{"coordinates" : Vector2i(2, 6), "piece" : null, "attribute" : null, "square" : "light", "movement_units" : null}, 
	{"coordinates" : Vector2i(2, 7), "piece" : null, "attribute" : null, "square" : "neutral", "movement_units" : null}, 
	{"coordinates" : Vector2i(2, 8), "piece" : null, "attribute" : null, "square" : "dark", "movement_units" : null}, 
	{"coordinates" : Vector2i(3, 0), "piece" : null, "attribute" : null, "square" : "neutral", "movement_units" : null}, 
	{"coordinates" : Vector2i(3, 1), "piece" : null, "attribute" : null, "square" : "light", "movement_units" : null}, 
	{"coordinates" : Vector2i(3, 2), "piece" : null, "attribute" : null, "square" : "dark", "movement_units" : null}, 
	{"coordinates" : Vector2i(3, 3), "piece" : null, "attribute" : null, "square" : "light", "movement_units" : null}, 
	{"coordinates" : Vector2i(3, 4), "piece" : null, "attribute" : null, "square" : "neutral", "movement_units" : null}, 
	{"coordinates" : Vector2i(3, 5), "piece" : null, "attribute" : null, "square" : "light", "movement_units" : null}, 
	{"coordinates" : Vector2i(3, 6), "piece" : null, "attribute" : null, "square" : "dark", "movement_units" : null}, 
	{"coordinates" : Vector2i(3, 7), "piece" : null, "attribute" : null, "square" : "light", "movement_units" : null}, 
	{"coordinates" : Vector2i(3, 8), "piece" : null, "attribute" : null, "square" : "neutral", "movement_units" : null}, 
	{"coordinates" : Vector2i(4, 0), "piece" : null, "attribute" : null, "square" : "neutral", "movement_units" : null}, 
	{"coordinates" : Vector2i(4, 1), "piece" : null, "attribute" : null, "square" : "neutral", "movement_units" : null}, 
	{"coordinates" : Vector2i(4, 2), "piece" : null, "attribute" : null, "square" : "neutral", "movement_units" : null}, 
	{"coordinates" : Vector2i(4, 3), "piece" : null, "attribute" : null, "square" : "neutral", "movement_units" : null}, 
	{"coordinates" : Vector2i(4, 4), "piece" : null, "attribute" : null, "square" : "neutral", "movement_units" : null}, 
	{"coordinates" : Vector2i(4, 5), "piece" : null, "attribute" : null, "square" : "neutral", "movement_units" : null}, 
	{"coordinates" : Vector2i(4, 6), "piece" : null, "attribute" : null, "square" : "neutral", "movement_units" : null}, 
	{"coordinates" : Vector2i(4, 7), "piece" : null, "attribute" : null, "square" : "neutral", "movement_units" : null}, 
	{"coordinates" : Vector2i(4, 8), "piece" : null, "attribute" : null, "square" : "neutral", "movement_units" : null}, 
	{"coordinates" : Vector2i(5, 0), "piece" : null, "attribute" : null, "square" : "neutral", "movement_units" : null}, 
	{"coordinates" : Vector2i(5, 1), "piece" : null, "attribute" : null, "square" : "dark", "movement_units" : null}, 
	{"coordinates" : Vector2i(5, 2), "piece" : null, "attribute" : null, "square" : "light", "movement_units" : null}, 
	{"coordinates" : Vector2i(5, 3), "piece" : null, "attribute" : null, "square" : "dark", "movement_units" : null}, 
	{"coordinates" : Vector2i(5, 4), "piece" : null, "attribute" : null, "square" : "neutral", "movement_units" : null}, 
	{"coordinates" : Vector2i(5, 5), "piece" : null, "attribute" : null, "square" : "dark", "movement_units" : null}, 
	{"coordinates" : Vector2i(5, 6), "piece" : null, "attribute" : null, "square" : "light", "movement_units" : null}, 
	{"coordinates" : Vector2i(5, 7), "piece" : null, "attribute" : null, "square" : "dark", "movement_units" : null}, 
	{"coordinates" : Vector2i(5, 8), "piece" : null, "attribute" : null, "square" : "neutral", "movement_units" : null}, 
	{"coordinates" : Vector2i(6, 0), "piece" : null, "attribute" : null, "square" : "light", "movement_units" : null}, 
	{"coordinates" : Vector2i(6, 1), "piece" : null, "attribute" : null, "square" : "neutral", "movement_units" : null}, 
	{"coordinates" : Vector2i(6, 2), "piece" : null, "attribute" : null, "square" : "dark", "movement_units" : null}, 
	{"coordinates" : Vector2i(6, 3), "piece" : null, "attribute" : null, "square" : "light", "movement_units" : null}, 
	{"coordinates" : Vector2i(6, 4), "piece" : null, "attribute" : null, "square" : "neutral", "movement_units" : null}, 
	{"coordinates" : Vector2i(6, 5), "piece" : null, "attribute" : null, "square" : "light", "movement_units" : null}, 
	{"coordinates" : Vector2i(6, 6), "piece" : null, "attribute" : null, "square" : "dark", "movement_units" : null}, 
	{"coordinates" : Vector2i(6, 7), "piece" : null, "attribute" : null, "square" : "neutral", "movement_units" : null}, 
	{"coordinates" : Vector2i(6, 8), "piece" : null, "attribute" : null, "square" : "light", "movement_units" : null},
	{"coordinates" : Vector2i(7, 0), "piece" : "manticore", "attribute" : "ground", "square" : "dark", "movement_units" : 3}, 
	{"coordinates" : Vector2i(7, 1), "piece" : "goblin", "attribute" : "ground", "square" : "light", "movement_units" : 3}, 
	{"coordinates" : Vector2i(7, 2), "piece" : "goblin", "attribute" : "ground", "square" : "neutral", "movement_units" : 3}, 
	{"coordinates" : Vector2i(7, 3), "piece" : "goblin", "attribute" : "ground", "square" : "dark", "movement_units" : 3}, 
	{"coordinates" : Vector2i(7, 4), "piece" : "goblin", "attribute" : "ground", "square" : "neutral", "movement_units" : 3}, 
	{"coordinates" : Vector2i(7, 5), "piece" : "goblin", "attribute" : "ground", "square" : "dark", "movement_units" : 3}, 
	{"coordinates" : Vector2i(7, 6), "piece" : "goblin", "attribute" : "ground", "square" : "neutral", "movement_units" : 3}, 
	{"coordinates" : Vector2i(7, 7), "piece" : "goblin", "attribute" : "ground", "square" : "light", "movement_units" : 3}, 
	{"coordinates" : Vector2i(7, 8), "piece" : "manticore", "attribute" : "ground", "square" : "dark", "movement_units" : 3},
	{"coordinates" : Vector2i(8, 0), "piece" : "banshee", "attribute" : "fly", "square" : "light", "movement_units" : 3}, 
	{"coordinates" : Vector2i(8, 1), "piece" : "troll", "attribute" : "ground", "square" : "dark", "movement_units" : 3}, 
	{"coordinates" : Vector2i(8, 2), "piece" : "basilisk", "attribute" : "ground", "square" : "light", "movement_units" : 3}, 
	{"coordinates" : Vector2i(8, 3), "piece" : "shapeshifter", "attribute" : "fly", "square" : "neutral", "movement_units" : 5}, 
	{"coordinates" : Vector2i(8, 4), "piece" : "sorceress", "attribute" : "teleport", "square" : "dark", "movement_units" : 3}, 
	{"coordinates" : Vector2i(8, 5), "piece" : "dragon", "attribute" : "fly", "square" : "neutral", "movement_units" : 4}, 
	{"coordinates" : Vector2i(8, 6), "piece" : "basilisk", "attribute" : "ground", "square" : "light", "movement_units" : 3},
	{"coordinates" : Vector2i(8, 7), "piece" : "troll", "attribute" : "ground", "square" : "dark", "movement_units" : 3}, 
	{"coordinates" : Vector2i(8, 8), "piece" : "banshee", "attribute" : "fly", "square" : "light", "movement_units" : 3}
	]
			
func _process(_delta):
	tile = tileMap.local_to_map(get_global_mouse_position())
	touchingGameTile = false
	#print("tile = %s" % (tile - Vector2i(OFFSET_VALUE, OFFSET_VALUE)))
	
	for x in (GRID_DIM + OFFSET_VALUE):
		for y in (GRID_DIM + OFFSET_VALUE):
			if x >= OFFSET_VALUE && x < (GRID_DIM + OFFSET_VALUE):
				if y >= OFFSET_VALUE && y < (GRID_DIM + OFFSET_VALUE):
					tileMap.erase_cell(0, Vector2(x, y))

	if tile.x >= OFFSET_VALUE && tile.x < (GRID_DIM + OFFSET_VALUE):
		if tile.y >= OFFSET_VALUE && tile.y < (GRID_DIM + OFFSET_VALUE):
			tileMap.set_cell(0, tile, 0, Vector2i(0, 0), 0)
			touchingGameTile = true
			#var coords = tile - Vector2i(OFFSET_VALUE, OFFSET_VALUE)
			#print(SQUARES[coords.y + (coords.x * GRID_DIM)])
			
	
func _input(event):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if touchingGameTile == true:
				for square in SQUARES:
					if square.get("coordinates") == tile - Vector2i(OFFSET_VALUE, OFFSET_VALUE):
						if (square.get("piece") == "archer"):
							var newPosCoords = topArcher.global_position
							topArcher.queue_free()
							var archerInstance = archer.instantiate()
							archerInstance.position = newPosCoords
							add_child(archerInstance)
							print(tileMap.local_to_map(archerInstance.position) - Vector2i(OFFSET_VALUE, OFFSET_VALUE))
							
				
		
func movePiece():
	tileMap.set_cell(0, Vector2i(1, 0) + Vector2i(OFFSET_VALUE, OFFSET_VALUE), 2, Vector2i(0, 0), 0)
	tileMap.set_cell(0, Vector2i(1, 8) + Vector2i(OFFSET_VALUE, OFFSET_VALUE), 2, Vector2i(0, 0), 0)
