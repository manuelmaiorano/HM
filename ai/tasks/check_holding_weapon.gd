extends BTCondition

var detect_player_component: DetectPlayerComponent
var player_inventory: InventoryComponent

var is_player_holding_weapon = false

func _setup() -> void:
	detect_player_component = agent.get_meta("DetectPlayerComponent")
	player_inventory = agent.get_tree().get_first_node_in_group("player").get_meta("InventoryComponent") as InventoryComponent
	detect_player_component.player_visibility_changed.connect(on_visibility_changed)


func on_visibility_changed(is_visible: bool):
	if is_visible:
		if not player_inventory.item_in_use:
			return
		if player_inventory.item_in_use.is_weapon:
			is_player_holding_weapon = true


func _tick(_delta: float) -> Status:
	if Globals.debug_ai:
		DebugDraw2D.set_text("is_player_holding_weapon", is_player_holding_weapon)
	if is_player_holding_weapon:
		return SUCCESS
	return FAILURE
