extends BTAction

var schedule_component: FollowScheduleComponent
var character_movement_component: CharacterMovementComponent

func _setup() -> void:
	schedule_component = agent.get_meta("FollowScheduleComponent")
	character_movement_component = agent.get_meta("CharacterMovementComponent")

func _enter() -> void:
	character_movement_component.set_navigation_target(Globals.places[schedule_component.current_schedule_action.location].navigation_position)


func _tick(_delta: float) -> Status:
	var navigation_complete = character_movement_component.navigate(_delta, character_movement_component.walk_speed)
	if navigation_complete:
		return SUCCESS
	return RUNNING