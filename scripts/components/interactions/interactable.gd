extends Node
class_name InteractableComponent

func _ready() -> void:
    get_parent().set_meta("InteractableComponent", self)

func get_actions() -> Array[InteractionAction]:
    return []

func execute_action(_action: InteractionAction, _agent: Node3D):
    pass
