extends Node
class_name InventoryInteractionComponent

@export var inventory: InventoryComponent


@export_category("Debug")
@export var enabled: bool:
	set(value):
		enabled = value
		if value:
			set_process_unhandled_input(true)
		else:
			set_process_unhandled_input(false)


func _enter_tree() -> void:
	Globals.SelectedItemToUse.connect(func (x): inventory.equip_item(x))
	Globals.PickedItem.connect(func (x): inventory.add_item(x))
	inventory.inventory_changed.connect(func(x): Globals.InventoryChanged.emit(x))


func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("drop_item"):
		var item = inventory.drop_item()
		if item:
			Globals.DroppedItem.emit(item)
