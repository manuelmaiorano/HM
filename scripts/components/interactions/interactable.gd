extends Node
class_name InteractableComponent

func _ready() -> void:
	get_parent().set_meta("InteractableComponent", self)

func get_actions() -> Array[InteractionAction]:
	return []

func execute_action(_action: InteractionAction, _agent: Node3D):
	pass

func is_reserved() -> bool:
	return false

func get_tags() -> Array[StringName]:
	return []


func get_action_by_tag(_tag: StringName):
	return null

func on_action_enter_npc(_action: InteractionAction, _agent: Node3D):
	pass

func on_action_process_npc(_delta: float, _action: InteractionAction, _agent: Node3D) -> bool:
	return false

func on_action_exit_npc(_action: InteractionAction, _agent: Node3D):
	pass