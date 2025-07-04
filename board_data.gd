extends Resource
class_name BoardData

@export var boardData = []
@export var originalSquares = []
@export var startup = true

func setCurrentBoardData(board):
	boardData = board
	
func setOriginalSquares(squares):
	originalSquares = squares
	
func negateStartup():
	startup = false
