extends InteractableComponent
class_name SittableInteractable

@export_category("Nodes")
@export var detect_area: Area3D
@export var target_sit_node: Node3D


@export_category("Parameters")
@export var sit_action: InteractionAction

@export_category("Debug")
@export var reserved: bool = false

func _ready() -> void:
	detect_area.set_meta("InteractableComponent", self)

func get_actions() -> Array[InteractionAction]:
	if reserved:
		return []
	return [sit_action]

func execute_action(_action: InteractionAction, _agent: Node3D):
	if reserved:
		return
	var sitting_component = _agent.get_meta("CharacterSittingComponent") as CharacterSittingComponent
	sitting_component.sit(target_sit_node.global_transform, self)
	reserved = true

func stand():
	reserved = false

func is_reserved():
	return reserved


func get_tags() -> Array[StringName]:
	return [&"sit"]

func get_action_by_tag(_tag):
	return sit_action

func on_action_enter_npc(_action: InteractionAction, _agent: Node3D):
	execute_action(_action, _agent)

func on_action_process_npc(_delta: float, _action: InteractionAction, _agent: Node3D) -> bool:
	return false

func on_action_exit_npc(_action: InteractionAction, _agent: Node3D):
	var sitting_component = _agent.get_meta("CharacterSittingComponent") as CharacterSittingComponent
	sitting_component.stand()
	stand()