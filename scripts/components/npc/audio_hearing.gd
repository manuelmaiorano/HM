extends Node
class_name AudioHearingComponent

@export_category("Nodes")
@export var agent: CharacterBody3D
@export var detect_area: Area3D

@export_category("Debug")
@export var last_sound_location: Vector3
@export var last_time_heard: float

signal is_sound_heard

func _enter_tree() -> void:
	agent.set_meta("AudioHearingComponent", self)
	detect_area.set_meta("AudioHearingComponent", self)

func hear_sound(where: Vector3):
	last_sound_location = where
	last_time_heard = Globals.get_timestamp_seconds()
	is_sound_heard.emit()