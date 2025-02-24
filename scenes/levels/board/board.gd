extends Node2D

const GRID_DIM = 9
const OFFSET_VALUE = 3
const SQUARE_SIZE = 64

var colorTurn = "light"
var touchingGameTile = false
var hoveredTile = Vector2i(0, 0)
var movableSquares = {}
var connectingSquares = {}
var paths = []
var pieceSelectionCount = 0
var currentPiece = null
var firstSelection = null
var pieceBlocked = false
@onready var boardInfo = $BoardInfo
@onready var tileMapLayer = $Layer0

@onready var archer1Node = $Archer1Node
@onready var archer2Node = $Archer2Node
@onready var valkyrie1Node = $Valkyrie1Node
@onready var valkyrie2Node = $Valkyrie2Node
@onready var golem1Node = $Golem1Node
@onready var golem2Node = $Golem2Node
@onready var unicorn1Node = $Unicorn1Node
@onready var unicorn2Node = $Unicorn2Node
@onready var knight1Node = $Knight1Node
@onready var knight2Node = $Knight2Node
@onready var knight3Node = $Knight3Node
@onready var knight4Node = $Knight4Node
@onready var knight5Node = $Knight5Node
@onready var knight6Node = $Knight6Node
@onready var knight7Node = $Knight7Node
@onready var djinnNode = $DjinnNode
@onready var phoenixNode = $PhoenixNode
@onready var wizardNode = $WizardNode

@onready var manticore1Node = $Manticore1Node
@onready var manticore2Node = $Manticore2Node
@onready var banshee1Node = $Banshee1Node
@onready var banshee2Node = $Banshee2Node
@onready var troll1Node = $Troll1Node
@onready var troll2Node = $Troll2Node
@onready var basilisk1Node = $Basilisk1Node
@onready var basilisk2Node = $Basilisk2Node
@onready var shapeshifterNode = $ShapeshifterNode
@onready var sorceressNode = $SorceressNode
@onready var dragonNode = $DragonNode
@onready var goblin1Node = $Goblin1Node
@onready var goblin2Node = $Goblin2Node
@onready var goblin3Node = $Goblin3Node
@onready var goblin4Node = $Goblin4Node
@onready var goblin5Node = $Goblin5Node
@onready var goblin6Node = $Goblin6Node
@onready var goblin7Node = $Goblin7Node

@onready var squares = [
	{"coordinates" : Vector2i(0, 0), "piece" : "valkyrie", "node2d" : valkyrie1Node, "sprite2d" : valkyrie1Node.get_node("Valkyrie1"), "number" : 1, "attribute" : "fly", "square_color" : "dark", "piece_color" : "light", "movement_units" : 3}, 
	{"coordinates" : Vector2i(0, 1), "piece" : "golem", "node2d" : golem1Node, "sprite2d" : golem1Node.get_node("Golem1"), "number" : 1, "attribute" : "ground", "square_color" : "light", "piece_color" : "light", "movement_units" : 3}, 
	{"coordinates" : Vector2i(0, 2), "piece" : "unicorn", "node2d" : unicorn1Node, "sprite2d" : unicorn1Node.get_node("Unicorn1"), "number" : 1, "attribute" : "ground", "square_color" : "dark", "piece_color" : "light", "movement_units" : 4}, 
	{"coordinates" : Vector2i(0, 3), "piece" : "djinn", "node2d" : djinnNode, "sprite2d" : djinnNode.get_node("Djinn"), "number" : 1, "attribute" : "fly", "square_color" : "neutral", "piece_color" : "light", "movement_units" : 4}, 
	{"coordinates" : Vector2i(0, 4), "piece" : "wizard", "node2d" : wizardNode, "sprite2d" : wizardNode.get_node("Wizard"), "number" : 1, "attribute" : "teleport", "square_color" : "light", "piece_color" : "light", "movement_units" : 3}, 
	{"coordinates" : Vector2i(0, 5), "piece" : "phoenix", "node2d" : phoenixNode, "sprite2d" : phoenixNode.get_node("Phoenix"), "number" : 1, "attribute" : "fly", "square_color" : "neutral", "piece_color" : "light", "movement_units" : 5}, 
	{"coordinates" : Vector2i(0, 6), "piece" : "unicorn", "node2d" : unicorn2Node, "sprite2d" : unicorn2Node.get_node("Unicorn2"), "number" : 1, "attribute" : "ground", "square_color" : "dark", "piece_color" : "light", "movement_units" : 4},
	{"coordinates" : Vector2i(0, 7), "piece" : "golem", "node2d" : golem2Node, "sprite2d" : golem2Node.get_node("Golem2"), "number" : 2, "attribute" : "ground", "square_color" : "light", "piece_color" : "light", "movement_units" : 3}, 
	{"coordinates" : Vector2i(0, 8), "piece" : "valkyrie", "node2d" : valkyrie2Node, "sprite2d" : valkyrie2Node.get_node("Valkyrie2"), "number" : 2, "attribute" : "fly", "square_color" : "dark", "piece_color" : "light", "movement_units" : 3}, 
	{"coordinates" : Vector2i(1, 0), "piece" : "archer", "node2d" : archer1Node, "sprite2d" : archer1Node.get_node("Archer1"), "number" : 1, "attribute" : "ground", "square_color" : "light", "piece_color" : "light", "movement_units" : 3}, 
	{"coordinates" : Vector2i(1, 1), "piece" : "knight", "node2d" : knight1Node, "sprite2d" : knight1Node.get_node("Knight1"), "number" : 1, "attribute" : "ground", "square_color" : "dark", "piece_color" : "light", "movement_units" : 3}, 
	{"coordinates" : Vector2i(1, 2), "piece" : "knight", "node2d" : knight2Node, "sprite2d" : knight2Node.get_node("Knight2"), "number" : 2, "attribute" : "ground", "square_color" : "neutral", "piece_color" : "light", "movement_units" : 3}, 
	{"coordinates" : Vector2i(1, 3), "piece" : "knight", "node2d" : knight3Node, "sprite2d" : knight3Node.get_node("Knight3"), "number" : 3, "attribute" : "ground", "square_color" : "light", "piece_color" : "light", "movement_units" : 3}, 
	{"coordinates" : Vector2i(1, 4), "piece" : "knight", "node2d" : knight4Node, "sprite2d" : knight4Node.get_node("Knight4"), "number" : 4, "attribute" : "ground", "square_color" : "neutral", "piece_color" : "light", "movement_units" : 3}, 
	{"coordinates" : Vector2i(1, 5), "piece" : "knight", "node2d" : knight5Node, "sprite2d" : knight5Node.get_node("Knight5"), "number" : 5, "attribute" : "ground", "square_color" : "light", "piece_color" : "light", "movement_units" : 3}, 
	{"coordinates" : Vector2i(1, 6), "piece" : "knight", "node2d" : knight6Node, "sprite2d" : knight6Node.get_node("Knight6"), "number" : 6, "attribute" : "ground", "square_color" : "neutral", "piece_color" : "light", "movement_units" : 3}, 
	{"coordinates" : Vector2i(1, 7), "piece" : "knight", "node2d" : knight7Node, "sprite2d" : knight7Node.get_node("Knight7"), "number" : 7, "attribute" : "ground", "square_color" : "dark", "piece_color" : "light", "movement_units" : 3}, 
	{"coordinates" : Vector2i(1, 8), "piece" : "archer", "node2d" : archer2Node, "sprite2d" : archer2Node.get_node("Archer2"), "number" : 2, "attribute" : "ground", "square_color" : "light", "piece_color" : "light", "movement_units" : 3}, 
	{"coordinates" : Vector2i(2, 0), "piece" : null, "node2d" : null, "sprite2d" : null, "number" : null, "attribute" : null, "square_color" : "dark", "piece_color" : null, "movement_units" : null}, 
	{"coordinates" : Vector2i(2, 1), "piece" : null, "node2d" : null, "sprite2d" : null, "number" : null, "attribute" : null, "square_color" : "neutral", "piece_color" : null, "movement_units" : null}, 
	{"coordinates" : Vector2i(2, 2), "piece" : null, "node2d" : null, "sprite2d" : null, "number" : null, "attribute" : null, "square_color" : "light", "piece_color" : null, "movement_units" : null}, 
	{"coordinates" : Vector2i(2, 3), "piece" : null, "node2d" : null, "sprite2d" : null, "number" : null, "attribute" : null, "square_color" : "dark", "piece_color" : null, "movement_units" : null}, 
	{"coordinates" : Vector2i(2, 4), "piece" : null, "node2d" : null, "sprite2d" : null, "number" : null, "attribute" : null, "square_color" : "neutral", "piece_color" : null, "movement_units" : null}, 
	{"coordinates" : Vector2i(2, 5), "piece" : null, "node2d" : null, "sprite2d" : null, "number" : null, "attribute" : null, "square_color" : "dark", "piece_color" : null, "movement_units" : null}, 
	{"coordinates" : Vector2i(2, 6), "piece" : null, "node2d" : null, "sprite2d" : null, "number" : null, "attribute" : null, "square_color" : "light", "piece_color" : null, "movement_units" : null}, 
	{"coordinates" : Vector2i(2, 7), "piece" : null, "node2d" : null, "sprite2d" : null, "number" : null, "attribute" : null, "square_color" : "neutral", "piece_color" : null, "movement_units" : null}, 
	{"coordinates" : Vector2i(2, 8), "piece" : null, "node2d" : null, "sprite2d" : null, "number" : null, "attribute" : null, "square_color" : "dark", "piece_color" : null, "movement_units" : null}, 
	{"coordinates" : Vector2i(3, 0), "piece" : null, "node2d" : null, "sprite2d" : null, "number" : null, "attribute" : null, "square_color" : "neutral", "piece_color" : null, "movement_units" : null}, 
	{"coordinates" : Vector2i(3, 1), "piece" : null, "node2d" : null, "sprite2d" : null, "number" : null, "attribute" : null, "square_color" : "light", "piece_color" : null, "movement_units" : null}, 
	{"coordinates" : Vector2i(3, 2), "piece" : null, "node2d" : null, "sprite2d" : null, "number" : null, "attribute" : null, "square_color" : "dark", "piece_color" : null, "movement_units" : null}, 
	{"coordinates" : Vector2i(3, 3), "piece" : null, "node2d" : null, "sprite2d" : null, "number" : null, "attribute" : null, "square_color" : "light", "piece_color" : null, "movement_units" : null}, 
	{"coordinates" : Vector2i(3, 4), "piece" : null, "node2d" : null, "sprite2d" : null, "number" : null, "attribute" : null, "square_color" : "neutral", "piece_color" : null, "movement_units" : null}, 
	{"coordinates" : Vector2i(3, 5), "piece" : null, "node2d" : null, "sprite2d" : null, "number" : null, "attribute" : null, "square_color" : "light", "piece_color" : null, "movement_units" : null}, 
	{"coordinates" : Vector2i(3, 6), "piece" : null, "node2d" : null, "sprite2d" : null, "number" : null, "attribute" : null, "square_color" : "dark", "piece_color" : null, "movement_units" : null}, 
	{"coordinates" : Vector2i(3, 7), "piece" : null, "node2d" : null, "sprite2d" : null, "number" : null, "attribute" : null, "square_color" : "light", "piece_color" : null, "movement_units" : null}, 
	{"coordinates" : Vector2i(3, 8), "piece" : null, "node2d" : null, "sprite2d" : null, "number" : null, "attribute" : null, "square_color" : "neutral", "piece_color" : null, "movement_units" : null}, 
	{"coordinates" : Vector2i(4, 0), "piece" : null, "node2d" : null, "sprite2d" : null, "number" : null, "attribute" : null, "square_color" : "neutral", "piece_color" : null, "movement_units" : null}, 
	{"coordinates" : Vector2i(4, 1), "piece" : null, "node2d" : null, "sprite2d" : null, "number" : null, "attribute" : null, "square_color" : "neutral", "piece_color" : null, "movement_units" : null}, 
	{"coordinates" : Vector2i(4, 2), "piece" : null, "node2d" : null, "sprite2d" : null, "number" : null, "attribute" : null, "square_color" : "neutral", "piece_color" : null, "movement_units" : null}, 
	{"coordinates" : Vector2i(4, 3), "piece" : null, "node2d" : null, "sprite2d" : null, "number" : null, "attribute" : null, "square_color" : "neutral", "piece_color" : null, "movement_units" : null}, 
	{"coordinates" : Vector2i(4, 4), "piece" : null, "node2d" : null, "sprite2d" : null, "number" : null, "attribute" : null, "square_color" : "neutral", "piece_color" : null, "movement_units" : null}, 
	{"coordinates" : Vector2i(4, 5), "piece" : null, "node2d" : null, "sprite2d" : null, "number" : null, "attribute" : null, "square_color" : "neutral", "piece_color" : null, "movement_units" : null}, 
	{"coordinates" : Vector2i(4, 6), "piece" : null, "node2d" : null, "sprite2d" : null, "number" : null, "attribute" : null, "square_color" : "neutral", "piece_color" : null, "movement_units" : null}, 
	{"coordinates" : Vector2i(4, 7), "piece" : null, "node2d" : null, "sprite2d" : null, "number" : null, "attribute" : null, "square_color" : "neutral", "piece_color" : null, "movement_units" : null}, 
	{"coordinates" : Vector2i(4, 8), "piece" : null, "node2d" : null, "sprite2d" : null, "number" : null, "attribute" : null, "square_color" : "neutral", "piece_color" : null, "movement_units" : null}, 
	{"coordinates" : Vector2i(5, 0), "piece" : null, "node2d" : null, "sprite2d" : null, "number" : null, "attribute" : null, "square_color" : "neutral", "piece_color" : null, "movement_units" : null}, 
	{"coordinates" : Vector2i(5, 1), "piece" : null, "node2d" : null, "sprite2d" : null, "number" : null, "attribute" : null, "square_color" : "dark", "piece_color" : null, "movement_units" : null}, 
	{"coordinates" : Vector2i(5, 2), "piece" : null, "node2d" : null, "sprite2d" : null, "number" : null, "attribute" : null, "square_color" : "light", "piece_color" : null, "movement_units" : null}, 
	{"coordinates" : Vector2i(5, 3), "piece" : null, "node2d" : null, "sprite2d" : null, "number" : null, "attribute" : null, "square_color" : "dark", "piece_color" : null, "movement_units" : null}, 
	{"coordinates" : Vector2i(5, 4), "piece" : null, "node2d" : null, "sprite2d" : null, "number" : null, "attribute" : null, "square_color" : "neutral", "piece_color" : null, "movement_units" : null}, 
	{"coordinates" : Vector2i(5, 5), "piece" : null, "node2d" : null, "sprite2d" : null, "number" : null, "attribute" : null, "square_color" : "dark", "piece_color" : null, "movement_units" : null}, 
	{"coordinates" : Vector2i(5, 6), "piece" : null, "node2d" : null, "sprite2d" : null, "number" : null, "attribute" : null, "square_color" : "light", "piece_color" : null, "movement_units" : null}, 
	{"coordinates" : Vector2i(5, 7), "piece" : null, "node2d" : null, "sprite2d" : null, "number" : null, "attribute" : null, "square_color" : "dark", "piece_color" : null, "movement_units" : null}, 
	{"coordinates" : Vector2i(5, 8), "piece" : null, "node2d" : null, "sprite2d" : null, "number" : null, "attribute" : null, "square_color" : "neutral", "piece_color" : null, "movement_units" : null}, 
	{"coordinates" : Vector2i(6, 0), "piece" : null, "node2d" : null, "sprite2d" : null, "number" : null, "attribute" : null, "square_color" : "light", "piece_color" : null, "movement_units" : null}, 
	{"coordinates" : Vector2i(6, 1), "piece" : null, "node2d" : null, "sprite2d" : null, "number" : null, "attribute" : null, "square_color" : "neutral", "piece_color" : null, "movement_units" : null}, 
	{"coordinates" : Vector2i(6, 2), "piece" : null, "node2d" : null, "sprite2d" : null, "number" : null, "attribute" : null, "square_color" : "dark", "piece_color" : null, "movement_units" : null}, 
	{"coordinates" : Vector2i(6, 3), "piece" : null, "node2d" : null, "sprite2d" : null, "number" : null, "attribute" : null, "square_color" : "light", "piece_color" : null, "movement_units" : null}, 
	{"coordinates" : Vector2i(6, 4), "piece" : null, "node2d" : null, "sprite2d" : null, "number" : null, "attribute" : null, "square_color" : "neutral", "piece_color" : null, "movement_units" : null}, 
	{"coordinates" : Vector2i(6, 5), "piece" : null, "node2d" : null, "sprite2d" : null, "number" : null, "attribute" : null, "square_color" : "light", "piece_color" : null, "movement_units" : null}, 
	{"coordinates" : Vector2i(6, 6), "piece" : null, "node2d" : null, "sprite2d" : null, "number" : null, "attribute" : null, "square_color" : "dark", "piece_color" : null, "movement_units" : null}, 
	{"coordinates" : Vector2i(6, 7), "piece" : null, "node2d" : null, "sprite2d" : null, "number" : null, "attribute" : null, "square_color" : "neutral", "piece_color" : null, "movement_units" : null}, 
	{"coordinates" : Vector2i(6, 8), "piece" : null, "node2d" : null, "sprite2d" : null, "number" : null, "attribute" : null, "square_color" : "light", "piece_color" : null, "movement_units" : null},
	{"coordinates" : Vector2i(7, 0), "piece" : "manticore", "node2d" : manticore1Node, "sprite2d" : manticore1Node.get_node("Manticore1"), "number" : 1, "attribute" : "ground", "square_color" : "dark", "piece_color" : "dark", "movement_units" : 3}, 
	{"coordinates" : Vector2i(7, 1), "piece" : "goblin", "node2d" : goblin1Node, "sprite2d" : goblin1Node.get_node("Goblin1"), "number" : 1, "attribute" : "ground", "square_color" : "light", "piece_color" : "dark", "movement_units" : 3}, 
	{"coordinates" : Vector2i(7, 2), "piece" : "goblin", "node2d" : goblin2Node, "sprite2d" : goblin2Node.get_node("Goblin2"), "number" : 2, "attribute" : "ground", "square_color" : "neutral", "piece_color" : "dark", "movement_units" : 3}, 
	{"coordinates" : Vector2i(7, 3), "piece" : "goblin", "node2d" : goblin3Node, "sprite2d" : goblin3Node.get_node("Goblin3"), "number" : 3, "attribute" : "ground", "square_color" : "dark", "piece_color" : "dark", "movement_units" : 3}, 
	{"coordinates" : Vector2i(7, 4), "piece" : "goblin", "node2d" : goblin4Node, "sprite2d" : goblin4Node.get_node("Goblin4"), "number" : 4, "attribute" : "ground", "square_color" : "neutral", "piece_color" : "dark", "movement_units" : 3}, 
	{"coordinates" : Vector2i(7, 5), "piece" : "goblin", "node2d" : goblin5Node, "sprite2d" : goblin5Node.get_node("Goblin5"), "number" : 5, "attribute" : "ground", "square_color" : "dark", "piece_color" : "dark", "movement_units" : 3}, 
	{"coordinates" : Vector2i(7, 6), "piece" : "goblin", "node2d" : goblin6Node, "sprite2d" : goblin6Node.get_node("Goblin6"), "number" : 6, "attribute" : "ground", "square_color" : "neutral", "piece_color" : "dark", "movement_units" : 3}, 
	{"coordinates" : Vector2i(7, 7), "piece" : "goblin", "node2d" : goblin7Node, "sprite2d" : goblin7Node.get_node("Goblin7"), "number" : 7, "attribute" : "ground", "square_color" : "light", "piece_color" : "dark", "movement_units" : 3}, 
	{"coordinates" : Vector2i(7, 8), "piece" : "manticore", "node2d" : manticore2Node, "sprite2d" : manticore2Node.get_node("Manticore2"), "number" : 2, "attribute" : "ground", "square_color" : "dark", "piece_color" : "dark", "movement_units" : 3},
	{"coordinates" : Vector2i(8, 0), "piece" : "banshee", "node2d" : banshee1Node, "sprite2d" : banshee1Node.get_node("Banshee1"), "number" : 1, "attribute" : "fly", "square_color" : "light", "piece_color" : "dark", "movement_units" : 3}, 
	{"coordinates" : Vector2i(8, 1), "piece" : "troll", "node2d" : troll1Node, "sprite2d" : troll1Node.get_node("Troll1"), "number" : 1, "attribute" : "ground", "square_color" : "dark", "piece_color" : "dark", "movement_units" : 3}, 
	{"coordinates" : Vector2i(8, 2), "piece" : "basilisk", "node2d" : basilisk1Node, "sprite2d" : basilisk1Node.get_node("Basilisk1"), "number" : 1, "attribute" : "ground", "square_color" : "light", "piece_color" : "dark", "movement_units" : 3}, 
	{"coordinates" : Vector2i(8, 3), "piece" : "shapeshifter", "node2d" : shapeshifterNode, "sprite2d" : shapeshifterNode.get_node("Shapeshifter"), "number" : 1, "attribute" : "fly", "square_color" : "neutral", "piece_color" : "dark", "movement_units" : 5}, 
	{"coordinates" : Vector2i(8, 4), "piece" : "sorceress", "node2d" : sorceressNode, "sprite2d" : sorceressNode.get_node("Sorceress"), "number" : 1, "attribute" : "teleport", "square_color" : "dark", "piece_color" : "dark", "movement_units" : 3}, 
	{"coordinates" : Vector2i(8, 5), "piece" : "dragon", "node2d" : dragonNode, "sprite2d" : dragonNode.get_node("Dragon"), "number" : 1, "attribute" : "fly", "square_color" : "neutral", "piece_color" : "dark", "movement_units" : 4}, 
	{"coordinates" : Vector2i(8, 6), "piece" : "basilisk", "node2d" : basilisk2Node, "sprite2d" : basilisk2Node.get_node("Basilisk2"), "number" : 2, "attribute" : "ground", "square_color" : "light", "piece_color" : "dark", "movement_units" : 3},
	{"coordinates" : Vector2i(8, 7), "piece" : "troll", "node2d" : troll2Node, "sprite2d" : troll2Node.get_node("Troll2"), "number" : 2, "attribute" : "ground", "square_color" : "dark", "piece_color" : "dark", "movement_units" : 3}, 
	{"coordinates" : Vector2i(8, 8), "piece" : "banshee", "node2d" : banshee2Node, "sprite2d" : banshee2Node.get_node("Banshee2"), "number" : 2, "attribute" : "fly", "square_color" : "light", "piece_color" : "dark", "movement_units" : 3}
	]
			
func _process(_delta):
	hoveredTile = tileMapLayer.local_to_map(get_global_mouse_position())
	#print("hoveredTile = %s" % (hoveredTile - Vector2i(OFFSET_VALUE, OFFSET_VALUE)))
	touchingGameTile = false
	
	for x in (GRID_DIM + OFFSET_VALUE):
		for y in (GRID_DIM + OFFSET_VALUE):
			if x >= OFFSET_VALUE && x < (GRID_DIM + OFFSET_VALUE):
				if y >= OFFSET_VALUE && y < (GRID_DIM + OFFSET_VALUE):
					tileMapLayer.erase_cell(Vector2i(x, y) - Vector2i(OFFSET_VALUE, OFFSET_VALUE))

	if hoveredTile.x >= OFFSET_VALUE && hoveredTile.x < (GRID_DIM + OFFSET_VALUE):
		if hoveredTile.y >= OFFSET_VALUE && hoveredTile.y < (GRID_DIM + OFFSET_VALUE):
			touchingGameTile = true

			if pieceSelectionCount == 1:
				if (hoveredTile - Vector2i(OFFSET_VALUE, OFFSET_VALUE)) in movableSquares.keys():  
					tileMapLayer.set_cell((hoveredTile - Vector2i(OFFSET_VALUE, OFFSET_VALUE)), 1, Vector2i(0, 0), 0)
				else:
					tileMapLayer.set_cell((hoveredTile - Vector2i(OFFSET_VALUE, OFFSET_VALUE)), 2, Vector2i(0, 0), 0)
			else:
				if colorTurn == "light":
					tileMapLayer.set_cell((hoveredTile - Vector2i(OFFSET_VALUE, OFFSET_VALUE)), 3, Vector2i(0, 0), 0)
				else:
					tileMapLayer.set_cell((hoveredTile - Vector2i(OFFSET_VALUE, OFFSET_VALUE)), 4, Vector2i(0, 0), 0)
					
			tileMapLayer.set_z_index(1)
				
func _input(event):	
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if touchingGameTile == true:
				if pieceSelectionCount == 0:
					for square in squares:
						if square.get("piece") != null:
							if square.get("coordinates") == hoveredTile - Vector2i(OFFSET_VALUE, OFFSET_VALUE):
								if square.get("piece_color") == colorTurn:
									currentPiece = square
									calculateMovableSquares(square)
									displayMoveInfo()
									pieceSelectionCount += 1
									firstSelection = hoveredTile

				elif pieceSelectionCount == 1:
					if hoveredTile != firstSelection:
						attemptPieceMove()

					clearMovement()
					boardInfo.clear()
					
func displayMoveInfo():
	boardInfo.set_text("")
	boardInfo.add_theme_font_size_override("normal_font_size", 20)
	if pieceBlocked == true:
		boardInfo.set_text("%s (%s %d)\nItem cannot be moved." % [currentPiece.get("piece"), currentPiece.get("attribute"), currentPiece.get("movement_units")])
		pieceBlocked = false
	else:
		boardInfo.set_text("%s (%s %d)" % [currentPiece.get("piece"), currentPiece.get("attribute"), currentPiece.get("movement_units")])
						
func clearMovement():
	pieceSelectionCount = 0
	movableSquares = {}
	
func changeTurn():
	if colorTurn == "light":
		colorTurn = "dark"
		get_viewport().warp_mouse(Vector2((((GRID_DIM - 1) + OFFSET_VALUE) * SQUARE_SIZE + (SQUARE_SIZE / 2.0)), ((4 + OFFSET_VALUE) * SQUARE_SIZE + (SQUARE_SIZE / 2.0))))
	else:
		colorTurn = "light"
		get_viewport().warp_mouse(Vector2(((0 + OFFSET_VALUE) * SQUARE_SIZE + (SQUARE_SIZE / 2.0)), ((4 + OFFSET_VALUE) * SQUARE_SIZE + (SQUARE_SIZE / 2.0))))
	
func attemptPieceMove():
	var newSquareIndex = 0
	var oldSquareIndex = 0
	var _prevNewColor = ""
	var _prevOldColor = ""
	var _prevNewCoords = null
	var _prevOldCoords = null
		
	if (touchingGameTile == true) && ((hoveredTile - Vector2i(OFFSET_VALUE, OFFSET_VALUE)) in movableSquares.keys()):
		if pieceSelectionCount == 1:
			var movementSquares = currentPiece.get("node2d").move(tileMapLayer, hoveredTile, OFFSET_VALUE, currentPiece, SQUARE_SIZE)
			
			for square in squares:
				if square.get("coordinates") == movementSquares.get("newPosition"):
					if square.get("piece") != null:
						square.get("sprite2d").set_z_index(0)
						currentPiece.get("sprite2d").set_z_index(1)
					break
					
				newSquareIndex += 1

			for square in squares:
				if square.get("coordinates") == movementSquares.get("oldPosition"):
					break
					
				oldSquareIndex += 1
				
		_prevNewCoords = squares[newSquareIndex].get("coordinates")
		_prevOldCoords = squares[oldSquareIndex].get("coordinates")
		_prevNewColor = squares[newSquareIndex].get("square_color")
		_prevOldColor = squares[oldSquareIndex].get("square_color")
		
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
		squares[newSquareIndex]["square_color"] = squares[oldSquareIndex]["square_color"]
		squares[oldSquareIndex]["square_color"] = null
		squares[newSquareIndex]["piece_color"] = squares[oldSquareIndex]["piece_color"]
		squares[oldSquareIndex]["piece_color"] = null
		
		changeTurn()
				
func calculateMovableSquares(inSquare):
	var frontier = []
	var squaresToConsider = {}
	var cameFrom = {}
	var startLocation = Vector2i(0, 0)
	var squareToConsider = null
	
	frontier.push_front(startLocation)
	cameFrom[startLocation] = null

	while !frontier.is_empty():
		var current = frontier.pop_front()
		
		for next in getNeighbors(current):
			if inSquare.get("attribute") == "ground":
				if absi(current.x) + absi(current.y) <= inSquare.get("movement_units"):
					squareToConsider = current + inSquare.get("coordinates")
					if !cameFrom.has(next):
						frontier.push_back(next)
						cameFrom[next] = current
			
			elif inSquare.get("attribute") == "fly" || inSquare.get("attribute") == "teleport":
				if absi(current.x) + absi(current.y) <= inSquare.get("movement_units") * 2:
					if absi(current.x) <= inSquare.get("movement_units"):
						if absi(current.y) <= inSquare.get("movement_units"):
							squareToConsider = current + inSquare.get("coordinates")
							if !cameFrom.has(next):
								frontier.push_back(next)
								cameFrom[next] = current
						
			squaresToConsider[squareToConsider] = null
							
	setMovableSquares(squaresToConsider, inSquare)
							
func setMovableSquares(squaresToConsider, inSquare):
	for squareToConsider in squaresToConsider.keys():
		if squareToConsider.x < GRID_DIM && squareToConsider.x >= 0:
			if squareToConsider.y < GRID_DIM && squareToConsider.y >= 0:
				if squareToConsider != inSquare.get("coordinates"):
					movableSquares[squareToConsider] = null
				connectingSquares[squareToConsider] = null
			
	for square in squares:
		for movableSquare in movableSquares.keys():
			if square.get("coordinates") == movableSquare:
				if square.get("piece") != null:
					if square.get("piece_color") == colorTurn:
						movableSquares.erase(movableSquare)
				else:
					connectingSquares.erase(movableSquare)
		
	if inSquare.get("attribute") == "ground":
		paths = []
		for movableSquare in movableSquares:
			getAllPaths(inSquare.get("coordinates"), movableSquare, [], {}, 0, inSquare.get("movement_units"))
		checkBlockedGroundSquares()
		
		for movableSquare in movableSquares.keys():
			var pathFound = false
			for path in paths:
				if movableSquare in path:
					pathFound = true
			if pathFound == false:
				movableSquares.erase(movableSquare)
		
		if movableSquares.size() == 0:
			pieceBlocked = true
					
func getAllPaths(start, end, path, visited, moves, movementUnits):
	if start == end && moves < movementUnits:
		path.push_back(end)
		paths.push_back(path.duplicate())
		path.pop_back()
		return
	
	path.push_back(start)
	visited[start] = true
	moves = path.size() - 1
	var neighbors = getNeighbors(start)
	for neighbor in neighbors:
		if neighbor in connectingSquares.keys() || neighbor in movableSquares.keys():
			if neighbor not in visited.keys() || visited[neighbor] == false:
				if moves < movementUnits: 
					#if neighbor == end:
						#print("found path")
						#print("neighbor = end")
						#print("%v = %v" % [neighbor, end])
					#print("neighbor = %v" % neighbor)
					#print("path = ")
					#print(path)
					#print("visited = %s" % visited)
					#print("moves = %d" % moves)
					#print("\n")
					getAllPaths(neighbor, end, path, visited, moves, movementUnits)	
	
	visited[start] = false
	path.pop_back()
	
func checkBlockedGroundSquares():
	var pathCounter = 0
	var pathsCounter = 0
	var checkedSquares = {}
	var occupiedSquares = {}
	var pathsDict = {}
	
	while pathsCounter < paths.size():
		pathsDict[pathsCounter] = paths[pathsCounter]
		pathCounter = 0
		while pathCounter < paths[pathsCounter].size():
			if paths[pathsCounter][pathCounter] not in checkedSquares.keys():
				for square in squares:
					if (pathCounter != 0 || pathCounter != paths[pathsCounter].size() - 1):
						if paths[pathsCounter][pathCounter] == square.get("coordinates"):
							if square.get("piece") != null:
								checkedSquares[paths[pathsCounter][pathCounter]] = null
								occupiedSquares[paths[pathsCounter][pathCounter]] = null
			pathCounter += 1
		pathsCounter += 1
	
	var squareIndex = 0
	var squareIndices = {}
	for occupiedSquare in occupiedSquares.keys():
		for pathIndex in pathsDict.keys():
			squareIndex = 0
			while squareIndex < pathsDict.get(pathIndex).size():
				if (squareIndex != 0 && squareIndex != pathsDict.get(pathIndex).size() - 1):
					if pathsDict.get(pathIndex)[squareIndex] == occupiedSquare:
						squareIndices[pathIndex] = null
				squareIndex += 1
				
	for index in squareIndices.keys():
		pathsDict.erase(index)
	
	paths = []
	for path in pathsDict.keys():
		paths.push_back(pathsDict[path])
				
func getNeighbors(node):
	var neighbors = []
	
	neighbors.append(node + Vector2i(-1, 0))
	neighbors.append(node + Vector2i(0, -1))
	neighbors.append(node + Vector2i(1, 0))
	neighbors.append(node + Vector2i(0, 1))
	
	return neighbors
