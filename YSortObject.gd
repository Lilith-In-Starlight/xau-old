extends Sprite2D

@onready var player_node: CharacterBody2D = get_tree().get_first_node_in_group("Player")

func _process(delta):
	if player_node.position.y < position.y and z_index != 1:
		z_index = 1
	elif player_node.position.y > position.y and z_index != 0:
		z_index = 0
