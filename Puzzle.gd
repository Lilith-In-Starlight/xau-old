extends Node2D

class_name Puzzle

## A node graph that must be solved.
##
## Puzzles are node graphs. Every child of this node that is in
## the group "PuzzleNode" is interpreted as a node.
##
## When every node's demands are satisified, the puzzle is correct
## if the node's demands have been satisified at any point in the past,
## it is considered solved, even when not currently correct

## Emitted when the puzzle is solved
signal was_solved

## Path to a Puzzle that is required to solve this one
@export var required :NodePath

## A Puzzle that is required to solve this one
@onready var required_puzzle = get_node_or_null(required)

## All the nodes in the puzzle. It is equal to 
## all of this node's children that are in the "PuzzleNodes" group
var nodes = []

## Whether the puzzle was solved or not
var solved := false

func _ready():
	for i in get_children():
		if i.is_in_group("PuzzleNode"):
			nodes.append(i)
			
		if not Engine.is_editor_hint():
			if not required_puzzle == null:
				if required_puzzle.solved == false:
					i.modulate.a = 0.0
	
	if not Engine.is_editor_hint():
		if not required_puzzle == null:
			required_puzzle.was_solved.connect(_on_required_was_solved)


func _draw():
	if !nodes.is_empty():
		var lesser :Vector2 = nodes[0].position
		var greater := Vector2(1, 1)
		for i in nodes:
			if i.position.x < lesser.x:
				lesser.x = i.position.x
			elif i.position.x > greater.x:
				greater.x = i.position.x
			if i.position.y < lesser.y:
				lesser.y = i.position.y
			elif i.position.y > greater.y:
				greater.y = i.position.y
		draw_rect(Rect2(lesser - Vector2(8, 8), greater-lesser + Vector2(16, 15)), Color("#0c0c0c"), true)


func _input(delta):
	if Input.is_action_just_pressed("confirm"):
		if is_enabled:
			var unhappy_nodes := []
			for i in nodes:
				if !i.check():
					unhappy_nodes.append(i)
					i.show_failure()
			if unhappy_nodes.is_empty():
				show_correct()
				solved = true
				was_solved.emit()

## Makes the puzzle look green to indicate that it is correct
func show_correct():
	var tween := create_tween()
	tween.tween_property(self, "modulate", Color.GREEN, 0.4)
	tween.play()

## Makes the puzzle look white to show that it is not correct
func unshow_correct():
	var tween := create_tween()
	tween.tween_property(self, "modulate", Color.WHITE, 0.4)
	tween.play()

## Called when the puzzle required to interact with this one is solved
func _on_required_was_solved():
	for i in get_children():
		i.modulate.a = 1.0


## Whether the puzzle is enabled
func is_enabled() -> bool:
	required_puzzle = get_node_or_null(required)
	if required_puzzle == null:
		return true
	return required_puzzle.solved
