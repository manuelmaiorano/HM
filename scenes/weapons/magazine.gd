extends Node
class_name MagazineComponent

@export_category("Nodes")
@export var agent: Node3D


@export_category("Debug")
@export var bullet_amount: int

func _enter_tree() -> void:
	agent.set_meta("MagazineComponent", self)