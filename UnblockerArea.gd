extends Area2D

@export var BlockingLayer :NodePath
@export_range(0.0, 1.0) var goal :float = 0.0
@onready var BlockingNode := get_node(BlockingLayer)
func _ready():
	if !BlockingNode.visible:
		BlockingNode.modulate.a = 0.0
	BlockingNode.visible = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_unblocker_body_entered(body):
	if BlockingNode.modulate.a != goal:
		var tween = create_tween()
		tween.tween_property(BlockingNode, "modulate:a", goal, 0.5)
		tween.play()
	
