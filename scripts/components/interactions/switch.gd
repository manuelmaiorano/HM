extends Node
class_name SwitchComponent

@export_category("Nodes")
@export var agent: Node3D
@export var switch_node_position_marker: Node3D

@export_category("Debug")
@export var swhitchables: Array[SwitchableComponent]

func _enter_tree() -> void:
	agent.set_meta("SwitchComponent", self)

func switch():
	for swithchable in swhitchables:
		swithchable.on_switch_pressed(switch_node_position_marker.global_position)
