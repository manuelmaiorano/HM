extends Node3D


func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("screenshot"):
		var img = get_viewport().get_texture().get_image()
		img.save_png("res://assets/minimaps/test_minimap.png")