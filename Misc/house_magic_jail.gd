extends StaticBody2D

## A jail that contains the player in it. It is opened once a required
## puzzle is solved

func _ready():
	$CollisionPolygon2d.disabled = $"../JailPuzzle".solved


func _process(delta):
	pass


## Called when the grid that opens this jail is solved
func _on_puzzle_grid_was_solved():
	$CollisionPolygon2d.disabled = true
	var tween := create_tween()
	tween.tween_property($JailOn, "modulate:a", 0.0, 0.1)
