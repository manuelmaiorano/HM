extends Node

@export_category("Nodes")
@export var door: AnimatableBody3D
@export var detect_area: Area3D

@export_category("Parameters")
@export var door_offset: float = -1.5
@export var door_close_duration: float = 1.0


func _ready() -> void:
	detect_area.area_entered.connect(on_area_entered)
	detect_area.area_exited.connect(on_area_exited)

func on_area_entered(_area):
	var tween = get_tree().create_tween()
	tween.tween_property(door, "position:x", door_offset, door_close_duration)


func on_area_exited(_area):
	var tween = get_tree().create_tween()
	tween.tween_property(door, "position:x", 0, door_close_duration)