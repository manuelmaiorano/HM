extends InteractableComponent

@export_category("Nodes")
@export var detection_area: Area3D
@export var elevator_body: AnimatableBody3D
@export var elevator_door: AnimatableBody3D


@export_category("Parameters")
@export var floor_offset: float
@export var floor_info: Array[FloorInfo]
@export var interpolation_string: StringName = &"Go to %s"
@export var single_floor_ride_duration: float = 2.0
@export var door_open_offset: float = -2.0
@export var door_open_duration: float = 1.0

@export_category("Debug")
@export var current_floor: int = 0
@export var state: State = State.Idle
var all_actions = [] as Array[InteractionAction]

enum State {Idle, Moving}


func _enter_tree() -> void:
	detection_area.set_meta("InteractableComponent", self)

func _ready() -> void:
	for idx in floor_info.size():
		var info = floor_info[idx]
		var action = InteractionAction.new()
		action.id = info.floor_number
		action.desc = interpolation_string % info.floor_name
		all_actions.append(action)


func get_actions() -> Array[InteractionAction]:
	if state == State.Moving:
		return []
	return all_actions

func execute_action(_action: InteractionAction, _agent: Node3D):
	if state == State.Moving:
		return
	state = State.Moving
	go_to_floor(_action.id)


func go_to_floor(floor_number: int):
	if current_floor == floor_number:
		state = State.Idle
		await open_door()
		return

	await close_door()
	var tween := create_tween()
	tween.tween_property(elevator_body, "global_position:y", floor_offset * floor_number, single_floor_ride_duration * abs(current_floor - floor_number))\
		.set_ease(Tween.EASE_IN_OUT)
	tween.tween_callback(func (): state = State.Idle; current_floor = floor_number)
	await tween.finished
	await open_door()


func close_door():
	var tween := create_tween()
	tween.tween_property(elevator_door, "position:x", 0.0, door_open_duration)
	await tween.finished


func open_door():
	var tween := create_tween()
	tween.tween_property(elevator_door, "position:x", door_open_offset, door_open_duration)
	await tween.finished
