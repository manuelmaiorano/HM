extends Node
class_name InventoryUiComponent

@export_category("Nodes")
@export var current_item_label: Label
@export var all_items: VBoxContainer
@export var scroll_component: ScrollItemsComponent

@export_category("Parameters")
@export var item_scene: PackedScene

var no_item_button = null

func _enter_tree() -> void:
	no_item_button = on_item_pickup(null)
	all_items.hide()
	Globals.PickedItem.connect(on_item_pickup)
	Globals.DroppedItem.connect(on_item_drop)
	Globals.InventoryChanged.connect(on_inventory_changed)
	scroll_component.current_index_changed.connect(func(idx): all_items.get_child(idx).grab_focus())

func on_inventory_changed(items: Array[InventoryItem]):
	for child in all_items.get_children():
		if child == no_item_button:
			continue
		child.queue_free()
	for item in items:
		on_item_pickup(item)

func update_scroll_active():
	scroll_component.active = Globals.current_ui_element_active == Globals.UiElementActive.InventoryMenu

func on_item_pickup(item: InventoryItem):
	var item_button = item_scene.instantiate()
	item_button.inventory_item = item
	all_items.add_child(item_button)
	return item_button

func on_item_drop(item: InventoryItem):
	for child in all_items.get_children():
		if child.inventory_item == item:
			child.queue_free()
			var current_item = all_items.get_child(scroll_component.current_index)
			Globals.SelectedItemToUse.emit(current_item.inventory_item)
			current_item_label.text = current_item.inventory_item.name


func _input(event):
	if Globals.current_ui_element_active == Globals.UiElementActive.None:
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_WHEEL_UP or event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
					Globals.current_ui_element_active = Globals.UiElementActive.InventoryMenu
					update_scroll_active()
					all_items.show()
	
	if Globals.current_ui_element_active == Globals.UiElementActive.InventoryMenu:
		if Input.is_action_just_pressed("interact"):
			Globals.current_ui_element_active = Globals.UiElementActive.None
			update_scroll_active()
			all_items.hide()

	if Input.is_action_just_pressed("execute_action") and Globals.current_ui_element_active == Globals.UiElementActive.InventoryMenu:
		var items = all_items.get_children()
		if not items.is_empty():
			var current_item = all_items.get_child(scroll_component.current_index)
			Globals.SelectedItemToUse.emit(current_item.inventory_item)
			if current_item.inventory_item:
				current_item_label.text = current_item.inventory_item.name
			Globals.current_ui_element_active = Globals.UiElementActive.None
			Globals.UiElementActiveChanged.emit()
			get_viewport().set_input_as_handled()
			update_scroll_active()
			all_items.hide()
