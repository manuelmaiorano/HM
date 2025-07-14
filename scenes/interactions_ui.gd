extends Node
@export var interactions: VBoxContainer
@export var no_interaction_tex: TextureRect
@export var can_interact_tex: TextureRect 
@export var scroll_interactions_component: ScrollItemsComponent

var current_actions: Array[InteractionAction]

func _ready() -> void:
	on_interaction_hover(false)
	Globals.Interactions.connect(on_interactions_update)
	Globals.CanInteract.connect(on_interaction_hover)
	scroll_interactions_component.current_index_changed.connect(func(idx): interactions.get_child(idx).grab_focus())

func on_interactions_update(actions: Array[InteractionAction]):
	current_actions = actions
	for child in interactions.get_children():
		child.queue_free()

	if not actions.is_empty():
		can_interact_tex.hide()
	else:
		no_interaction_tex.show()

	scroll_interactions_component.current_index = 0
	var first = true
	for action in actions:
		var button = Button.new()
		button.text = action.desc
		interactions.add_child(button)
		if first:
			button.grab_focus()
			first = false

func on_interaction_hover(can_interact: bool):
	if can_interact:
		can_interact_tex.show()
		no_interaction_tex.hide()
	else:
		can_interact_tex.hide()
		no_interaction_tex.show()


func _input(_event):
	if Input.is_action_just_pressed("execute_action"):
		var items = interactions.get_children()
		if not items.is_empty():
			Globals.ExecuteAction.emit(current_actions[scroll_interactions_component.current_index])
