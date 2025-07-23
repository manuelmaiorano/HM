extends Node
class_name SniperZoomControl

@export_category("Nodes")
@export var camera: Camera3D

# Adjustable variables
@export_category("Parameters")
@export var min_fov: float = 5.0   # Narrowest FOV (highest zoom)
@export var max_fov: float = 70.0  # Widest FOV (normal view)
@export var zoom_speed: float = 2.0


@export_category("Debug")
@export var enabled: bool = true:
	set(value):
		enabled = value
		if value:
			set_process_unhandled_input(true)
			camera.fov = max_fov
		else:
			set_process_unhandled_input(false)

var rotation_x := 0.0
var rotation_y := 0.0

func _ready():
	camera.fov = max_fov

func _unhandled_input(event):
    
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP and event.pressed:
			camera.fov = max(min_fov, camera.fov - zoom_speed)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.pressed:
			camera.fov = min(max_fov, camera.fov + zoom_speed)