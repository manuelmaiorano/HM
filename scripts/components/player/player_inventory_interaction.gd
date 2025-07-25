extends Node
class_name PlayerInventoryInteractionComponent

@export var inventory: InventoryComponent


@export_category("Debug")
@export var enabled: bool = true:
	set(value):
		enabled = value
		if value:
			set_process_unhandled_input(true)
		else:
			set_process_unhandled_input(false)


func _enter_tree() -> void:
	Globals.SelectedItemToUse.connect(func (x): inventory.equip_item(x))
	inventory.item_added.connect(func (x): Globals.PickedItem.emit(x))
	inventory.inventory_changed.connect(func(x, idx): Globals.InventoryChanged.emit(x, idx))
	inventory.ammo_info_changed.connect(func (magazine, remaining): Globals.AmmoChanged.emit(magazine, remaining))


func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("drop_item"):
		var item = inventory.drop_item()
		if item:
			Globals.DroppedItem.emit(item)
