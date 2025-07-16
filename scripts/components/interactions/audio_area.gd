extends Node
class_name AudioAreaComponent

@export var sound_emission_node: Node3D
@export var detect_area: Area3D

func activate():
	for area in detect_area.get_overlapping_areas():
		var hearing_component = area.get_meta("AudioHearingComponent")
		if hearing_component:
			hearing_component.hear_sound(sound_emission_node.global_position)