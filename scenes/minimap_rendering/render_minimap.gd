extends Node3D



var idx = 1
func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("screenshot"):
		var img = get_viewport().get_texture().get_image()
		img.save_png("res://assets/screenshot%s.png" % idx)
		idx += 1