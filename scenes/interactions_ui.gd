extends Node
@export var interactions: VBoxContainer
@export var no_interaction_tex: TextureRect
@export var can_interact_tex: TextureRect 
@export var scroll_component: ScrollItemsComponent

var current_actions: Array[InteractionAction]

func _ready() -> void:
	on_interaction_hover(false)
	Globals.Interactions.connect(on_interactions_update)
	Globals.CanInteract.connect(on_interaction_hover)
	Globals.UiElementActiveChanged.connect(on_ui_element_changed)
	scroll_component.current_index_changed.connect(func(idx): interactions.get_child(idx).grab_focus())


func update_scroll_active():
	scroll_component.active = Globals.current_ui_element_active == Globals.UiElementActive.InteractionsMenu

func on_interactions_update(actions: Array[InteractionAction]):
	interactions.show()
	current_actions = actions
	for child in interactions.get_children():
		child.queue_free()

	if not actions.is_empty():
		can_interact_tex.hide()
		Globals.current_ui_element_active = Globals.UiElementActive.InteractionsMenu
		update_scroll_active()
	else:
		no_interaction_tex.show()
		Globals.current_ui_element_active = Globals.UiElementActive.None
		update_scroll_active()

	scroll_component.current_index = 0
	var first = true
	for action in actions:
		var button = Button.new()
		button.text = action.desc
		interactions.add_child(button)
		if first:
			button.grab_focus()
			first = false

func on_ui_element_changed():
	if Globals.current_ui_element_active == Globals.UiElementActive.InventoryMenu:
		no_interaction_tex.hide()
		can_interact_tex.hide()
		return
	if Globals.current_ui_element_active == Globals.UiElementActive.None:
		no_interaction_tex.show()
		can_interact_tex.hide()

func on_interaction_hover(can_interact: bool):
	if Globals.current_ui_element_active == Globals.UiElementActive.InventoryMenu:
		return

	if can_interact:
		can_interact_tex.show()
		no_interaction_tex.hide()
	else:
		can_interact_tex.hide()
		no_interaction_tex.show()
		if Globals.current_ui_element_active == Globals.UiElementActive.InteractionsMenu:
			Globals.current_ui_element_active = Globals.UiElementActive.None
			update_scroll_active()
			interactions.hide()


func _input(_event):
	if Globals.current_ui_element_active == Globals.UiElementActive.InteractionsMenu:
		if Input.is_action_just_pressed("interact"):
			Globals.current_ui_element_active = Globals.UiElementActive.None
			update_scroll_active()
			interactions.hide()

	if Input.is_action_just_pressed("execute_action") and\
		Globals.current_ui_element_active == Globals.UiElementActive.InteractionsMenu:
		var items = interactions.get_children()
		if not items.is_empty():
			interactions.hide()
			can_interact_tex.show()
			Globals.ExecuteAction.emit(current_actions[scroll_component.current_index])
