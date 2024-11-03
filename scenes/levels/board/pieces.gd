extends Node2D
class_name Pieces

func move(tileMap, tile, offset, currentPiece, squareSize):	
	var returnSquares = {}
	var oldPos = currentPiece.get("coordinates")
	var moveUnits = (tile - Vector2i(offset, offset)) - oldPos
	var moveUnitsPixels = Vector2(moveUnits.x * squareSize, moveUnits.y * squareSize)
	self.position = moveUnitsPixels + self.position
	var newPos = Vector2(oldPos.x * squareSize, oldPos.y * squareSize) + moveUnitsPixels
	
	returnSquares["newPosition"] = tileMap.local_to_map(newPos)
	returnSquares["oldPosition"] = oldPos
	
	return returnSquares
