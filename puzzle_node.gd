@tool
extends StaticBody2D

class_name PuzzleNode

## A node in a [Puzzle].

@export var path := false
@export var allow_branch := false


@onready var cursor_node = get_tree().get_first_node_in_group("Cursor")
@onready var raycast: RayCast2D = $RayCast
@onready var blocadecast: RayCast2D = $BlockadeCast

var connections: Array[PuzzleNode] = []


func _ready():
	$PathMark.visible = path


func _process(delta):
	$PathMark.visible = path
	if not Engine.is_editor_hint():
		if cursor_node.position.distance_to(global_position) < 6:
			$Sprite2d.scale.x = 1.2
			$Sprite2d.scale.y = 1.2
		else:
			$Sprite2d.scale.x = 1.0
			$Sprite2d.scale.y = 1.0
		var count := 0
		var sum := 0
		if $Lines.get_child_count() < connections.size():
			for j in abs($Lines.get_child_count() - connections.size()):
				var new_line = Line2D.new()
				new_line.width = 2.0
				$Lines.add_child(new_line)
		if $Lines.get_child_count() > connections.size():
			for j in abs($Lines.get_child_count() - connections.size()):
				$Lines.remove_child($Lines.get_child(0))
				
		for i in connections.size():
			$Lines.get_child(i).points = [Vector2.ZERO, connections[i].global_position - global_position]
		
#		if cursor_node.connecting_from == self:
#			blocadecast.target_position = cursor_node.position - get_parent().position - position
#			blocadecast.force_raycast_update()
#			if !blocadecast.is_colliding():
#				$Lines.get_child(connections.size()).points = [Vector2.ZERO, cursor_node.position - global_position]
#			if blocadecast.is_colliding() and blocadecast.get_collider().is_in_group("PuzzleBarrier"):
#				$Lines.get_child(connections.size()).points = [Vector2.ZERO, blocadecast.get_collision_point() - get_parent().position - position]
#			else:
#				$Lines.get_child(connections.size()).points = [Vector2.ZERO, cursor_node.position - global_position]


func check() -> bool:
	if path:
		if connections.size() > 1:
			return false
		else:
			if connections.is_empty():
				return false
			var next_checks: Array[PuzzleNode] = [connections[0]]
			var already_checked: Array[PuzzleNode] = [self]
			while next_checks.size() > 0:
				var current_check = next_checks[0]
				if !current_check.path:
					already_checked.append(current_check)
					next_checks.remove_at(0)
					for i in current_check.connections:
						if not i in already_checked:
							next_checks.append(i)
				else:
					return true
			return false # if it gets here it's cuz it never found a goal
	return true


func show_failure():
	var tween := create_tween()
	tween.tween_property(self, "modulate:g", 0.0, 0.3)
	tween.parallel().tween_property(self, "modulate:b", 0.0, 0.3)
	tween.tween_property(self, "modulate:g", 1.0, 0.3)
	tween.parallel().tween_property(self, "modulate:b", 1.0, 0.3)
	tween.tween_property(self, "modulate:g", 0.0, 0.3)
	tween.parallel().tween_property(self, "modulate:b", 0.0, 0.3)
	tween.tween_property(self, "modulate:g", 1.0, 0.3)
	tween.parallel().tween_property(self, "modulate:b", 1.0, 0.3)
	tween.play()



func _input(delta):
	if get_parent().is_enabled():
		if Input.is_action_just_pressed("connect"):
			if cursor_node.position.distance_to(global_position) < 6:
				get_parent().correct = false
				if cursor_node.connecting_from == null:
					cursor_node.connecting_from = self
			elif cursor_node.connecting_from == self:
				connect_puzzle(cursor_node.position)


func connect_puzzle(target):
	raycast.target_position = target - global_position
	raycast.force_raycast_update()
	if raycast.is_colliding():
		var raycast_collider = raycast.get_collider()
		if raycast_collider.is_in_group("PuzzleNode"):
			if raycast_collider.get_parent().is_enabled():
				if not raycast_collider in connections:
					connections.append(raycast_collider)
					raycast_collider.connections.append(self)
					cursor_node.connecting_from = raycast_collider
					raycast_collider.connect_puzzle(target)
				else:
					connections.erase(raycast_collider)
					raycast_collider.connections.erase(self)
					cursor_node.connecting_from = raycast_collider
					raycast_collider.connect_puzzle(target)
	raycast.target_position = Vector2.ZERO

