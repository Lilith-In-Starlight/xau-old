extends Area2D

@export var BlockingLayer :Node2D
@export_range(0.0, 1.0) var goal :float = 0.0
@export var UnblockingLayer :Node2D
@export_range(0.0, 1.0) var anti_goal :float = 0.0
func _ready():
	if !BlockingLayer.visible:
		BlockingLayer.modulate.a = 0.0
		BlockingLayer.visible = true
	
	if UnblockingLayer != null and !UnblockingLayer.visible:
		UnblockingLayer.modulate.a = 0.0
		UnblockingLayer.visible = true


func _on_unblocker_body_entered(body):
	if BlockingLayer.modulate.a != goal:
		var tween = create_tween()
		tween.tween_property(BlockingLayer, "modulate:a", goal, 0.5)
		tween.play()
	if UnblockingLayer != null and UnblockingLayer.modulate.a != anti_goal:
		var tween = create_tween()
		tween.tween_property(UnblockingLayer, "modulate:a", anti_goal, 0.5)
		tween.play()
	
