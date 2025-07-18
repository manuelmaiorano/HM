extends Node
class_name PlayerDraggingComponent



@export_category("Nodes")
@export var character: CharacterBody3D
@export var movement_component: CharacterMovementComponent
@export var camera: Camera3D
@export var yaw: Node3D

@export_category("Debug")
@export var enabled: bool = false:
	set(value):
		enabled = value
		if value:
			set_physics_process(true)
		else:
			set_physics_process(false)
		is_dragging_state_changed.emit(value)

signal is_dragging_state_changed(is_dragging: bool)
signal drag_requested

func _enter_tree() -> void:
	character.set_meta("PlayerDraggingComponent", self)

func _physics_process(delta: float) -> void:
	var movement_direction = Input.get_vector("forward", "back", "right", "left")

	var camera_basis : Basis = camera.global_basis
	var camera_z := camera_basis.z
	var camera_x := camera_basis.x

	camera_z.y = 0
	camera_z = camera_z.normalized()
	camera_x.y = 0
	camera_x = camera_x.normalized()
	
	var direction = - camera_x * movement_direction.y + camera_z * movement_direction.x
	
	movement_component.move(delta, direction, movement_component.walk_speed)

func request_drag():
	drag_requested.emit()

	
