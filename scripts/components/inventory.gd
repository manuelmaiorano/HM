extends Node
class_name  InventoryComponent

@export_category("Nodes")
@export var character: Node3D
@export var drop_node: Node3D

@export_category("Parameters")
@export var initial_items: Array[InventoryItem]

@export_category("Debug")
@export var item_in_use: InventoryItem = null

signal inventory_changed(items: Array[InventoryItem])
signal item_in_use_changed(item: InventoryItem)

var current_items: Array[InventoryItem] = []

func _enter_tree() -> void:
	character.set_meta("InventoryComponent", self)

func _ready() -> void:
	current_items = initial_items.duplicate()
	if not current_items.is_empty():
		inventory_changed.emit(current_items)
	if item_in_use:
		item_in_use_changed.emit(item_in_use)

func equip_item(item: InventoryItem):
	item_in_use = item
	item_in_use_changed.emit(item_in_use)

func drop_item():
	if item_in_use == null:
		return null
	var item_dropped = item_in_use
	current_items.erase(item_in_use)
	var instance = load(item_in_use.scene_path).instantiate()
	character.get_parent().add_child(instance)
	instance.global_position = drop_node.global_position
	item_in_use = null
	item_in_use_changed.emit(item_in_use)
	return item_dropped

func add_item(item: InventoryItem):
	current_items.append(item)

func transfer_all_inventory(other_inventory: InventoryComponent):
	other_inventory.current_items = current_items
	current_items = []
	item_in_use = null
	inventory_changed.emit(current_items)
	item_in_use_changed.emit(item_in_use)
	other_inventory.inventory_changed.emit(other_inventory.current_items)


func transfer_item(item: InventoryItem, other_inventory: InventoryComponent):
	assert(current_items.has(item))
	other_inventory.current_items.append(item)
	current_items.erase(item)
	if item_in_use == item:
		item_in_use = null
		item_in_use_changed.emit(item_in_use)

	inventory_changed.emit(current_items)
	other_inventory.inventory_changed.emit(other_inventory.current_items)
