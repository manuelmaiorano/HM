extends Node

@export var npc_to_patrol_points: Dictionary[CharacterBody3D, Array]

func _ready() -> void:
	for npc in npc_to_patrol_points.keys():
		var patrol_points = npc_to_patrol_points[npc]
		var patrol_point_registration = npc.get_meta("PatrolPointRegistrationComponent") as PatrolPointRegistrationComponent
		patrol_point_registration.patrol_points = patrol_points.map(func (x: NodePath): return get_node(x))
		