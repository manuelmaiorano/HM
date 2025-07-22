extends Node


@export var npcs_initial_inventories: Dictionary[CharacterBody3D, Array]
@export var npcs_initial_item_in_use: Dictionary[CharacterBody3D, InventoryItem]

func _ready() -> void:
	for npc in npcs_initial_inventories.keys():
		var inventory = npc.get_meta("InventoryComponent") as InventoryComponent
		inventory.assign_initial_items(npcs_initial_inventories[npc])
	
	for npc in npcs_initial_item_in_use.keys():
		var inventory = npc.get_meta("InventoryComponent") as InventoryComponent
		inventory.item_in_use = npcs_initial_item_in_use[npc]

	