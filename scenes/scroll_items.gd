extends Node
class_name ScrollItemsComponent

@export var container_node: Control
@export var current_index := 0

signal current_index_changed(idx: int)

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP and event.pressed:
			_select_previous_item()
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.pressed:
			_select_next_item()

func _select_next_item():
	var items = container_node.get_children()
	if items.is_empty():
		return
	current_index = (current_index + 1) % items.size()
	current_index_changed.emit(current_index)

func _select_previous_item():
	var items = container_node.get_children()
	if items.is_empty():
		return
	current_index = (current_index - 1 + items.size()) % items.size()
	current_index_changed.emit(current_index)
