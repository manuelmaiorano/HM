extends Node
class_name SniperComponent

@export var agent: Node3D

func _enter_tree() -> void:
	agent.set_meta("SniperComponent", self)