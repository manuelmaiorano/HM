extends SwitchableComponent

@export_category("Nodes")
@export var agent: Node3D
@export var elevator_interactable: ElevatorInteractable

func _enter_tree() -> void:
	agent.set_meta("SwitchableComponent", self)




func on_switch_pressed(switch_location: Vector3):
	var floor_idx = elevator_interactable.get_floor_from_switch_position(switch_location)
	elevator_interactable.go_to_floor(floor_idx)