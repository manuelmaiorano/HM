extends Node
class_name FollowPlayerTopDownComponent

@export var player: CharacterBody3D
@export var camera: Camera3D

func _process(_delta: float) -> void:
	camera.global_position.x = player.global_position.x
	camera.global_position.z = player.global_position.z