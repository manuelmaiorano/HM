extends Node
class_name InventoryUiComponent

@export_category("Nodes")
@export var current_item_label: Label
@export var current_ammo_label: Label
@export var all_items: VBoxContainer
@export var scroll_component: ScrollItemsComponent

@export_category("Parameters")
@export var item_scene: PackedScene

var no_item_button = null

func _enter_tree() -> void:
	get_parent().set_meta("InventoryManager", self)
	no_item_button = on_item_pickup(null)
	all_items.hide()
	Globals.PickedItem.connect(on_item_pickup)
	Globals.DroppedItem.connect(on_item_drop)
	Globals.InventoryChanged.connect(on_inventory_changed)
	Globals.AmmoChanged.connect(on_ammo_changed)
	scroll_component.current_index_changed.connect(func(idx): all_items.get_child(idx).grab_focus())

func on_ammo_changed(item: InventoryItem, current_ammo: int, total_ammo: int):
	if item == null:
		current_ammo_label.text = ""
		return
	current_ammo_label.text = "%s/%s" % [current_ammo, total_ammo]

func on_inventory_changed(items: Array[InventoryItem]):
	for child in all_items.get_children():
		if child == no_item_button:
			continue
		child.queue_free()
	for item in items:
		on_item_pickup(item)

func on_item_pickup(item: InventoryItem):
	var item_button = item_scene.instantiate()
	item_button.inventory_item = item
	all_items.add_child(item_button)
	return item_button

func on_item_drop(item: InventoryItem):
	for child in all_items.get_children():
		if child.inventory_item == item:
			child.queue_free()
			scroll_component.current_index = 0
			var current_item = all_items.get_child(scroll_component.current_index)
			Globals.SelectedItemToUse.emit(-1)
			current_item_label.text = current_item.item_name
			return

func scroll(event):
	scroll_component.scroll(event)

func select_invetory_item():
	var items = all_items.get_children()
	if not items.is_empty():
		var current_item = all_items.get_child(scroll_component.current_index)
		Globals.SelectedItemToUse.emit(scroll_component.current_index-1)
		current_item_label.text = current_item.item_name

func change_visibility(visibile):
	if visibile:
		all_items.show()
	else:
		all_items.hide()