extends Node
class_name  InventoryComponent

@export_category("Nodes")
@export var character: CharacterBody3D
@export var drop_node: Node3D

@export_category("Parameters")
@export var initial_items: Array[InventoryItem]

signal item_in_use_changed(item: InventoryItem)


@export_category("Debug")
@export var item_in_use: InventoryItem = null

var current_items: Array[InventoryItem] = []


func _ready() -> void:
	current_items = initial_items
	Globals.SelectedItemToUse.connect(func (x): item_in_use = x; item_in_use_changed.emit(item_in_use))
	Globals.PickedItem.connect(func (x): add_item(x))

func drop_item():
	if item_in_use == null:
		return
	current_items.erase(item_in_use)
	Globals.DroppedItem.emit(item_in_use)
	var instance = load(item_in_use.scene_path).instantiate()
	character.get_parent().add_child(instance)
	instance.global_position = drop_node.global_position
	item_in_use = null
	item_in_use_changed.emit(item_in_use)

func add_item(item: InventoryItem):
	current_items.append(item)

func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("drop_item"):
		drop_item()
