extends BTAction

var detect_interactables_component: DetectInteractablesComponent
var schedule_component: FollowScheduleComponent


func _setup() -> void:
	detect_interactables_component = agent.get_meta("DetectInteractablesComponent")
	schedule_component = agent.get_meta("FollowScheduleComponent")

func _enter() -> void:
	detect_interactables_component.pick_random_interactable(schedule_component.current_schedule_action.action_tag)


func _tick(_delta: float) -> Status:
	if detect_interactables_component.current_interactable:
		return SUCCESS
	else:
		return FAILURE