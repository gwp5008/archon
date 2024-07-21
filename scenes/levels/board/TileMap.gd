extends TileMap

var GRID_DIM = 9
var OFFSET_VALUE = 3
var dic = {}

func _ready():
	for x in (GRID_DIM + OFFSET_VALUE):
		for y in (GRID_DIM + OFFSET_VALUE):
			if x >= OFFSET_VALUE && x < (GRID_DIM + OFFSET_VALUE):
				if y >= OFFSET_VALUE && y < (GRID_DIM + OFFSET_VALUE):
					dic[str(Vector2(x, y))] = {
				"Type" : "neutral"
			}
			#print("(%d, %d)" % [x, y])
			

			#set_cell(0, Vector2(x, y), 6, Vector2i(0, 0), 0)
			
func _process(_delta):
	var tile = local_to_map(get_global_mouse_position())
	#print("tile = %s" % tile)
	#tile = tile - Vector2i(3, 3)
	#print("tile = %s" % tile)
	
	for x in (GRID_DIM + OFFSET_VALUE):
		for y in (GRID_DIM + OFFSET_VALUE):
			if x >= OFFSET_VALUE && x < (GRID_DIM + OFFSET_VALUE):
				if y >= OFFSET_VALUE && y < (GRID_DIM + OFFSET_VALUE):
					erase_cell(0, Vector2(x, y))

	#if dic.has(str(tile)):
	if tile.x >= OFFSET_VALUE && tile.x < (GRID_DIM + OFFSET_VALUE):
		if tile.y >= OFFSET_VALUE && tile.y < (GRID_DIM + OFFSET_VALUE):
			set_cell(0, tile, 0, Vector2i(0, 0), 0)
			print(dic[str(tile)])
		
