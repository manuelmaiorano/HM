extends InteractableComponent

enum State {Open, Closed, Running}
enum Action {Open, Close}

@export_category("Debug")
@export var state = State.Closed

@export_category("Parameters")
@export var animation_duration: float = 1.0
@export var open_angle = 90

@export_category("Action Resources")
@export var open_action: InteractionAction
@export var close_action: InteractionAction
@export var lock_action: InteractionAction

func _ready() -> void:
	super._ready()

func get_actions() -> Array[InteractionAction]:
	if state == State.Closed:
		return [open_action, lock_action]
	elif state == State.Open:
		return [close_action]
	else:
		return []

func execute_action(action: InteractionAction):
	if state == State.Running:
		return
	if action.id == open_action.id:
		state = State.Running
		var tween = get_tree().create_tween()
		tween.tween_property(get_parent(), "rotation_degrees:y", open_angle, animation_duration).as_relative()
		tween.tween_callback(func (): state = State.Open)
	elif action.id == close_action.id:
		state = State.Running
		var tween = get_tree().create_tween()
		tween.tween_property(get_parent(), "rotation_degrees:y", -open_angle, animation_duration).as_relative()
		tween.tween_callback(func (): state = State.Closed)
