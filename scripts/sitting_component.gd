extends Node
class_name CharacterSittingComponent

@export_category("Nodes")
@export var character: CharacterBody3D
@export var character_movement: CharacterMovementComponent
@export var movement_collsion_shape: CollisionShape3D

@export_category("Parameters")
@export var sitting_tween_duration: float = 0.1

@export_category("Debug")
@export var is_sitting: bool = false:
	set(value):
		is_sitting = value
		is_sitting_state_changed.emit(is_sitting)
@export var current_sittable: SittableInteractable

signal is_sitting_state_changed(is_sitting: bool)

func _enter_tree() -> void:
	character.set_meta("CharacterSittingComponent", self)


func sit(final_transform: Transform3D, sittable: SittableInteractable):
	current_sittable = sittable
	movement_collsion_shape.disabled = true
	character_movement.rotateModelTowardsTweened(final_transform.basis.z, sitting_tween_duration)
	var tween := create_tween()
	tween.tween_property(character, "global_transform", final_transform, sitting_tween_duration)
	tween.tween_callback(func(): is_sitting = true)

func stand():
	var tween := create_tween()
	tween.tween_property(character, "global_position", character.global_position + character.global_basis.z * 0.2, sitting_tween_duration)
	tween.tween_callback(stand_finalization)

func stand_finalization():
	movement_collsion_shape.disabled = false
	current_sittable.stand()
	current_sittable = null
	is_sitting = false
