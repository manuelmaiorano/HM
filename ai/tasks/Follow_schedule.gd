extends BTAction


var schedule_component: FollowScheduleComponent
var current_action: ScheduleAction

func _setup() -> void:
	schedule_component = agent.get_meta("FollowScheduleComponent")
	schedule_component.action_changed.connect(on_action_changed)

func on_action_changed(action: ScheduleAction):
	current_action = action
	action._enter(agent)

func _tick(delta: float) -> Status:
	if not current_action:
		return RUNNING
	current_action._execute(delta)

	return RUNNING


