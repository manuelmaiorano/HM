extends Node

@export var inventory: InventoryComponent



func _ready() -> void:
	Globals.SelectedItemToUse.connect(func (x): inventory.equip_item(x))
	Globals.PickedItem.connect(func (x): inventory.add_item(x))


func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("drop_item"):
		var item = inventory.drop_item()
		if item:
			Globals.DroppedItem.emit(item)
