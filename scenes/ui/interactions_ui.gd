extends Node
@export var interactions: VBoxContainer
@export var scroll_component: ScrollItemsComponent

var current_actions: Array[InteractionAction]

func _enter_tree() -> void:
	get_parent().set_meta("InteractionsManager", self)

func _ready() -> void:
	Globals.Interactions.connect(on_interactions_update)
	scroll_component.current_index_changed.connect(func(idx): interactions.get_child(idx).grab_focus())


func update_scroll_active():
	scroll_component.active = Globals.current_ui_element_active == Globals.UiElementActive.InteractionsMenu

func on_interactions_update(actions: Array[InteractionAction]):
	interactions.show()
	current_actions = actions
	for child in interactions.get_children():
		child.queue_free()

	scroll_component.current_index = 0
	var first = true
	for action in actions:
		var button = Button.new()
		button.mouse_filter = Control.MOUSE_FILTER_PASS
		button.text = action.desc
		interactions.add_child(button)
		if first:
			button.grab_focus()
			first = false

func scroll(event):
	scroll_component.scroll(event)

func select_interaction():
	var items = interactions.get_children()
	if not items.is_empty():
		Globals.ExecuteAction.emit(current_actions[scroll_component.current_index])


func change_visibility(visibile):
	if visibile:
		get_parent().show()
	else:
		get_parent().hide()