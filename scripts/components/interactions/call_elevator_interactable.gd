extends InteractableComponent

@export_category("Nodes")
@export var detect_area: Area3D

@export_category("Parameters")
@export var call_elevator_action: InteractionAction
@export var switch: SwitchComponent

func _enter_tree() -> void:
	detect_area.set_meta("InteractableComponent", self)

func get_actions() -> Array[InteractionAction]:
	return [call_elevator_action]

func execute_action(_action: InteractionAction, _agent: Node3D):
	switch.switch()