extends BTCondition




var detect_dead_body_component: DetectDeadBodyComponent
var detect_player_component: DetectPlayerComponent
var npc_events: NpcEventsComponent

var is_dead_body_found_near_player = false

func _setup() -> void:
	npc_events = agent.get_meta("NpcEventsComponent") as NpcEventsComponent
	detect_dead_body_component = agent.get_meta("DetectDeadBodyComponent")
	detect_player_component = agent.get_meta("DetectPlayerComponent")
	detect_dead_body_component.dead_body_found.connect(on_detected_dead_body_npc)

func on_detected_dead_body_npc(position: Vector3):
	if detect_player_component.is_player_visible:
		npc_events.player_near_dead_body.emit()
		is_dead_body_found_near_player = true


func _tick(_delta: float) -> Status:
	if Globals.debug_ai:
		DebugDraw2D.set_text("is_dead_body_found_near_player", is_dead_body_found_near_player)
	if is_dead_body_found_near_player:
		return SUCCESS
	return FAILURE