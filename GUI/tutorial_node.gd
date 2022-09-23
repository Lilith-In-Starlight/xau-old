extends Node2D

var stage := 0

@onready var player_node: CharacterBody2D = get_tree().get_first_node_in_group("Player")
@onready var cursor_node = get_tree().get_first_node_in_group("Cursor")

func _ready():
	if SaveData.upid.has("tutorial_puzzle"):
		if SaveData.upid["tutorial_puzzle"].solved:
			var tween := create_tween()
			tween.tween_property($Space, "modulate:a", 0.0, 0.2)
			tween.play()
			stage = 4

func _input(event):
	match stage:
		0:
			if Input.is_action_just_pressed("confirm"):
				var tween := create_tween()
				tween.tween_property($Space, "modulate:a", 0.0, 0.2)
				tween.tween_property($ClickHold, "modulate:a", 1.0, 0.2)
				tween.play()
				stage = 1
			
			if SaveData.upid.has("tutorial_puzzle"):
				if SaveData.upid["tutorial_puzzle"].check_correct():
					var tween := create_tween()
					tween.tween_property($Space, "modulate:a", 1.0, 0.2)
					tween.play()
					stage = 2
		1:
			if SaveData.upid.has("tutorial_puzzle"):
				if SaveData.upid["tutorial_puzzle"].check_correct():
					var tween := create_tween()
					tween.tween_property($Space, "modulate:a", 1.0, 0.2)
					tween.tween_property($ClickHold, "modulate:a", 0.0, 0.2)
					tween.play()
					stage = 2
		2:
			if SaveData.upid["tutorial_puzzle"].solved:
				var tween := create_tween()
				tween.tween_property($Space, "modulate:a", 0.0, 0.2)
				tween.tween_property($Wasd, "modulate:a", 1.0, 0.2)
				tween.play()
				stage = 3
		3:
			if player_node.global_position.distance_to(Vector2(150, 90)) > 30:
				var tween := create_tween()
				tween.tween_property($Wasd, "modulate:a", 0.0, 0.2)
				tween.play()
				stage = 4
