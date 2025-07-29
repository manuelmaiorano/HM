extends Node


@export var npc_to_restricted_areas: Dictionary[CharacterBody3D, Array]

func _ready() -> void:
	for npc in npc_to_restricted_areas.keys():
		var areas = npc_to_restricted_areas[npc]
		var restricted_areas = [] as Array[RestrictedAreaAccessComponent]
		for area in areas:
			restricted_areas.append(get_node(area) as RestrictedAreaAccessComponent)
		var area_registration_comp = npc.get_meta("RestrictedAreaRegistrationComponent") as RestrictedAreaRegistrationComponent
		area_registration_comp.restricted_areas = restricted_areas
