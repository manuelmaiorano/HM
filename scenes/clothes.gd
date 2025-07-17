extends Node3D

@export var mesh: MeshInstance3D


func set_skeleton(skeleton: Skeleton3D):
	mesh.skeleton = skeleton.get_path()