@tool
extends Puzzle

## A [Puzzle] where the nodes are set in a grid
##
## A PuzzleGrid automatically sets all its nodes to be in a grid-like
## configuration.

## The size of a row. If there are more than [member row_size] [PuzzleNode]s,
## there will be more than one row.
@export var row_size :int = 1
## The separation between adjacent nodes in this puzzle
@export var spacing :int = 16
## Positions of the puzzle where there should not be a node
@export var holes: Array[Vector2i] = []

func _process(delta):
	var x := 0
	var y := 0
	if Engine.is_editor_hint():
		for i in get_children():
			if i.is_in_group("PuzzleNode"):
				while Vector2i(x, y) in holes:
					x += 1
					if x >= row_size:
						x = 0
						y += 1
				i.position = Vector2i(x, y) * spacing
				x += 1
				if x >= row_size:
					x = 0
					y += 1
