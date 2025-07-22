extends BTCondition


var restricted_area_component: RestrictedAreaRegistrationComponent
var npc_events: NpcEventsComponent

var is_suspicious_action_in_restricted_area: bool = false

func _setup() -> void:
	npc_events = agent.get_meta("NpcEventsComponent") as NpcEventsComponent
	restricted_area_component = agent.get_meta("RestrictedAreaRegistrationComponent")
	restricted_area_component.player_caught.connect(on_restricted_area_action)

func on_restricted_area_action():
	is_suspicious_action_in_restricted_area = true
	npc_events.player_suspicious_action.emit()


func _tick(_delta: float) -> Status:
	if is_suspicious_action_in_restricted_area:
		return SUCCESS
	return FAILURE
