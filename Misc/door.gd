extends Node2D


@export var requirements := 1

@onready var player_node: CharacterBody2D = get_tree().get_first_node_in_group("Player")

var met_requirements := 0

func _process(delta):
	if player_node.global_position.distance_to(global_position) < 60:
		if player_node.global_position.y < global_position.y and z_index != 2:
			z_index = 2
		elif player_node.global_position.y > global_position.y and z_index != 1:
			z_index = 1

func _on_required_was_solved():
	met_requirements += 1
	if met_requirements == requirements:
		$Sprite.play("default")


func _on_sprite_animation_finished():
	$Collision/CollisionShape2d.disabled = true
