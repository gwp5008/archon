extends TileMap

var GRID_DIM = 9
var OFFSET_VALUE = 3
var DIC = {}
var SQUARES = [
	["dark", "light", "dark", "neutral", "light", "neutral", "dark", "light", "dark"],
	["light", "dark", "neutral", "light", "neutral", "light", "neutral", "dark", "light"],
	["dark", "neutral", "light", "dark", "neutral", "dark", "light", "neutral", "dark"],
	["neutral", "light", "dark", "light", "neutral", "light", "dark", "light", "neutral"],
	["neutral", "neutral", "neutral", "neutral", "neutral", "neutral", "neutral", "neutral", "neutral"],
	["neutral", "dark", "light", "dark", "neutral", "dark", "light", "dark", "neutral"],
	["light", "neutral", "dark", "light", "neutral", "light", "dark", "neutral", "light"],
	["dark", "light", "neutral", "dark", "neutral", "dark", "neutral", "light", "dark"],
	["light", "dark", "light", "neutral", "dark", "neutral", "light", "dark", "light"]
]

func _ready():
	for x in len(SQUARES):
		for y in len(SQUARES[x]):
			DIC[str(Vector2(x, y) + Vector2(OFFSET_VALUE, OFFSET_VALUE))] = {
		"Type" : SQUARES[x][y]
			}
			#print("(%d, %d)" % [x, y])
			#set_cell(0, Vector2(x, y), 6, Vector2i(0, 0), 0)
			
func _process(_delta):
	var tile = local_to_map(get_global_mouse_position())
	#print("tile = %s" % tile)
	
	for x in (GRID_DIM + OFFSET_VALUE):
		for y in (GRID_DIM + OFFSET_VALUE):
			if x >= OFFSET_VALUE && x < (GRID_DIM + OFFSET_VALUE):
				if y >= OFFSET_VALUE && y < (GRID_DIM + OFFSET_VALUE):
					erase_cell(0, Vector2(x, y))

	if tile.x >= OFFSET_VALUE && tile.x < (GRID_DIM + OFFSET_VALUE):
		if tile.y >= OFFSET_VALUE && tile.y < (GRID_DIM + OFFSET_VALUE):
			set_cell(0, tile, 0, Vector2i(0, 0), 0)
			print(DIC[str(tile)])
		
