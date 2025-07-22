extends BTCondition

var detect_alarm_component: DetectAlarmedNpcComponent
var npc_events: NpcEventsComponent
var detect_player_component: DetectPlayerComponent


var is_alarmed_npc_detected_near_player = false

func _setup() -> void:
	detect_alarm_component = agent.get_meta("DetectAlarmedNpcComponent")
	npc_events = agent.get_meta("NpcEventsComponent") as NpcEventsComponent
	detect_player_component = agent.get_meta("DetectPlayerComponent")
	detect_alarm_component.detected_alarmed_npc.connect(on_detected_alarmed_npc)

func on_detected_alarmed_npc(_position: Vector3):
	if detect_player_component.is_player_visible:
		is_alarmed_npc_detected_near_player = true
		npc_events.player_suspicious_action.emit()



func _tick(_delta: float) -> Status:
	if Globals.debug_ai:
		DebugDraw2D.set_text("is_alarmed_npc_detected_near_player", is_alarmed_npc_detected_near_player)
	if is_alarmed_npc_detected_near_player:
		return SUCCESS
	return FAILURE