extends Button
class_name InventoryItemButton

@export var inventory_item: InventoryItem:
	set(value):
		inventory_item = value
		if value == null:
			text = "Holster"
			return
		text = inventory_item.name

@export var item_name: String:
	get():
		if inventory_item:
			return inventory_item.name
		else:
			return "Holster"
