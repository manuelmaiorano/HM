extends Node
class_name DetectAlarmedNpcComponent


@export_category("Nodes")
@export var character: Node3D
@export var detect_area: Area3D
@export var raycast: RayCast3D

@export_category("Parameters")
@export var update_frequency: float = 1.0
@export var ignore_raycast: bool = false

@export_category("Debug")

signal detected_alarmed_npc(alarm_position: Vector3)

var time_passed = 0.0

func _ready() -> void:
	character.set_meta("DetectAlarmedNpcComponent", self)



func _physics_process(delta: float) -> void:
	time_passed = Globals.call_with_cooldown(delta, update_frequency, check_alarmed, time_passed)


func check_alarmed():
	var visible_areas = Globals.get_visible_areas(detect_area, func(x): return x.has_meta("CommunicateAlarmComponent"), false, raycast)
	for area in visible_areas:
		var alarm_component = area.get_meta("CommunicateAlarmComponent") as CommunicateAlarmComponent
		if alarm_component.is_alarmed:
			detected_alarmed_npc.emit(alarm_component.last_alarm_position)
			return