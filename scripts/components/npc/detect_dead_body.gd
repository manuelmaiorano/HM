extends Node

class_name DetectDeadBodyComponent

@export_category("Nodes")
@export var character: Node3D
@export var detect_area: Area3D
@export var raycast: RayCast3D

@export_category("Parameters")
@export var update_frequency: float = 1.0
@export var ignore_raycast: bool = false

@export_category("Debug")
var last_body: CharacterBody3D
var last_dead_body_position: Vector3 = Vector3.ZERO

signal dead_body_found(where: Vector3)

var time_passed = 0.0

func _enter_tree() -> void:
	character.set_meta("DetectDeadBodyComponent", self)


func _physics_process(delta: float) -> void:
	time_passed = Globals.call_with_cooldown(delta, update_frequency, check_dead_bodies, time_passed)


func check_dead_bodies():
	var visible_areas = Globals.get_visible_areas(detect_area, func(x): return x.has_meta("LootInteractableComponent"), ignore_raycast, raycast)
	for area in visible_areas:
		var loot_component = area.get_meta("LootInteractableComponent") as LootInteractableComponent
		dead_body_found.emit(area.global_position)
		last_dead_body_position = area.global_position
		last_body = loot_component.character
		return


	# for area in detect_area.get_overlapping_areas():
	# 	if area.has_meta("LootInteractableComponent"):
	# 		var loot_component = area.get_meta("LootInteractableComponent") as LootInteractableComponent
	# 		if ignore_raycast:
	# 			dead_body_found.emit(area.global_position)
	# 			last_dead_body_position = area.global_position
	# 			last_body = loot_component.character
	# 		else:
	# 			raycast.target_position = raycast.to_local(area.global_position)
	# 			raycast.force_raycast_update()
	# 			if raycast.is_colliding():
	# 				if raycast.get_collider() == area:
	# 					dead_body_found.emit(area.global_position)
	# 					last_dead_body_position = area.global_position
	# 					last_body = loot_component.character
	# 					return
