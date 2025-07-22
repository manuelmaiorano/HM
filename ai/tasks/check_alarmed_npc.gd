extends BTCondition

var detect_alarm_component: DetectAlarmedNpcComponent
var npc_events: NpcEventsComponent

var is_alarmed_npc_detected = false

func _setup() -> void:
	detect_alarm_component = agent.get_meta("DetectAlarmedNpcComponent")
	npc_events = agent.get_meta("NpcEventsComponent") as NpcEventsComponent
	detect_alarm_component.detected_alarmed_npc.connect(on_detected_alarmed_npc)

func on_detected_alarmed_npc(_position: Vector3):
	is_alarmed_npc_detected = true
	npc_events.spotted_alarmed_npc.emit()
	blackboard.set_var("investigate_position", _position)



func _tick(_delta: float) -> Status:
	if Globals.debug_ai:
		DebugDraw2D.set_text("is_alarmed_npc_detected", is_alarmed_npc_detected)
	if is_alarmed_npc_detected:
		return SUCCESS
	return FAILURE