@tool
extends Node2D

## A sequence of puzzles where one requires the previous one
##
## All puzzles will be at the same y position

## The distance between puzzlews
@export var separation := 8.0

# Called when the node enters the scene tree for the first time.
func _ready():
	var n :Node2D = null
	for i in get_children():
		if n != null:
			i.required = n.get_path()
			i.required_puzzle = n
			n.was_solved.connect(i._on_required_was_solved)
			if not Engine.is_editor_hint():
				for j in i.get_children():
					if n.solved == false:
						j.modulate.a = 0
		n = i


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var x = 0
	for i in get_children():
		i.position.x = x
		i.position.y = 0
		x += i.row_size * 20
