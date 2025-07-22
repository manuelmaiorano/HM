extends BTAction


var character_movement: CharacterMovementComponent
var character_alarm: CommunicateAlarmComponent


func _setup() -> void:
	character_movement = agent.get_meta("CharacterMovementComponent")
	character_alarm = agent.get_meta("CommunicateAlarmComponent")

func _enter() -> void:
	character_alarm.set_alarmed(agent.global_position)
	var exit = Globals.exits.pick_random()
	character_movement.set_navigation_target(exit.navigation_position)

func _exit() -> void:
	return

func _tick(delta: float) -> Status:
	var navigation_finished = character_movement.navigate(delta, character_movement.run_speed)
	if navigation_finished:
		return SUCCESS
	return RUNNING

