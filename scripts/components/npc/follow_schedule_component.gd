extends Node
class_name FollowScheduleComponent

@export_category("Nodes")
@export var character: CharacterBody3D

@export_category("Parameters")
@export var schedule: Schedule = null:
	set(value):
		schedule = value
		if schedule:
			last_action = false
			current_idx = 0
			next_schedule_action = schedule.actions[current_idx]
			set_physics_process(true)
		else:
			set_physics_process(false)

@export_category("Debug")
@export var current_schedule_action: ScheduleAction = null
@export var next_schedule_action: ScheduleAction = null
@export var last_action = false
@export var current_idx: int = 0

signal action_changed(action: ScheduleAction)

func _enter_tree() -> void:
	character.set_meta("FollowScheduleComponent", self)
	schedule = null


func _physics_process(_delta: float) -> void:
	if not schedule or last_action:
		return
	if Globals.get_timestamp_seconds() > next_schedule_action.timestamp:
		current_schedule_action = next_schedule_action
		action_changed.emit(current_schedule_action)

		current_idx += 1
		if current_idx < schedule.actions.size():
			next_schedule_action = schedule.actions[current_idx]
		else:
			last_action = true

