extends Node
class_name Shootable

@export_category("Nodes")
@export var agent: Node3D
@export var shoot_from: Node3D

@export_category("Parameters")
@export var bullet_scene: PackedScene

func _ready() -> void:
	agent.set_meta("Shootable", self)

func shoot(target: Vector3):
	var instance = bullet_scene.instantiate()
	agent.add_child(instance)
	instance.top_level = true
	instance.global_position = shoot_from.global_position
	instance.get_meta("ProjectileMovement").target = target
