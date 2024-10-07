extends Node2D

func move(tileMap, tile, offset, currentPiece, squareSize):
	var returnSquares = {}
	var oldPos = currentPiece.get("coordinates")
	var moveUnits = tile - (oldPos + Vector2i(offset, offset))
	var newPos = Vector2(moveUnits.x * squareSize, moveUnits.y * squareSize)
	position = newPos
	
	returnSquares["newPosition"] = tileMap.local_to_map(newPos) + oldPos
	returnSquares["oldPosition"] = oldPos
	
	return returnSquares
