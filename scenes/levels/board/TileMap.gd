extends TileMap

var GRID_DIM = 9
var dic = {}

func _ready():
	for x in GRID_DIM:
		for y in GRID_DIM:
			dic[str(Vector2(x, y))] = {
				"Type" : "neutral"
			}
			set_cell(0, Vector2(x, y), 0, Vector2i(0, 0), 0)
			
func _process(delta):
	var tile = local_to_map(get_global_mouse_position())
	
	for x in GRID_DIM:
		for y in GRID_DIM:
			erase_cell(1, Vector2(x, y))

	if dic.has(str(tile)):
		set_cell(1, tile, 1, Vector2i(0, 0), 0)
		print(dic[str(tile)])
