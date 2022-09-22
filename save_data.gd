extends Node

const save_path := "user://savedata.xau"

var data := {}

var upid := {}

func _ready():
	var file := File.new()
	if File.file_exists(save_path):
		file.open(save_path, File.READ)
		data = JSON.parse_string(file.get_as_text())
		file.close()


func _input(event):
	if Input.is_action_just_pressed("confirm"):
		save()


func save():
	for i in get_tree().get_nodes_in_group("Puzzle"):
		var isave: Dictionary = i.save()
		if not isave.is_empty():
			data[str(i.get_path())] = i.save()
	
	for i in get_tree().get_first_node_in_group("World").get_children():
		data[str(i.get_path())] = i.modulate.a
		
	var file := File.new()
	data["player_pos_x"] = get_tree().get_first_node_in_group("Player").position.x
	data["player_pos_y"] = get_tree().get_first_node_in_group("Player").position.y
	file.open("user://savedata.xau", File.WRITE)
	file.store_string(JSON.stringify(data))
	file.close()


func _notification(what):
	if what == Window.NOTIFICATION_WM_CLOSE_REQUEST:
		save()
		get_tree().quit()
