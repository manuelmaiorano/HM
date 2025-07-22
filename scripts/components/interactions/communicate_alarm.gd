extends Node
class_name CommunicateAlarmComponent

@export_category("Nodes")
@export var agent: Node3D
@export var detect_area: Area3D

@export_category("Debug")
@export var is_alarmed: bool = false
@export var last_alarm_position: Vector3


func _enter_tree() -> void:
	agent.set_meta("CommunicateAlarmComponent", self)
	detect_area.set_meta("CommunicateAlarmComponent", self)

func set_alarmed(position: Vector3):
	is_alarmed = true
	last_alarm_position = position




