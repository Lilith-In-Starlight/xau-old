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
			if raycast_collider.get_parent() == get_parent() or (!get_parent().framed and !raycast_collider.get_parent().framed):
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

