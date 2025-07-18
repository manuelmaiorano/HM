extends Node

class_name DetectDeadBodyComponent

@export_category("Nodes")
@export var character: CharacterBody3D
@export var detect_area: Area3D
@export var raycast: RayCast3D

@export_category("Parameters")
@export var update_frequency: float = 1.0

@export_category("Debug")
var last_dead_body_position: Vector3 = Vector3.ZERO

signal dead_body_found(where: Vector3)

var time_passed = 0.0

func _ready() -> void:
	character.set_meta("DetectDeadBodyComponent", self)


func _physics_process(delta: float) -> void:
	time_passed = Globals.call_with_cooldown(delta, update_frequency, check_dead_bodies, time_passed)


func check_dead_bodies():
	for area in detect_area.get_overlapping_areas():
		if area.has_meta("LootInteractableComponent"):
			raycast.target_position = raycast.to_local(area.global_position)
			raycast.force_raycast_update()
			if raycast.is_colliding():
				if raycast.get_collider() == area:
					dead_body_found.emit(area.global_position)
					last_dead_body_position = area.global_position
					return
