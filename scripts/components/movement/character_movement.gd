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

@export_category("Debug")
@export var current_navigation_target: Vector3 = Vector3.ZERO
@export var moving_through_link: bool = false
@export var current_link_component: NavigationLinkCrossingComponent
var tolerance = 0.1

func _enter_tree() -> void:
	character.set_meta("CharacterMovementComponent", self)
	
func _ready() -> void:
	if navigation_agent:
		navigation_agent.link_reached.connect(on_link_reached)
		navigation_agent.velocity_computed.connect(Callable(_on_velocity_computed))

func on_link_reached(link_info: Dictionary):
	current_link_component = link_info["owner"].get_meta("NavigationLinkCrossingComponent")
	assert(current_link_component != null)
	moving_through_link = true
	current_link_component.on_link_enter(character)

func set_navigation_target(movement_target: Vector3):
	if navigation_agent:
		if current_navigation_target.distance_squared_to(movement_target) > tolerance:
			navigation_agent.set_target_position(movement_target)
			current_navigation_target = movement_target
	if moving_through_link:
		moving_through_link = false
		current_link_component.on_link_abort(character)

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
	position.y = character.global_position.y
	var direction = character.global_position.direction_to(position)
	DebugDraw3D.draw_line(character.global_position + Vector3.UP, character.global_position + Vector3.UP + direction) 
	move(delta, direction, speed)
	rotateModelTowards(delta, direction)

func stand_idle(delta: float):
	move(delta, Vector3.ZERO, walk_speed)


func navigate(delta: float, speed: float) -> bool:
	if NavigationServer3D.map_get_iteration_id(navigation_agent.get_navigation_map()) == 0:
		return true

	if navigation_agent.is_navigation_finished():
		return true

	var next_path_position: Vector3 = navigation_agent.get_next_path_position()
	if moving_through_link:
		if current_link_component.move_through_link(delta, self, next_path_position, speed):
			moving_through_link = false
			current_link_component.on_link_exit(character)
			return false
		return false

	if navigation_agent.avoidance_enabled:
		return false
		#navigation_agent.set_velocity(character.global_position.direction_to(position) * speed)
	else:
		move_to(delta, next_path_position, speed)
	
	return false

func rotateModelTowards(delta: float, direction: Vector3):
	if direction.is_zero_approx():
		return
	var q_from = character_model.global_basis.get_rotation_quaternion()
	var q_to = Transform3D().looking_at(-direction, Vector3.UP).basis.get_rotation_quaternion()
	# Interpolate current rotation with desired one.
	character_model.global_basis = Basis(q_from.slerp(q_to, delta * rotation_speed))


func rotateModelTowardsTweened(direction: Vector3, duration: float):
	if direction.is_zero_approx():
		return
	var tween = get_tree().create_tween()
	var q_from = character_model.global_basis.get_rotation_quaternion()
	var q_to = Transform3D().looking_at(-direction, Vector3.UP).basis.get_rotation_quaternion()
	tween.tween_method(func(weight): character_model.global_basis = Basis(q_from.slerp(q_to, weight)), 0.0, 1.0, duration)
