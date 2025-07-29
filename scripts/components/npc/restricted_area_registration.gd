extends Node
class_name RestrictedAreaRegistrationComponent


@export_category("Nodes")
@export var character: CharacterBody3D

@export_category("Debug")
@export var restricted_areas: Array[RestrictedAreaAccessComponent]:
	set(value):
		restricted_areas = value
		for restricted_area in restricted_areas:
			restricted_area.player_executed_suspicious_action.connect(on_suspicios_action)
			restricted_area.player_in_restricted_area.connect(on_restricted_area_enter)
			restricted_area.player_exited_restricted_area.connect(on_restricted_area_exit)

@export var player_in_restricted_area: bool = false

signal player_caught

func _enter_tree() -> void:
	character.set_meta("RestrictedAreaRegistrationComponent", self)


func on_suspicios_action(_area: RestrictedAreaAccessComponent):
	player_caught.emit()


func on_restricted_area_enter(area: RestrictedAreaAccessComponent):
	if area.limit_to_only_suspicious_actions:
		return
	player_in_restricted_area = true

func on_restricted_area_exit(_area: RestrictedAreaAccessComponent):
	player_in_restricted_area = false