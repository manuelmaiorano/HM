extends Resource
class_name ScheduleAction

@export var timestamp: float
@export var action_name: StringName
@export var location: StringName
@export var action_tag: StringName

func _enter(_agent: CharacterBody3D):
	pass

func _execute(_delta: float) -> bool:
	return false

func _exit():
	pass