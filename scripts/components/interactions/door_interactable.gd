extends InteractableComponent
class_name DoorInteractableComponent

enum State {Open, Closed, Running}
enum Action {Open, Close}

@export_category("Nodes")
@export var agent: Node3D

@export_category("Debug")
@export var state = State.Closed

@export_category("Parameters")
@export var animation_duration: float = 1.0
@export var open_angle = 90

@export_category("Action Resources")
@export var open_action: InteractionAction
@export var close_action: InteractionAction
@export var lock_action: InteractionAction


func _enter_tree() -> void:
	agent.set_meta("InteractableComponent", self)

func _ready() -> void:
	super._ready()

func get_actions() -> Array[InteractionAction]:
	if state == State.Closed:
		return [open_action, lock_action]
	elif state == State.Open:
		return [close_action]
	else:
		return []

func execute_action(action: InteractionAction, _agent: Node3D):
	if state == State.Running:
		return
	if action.id == open_action.id:
		open()
	elif action.id == close_action.id:
		close()


func open():
	if state == State.Open or state == State.Running:
		return
	state = State.Running
	var tween = get_tree().create_tween()
	tween.tween_property(agent, "rotation_degrees:y", open_angle, animation_duration).as_relative()
	tween.tween_callback(func (): state = State.Open)

func close():
	if state == State.Closed or state == State.Running:
		return
	state = State.Running
	var tween = get_tree().create_tween()
	tween.tween_property(agent, "rotation_degrees:y", -open_angle, animation_duration).as_relative()
	tween.tween_callback(func (): state = State.Closed)
