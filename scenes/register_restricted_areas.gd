extends Node


@export var npc_to_restricted_areas: Dictionary[CharacterBody3D, Area3D]

func _ready() -> void:
	for npc in npc_to_restricted_areas.keys():
		var area = npc_to_restricted_areas[npc]
		var area_registration_comp = npc.get_meta("RestrictedAreaRegistrationComponent") as RestrictedAreaRegistrationComponent
		area_registration_comp.restricted_area = area
