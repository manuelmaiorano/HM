extends BTCondition



var schedule_component: FollowScheduleComponent

var should_change_schedule = false

func _setup() -> void:
	schedule_component = agent.get_meta("FollowScheduleComponent")
	schedule_component.action_changed.connect(on_schedule_action_changed)

func on_schedule_action_changed(_action):
	should_change_schedule = true


func _tick(_delta: float) -> Status:
	if should_change_schedule:
		should_change_schedule = false
		return SUCCESS
	else:
		return FAILURE