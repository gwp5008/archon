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
var firstSelection = null
@onready var tileMap = $Layer0
@onready var archerScene = preload("res://scenes/archer_movement.tscn")

@onready var archer1Node = $Archer1Node
@onready var archer2Node = $Archer2Node
@onready var valkyrie1Node = $Valkyrie1Node
@onready var valkyrie2Node = $Valkyrie2Node
@onready var golem1Node = $Golem1Node
@onready var golem2Node = $Golem2Node

@onready var squares = [
	{"coordinates" : Vector2i(0, 0), "piece" : "valkyrie", "node2d" : valkyrie1Node, "sprite2d" : valkyrie1Node.get_node("Valkyrie1"), "number" : 1, "attribute" : "fly", "square_color" : "dark", "movement_units" : 3}, 
	{"coordinates" : Vector2i(0, 1), "piece" : "golem", "node2d" : golem1Node, "sprite2d" : golem1Node.get_node("Golem1"), "number" : 1, "attribute" : "ground", "square_color" : "light", "movement_units" : 3}, 
	{"coordinates" : Vector2i(0, 2), "piece" : "unicorn", "node2d" : null, "sprite2d" : null, "number" : 1, "attribute" : "ground", "square_color" : "dark", "movement_units" : 4}, 
	{"coordinates" : Vector2i(0, 3), "piece" : "djinn", "node2d" : null, "sprite2d" : null, "number" : 1, "attribute" : "fly", "square_color" : "neutral", "movement_units" : 4}, 
	{"coordinates" : Vector2i(0, 4), "piece" : "wizard", "node2d" : null, "sprite2d" : null, "number" : 1, "attribute" : "teleport", "square_color" : "light", "movement_units" : 3}, 
	{"coordinates" : Vector2i(0, 5), "piece" : "phoenix", "node2d" : null, "sprite2d" : null, "number" : 1, "attribute" : "fly", "square_color" : "neutral", "movement_units" : 5}, 
	{"coordinates" : Vector2i(0, 6), "piece" : "unicorn", "node2d" : null, "sprite2d" : null, "number" : 2, "attribute" : "ground", "square_color" : "dark", "movement_units" : 4}, 
	{"coordinates" : Vector2i(0, 7), "piece" : "golem", "node2d" : golem2Node, "sprite2d" : golem2Node.get_node("Golem2"), "number" : 2, "attribute" : "ground", "square_color" : "light", "movement_units" : 3}, 
	{"coordinates" : Vector2i(0, 8), "piece" : "valkyrie", "node2d" : valkyrie2Node, "sprite2d" : valkyrie2Node.get_node("Valkyrie2"), "number" : 2, "attribute" : "fly", "square_color" : "dark", "movement_units" : 3}, 
	{"coordinates" : Vector2i(1, 0), "piece" : "archer", "node2d" : archer1Node, "sprite2d" : archer1Node.get_node("Archer1"), "number" : 1, "attribute" : "ground", "square_color" : "light", "movement_units" : 3}, 
	{"coordinates" : Vector2i(1, 1), "piece" : "knight", "node2d" : null, "sprite2d" : null, "number" : 1, "attribute" : "ground", "square_color" : "dark", "movement_units" : 3}, 
	{"coordinates" : Vector2i(1, 2), "piece" : "knight", "node2d" : null, "sprite2d" : null, "number" : 2, "attribute" : "ground", "square_color" : "neutral", "movement_units" : 3}, 
	{"coordinates" : Vector2i(1, 3), "piece" : "knight", "node2d" : null, "sprite2d" : null, "number" : 3, "attribute" : "ground", "square_color" : "light", "movement_units" : 3}, 
	{"coordinates" : Vector2i(1, 4), "piece" : "knight", "node2d" : null, "sprite2d" : null, "number" : 4, "attribute" : "ground", "square_color" : "neutral", "movement_units" : 3}, 
	{"coordinates" : Vector2i(1, 5), "piece" : "knight", "node2d" : null, "sprite2d" : null, "number" : 5, "attribute" : "ground", "square_color" : "light", "movement_units" : 3}, 
	{"coordinates" : Vector2i(1, 6), "piece" : "knight", "node2d" : null, "sprite2d" : null, "number" : 6, "attribute" : "ground", "square_color" : "neutral", "movement_units" : 3}, 
	{"coordinates" : Vector2i(1, 7), "piece" : "knight", "node2d" : null, "sprite2d" : null, "number" : 7, "attribute" : "ground", "square_color" : "dark", "movement_units" : 3}, 
	{"coordinates" : Vector2i(1, 8), "piece" : "archer", "node2d" : archer2Node, "sprite2d" : archer2Node.get_node("Archer2"), "number" : 2, "attribute" : "ground", "square_color" : "light", "movement_units" : 3}, 
	{"coordinates" : Vector2i(2, 0), "piece" : null, "node2d" : null, "sprite2d" : null, "number" : null, "attribute" : null, "square_color" : "dark", "movement_units" : null}, 
	{"coordinates" : Vector2i(2, 1), "piece" : null, "node2d" : null, "sprite2d" : null, "number" : null, "attribute" : null, "square_color" : "neutral", "movement_units" : null}, 
	{"coordinates" : Vector2i(2, 2), "piece" : null, "node2d" : null, "sprite2d" : null, "number" : null, "attribute" : null, "square_color" : "light", "movement_units" : null}, 
	{"coordinates" : Vector2i(2, 3), "piece" : null, "node2d" : null, "sprite2d" : null, "number" : null, "attribute" : null, "square_color" : "dark", "movement_units" : null}, 
	{"coordinates" : Vector2i(2, 4), "piece" : null, "node2d" : null, "sprite2d" : null, "number" : null, "attribute" : null, "square_color" : "neutral", "movement_units" : null}, 
	{"coordinates" : Vector2i(2, 5), "piece" : null, "node2d" : null, "sprite2d" : null, "number" : null, "attribute" : null, "square_color" : "dark", "movement_units" : null}, 
	{"coordinates" : Vector2i(2, 6), "piece" : null, "node2d" : null, "sprite2d" : null, "number" : null, "attribute" : null, "square_color" : "light", "movement_units" : null}, 
	{"coordinates" : Vector2i(2, 7), "piece" : null, "node2d" : null, "sprite2d" : null, "number" : null, "attribute" : null, "square_color" : "neutral", "movement_units" : null}, 
	{"coordinates" : Vector2i(2, 8), "piece" : null, "node2d" : null, "sprite2d" : null, "number" : null, "attribute" : null, "square_color" : "dark", "movement_units" : null}, 
	{"coordinates" : Vector2i(3, 0), "piece" : null, "node2d" : null, "sprite2d" : null, "number" : null, "attribute" : null, "square_color" : "neutral", "movement_units" : null}, 
	{"coordinates" : Vector2i(3, 1), "piece" : null, "node2d" : null, "sprite2d" : null, "number" : null, "attribute" : null, "square_color" : "light", "movement_units" : null}, 
	{"coordinates" : Vector2i(3, 2), "piece" : null, "node2d" : null, "sprite2d" : null, "number" : null, "attribute" : null, "square_color" : "dark", "movement_units" : null}, 
	{"coordinates" : Vector2i(3, 3), "piece" : null, "node2d" : null, "sprite2d" : null, "number" : null, "attribute" : null, "square_color" : "light", "movement_units" : null}, 
	{"coordinates" : Vector2i(3, 4), "piece" : null, "node2d" : null, "sprite2d" : null, "number" : null, "attribute" : null, "square_color" : "neutral", "movement_units" : null}, 
	{"coordinates" : Vector2i(3, 5), "piece" : null, "node2d" : null, "sprite2d" : null, "number" : null, "attribute" : null, "square_color" : "light", "movement_units" : null}, 
	{"coordinates" : Vector2i(3, 6), "piece" : null, "node2d" : null, "sprite2d" : null, "number" : null, "attribute" : null, "square_color" : "dark", "movement_units" : null}, 
	{"coordinates" : Vector2i(3, 7), "piece" : null, "node2d" : null, "sprite2d" : null, "number" : null, "attribute" : null, "square_color" : "light", "movement_units" : null}, 
	{"coordinates" : Vector2i(3, 8), "piece" : null, "node2d" : null, "sprite2d" : null, "number" : null, "attribute" : null, "square_color" : "neutral", "movement_units" : null}, 
	{"coordinates" : Vector2i(4, 0), "piece" : null, "node2d" : null, "sprite2d" : null, "number" : null, "attribute" : null, "square_color" : "neutral", "movement_units" : null}, 
	{"coordinates" : Vector2i(4, 1), "piece" : null, "node2d" : null, "sprite2d" : null, "number" : null, "attribute" : null, "square_color" : "neutral", "movement_units" : null}, 
	{"coordinates" : Vector2i(4, 2), "piece" : null, "node2d" : null, "sprite2d" : null, "number" : null, "attribute" : null, "square_color" : "neutral", "movement_units" : null}, 
	{"coordinates" : Vector2i(4, 3), "piece" : null, "node2d" : null, "sprite2d" : null, "number" : null, "attribute" : null, "square_color" : "neutral", "movement_units" : null}, 
	{"coordinates" : Vector2i(4, 4), "piece" : null, "node2d" : null, "sprite2d" : null, "number" : null, "attribute" : null, "square_color" : "neutral", "movement_units" : null}, 
	{"coordinates" : Vector2i(4, 5), "piece" : null, "node2d" : null, "sprite2d" : null, "number" : null, "attribute" : null, "square_color" : "neutral", "movement_units" : null}, 
	{"coordinates" : Vector2i(4, 6), "piece" : null, "node2d" : null, "sprite2d" : null, "number" : null, "attribute" : null, "square_color" : "neutral", "movement_units" : null}, 
	{"coordinates" : Vector2i(4, 7), "piece" : null, "node2d" : null, "sprite2d" : null, "number" : null, "attribute" : null, "square_color" : "neutral", "movement_units" : null}, 
	{"coordinates" : Vector2i(4, 8), "piece" : null, "node2d" : null, "sprite2d" : null, "number" : null, "attribute" : null, "square_color" : "neutral", "movement_units" : null}, 
	{"coordinates" : Vector2i(5, 0), "piece" : null, "node2d" : null, "sprite2d" : null, "number" : null, "attribute" : null, "square_color" : "neutral", "movement_units" : null}, 
	{"coordinates" : Vector2i(5, 1), "piece" : null, "node2d" : null, "sprite2d" : null, "number" : null, "attribute" : null, "square_color" : "dark", "movement_units" : null}, 
	{"coordinates" : Vector2i(5, 2), "piece" : null, "node2d" : null, "sprite2d" : null, "number" : null, "attribute" : null, "square_color" : "light", "movement_units" : null}, 
	{"coordinates" : Vector2i(5, 3), "piece" : null, "node2d" : null, "sprite2d" : null, "number" : null, "attribute" : null, "square_color" : "dark", "movement_units" : null}, 
	{"coordinates" : Vector2i(5, 4), "piece" : null, "node2d" : null, "sprite2d" : null, "number" : null, "attribute" : null, "square_color" : "neutral", "movement_units" : null}, 
	{"coordinates" : Vector2i(5, 5), "piece" : null, "node2d" : null, "sprite2d" : null, "number" : null, "attribute" : null, "square_color" : "dark", "movement_units" : null}, 
	{"coordinates" : Vector2i(5, 6), "piece" : null, "node2d" : null, "sprite2d" : null, "number" : null, "attribute" : null, "square_color" : "light", "movement_units" : null}, 
	{"coordinates" : Vector2i(5, 7), "piece" : null, "node2d" : null, "sprite2d" : null, "number" : null, "attribute" : null, "square_color" : "dark", "movement_units" : null}, 
	{"coordinates" : Vector2i(5, 8), "piece" : null, "node2d" : null, "sprite2d" : null, "number" : null, "attribute" : null, "square_color" : "neutral", "movement_units" : null}, 
	{"coordinates" : Vector2i(6, 0), "piece" : null, "node2d" : null, "sprite2d" : null, "number" : null, "attribute" : null, "square_color" : "light", "movement_units" : null}, 
	{"coordinates" : Vector2i(6, 1), "piece" : null, "node2d" : null, "sprite2d" : null, "number" : null, "attribute" : null, "square_color" : "neutral", "movement_units" : null}, 
	{"coordinates" : Vector2i(6, 2), "piece" : null, "node2d" : null, "sprite2d" : null, "number" : null, "attribute" : null, "square_color" : "dark", "movement_units" : null}, 
	{"coordinates" : Vector2i(6, 3), "piece" : null, "node2d" : null, "sprite2d" : null, "number" : null, "attribute" : null, "square_color" : "light", "movement_units" : null}, 
	{"coordinates" : Vector2i(6, 4), "piece" : null, "node2d" : null, "sprite2d" : null, "number" : null, "attribute" : null, "square_color" : "neutral", "movement_units" : null}, 
	{"coordinates" : Vector2i(6, 5), "piece" : null, "node2d" : null, "sprite2d" : null, "number" : null, "attribute" : null, "square_color" : "light", "movement_units" : null}, 
	{"coordinates" : Vector2i(6, 6), "piece" : null, "node2d" : null, "sprite2d" : null, "number" : null, "attribute" : null, "square_color" : "dark", "movement_units" : null}, 
	{"coordinates" : Vector2i(6, 7), "piece" : null, "node2d" : null, "sprite2d" : null, "number" : null, "attribute" : null, "square_color" : "neutral", "movement_units" : null}, 
	{"coordinates" : Vector2i(6, 8), "piece" : null, "node2d" : null, "sprite2d" : null, "number" : null, "attribute" : null, "square_color" : "light", "movement_units" : null},
	{"coordinates" : Vector2i(7, 0), "piece" : "manticore", "node2d" : null, "sprite2d" : null, "number" : 1, "attribute" : "ground", "square_color" : "dark", "movement_units" : 3}, 
	{"coordinates" : Vector2i(7, 1), "piece" : "goblin", "node2d" : null, "sprite2d" : null, "number" : 1, "attribute" : "ground", "square_color" : "light", "movement_units" : 3}, 
	{"coordinates" : Vector2i(7, 2), "piece" : "goblin", "node2d" : null, "sprite2d" : null, "number" : 1, "attribute" : "ground", "square_color" : "neutral", "movement_units" : 3}, 
	{"coordinates" : Vector2i(7, 3), "piece" : "goblin", "node2d" : null, "sprite2d" : null, "number" : 1, "attribute" : "ground", "square_color" : "dark", "movement_units" : 3}, 
	{"coordinates" : Vector2i(7, 4), "piece" : "goblin", "node2d" : null, "sprite2d" : null, "number" : 1, "attribute" : "ground", "square_color" : "neutral", "movement_units" : 3}, 
	{"coordinates" : Vector2i(7, 5), "piece" : "goblin", "node2d" : null, "sprite2d" : null, "number" : 1, "attribute" : "ground", "square_color" : "dark", "movement_units" : 3}, 
	{"coordinates" : Vector2i(7, 6), "piece" : "goblin", "node2d" : null, "sprite2d" : null, "number" : 1, "attribute" : "ground", "square_color" : "neutral", "movement_units" : 3}, 
	{"coordinates" : Vector2i(7, 7), "piece" : "goblin", "node2d" : null, "sprite2d" : null, "number" : 1, "attribute" : "ground", "square_color" : "light", "movement_units" : 3}, 
	{"coordinates" : Vector2i(7, 8), "piece" : "manticore", "node2d" : null, "sprite2d" : null, "number" : 2, "attribute" : "ground", "square_color" : "dark", "movement_units" : 3},
	{"coordinates" : Vector2i(8, 0), "piece" : "banshee", "node2d" : null, "sprite2d" : null, "number" : 1, "attribute" : "fly", "square_color" : "light", "movement_units" : 3}, 
	{"coordinates" : Vector2i(8, 1), "piece" : "troll", "node2d" : null, "sprite2d" : null, "number" : 1, "attribute" : "ground", "square_color" : "dark", "movement_units" : 3}, 
	{"coordinates" : Vector2i(8, 2), "piece" : "basilisk", "node2d" : null, "sprite2d" : null, "number" : 1, "attribute" : "ground", "square_color" : "light", "movement_units" : 3}, 
	{"coordinates" : Vector2i(8, 3), "piece" : "shapeshifter", "node2d" : null, "sprite2d" : null, "number" : 1, "attribute" : "fly", "square_color" : "neutral", "movement_units" : 5}, 
	{"coordinates" : Vector2i(8, 4), "piece" : "sorceress", "node2d" : null, "sprite2d" : null, "number" : 1, "attribute" : "teleport", "square_color" : "dark", "movement_units" : 3}, 
	{"coordinates" : Vector2i(8, 5), "piece" : "dragon", "node2d" : null, "sprite2d" : null, "number" : 1, "attribute" : "fly", "square_color" : "neutral", "movement_units" : 4}, 
	{"coordinates" : Vector2i(8, 6), "piece" : "basilisk", "node2d" : null, "sprite2d" : null, "number" : 2, "attribute" : "ground", "square_color" : "light", "movement_units" : 3},
	{"coordinates" : Vector2i(8, 7), "piece" : "troll", "node2d" : null, "sprite2d" : null, "number" : 2, "attribute" : "ground", "square_color" : "dark", "movement_units" : 3}, 
	{"coordinates" : Vector2i(8, 8), "piece" : "banshee", "node2d" : null, "sprite2d" : null, "number" : 2, "attribute" : "fly", "square_color" : "light", "movement_units" : 3}
	]
			
func _process(_delta):
	tile = tileMap.local_to_map(get_global_mouse_position())
	#print("tile = %s" % (tile - Vector2i(OFFSET_VALUE, OFFSET_VALUE)))
	touchingGameTile = false
	
	for x in (GRID_DIM + OFFSET_VALUE):
		for y in (GRID_DIM + OFFSET_VALUE):
			if x >= OFFSET_VALUE && x < (GRID_DIM + OFFSET_VALUE):
				if y >= OFFSET_VALUE && y < (GRID_DIM + OFFSET_VALUE):
					tileMap.erase_cell(Vector2i(x, y) - Vector2i(OFFSET_VALUE, OFFSET_VALUE))

	if tile.x >= OFFSET_VALUE && tile.x < (GRID_DIM + OFFSET_VALUE):
		if tile.y >= OFFSET_VALUE && tile.y < (GRID_DIM + OFFSET_VALUE):
			touchingGameTile = true

			if pieceSelectionCount == 1:
				if ((tile - Vector2i(OFFSET_VALUE, OFFSET_VALUE)) in movableSquares.keys() || 
				((tile - Vector2i(OFFSET_VALUE, OFFSET_VALUE)) == currentPiece.get("coordinates"))):
					tileMap.set_cell((tile - Vector2i(OFFSET_VALUE, OFFSET_VALUE)), 1, Vector2i(0, 0), 0)
				else:
					tileMap.set_cell((tile - Vector2i(OFFSET_VALUE, OFFSET_VALUE)), 2, Vector2i(0, 0), 0)
			else: 
				tileMap.set_cell((tile - Vector2i(OFFSET_VALUE, OFFSET_VALUE)), 0, Vector2i(0, 0), 0)
				
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
								firstSelection = tile

				elif pieceSelectionCount == 1:
					if (tile != firstSelection):
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
			var movementSquares = currentPiece.get("node2d").move(tileMap, tile, OFFSET_VALUE, currentPiece, SQUARE_SIZE)
			
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
	
	squares[newSquareIndex]["node2d"] = squares[oldSquareIndex]["node2d"]
	squares[oldSquareIndex]["node2d"] = null
	squares[newSquareIndex]["number"] = squares[oldSquareIndex]["number"]
	squares[oldSquareIndex]["number"] = null
	squares[newSquareIndex]["attribute"] = squares[oldSquareIndex]["attribute"]
	squares[oldSquareIndex]["attribute"] = null
	squares[newSquareIndex]["sprite2d"] = squares[oldSquareIndex]["sprite2d"]
	squares[oldSquareIndex]["sprite2d"] = null
	squares[newSquareIndex]["piece"] = squares[oldSquareIndex]["piece"]
	squares[oldSquareIndex]["piece"] = null
	squares[newSquareIndex]["movement_units"] = squares[oldSquareIndex]["movement_units"]
	squares[oldSquareIndex]["movement_units"] = null

	pieceSelectionCount = 0
	movableSquares = {}
	
	#print("oldSquare = %s" % (oldSquare))
	#print("newSquare = %s" % (newSquare))
		
func calculateMovableSquares(inSquare):
	var frontier = []
	var cameFrom = {}
	var startLocation = Vector2i(0, 0)
	var squareToConsider = null
	
	frontier.push_front(startLocation)
	cameFrom[startLocation] = null

	while !frontier.is_empty():
		var current = frontier.pop_front()
		
		for next in getNeighbors(current):
			if (inSquare.get("attribute") == "ground"):
				if absi(current.x) + absi(current.y) <= inSquare.get("movement_units"):
					squareToConsider = current + inSquare.get("coordinates")
					if !cameFrom.has(next):
						frontier.push_back(next)
						cameFrom[next] = current
					
					setMovableSquares(squareToConsider)
			
			elif (inSquare.get("attribute") == "fly" || inSquare.get("attribute") == "teleport"):
				if absi(current.x) + absi(current.y) <= inSquare.get("movement_units") * 2:
					if absi(current.x) <= inSquare.get("movement_units"):
						if absi(current.y) <= inSquare.get("movement_units"):
							squareToConsider = current + inSquare.get("coordinates")
							if !cameFrom.has(next):
								frontier.push_back(next)
								cameFrom[next] = current
						
							setMovableSquares(squareToConsider)
						
		for square in squares:
			for movableSquare in movableSquares.keys():
				if square.get("coordinates") == movableSquare:
					if square.get("piece") != null:
						movableSquares.erase(movableSquare)
						
		if (inSquare.get("attribute") == "ground"):
			checkIfSquareIsBlocked(inSquare)

	#print(movableSquares)
	
func checkIfSquareIsBlocked(inSquare):
	var link = inSquare.get("coordinates")
	
	for squareToConsider in movableSquares:
		if (squareToConsider != link):
			if Vector2i(link.x + 1, link.y) in movableSquares:
				link = Vector2i(link.x + 1, link.y)
			elif Vector2i(link.x - 1, link.y) in movableSquares:
				link = Vector2i(link.x + 1, link.y)
			elif Vector2i(link.x, link.y + 1) in movableSquares:
				link = Vector2i(link.x, link.y + 1)
			elif Vector2i(link.x, link.y - 1) in movableSquares:
				link = Vector2i(link.x, link.y - 1)
			else:
				movableSquares.erase(squareToConsider)
					
func setMovableSquares(squareToConsider):
	if squareToConsider.x < GRID_DIM && squareToConsider.x >= 0:
		if squareToConsider.y < GRID_DIM && squareToConsider.y >= 0:
			movableSquares[squareToConsider] = null	
				
func getNeighbors(node):
	var neighbors = []
	
	neighbors.append(node + Vector2i(-1, 0))
	neighbors.append(node + Vector2i(0, -1))
	neighbors.append(node + Vector2i(1, 0))
	neighbors.append(node + Vector2i(0, 1))
	
	return neighbors
