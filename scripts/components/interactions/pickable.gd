extends Node
class_name PickableComponent

@export var agent: Node3D
@export var inventory_item: InventoryItem

func pick() -> InventoryItem:
	agent.queue_free()
	Globals.PickedItem.emit(inventory_item)
	return inventory_item
