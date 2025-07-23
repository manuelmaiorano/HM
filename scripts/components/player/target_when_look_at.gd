extends Node
class_name TargetLookAtComponent

@export var agent: CharacterBody3D
@export var target: Node3D

func _enter_tree() -> void:
	agent.set_meta("TargetLookAtComponent", self)

	