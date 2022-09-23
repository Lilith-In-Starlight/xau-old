extends Line2D


@export var on_color := Color("#72ffdf")
@export var off_color := Color("#588b86")
@export var required_puzzle :Node2D

func _ready():
	default_color = off_color
	if required_puzzle != null:
		required_puzzle.was_solved.connect(_on_required_was_solved)

func _on_required_was_solved():
	var tween = create_tween()
	tween.tween_property(self, "default_color", on_color, 0.3)
	tween.play()
