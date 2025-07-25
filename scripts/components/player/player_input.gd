extends Node
class_name PlayerInputComponent

@export_category("Nodes")
@export var character: CharacterBody3D
@export var movement_component: CharacterMovementComponent
@export var camera: Camera3D
@export var yaw: Node3D

@export_category("Debug")
@export var enabled: bool = true:
	set(value):
		enabled = value
		if value:
			set_physics_process(true)
			process_mode = Node.PROCESS_MODE_INHERIT
		else:
			set_physics_process(false)
			process_mode = Node.PROCESS_MODE_DISABLED

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
	
	if Input.is_action_pressed("sprint"):
		movement_component.move(delta, direction, movement_component.run_speed)
	else:
		movement_component.move(delta, direction, movement_component.walk_speed)

	movement_component.rotateModelTowards(delta, yaw.global_basis.z)
	#movement_component.rotateModelTowards(delta, direction)
