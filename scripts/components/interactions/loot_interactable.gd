extends InteractableComponent
class_name LootInteractableComponent

@export var inventory: InventoryComponent

@export var interpolation_string = "Take %s"

func _ready() -> void:
	super._ready()
	get_parent().set_meta("LootInteractableComponent", self)

func get_actions() -> Array[InteractionAction]:
	var actions = [] as Array[InteractionAction]
	for idx in inventory.current_items.size():
		var inventory_item = inventory.current_items[idx]
		var action = InteractionAction.new()
		action.id = idx
		action.desc = interpolation_string % inventory_item.name
		actions.append(action)
	return actions

func execute_action(action: InteractionAction, agent: Node3D):
	if agent.has_meta("InventoryComponent"):
		var agent_inventory = agent.get_meta("InventoryComponent") as InventoryComponent
		inventory.transfer_item(inventory.current_items[action.id], agent_inventory)
