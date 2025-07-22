extends BTCondition


var detect_dead_body_component: DetectDeadBodyComponent

var is_dead_body_found = false

func _setup() -> void:
	detect_dead_body_component = agent.get_meta("DetectDeadBodyComponent")
	detect_dead_body_component.dead_body_found.connect(on_detected_dead_body_npc)

func on_detected_dead_body_npc(_position: Vector3):
	is_dead_body_found = true


func _tick(_delta: float) -> Status:
	if Globals.debug_ai:
		DebugDraw2D.set_text("is_dead_body_found", is_dead_body_found)
	if is_dead_body_found:
		return SUCCESS
	return FAILURE