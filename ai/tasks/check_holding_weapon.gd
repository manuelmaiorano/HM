extends BTCondition

var detect_player_component: DetectPlayerComponent
var player_inventory: InventoryComponent

func _setup() -> void:
	detect_player_component = agent.get_meta("DetectPlayerComponent")
	player_inventory = agent.get_tree().get_first_node_in_group("player").get_meta("InventoryComponent") as InventoryComponent


func _tick(_delta: float) -> Status:
	if detect_player_component.is_player_visible:
		if not player_inventory.item_in_use:
			return FAILURE
		if player_inventory.item_in_use.is_weapon:
			return SUCCESS
	return FAILURE
