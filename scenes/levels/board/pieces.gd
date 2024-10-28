extends Node2D
class_name Pieces

func move(tileMap, tile, offset, currentPiece, squareSize):
	#print("initial self.position = %s" % (self.position))
	#self.position = Vector2(currentPiece.get("coordinates").x * squareSize, currentPiece.get("coordinates").y * squareSize) + Vector2(offset * squareSize, offset * squareSize)
	#self.position = Vector2(currentPiece.get("coordinates").x * squareSize, currentPiece.get("coordinates").y * squareSize)
	#print("initial self.position = %s" % (self.position))
	#print("tile = %s" % (tile))
	#print("tileWithOffset = %s" % (tile - Vector2i(offset, offset)))
	var returnSquares = {}
	var oldPos = currentPiece.get("coordinates")
	print("oldPos = %s" % (oldPos))
	var moveUnits = (tile - Vector2i(offset, offset)) - oldPos
	print("moveUnits = %s" % (moveUnits))
	var moveUnitsPixels = Vector2(moveUnits.x * squareSize, moveUnits.y * squareSize)
	print("moveUnitsPixels = %s" % (moveUnitsPixels))
	#self.position = moveUnitsPixels + Vector2(oldPos.x * squareSize, oldPos.y * squareSize)
	self.position = moveUnitsPixels + self.position
	var newPos = self.position
	print("self.position = %s" % (self.position))
	print("self.global_position = %s" % (self.global_position))
	print("tileMap.local_to_map(newPos) = %s" % (tileMap.local_to_map(newPos)))
	
	returnSquares["newPosition"] = tileMap.local_to_map(newPos)
	#print("returnSquares['newPosition'] = %s" % (returnSquares["newPosition"]))
	returnSquares["oldPosition"] = oldPos
	#print("returnSquares['oldPosition'] = %s" % (returnSquares["oldPosition"]))
	
	return returnSquares
