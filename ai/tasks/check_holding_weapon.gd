extends BTCondition

var detect_player_component: DetectPlayerComponent
var player_inventory: InventoryComponent
var npc_events: NpcEventsComponent

var is_player_holding_weapon = false

func _setup() -> void:
	npc_events = agent.get_meta("NpcEventsComponent") as NpcEventsComponent
	detect_player_component = agent.get_meta("DetectPlayerComponent")
	player_inventory = agent.get_tree().get_first_node_in_group("player").get_meta("InventoryComponent") as InventoryComponent
	detect_player_component.player_visibility_changed.connect(on_visibility_changed)
	player_inventory.item_in_use_changed.connect(on_item_in_use_changed)

func on_item_in_use_changed(item: InventoryItem):
	if detect_player_component.is_player_visible:
		if item.is_weapon:
			is_player_holding_weapon = true
			npc_events.player_is_holding_weapon.emit()

func on_visibility_changed(is_visible: bool):
	if is_visible:
		if not player_inventory.item_in_use:
			return
		if player_inventory.item_in_use.is_weapon:
			is_player_holding_weapon = true
			npc_events.player_is_holding_weapon.emit()


func _tick(_delta: float) -> Status:
	if Globals.debug_ai:
		DebugDraw2D.set_text("is_player_holding_weapon", is_player_holding_weapon)
	if is_player_holding_weapon:
		return SUCCESS
	return FAILURE
