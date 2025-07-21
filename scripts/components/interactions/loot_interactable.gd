extends InteractableComponent
class_name LootInteractableComponent

@export_category("Nodes")
@export var inventory: InventoryComponent

@export_category("Parameters")
@export var character: CharacterBody3D
@export var clothes_component: ClothesComponent
@export var bone_to_drag: PhysicalBone3D
@export var interpolation_string = "Take %s"
@export var interpolation_string_clothes = "Take %s's clothes"
@export var drag_action: InteractionAction

func _ready() -> void:
	super._ready()
	get_parent().set_meta("LootInteractableComponent", self)

func get_actions() -> Array[InteractionAction]:
	var actions = [] as Array[InteractionAction]
	actions.append(drag_action)
	if clothes_component:
		var action = InteractionAction.new()
		action.id = 1
		action.desc = interpolation_string_clothes % clothes_component.current_clothes.name
		actions.append(action)

	for idx in inventory.current_items.size():
		var inventory_item = inventory.current_items[idx]
		var action = InteractionAction.new()
		if clothes_component:
			action.id = idx + 2
		else:
			action.id = idx + 1
		action.desc = interpolation_string % inventory_item.name
		actions.append(action)
	return actions

func execute_action(action: InteractionAction, agent: Node3D):
	if action.id == 0:
		if agent.has_meta("PlayerDraggingComponent"):
			var drag_component = agent.get_meta("PlayerDraggingComponent") as PlayerDraggingComponent
			drag_component.request_drag(bone_to_drag)
		return
	if agent.has_meta("InventoryComponent"):
		var agent_inventory = agent.get_meta("InventoryComponent") as InventoryComponent
		if clothes_component:
			if(action.id == 1):
				var agent_clothes = agent.get_meta("ClothesComponent") as ClothesComponent
				agent_clothes.change_clothes(clothes_component.current_clothes)
				clothes_component.change_clothes(null)
				clothes_component = null
			else:
				inventory.transfer_item(inventory.current_items[action.id - 2], agent_inventory)
		else:
			inventory.transfer_item(inventory.current_items[action.id - 1], agent_inventory)
