@tool
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


## A Puzzle that is required to solve this one
@export @onready var required_puzzle: Node2D :
	set(value):
		required_puzzle = value
		update_enabled_visuals()

## Whether the puzzle was solved or not
var solved := false


## Whether the puzzle is currently verified as correct
var correct := false :
	set(value):
		correct = value
		update_correctness_visuals()


func _draw():
	var rect := get_rect()
	draw_rect(rect.grow(8), Color("#0c0c0c"), true)


func _ready():
	if SaveData.data.has(str(get_path())):
		var id = str(get_path())
		solved = SaveData.data[id]["solved"]
		correct = SaveData.data[id]["correct"]
		if solved or correct: was_solved.emit()
		for i in get_child_count():
			var child = get_child(i)
			if SaveData.data[id]["connections"].has(str(i)):
				for j in SaveData.data[id]["connections"][str(i)]:
					child.connections.append(get_child(j))
	if not required_puzzle == null:
		required_puzzle.was_solved.connect(_on_required_was_solved)
	update_enabled_visuals()
	child_entered_tree.connect(_on_child_entered_tree)
	child_exiting_tree.connect(_on_child_exiting_tree)


func _input(delta):
	if Input.is_action_just_pressed("confirm"):
		if is_enabled:
			var unhappy_nodes := []
			for i in get_children():
				if i.is_in_group("PuzzleNode"):
					if !i.check():
						unhappy_nodes.append(i)
						i.show_failure()
			if unhappy_nodes.is_empty():
				show_correct()
				solved = true
				correct = true
				was_solved.emit()

## Makes the puzzle look green to indicate that it is correct
func show_correct():
	for i in get_children():
		if not i.name == "NoNode":
			var tween := i.create_tween()
			tween.tween_property(i, "modulate", Color.PLUM, 0.2)
			tween.play()

## Makes the puzzle look white to show that it is not correct
func unshow_correct():
	for i in get_children():
		if not i.name == "NoNode":
			var tween := i.create_tween()
			tween.tween_property(i, "modulate", Color.WHITE, 0.2)
			tween.play()

## Called when the puzzle required to interact with this one is solved
func _on_required_was_solved():
	update_enabled_visuals()


## Whether the puzzle is enabled
func is_enabled() -> bool:
	if required_puzzle == null:
		return true
	return required_puzzle.solved

## Display the correctness of the puzzle
func update_correctness_visuals(queue_redraw: bool = false) -> void:
	if not Engine.is_editor_hint():
		if is_enabled():
			if correct: show_correct()
			else: unshow_correct()
		if queue_redraw: queue_redraw()

## Display whether the puzzle is enabled
func update_enabled_visuals() -> void:
	for i in get_children():
		if not i.name == "NoNode":
			if is_enabled():
				i.modulate.a = 1.0
			elif Engine.is_editor_hint():
				i.modulate.a = 1.0
			else:
				i.modulate.a = 0.0
	queue_redraw()

func _on_child_entered_tree(gone_node: Node):
	queue_redraw()

func _on_child_exiting_tree(gone_node: Node):
	queue_redraw()


func get_rect() -> Rect2:
	var lesser :Vector2 = Vector2(0, 0)
	var greater := Vector2(1, 1)
	for i in get_children():
		if not i.name == "NoNode":
			if i.position.x < lesser.x:
				lesser.x = i.position.x
			elif i.position.x > greater.x:
				greater.x = i.position.x
			if i.position.y < lesser.y:
				lesser.y = i.position.y
			elif i.position.y > greater.y:
				greater.y = i.position.y
	return Rect2(lesser, greater)


func save():
	var dict := {}
	var conn := {}
	for i in get_children():
		var c_con = []
		if i.is_in_group("PuzzleNode"):
			for j in i.connections:
				c_con.append(j.get_index())
		if not c_con.is_empty():
			conn[str(i.get_index())] = c_con
	if not conn.is_empty():
		dict["connections"] = conn
		dict["solved"] = solved
		dict["correct"] = correct
	return dict
