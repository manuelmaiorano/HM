extends Node
class_name NavigationLinkCrossingComponent


@export_category("Nodes")
@export var agent: Node3D
@export var navigation_link: NavigationLink3D

func _enter_tree() -> void:
	navigation_link.set_meta("NavigationLinkCrossingComponent", self)

func on_link_enter(agent: Node3D):
	pass

func move_through_link(_delta: float, movement_comp: CharacterMovementComponent, next_path_position: Vector3, speed: float) -> bool:
	return false


func on_link_exit(agent: Node3D):
	pass


func on_link_abort(agent: Node3D):
	pass