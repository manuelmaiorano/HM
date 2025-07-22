extends BTCondition



var detect_player_component: DetectPlayerComponent
var health_component: HealthComponent
var npc_events: NpcEventsComponent

var is_getting_hurt_player_not_visible = false

func _setup() -> void:
	npc_events = agent.get_meta("NpcEventsComponent") as NpcEventsComponent
	detect_player_component = agent.get_meta("DetectPlayerComponent")
	health_component = agent.get_meta("HealthComponent") as HealthComponent
	health_component.health_reduced.connect(on_health_reduced)

func on_health_reduced(_health):
	if not detect_player_component.is_player_visible:
		is_getting_hurt_player_not_visible = true

func _tick(_delta: float) -> Status:
	if Globals.debug_ai:
		DebugDraw2D.set_text("is_getting_hurt_player_not_visible", is_getting_hurt_player_not_visible)
	if is_getting_hurt_player_not_visible:
		return SUCCESS
	return FAILURE