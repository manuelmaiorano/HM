extends Node
class_name VisibilityCheckTargetComponent

@export var character: CharacterBody3D
@export var target_node: Node3D

func _ready() -> void:
	character.set_meta("VisibilityCheckTargetComponent", self)