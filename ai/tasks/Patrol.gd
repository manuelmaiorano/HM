extends BTAction

@export var time_to_wait_on_patrol_point: float
@export var waiting_on_start: bool

var character_movement: CharacterMovementComponent
var patrol_points: Array

var current_patrol_point_idx = 0
var is_waiting = true
var time_passed = 0.0

func _setup() -> void:
	character_movement = agent.get_meta("CharacterMovementComponent")
	patrol_points = agent.get_meta("PatrolPointRegistrationComponent").patrol_points
	blackboard.set_var("current_patrol_point_idx", 0)

func _enter() -> void:
	is_waiting = waiting_on_start
	current_patrol_point_idx = blackboard.get_var("current_patrol_point_idx")
	if patrol_points.is_empty():
		return
	character_movement.set_navigation_target(patrol_points[current_patrol_point_idx].global_position)

func _exit() -> void:
	blackboard.set_var("current_patrol_point_idx", current_patrol_point_idx)

func _tick(delta: float) -> Status:
	if patrol_points.is_empty():
		character_movement.stand_idle(delta)
		return RUNNING
	if is_waiting:
		character_movement.stand_idle(delta)
		time_passed += delta
		if time_passed >= time_to_wait_on_patrol_point:
			is_waiting = false
			time_passed = 0.0
	else:
		var navigation_finished = character_movement.navigate(delta, character_movement.walk_speed)
		if navigation_finished:
			is_waiting = true
			var new_patrol_point_idx = (current_patrol_point_idx + 1) % patrol_points.size()
			if new_patrol_point_idx != current_patrol_point_idx:
				current_patrol_point_idx = new_patrol_point_idx
				character_movement.set_navigation_target(patrol_points[current_patrol_point_idx].global_position)
			else:
				is_waiting = true

	return RUNNING
