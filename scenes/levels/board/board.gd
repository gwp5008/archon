extends Node2D

const GRID_DIM = 9
const OFFSET_VALUE = 3
const SQUARE_SIZE = 64

var colorTurn = "light"
var touchingGameTile = false
var tile = Vector2i(0, 0)
var movableSquares = {}
var pieceSelectionCount = 0
var currentPiece = null
@onready var tileMap = $Layer0
@onready var archerScene = preload("res://scenes/archer_movement.tscn")
@onready var archer1Node = $Archer1Node
@onready var archer2Node = $Archer2Node

@onready var squares = [
	{"coordinates" : Vector2i(0, 0), "piece" : "valkyrie", "sprite2d" : null, "number" : 1, "attribute" : "fly", "square_color" : "dark", "movement_units" : 3}, 
	{"coordinates" : Vector2i(0, 1), "piece" : "golem", "sprite2d" : null, "number" : 1, "attribute" : "ground", "square_color" : "light", "movement_units" : 3}, 
	{"coordinates" : Vector2i(0, 2), "piece" : "unicorn", "sprite2d" : null, "number" : 1, "attribute" : "ground", "square_color" : "dark", "movement_units" : 4}, 
	{"coordinates" : Vector2i(0, 3), "piece" : "djinn", "sprite2d" : null, "number" : 1, "attribute" : "fly", "square_color" : "neutral", "movement_units" : 4}, 
	{"coordinates" : Vector2i(0, 4), "piece" : "wizard", "sprite2d" : null, "number" : 1, "attribute" : "teleport", "square_color" : "light", "movement_units" : 3}, 
	{"coordinates" : Vector2i(0, 5), "piece" : "phoenix", "sprite2d" : null, "number" : 1, "attribute" : "fly", "square_color" : "neutral", "movement_units" : 5}, 
	{"coordinates" : Vector2i(0, 6), "piece" : "unicorn", "sprite2d" : null, "number" : 2, "attribute" : "ground", "square_color" : "dark", "movement_units" : 4}, 
	{"coordinates" : Vector2i(0, 7), "piece" : "golem", "sprite2d" : null, "number" : 2, "attribute" : "ground", "square_color" : "light", "movement_units" : 3}, 
	{"coordinates" : Vector2i(0, 8), "piece" : "valkyrie", "sprite2d" : null, "number" : 2, "attribute" : "fly", "square_color" : "dark", "movement_units" : 3}, 
	{"coordinates" : Vector2i(1, 0), "piece" : "archer", "sprite2d" : archer1Node, "number" : 1, "attribute" : "ground", "square_color" : "light", "movement_units" : 3}, 
	{"coordinates" : Vector2i(1, 1), "piece" : "knight", "sprite2d" : null, "number" : 1, "attribute" : "ground", "square_color" : "dark", "movement_units" : 3}, 
	{"coordinates" : Vector2i(1, 2), "piece" : "knight", "sprite2d" : null, "number" : 2, "attribute" : "ground", "square_color" : "neutral", "movement_units" : 3}, 
	{"coordinates" : Vector2i(1, 3), "piece" : "knight", "sprite2d" : null, "number" : 3, "attribute" : "ground", "square_color" : "light", "movement_units" : 3}, 
	{"coordinates" : Vector2i(1, 4), "piece" : "knight", "sprite2d" : null, "number" : 4, "attribute" : "ground", "square_color" : "neutral", "movement_units" : 3}, 
	{"coordinates" : Vector2i(1, 5), "piece" : "knight", "sprite2d" : null, "number" : 5, "attribute" : "ground", "square_color" : "light", "movement_units" : 3}, 
	{"coordinates" : Vector2i(1, 6), "piece" : "knight", "sprite2d" : null, "number" : 6, "attribute" : "ground", "square_color" : "neutral", "movement_units" : 3}, 
	{"coordinates" : Vector2i(1, 7), "piece" : "knight", "sprite2d" : null, "number" : 7, "attribute" : "ground", "square_color" : "dark", "movement_units" : 3}, 
	{"coordinates" : Vector2i(1, 8), "piece" : "archer", "sprite2d" : archer2Node, "number" : 2, "attribute" : "ground", "square_color" : "light", "movement_units" : 3}, 
	{"coordinates" : Vector2i(2, 0), "piece" : null, "sprite2d" : null, "number" : null, "attribute" : null, "square_color" : "dark", "movement_units" : null}, 
	{"coordinates" : Vector2i(2, 1), "piece" : null, "sprite2d" : null, "number" : null, "attribute" : null, "square_color" : "neutral", "movement_units" : null}, 
	{"coordinates" : Vector2i(2, 2), "piece" : null, "sprite2d" : null, "number" : null, "attribute" : null, "square_color" : "light", "movement_units" : null}, 
	{"coordinates" : Vector2i(2, 3), "piece" : null, "sprite2d" : null, "number" : null, "attribute" : null, "square_color" : "dark", "movement_units" : null}, 
	{"coordinates" : Vector2i(2, 4), "piece" : null, "sprite2d" : null, "number" : null, "attribute" : null, "square_color" : "neutral", "movement_units" : null}, 
	{"coordinates" : Vector2i(2, 5), "piece" : null, "sprite2d" : null, "number" : null, "attribute" : null, "square_color" : "dark", "movement_units" : null}, 
	{"coordinates" : Vector2i(2, 6), "piece" : null, "sprite2d" : null, "number" : null, "attribute" : null, "square_color" : "light", "movement_units" : null}, 
	{"coordinates" : Vector2i(2, 7), "piece" : null, "sprite2d" : null, "number" : null, "attribute" : null, "square_color" : "neutral", "movement_units" : null}, 
	{"coordinates" : Vector2i(2, 8), "piece" : null, "sprite2d" : null, "number" : null, "attribute" : null, "square_color" : "dark", "movement_units" : null}, 
	{"coordinates" : Vector2i(3, 0), "piece" : null, "sprite2d" : null, "number" : null, "attribute" : null, "square_color" : "neutral", "movement_units" : null}, 
	{"coordinates" : Vector2i(3, 1), "piece" : null, "sprite2d" : null, "number" : null, "attribute" : null, "square_color" : "light", "movement_units" : null}, 
	{"coordinates" : Vector2i(3, 2), "piece" : null, "sprite2d" : null, "number" : null, "attribute" : null, "square_color" : "dark", "movement_units" : null}, 
	{"coordinates" : Vector2i(3, 3), "piece" : null, "sprite2d" : null, "number" : null, "attribute" : null, "square_color" : "light", "movement_units" : null}, 
	{"coordinates" : Vector2i(3, 4), "piece" : null, "sprite2d" : null, "number" : null, "attribute" : null, "square_color" : "neutral", "movement_units" : null}, 
	{"coordinates" : Vector2i(3, 5), "piece" : null, "sprite2d" : null, "number" : null, "attribute" : null, "square_color" : "light", "movement_units" : null}, 
	{"coordinates" : Vector2i(3, 6), "piece" : null, "sprite2d" : null, "number" : null, "attribute" : null, "square_color" : "dark", "movement_units" : null}, 
	{"coordinates" : Vector2i(3, 7), "piece" : null, "sprite2d" : null, "number" : null, "attribute" : null, "square_color" : "light", "movement_units" : null}, 
	{"coordinates" : Vector2i(3, 8), "piece" : null, "sprite2d" : null, "number" : null, "attribute" : null, "square_color" : "neutral", "movement_units" : null}, 
	{"coordinates" : Vector2i(4, 0), "piece" : null, "sprite2d" : null, "number" : null, "attribute" : null, "square_color" : "neutral", "movement_units" : null}, 
	{"coordinates" : Vector2i(4, 1), "piece" : null, "sprite2d" : null, "number" : null, "attribute" : null, "square_color" : "neutral", "movement_units" : null}, 
	{"coordinates" : Vector2i(4, 2), "piece" : null, "sprite2d" : null, "number" : null, "attribute" : null, "square_color" : "neutral", "movement_units" : null}, 
	{"coordinates" : Vector2i(4, 3), "piece" : null, "sprite2d" : null, "number" : null, "attribute" : null, "square_color" : "neutral", "movement_units" : null}, 
	{"coordinates" : Vector2i(4, 4), "piece" : null, "sprite2d" : null, "number" : null, "attribute" : null, "square_color" : "neutral", "movement_units" : null}, 
	{"coordinates" : Vector2i(4, 5), "piece" : null, "sprite2d" : null, "number" : null, "attribute" : null, "square_color" : "neutral", "movement_units" : null}, 
	{"coordinates" : Vector2i(4, 6), "piece" : null, "sprite2d" : null, "number" : null, "attribute" : null, "square_color" : "neutral", "movement_units" : null}, 
	{"coordinates" : Vector2i(4, 7), "piece" : null, "sprite2d" : null, "number" : null, "attribute" : null, "square_color" : "neutral", "movement_units" : null}, 
	{"coordinates" : Vector2i(4, 8), "piece" : null, "sprite2d" : null, "number" : null, "attribute" : null, "square_color" : "neutral", "movement_units" : null}, 
	{"coordinates" : Vector2i(5, 0), "piece" : null, "sprite2d" : null, "number" : null, "attribute" : null, "square_color" : "neutral", "movement_units" : null}, 
	{"coordinates" : Vector2i(5, 1), "piece" : null, "sprite2d" : null, "number" : null, "attribute" : null, "square_color" : "dark", "movement_units" : null}, 
	{"coordinates" : Vector2i(5, 2), "piece" : null, "sprite2d" : null, "number" : null, "attribute" : null, "square_color" : "light", "movement_units" : null}, 
	{"coordinates" : Vector2i(5, 3), "piece" : null, "sprite2d" : null, "number" : null, "attribute" : null, "square_color" : "dark", "movement_units" : null}, 
	{"coordinates" : Vector2i(5, 4), "piece" : null, "sprite2d" : null, "number" : null, "attribute" : null, "square_color" : "neutral", "movement_units" : null}, 
	{"coordinates" : Vector2i(5, 5), "piece" : null, "sprite2d" : null, "number" : null, "attribute" : null, "square_color" : "dark", "movement_units" : null}, 
	{"coordinates" : Vector2i(5, 6), "piece" : null, "sprite2d" : null, "number" : null, "attribute" : null, "square_color" : "light", "movement_units" : null}, 
	{"coordinates" : Vector2i(5, 7), "piece" : null, "sprite2d" : null, "number" : null, "attribute" : null, "square_color" : "dark", "movement_units" : null}, 
	{"coordinates" : Vector2i(5, 8), "piece" : null, "sprite2d" : null, "number" : null, "attribute" : null, "square_color" : "neutral", "movement_units" : null}, 
	{"coordinates" : Vector2i(6, 0), "piece" : null, "sprite2d" : null, "number" : null, "attribute" : null, "square_color" : "light", "movement_units" : null}, 
	{"coordinates" : Vector2i(6, 1), "piece" : null, "sprite2d" : null, "number" : null, "attribute" : null, "square_color" : "neutral", "movement_units" : null}, 
	{"coordinates" : Vector2i(6, 2), "piece" : null, "sprite2d" : null, "number" : null, "attribute" : null, "square_color" : "dark", "movement_units" : null}, 
	{"coordinates" : Vector2i(6, 3), "piece" : null, "sprite2d" : null, "number" : null, "attribute" : null, "square_color" : "light", "movement_units" : null}, 
	{"coordinates" : Vector2i(6, 4), "piece" : null, "sprite2d" : null, "number" : null, "attribute" : null, "square_color" : "neutral", "movement_units" : null}, 
	{"coordinates" : Vector2i(6, 5), "piece" : null, "sprite2d" : null, "number" : null, "attribute" : null, "square_color" : "light", "movement_units" : null}, 
	{"coordinates" : Vector2i(6, 6), "piece" : null, "sprite2d" : null, "number" : null, "attribute" : null, "square_color" : "dark", "movement_units" : null}, 
	{"coordinates" : Vector2i(6, 7), "piece" : null, "sprite2d" : null, "number" : null, "attribute" : null, "square_color" : "neutral", "movement_units" : null}, 
	{"coordinates" : Vector2i(6, 8), "piece" : null, "sprite2d" : null, "number" : null, "attribute" : null, "square_color" : "light", "movement_units" : null},
	{"coordinates" : Vector2i(7, 0), "piece" : "manticore", "sprite2d" : null, "number" : 1, "attribute" : "ground", "square_color" : "dark", "movement_units" : 3}, 
	{"coordinates" : Vector2i(7, 1), "piece" : "goblin", "sprite2d" : null, "number" : 1, "attribute" : "ground", "square_color" : "light", "movement_units" : 3}, 
	{"coordinates" : Vector2i(7, 2), "piece" : "goblin", "sprite2d" : null, "number" : 1, "attribute" : "ground", "square_color" : "neutral", "movement_units" : 3}, 
	{"coordinates" : Vector2i(7, 3), "piece" : "goblin", "sprite2d" : null, "number" : 1, "attribute" : "ground", "square_color" : "dark", "movement_units" : 3}, 
	{"coordinates" : Vector2i(7, 4), "piece" : "goblin", "sprite2d" : null, "number" : 1, "attribute" : "ground", "square_color" : "neutral", "movement_units" : 3}, 
	{"coordinates" : Vector2i(7, 5), "piece" : "goblin", "sprite2d" : null, "number" : 1, "attribute" : "ground", "square_color" : "dark", "movement_units" : 3}, 
	{"coordinates" : Vector2i(7, 6), "piece" : "goblin", "sprite2d" : null, "number" : 1, "attribute" : "ground", "square_color" : "neutral", "movement_units" : 3}, 
	{"coordinates" : Vector2i(7, 7), "piece" : "goblin", "sprite2d" : null, "number" : 1, "attribute" : "ground", "square_color" : "light", "movement_units" : 3}, 
	{"coordinates" : Vector2i(7, 8), "piece" : "manticore", "sprite2d" : null, "number" : 2, "attribute" : "ground", "square_color" : "dark", "movement_units" : 3},
	{"coordinates" : Vector2i(8, 0), "piece" : "banshee", "sprite2d" : null, "number" : 1, "attribute" : "fly", "square_color" : "light", "movement_units" : 3}, 
	{"coordinates" : Vector2i(8, 1), "piece" : "troll", "sprite2d" : null, "number" : 1, "attribute" : "ground", "square_color" : "dark", "movement_units" : 3}, 
	{"coordinates" : Vector2i(8, 2), "piece" : "basilisk", "sprite2d" : null, "number" : 1, "attribute" : "ground", "square_color" : "light", "movement_units" : 3}, 
	{"coordinates" : Vector2i(8, 3), "piece" : "shapeshifter", "sprite2d" : null, "number" : 1, "attribute" : "fly", "square_color" : "neutral", "movement_units" : 5}, 
	{"coordinates" : Vector2i(8, 4), "piece" : "sorceress", "sprite2d" : null, "number" : 1, "attribute" : "teleport", "square_color" : "dark", "movement_units" : 3}, 
	{"coordinates" : Vector2i(8, 5), "piece" : "dragon", "sprite2d" : null, "number" : 1, "attribute" : "fly", "square_color" : "neutral", "movement_units" : 4}, 
	{"coordinates" : Vector2i(8, 6), "piece" : "basilisk", "sprite2d" : null, "number" : 2, "attribute" : "ground", "square_color" : "light", "movement_units" : 3},
	{"coordinates" : Vector2i(8, 7), "piece" : "troll", "sprite2d" : null, "number" : 2, "attribute" : "ground", "square_color" : "dark", "movement_units" : 3}, 
	{"coordinates" : Vector2i(8, 8), "piece" : "banshee", "sprite2d" : null, "number" : 2, "attribute" : "fly", "square_color" : "light", "movement_units" : 3}
	]
			
func _process(_delta):
	tile = tileMap.local_to_map(get_global_mouse_position())
	touchingGameTile = false
	#print("tile = %s" % (tile - Vector2i(OFFSET_VALUE, OFFSET_VALUE)))
	
	for x in (GRID_DIM + OFFSET_VALUE):
		for y in (GRID_DIM + OFFSET_VALUE):
			if x >= OFFSET_VALUE && x < (GRID_DIM + OFFSET_VALUE):
				if y >= OFFSET_VALUE && y < (GRID_DIM + OFFSET_VALUE):
					tileMap.erase_cell(Vector2i(x, y) - Vector2i(OFFSET_VALUE, OFFSET_VALUE))

	if tile.x >= OFFSET_VALUE && tile.x < (GRID_DIM + OFFSET_VALUE):
		if tile.y >= OFFSET_VALUE && tile.y < (GRID_DIM + OFFSET_VALUE):
			tileMap.set_cell((tile - Vector2i(OFFSET_VALUE, OFFSET_VALUE)), 0, Vector2i(0, 0), 0)
			touchingGameTile = true
				
func _input(event):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if touchingGameTile == true:
				if pieceSelectionCount == 0:
					for square in squares:
						if (square.get("piece") != null):
							if square.get("coordinates") == tile - Vector2i(OFFSET_VALUE, OFFSET_VALUE):
								calculateMovableSquares(square)
								currentPiece = square
								pieceSelectionCount += 1
				elif pieceSelectionCount == 1:
					if (currentPiece.get("piece") != null):
						movePiece()
					
func movePiece():
	var newSquareIndex = 0
	var oldSquareIndex = 0
	var newSquare = {}
	var oldSquare = {}
	var prevNewColor = ""
	var prevOldColor = ""
	var prevNewCoords = null
	var prevOldCoords = null
	
	if (touchingGameTile == true) && ((tile - Vector2i(OFFSET_VALUE, OFFSET_VALUE)) in movableSquares.keys()):
		if pieceSelectionCount == 1:
			#var tween = create_tween()
			#tween.tween_property(currentPiece.get("sprite2d"), "modulate:a", 0, 0)
			print(currentPiece.get("sprite2d"))
			var movementSquares = currentPiece.get("sprite2d").move(tileMap, tile, OFFSET_VALUE, currentPiece, SQUARE_SIZE)
			
			for square in squares:
				if (square.get("coordinates") == movementSquares.get("newPosition")):
					newSquare = square
					break
					
				newSquareIndex += 1

			for square in squares:
				if (square.get("coordinates") == movementSquares.get("oldPosition")):
					oldSquare = square
					break
					
				oldSquareIndex += 1
				
	prevNewCoords = squares[newSquareIndex].get("coordinates")
	prevOldCoords = squares[oldSquareIndex].get("coordinates")
	prevNewColor = squares[newSquareIndex].get("square_color")
	prevOldColor = squares[oldSquareIndex].get("square_color")

	squares[newSquareIndex]["square_color"] = prevOldColor
	squares[newSquareIndex] = oldSquare
	squares[newSquareIndex]["coordinates"] = prevNewCoords

	squares[oldSquareIndex]["square_color"] = prevNewColor
	squares[oldSquareIndex] = newSquare
	squares[oldSquareIndex]["coordinates"] = prevOldCoords
	
	pieceSelectionCount = 0
	movableSquares = {}
		
func calculateMovableSquares(inSquare):
	var frontier = []
	var came_from = {}
	var start_location = tileMap.local_to_map(squares[0].get("coordinates"))	#Position in tilemap (Vector2)
	
	frontier.push_front(start_location)
	came_from[start_location] = null

	while !frontier.is_empty():
		var current = frontier.pop_front()
		for next in get_neighbors(current):
			if absi(current.x) + absi(current.y) <= inSquare.get("movement_units"):
				var squareToConsider = current + inSquare.get("coordinates")
				if !came_from.has(next):
					frontier.push_back(next)
					came_from[next] = current
				
				if squareToConsider.x <= GRID_DIM && squareToConsider.x >= 0:
					if squareToConsider.y <= GRID_DIM && squareToConsider.y >= 0:
						movableSquares[squareToConsider] = null	
						
		for square in squares:
			for movableSquare in movableSquares.keys():
				if square.get("coordinates") == movableSquare && square.get("piece") != null:
					movableSquares.erase(movableSquare)
				
func get_neighbors(node):
	var neighbors = []
	
	neighbors.append(node + Vector2i(-1, 0))
	neighbors.append(node + Vector2i(0, -1))
	neighbors.append(node + Vector2i(1, 0))
	neighbors.append(node + Vector2i(0, 1))
	
	return neighbors
	
