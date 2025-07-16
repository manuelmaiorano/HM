extends Node
class_name PatrolPointRegistrationComponent

@export_category("Nodes")
@export var character: CharacterBody3D

@export_category("Parameters")
@export var patrol_point_id: StringName

@export_category("Debug")
@export var patrol_points: Array = []

func _ready() -> void:
	character.set_meta("PatrolPointRegistrationComponent", self)
	if Globals.patrol_points.has(patrol_point_id):
		patrol_points = Globals.patrol_points[patrol_point_id]
