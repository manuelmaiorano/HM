extends Node
class_name PlayerDisguiseComponent

@export_category("Nodes")
@export var character: CharacterBody3D

@export_category("Debug")
@export var is_disguised: bool = false

func _enter_tree() -> void:
	character.set_meta("PlayerDisguiseComponent", self)