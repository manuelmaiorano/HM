extends BTCondition


var detect_dead_body_component: DetectDeadBodyComponent
var npc_events: NpcEventsComponent

var is_dead_body_found = false

func _setup() -> void:
	npc_events = agent.get_meta("NpcEventsComponent") as NpcEventsComponent
	detect_dead_body_component = agent.get_meta("DetectDeadBodyComponent")
	detect_dead_body_component.dead_body_found.connect(on_detected_dead_body_npc)

func on_detected_dead_body_npc(_position: Vector3):
	is_dead_body_found = true
	blackboard.set_var("investigate_position", _position)
	npc_events.spotted_dead_body.emit()


func _tick(_delta: float) -> Status:
	if Globals.debug_ai:
		DebugDraw2D.set_text("is_dead_body_found", is_dead_body_found)
	if is_dead_body_found:
		return SUCCESS
	return FAILURE