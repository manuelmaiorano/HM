extends Node
class_name CameraControl


@export_category("Nodes")
@export var pitch: Node3D
@export var yaw: Node3D

@export_category("Parameters")
@export var mouse_sensitivity:float = 0.002
@export var clamp_pitch_rotation: float = 80
@export var invert_x_axis = false:
	set(value):
		invert_x_axis = value
		if invert_x_axis:
			x_rotation_mult = -1
		else:
			x_rotation_mult = 1

var x_rotation_mult = 1

func _input(event:InputEvent) -> void:
	if not event is InputEventMouseMotion:
		return
		
	var mouse_movement:Vector2 = event.relative * mouse_sensitivity 
	
	pitch.rotation.x = clamp(pitch.rotation.x + x_rotation_mult * mouse_movement.y/2, -deg_to_rad(clamp_pitch_rotation), deg_to_rad(clamp_pitch_rotation) )
	yaw.rotate_y(-mouse_movement.x )