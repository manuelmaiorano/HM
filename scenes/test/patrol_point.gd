extends Node3D

@export var patrol_point_id: StringName

func _enter_tree() -> void:
	if Globals.patrol_points.has(patrol_point_id):
		Globals.patrol_points[patrol_point_id].append(self)
	else:
		Globals.patrol_points[patrol_point_id] = [self]