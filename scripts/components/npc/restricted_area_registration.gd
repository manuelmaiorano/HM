extends Node
class_name RestrictedAreaRegistrationComponent


@export_category("Nodes")
@export var character: CharacterBody3D

@export_category("Debug")
@export var restricted_area: Area3D:
	set(value):
		restricted_area = value
		restricted_area.get_meta("RestrictedAreaAccessComponent").player_executed_suspicious_action.connect(on_suspicios_action)

signal player_caught

func _enter_tree() -> void:
	character.set_meta("RestrictedAreaRegistrationComponent", self)


func on_suspicios_action():
	if restricted_area.get_overlapping_bodies().has(character):
		player_caught.emit()

