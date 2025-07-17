extends InteractableComponent
class_name LootInteractableComponent

@export_category("Nodes")
@export var inventory: InventoryComponent

@export_category("Parameters")
@export var clothes_component: ClothesComponent
@export var interpolation_string = "Take %s"
@export var interpolation_string_clothes = "Take %s's clothes"

func _ready() -> void:
	super._ready()
	get_parent().set_meta("LootInteractableComponent", self)

func get_actions() -> Array[InteractionAction]:
	var actions = [] as Array[InteractionAction]
	if clothes_component:
		var action = InteractionAction.new()
		action.id = 0
		action.desc = interpolation_string_clothes % clothes_component.current_clothes.name
		actions.append(action)

	for idx in inventory.current_items.size():
		var inventory_item = inventory.current_items[idx]
		var action = InteractionAction.new()
		if clothes_component:
			action.id = idx + 1
		else:
			action.id = idx
		action.desc = interpolation_string % inventory_item.name
		actions.append(action)
	return actions

func execute_action(action: InteractionAction, agent: Node3D):
	if agent.has_meta("InventoryComponent"):
		var agent_inventory = agent.get_meta("InventoryComponent") as InventoryComponent
		if clothes_component:
			if(action.id == 0):
				var agent_clothes = agent.get_meta("ClothesComponent") as ClothesComponent
				agent_clothes.change_clothes(clothes_component.current_clothes)
				clothes_component.change_clothes(null)
				clothes_component = null
			else:
				inventory.transfer_item(inventory.current_items[action.id-1], agent_inventory)
		else:
			inventory.transfer_item(inventory.current_items[action.id], agent_inventory)
