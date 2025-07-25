extends Node


@export var npc_roles: Dictionary[CharacterBody3D, NpcRole]


func _ready() -> void:
	for npc in npc_roles:
		var role = npc_roles[npc]

		var inventory = npc.get_meta("InventoryComponent") as InventoryComponent
		inventory.assign_initial_items(role.initial_inventory)
		inventory.item_in_use = role.item_in_use

		var bt_component = npc.get_meta("BehaviourTreeManagerComponent") as BehaviourTreeManagerComponent
		bt_component.update_behaviour_tree(role.behaviour_tree)

		var shouts_component = npc.get_meta("NpcShoutsComponent") as NpcShoutsComponent
		shouts_component.shouts = role.shouts

		var clothes_component = npc.get_meta("ClothesComponent") as ClothesComponent
		clothes_component.initial_clothes = role.initial_clothes

		if role.initial_base_mesh != null:
			clothes_component.set_base_mesh(role.initial_base_mesh)

	