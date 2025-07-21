extends Node
class_name NavigationLinkCrossingComponent


@export_category("Nodes")
@export var agent: Node3D
@export var navigation_link: NavigationLink3D

func _enter_tree() -> void:
	agent.set_meta("NavigationLinkCrossingComponent", self)

