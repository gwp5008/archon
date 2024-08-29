extends Node2D

var GRID_DIM = 9
var OFFSET_VALUE = 3
var colorTurn = "light"
var touchingGameTile = false
var tile = Vector2i(0, 0)
@onready var tileMap = $TileMap
@onready var archerScene = preload("res://scenes/archer_movement.tscn")

var SQUARES = [
	{"coordinates" : Vector2i(0, 0), "piece" : "valkyrie", "number" : 1, "attribute" : "fly", "square" : "dark", "movement_units" : 3}, 
	{"coordinates" : Vector2i(0, 1), "piece" : "golem", "number" : 1, "attribute" : "ground", "square" : "light", "movement_units" : 3}, 
	{"coordinates" : Vector2i(0, 2), "piece" : "unicorn", "number" : 1, "attribute" : "ground", "square" : "dark", "movement_units" : 4}, 
	{"coordinates" : Vector2i(0, 3), "piece" : "djinn", "number" : 1, "attribute" : "fly", "square" : "neutral", "movement_units" : 4}, 
	{"coordinates" : Vector2i(0, 4), "piece" : "wizard", "number" : 1, "attribute" : "teleport", "square" : "light", "movement_units" : 3}, 
	{"coordinates" : Vector2i(0, 5), "piece" : "phoenix", "number" : 1, "attribute" : "fly", "square" : "neutral", "movement_units" : 5}, 
	{"coordinates" : Vector2i(0, 6), "piece" : "unicorn", "number" : 2, "attribute" : "ground", "square" : "dark", "movement_units" : 4}, 
	{"coordinates" : Vector2i(0, 7), "piece" : "golem", "number" : 2, "attribute" : "ground", "square" : "light", "movement_units" : 3}, 
	{"coordinates" : Vector2i(0, 8), "piece" : "valkyrie", "number" : 2, "attribute" : "fly", "square" : "dark", "movement_units" : 3}, 
	{"coordinates" : Vector2i(1, 0), "piece" : "archer", "number" : 1, "attribute" : "ground", "square" : "light", "movement_units" : 3}, 
	{"coordinates" : Vector2i(1, 1), "piece" : "knight", "number" : 1, "attribute" : "ground", "square" : "dark", "movement_units" : 3}, 
	{"coordinates" : Vector2i(1, 2), "piece" : "knight", "number" : 2, "attribute" : "ground", "square" : "neutral", "movement_units" : 3}, 
	{"coordinates" : Vector2i(1, 3), "piece" : "knight", "number" : 3, "attribute" : "ground", "square" : "light", "movement_units" : 3}, 
	{"coordinates" : Vector2i(1, 4), "piece" : "knight", "number" : 4, "attribute" : "ground", "square" : "neutral", "movement_units" : 3}, 
	{"coordinates" : Vector2i(1, 5), "piece" : "knight", "number" : 5, "attribute" : "ground", "square" : "light", "movement_units" : 3}, 
	{"coordinates" : Vector2i(1, 6), "piece" : "knight", "number" : 6, "attribute" : "ground", "square" : "neutral", "movement_units" : 3}, 
	{"coordinates" : Vector2i(1, 7), "piece" : "knight", "number" : 7, "attribute" : "ground", "square" : "dark", "movement_units" : 3}, 
	{"coordinates" : Vector2i(1, 8), "piece" : "archer", "number" : 2, "attribute" : "ground", "square" : "light", "movement_units" : 3}, 
	{"coordinates" : Vector2i(2, 0), "piece" : null, "number" : null, "attribute" : null, "square" : "dark", "movement_units" : null}, 
	{"coordinates" : Vector2i(2, 1), "piece" : null, "number" : null, "attribute" : null, "square" : "neutral", "movement_units" : null}, 
	{"coordinates" : Vector2i(2, 2), "piece" : null, "number" : null, "attribute" : null, "square" : "light", "movement_units" : null}, 
	{"coordinates" : Vector2i(2, 3), "piece" : null, "number" : null, "attribute" : null, "square" : "dark", "movement_units" : null}, 
	{"coordinates" : Vector2i(2, 4), "piece" : null, "number" : null, "attribute" : null, "square" : "neutral", "movement_units" : null}, 
	{"coordinates" : Vector2i(2, 5), "piece" : null, "number" : null, "attribute" : null, "square" : "dark", "movement_units" : null}, 
	{"coordinates" : Vector2i(2, 6), "piece" : null, "number" : null, "attribute" : null, "square" : "light", "movement_units" : null}, 
	{"coordinates" : Vector2i(2, 7), "piece" : null, "number" : null, "attribute" : null, "square" : "neutral", "movement_units" : null}, 
	{"coordinates" : Vector2i(2, 8), "piece" : null, "number" : null, "attribute" : null, "square" : "dark", "movement_units" : null}, 
	{"coordinates" : Vector2i(3, 0), "piece" : null, "number" : null, "attribute" : null, "square" : "neutral", "movement_units" : null}, 
	{"coordinates" : Vector2i(3, 1), "piece" : null, "number" : null, "attribute" : null, "square" : "light", "movement_units" : null}, 
	{"coordinates" : Vector2i(3, 2), "piece" : null, "number" : null, "attribute" : null, "square" : "dark", "movement_units" : null}, 
	{"coordinates" : Vector2i(3, 3), "piece" : null, "number" : null, "attribute" : null, "square" : "light", "movement_units" : null}, 
	{"coordinates" : Vector2i(3, 4), "piece" : null, "number" : null, "attribute" : null, "square" : "neutral", "movement_units" : null}, 
	{"coordinates" : Vector2i(3, 5), "piece" : null, "number" : null, "attribute" : null, "square" : "light", "movement_units" : null}, 
	{"coordinates" : Vector2i(3, 6), "piece" : null, "number" : null, "attribute" : null, "square" : "dark", "movement_units" : null}, 
	{"coordinates" : Vector2i(3, 7), "piece" : null, "number" : null, "attribute" : null, "square" : "light", "movement_units" : null}, 
	{"coordinates" : Vector2i(3, 8), "piece" : null, "number" : null, "attribute" : null, "square" : "neutral", "movement_units" : null}, 
	{"coordinates" : Vector2i(4, 0), "piece" : null, "number" : null, "attribute" : null, "square" : "neutral", "movement_units" : null}, 
	{"coordinates" : Vector2i(4, 1), "piece" : null, "number" : null, "attribute" : null, "square" : "neutral", "movement_units" : null}, 
	{"coordinates" : Vector2i(4, 2), "piece" : null, "number" : null, "attribute" : null, "square" : "neutral", "movement_units" : null}, 
	{"coordinates" : Vector2i(4, 3), "piece" : null, "number" : null, "attribute" : null, "square" : "neutral", "movement_units" : null}, 
	{"coordinates" : Vector2i(4, 4), "piece" : null, "number" : null, "attribute" : null, "square" : "neutral", "movement_units" : null}, 
	{"coordinates" : Vector2i(4, 5), "piece" : null, "number" : null, "attribute" : null, "square" : "neutral", "movement_units" : null}, 
	{"coordinates" : Vector2i(4, 6), "piece" : null, "number" : null, "attribute" : null, "square" : "neutral", "movement_units" : null}, 
	{"coordinates" : Vector2i(4, 7), "piece" : null, "number" : null, "attribute" : null, "square" : "neutral", "movement_units" : null}, 
	{"coordinates" : Vector2i(4, 8), "piece" : null, "number" : null, "attribute" : null, "square" : "neutral", "movement_units" : null}, 
	{"coordinates" : Vector2i(5, 0), "piece" : null, "number" : null, "attribute" : null, "square" : "neutral", "movement_units" : null}, 
	{"coordinates" : Vector2i(5, 1), "piece" : null, "number" : null, "attribute" : null, "square" : "dark", "movement_units" : null}, 
	{"coordinates" : Vector2i(5, 2), "piece" : null, "number" : null, "attribute" : null, "square" : "light", "movement_units" : null}, 
	{"coordinates" : Vector2i(5, 3), "piece" : null, "number" : null, "attribute" : null, "square" : "dark", "movement_units" : null}, 
	{"coordinates" : Vector2i(5, 4), "piece" : null, "number" : null, "attribute" : null, "square" : "neutral", "movement_units" : null}, 
	{"coordinates" : Vector2i(5, 5), "piece" : null, "number" : null, "attribute" : null, "square" : "dark", "movement_units" : null}, 
	{"coordinates" : Vector2i(5, 6), "piece" : null, "number" : null, "attribute" : null, "square" : "light", "movement_units" : null}, 
	{"coordinates" : Vector2i(5, 7), "piece" : null, "number" : null, "attribute" : null, "square" : "dark", "movement_units" : null}, 
	{"coordinates" : Vector2i(5, 8), "piece" : null, "number" : null, "attribute" : null, "square" : "neutral", "movement_units" : null}, 
	{"coordinates" : Vector2i(6, 0), "piece" : null, "number" : null, "attribute" : null, "square" : "light", "movement_units" : null}, 
	{"coordinates" : Vector2i(6, 1), "piece" : null, "number" : null, "attribute" : null, "square" : "neutral", "movement_units" : null}, 
	{"coordinates" : Vector2i(6, 2), "piece" : null, "number" : null, "attribute" : null, "square" : "dark", "movement_units" : null}, 
	{"coordinates" : Vector2i(6, 3), "piece" : null, "number" : null, "attribute" : null, "square" : "light", "movement_units" : null}, 
	{"coordinates" : Vector2i(6, 4), "piece" : null, "number" : null, "attribute" : null, "square" : "neutral", "movement_units" : null}, 
	{"coordinates" : Vector2i(6, 5), "piece" : null, "number" : null, "attribute" : null, "square" : "light", "movement_units" : null}, 
	{"coordinates" : Vector2i(6, 6), "piece" : null, "number" : null, "attribute" : null, "square" : "dark", "movement_units" : null}, 
	{"coordinates" : Vector2i(6, 7), "piece" : null, "number" : null, "attribute" : null, "square" : "neutral", "movement_units" : null}, 
	{"coordinates" : Vector2i(6, 8), "piece" : null, "number" : null, "attribute" : null, "square" : "light", "movement_units" : null},
	{"coordinates" : Vector2i(7, 0), "piece" : "manticore", "number" : 1, "attribute" : "ground", "square" : "dark", "movement_units" : 3}, 
	{"coordinates" : Vector2i(7, 1), "piece" : "goblin", "number" : 1, "attribute" : "ground", "square" : "light", "movement_units" : 3}, 
	{"coordinates" : Vector2i(7, 2), "piece" : "goblin", "number" : 1, "attribute" : "ground", "square" : "neutral", "movement_units" : 3}, 
	{"coordinates" : Vector2i(7, 3), "piece" : "goblin", "number" : 1, "attribute" : "ground", "square" : "dark", "movement_units" : 3}, 
	{"coordinates" : Vector2i(7, 4), "piece" : "goblin", "number" : 1, "attribute" : "ground", "square" : "neutral", "movement_units" : 3}, 
	{"coordinates" : Vector2i(7, 5), "piece" : "goblin", "number" : 1, "attribute" : "ground", "square" : "dark", "movement_units" : 3}, 
	{"coordinates" : Vector2i(7, 6), "piece" : "goblin", "number" : 1, "attribute" : "ground", "square" : "neutral", "movement_units" : 3}, 
	{"coordinates" : Vector2i(7, 7), "piece" : "goblin", "number" : 1, "attribute" : "ground", "square" : "light", "movement_units" : 3}, 
	{"coordinates" : Vector2i(7, 8), "piece" : "manticore", "number" : 2, "attribute" : "ground", "square" : "dark", "movement_units" : 3},
	{"coordinates" : Vector2i(8, 0), "piece" : "banshee", "number" : 1, "attribute" : "fly", "square" : "light", "movement_units" : 3}, 
	{"coordinates" : Vector2i(8, 1), "piece" : "troll", "number" : 1, "attribute" : "ground", "square" : "dark", "movement_units" : 3}, 
	{"coordinates" : Vector2i(8, 2), "piece" : "basilisk", "number" : 1, "attribute" : "ground", "square" : "light", "movement_units" : 3}, 
	{"coordinates" : Vector2i(8, 3), "piece" : "shapeshifter", "number" : 1, "attribute" : "fly", "square" : "neutral", "movement_units" : 5}, 
	{"coordinates" : Vector2i(8, 4), "piece" : "sorceress", "number" : 1, "attribute" : "teleport", "square" : "dark", "movement_units" : 3}, 
	{"coordinates" : Vector2i(8, 5), "piece" : "dragon", "number" : 1, "attribute" : "fly", "square" : "neutral", "movement_units" : 4}, 
	{"coordinates" : Vector2i(8, 6), "piece" : "basilisk", "number" : 2, "attribute" : "ground", "square" : "light", "movement_units" : 3},
	{"coordinates" : Vector2i(8, 7), "piece" : "troll", "number" : 2, "attribute" : "ground", "square" : "dark", "movement_units" : 3}, 
	{"coordinates" : Vector2i(8, 8), "piece" : "banshee", "number" : 2, "attribute" : "fly", "square" : "light", "movement_units" : 3}
	]
	
var frontier = []
var came_from = {}
var movableSquares = {}
@onready var start_location = tileMap.local_to_map(SQUARES[0].get("coordinates"))	#Position in tilemap (Vector2)
@onready var end_location = tileMap.local_to_map(SQUARES[SQUARES.size() - 1].get("coordinates"))	#Position in tilemap (Vector2)
			
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
			
func _input(event):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if touchingGameTile == true:
				for square in SQUARES:
					if square.get("coordinates") == tile - Vector2i(OFFSET_VALUE, OFFSET_VALUE):
						movePiece(square)
							
func movePiece(square):
	var neededData = swapPieceInstances(square)
	var newPosCoords = neededData.get("global_position")
	var pieceInstance = neededData.get("scene").instantiate()
	pieceInstance.position = newPosCoords
	add_child(pieceInstance)
	calculateMovableSquares(square)
	print(movableSquares)
		
func swapPieceInstances(square):
	var archer = null
	if (square.get("piece") == "archer"):
		if (square.get("number") == 1):
			archer = $Archer1
		elif (square.get("number") == 2):
			archer = $Archer2
		
		archer.queue_free()
		var data = {"global_position" : archer.global_position, "scene" : archerScene}
		return data
		
func calculateMovableSquares(square):
	frontier.push_front(start_location)
	came_from[start_location] = null

	while !frontier.is_empty():
		var current = frontier.pop_front()
		for next in get_neighbors(current):
			if absi(current.x) + absi(current.y) <= square.get("movement_units"):
				var squareToConsider = current + square.get("coordinates")
				if !came_from.has(next):
					frontier.push_back(next)
					came_from[next] = current
				
				#More code needed here to make sure pieces are not already on the square
				if squareToConsider.x <= GRID_DIM && squareToConsider.x >= 0:
					if squareToConsider.y <= GRID_DIM && squareToConsider.y >= 0:
						movableSquares[squareToConsider] = null	
				
func get_neighbors(node):
	var neighbors = []
	neighbors.append(node + Vector2i(-1, 0))
	neighbors.append(node + Vector2i(0, -1))
	neighbors.append(node + Vector2i(1, 0))
	neighbors.append(node + Vector2i(0, 1))
	return neighbors
	
	
	
