extends InteractableComponent
class_name TalkInteractable

@export_category("Nodes")
@export var agent: Node3D
@export var detect_area: Area3D
@export var detect_area_collision_shape: CollisionShape3D
@export var dialogue_component: DialogueComponent

@export_category("Parameters")
@export var talk_action: InteractionAction

@export_category("Debug")
@export var enabled: bool = false:
	set(value):
		enabled = value
		detect_area_collision_shape.disabled = not enabled



func _enter_tree() -> void:
	enabled = false
	agent.set_meta("TalkInteractable", self)
	detect_area.set_meta("InteractableComponent", self)


func get_actions() -> Array[InteractionAction]:
	return [talk_action]

func execute_action(_action: InteractionAction, _agent: Node3D):
	if _agent.is_in_group("player"):
		dialogue_component.play(_agent)
