extends Node
class_name InventoryUiComponent

@export var current_item_label: Label
@export var all_items: VBoxContainer
@export var scroll_component: ScrollItemsComponent

var active = false:
	set(value):
		active = value
		all_items.visible = active

func _ready() -> void:
	Globals.PickedItem.connect(on_item_pickup)
	Globals.DroppedItem.connect(on_item_drop)
	Globals.Interactions.connect(on_interactions_update)
	scroll_component.current_index_changed.connect(func(idx): all_items.get_child(idx).grab_focus())

func on_interactions_update(actions: Array[InteractionAction]):
	active = actions.is_empty()


func on_item_pickup(item: InventoryItem):
	var item_button = InventoryItemButton.new()
	item_button.inventory_item = item
	all_items.add_child(item_button)

func on_item_drop(item: InventoryItem):
	for child in all_items.get_children():
		if child.inventory_item == item:
			child.queue_free()
			scroll_component.current_index = 0
			current_item_label.text = "No item"


func _input(event):
	if not active:
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_WHEEL_UP or event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
					active = true
	
	if active:
		if Input.is_action_just_pressed("interact"):
			active = false

	if Input.is_action_just_pressed("execute_action") and active:
		var items = all_items.get_children()
		if not items.is_empty():
			var current_item = all_items.get_child(scroll_component.current_index)
			Globals.SelectedItemToUse.emit(current_item.inventory_item)
			current_item_label.text = current_item.inventory_item.name
