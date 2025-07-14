extends Node
class_name CharacterMovementComponent

### CHARACTER MODEL FACING Z AXIS

@export_category("Nodes")
@export var character: CharacterBody3D
@export var character_model: Node3D
@export var navigation_agent: NavigationAgent3D

@export_category("Parameters")
@export var walk_speed: float = 2.0
@export var run_speed: float = 4.0
@export var rotation_speed: float = 5.0

var current_navigation_target: Vector3 = Vector3.ZERO

func _ready() -> void:
	if navigation_agent:
		navigation_agent.velocity_computed.connect(Callable(_on_velocity_computed))

func set_navigation_target(movement_target: Vector3):
	if navigation_agent:
		navigation_agent.set_target_position(movement_target)

func _on_velocity_computed(safe_velocity: Vector3):
	character.velocity = safe_velocity
	rotateModelTowards(get_physics_process_delta_time(), character.global_position + safe_velocity)
	character.move_and_slide()

func move(delta: float, direction: Vector3, speed: float):
	character.velocity.x = move_toward(character.velocity.x, direction.x * speed, speed)
	character.velocity.z = move_toward(character.velocity.z, direction.z * speed, speed)
	character.velocity += character.get_gravity() * delta
	character.move_and_slide()

func move_to(delta: float, position: Vector3, speed: float):
	var direction = character.global_position.direction_to(position)
	rotateModelTowards(delta, direction)
	move(delta, direction, speed)

func navigateTo(delta: float, position: Vector3, speed: float):
	if NavigationServer3D.map_get_iteration_id(navigation_agent.get_navigation_map()) == 0:
		return

	if navigation_agent.is_navigation_finished():
		return

	var next_path_position: Vector3 = navigation_agent.get_next_path_position()
	if navigation_agent.avoidance_enabled:
		navigation_agent.set_velocity(character.global_position.direction_to(position) * speed)
	else:
		move_to(delta, next_path_position, speed)

func rotateModelTowards(delta: float, direction: Vector3):
	if direction.is_zero_approx():
		return
	var q_from = character_model.global_basis.get_rotation_quaternion()
	var q_to = Transform3D().looking_at(-direction, Vector3.UP).basis.get_rotation_quaternion()
	# Interpolate current rotation with desired one.
	character_model.global_basis = Basis(q_from.slerp(q_to, delta * rotation_speed))