extends BTCondition

var schedule_component: FollowScheduleComponent

func _setup() -> void:
	schedule_component = agent.get_meta("FollowScheduleComponent")


func _tick(_delta: float) -> Status:
	if schedule_component.current_schedule_action == null:
		return FAILURE
	return SUCCESS