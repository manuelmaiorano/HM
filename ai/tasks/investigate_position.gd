extends BTAction

var character_movement: CharacterMovementComponent


@export var time_to_stop_investigating: float = 100.0

var time_entered = 0.0
var position_to_investigate

func _enter() -> void:
	time_entered = Globals.get_timestamp_seconds()
	position_to_investigate = blackboard.get_var("investigate_position")

func _exit() -> void:
	pass

func _setup() -> void:
	character_movement = agent.get_meta("CharacterMovementComponent")


func _tick(delta: float) -> Status:

	if Globals.get_elapsed_seconds(time_entered) > time_to_stop_investigating:
		return FAILURE

	character_movement.set_navigation_target(position_to_investigate)
	var navigation_finished = character_movement.navigate(delta, character_movement.run_speed)
	if navigation_finished:
		character_movement.stand_idle(delta)
	return RUNNING

