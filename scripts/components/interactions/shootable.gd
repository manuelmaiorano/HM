extends Node
class_name Shootable

@export_category("Nodes")
@export var agent: Node3D
@export var shoot_from: Node3D

@export_category("Parameters")
@export var bullet_scene: PackedScene

signal is_shooting

func _ready() -> void:
	agent.set_meta("Shootable", self)

func shoot(target: Vector3, override_shoot_from: Node3D = null):
	var instance = bullet_scene.instantiate()
	agent.add_child(instance)
	instance.top_level = true
	if override_shoot_from:
		instance.global_position = override_shoot_from.global_position
	else:
		instance.global_position = shoot_from.global_position

	instance.get_meta("ProjectileMovement").target = target
	is_shooting.emit()
	DebugDraw3D.draw_line(instance.global_position, target, Color.REBECCA_PURPLE, 2.0)
