extends InteractableComponent
class_name DraggableInteractale

@export_category("Nodes")
@export var body: RigidBody3D

@export_category("Nodes")
@export var drag_action: InteractionAction

func _ready() -> void:
	super._ready()

func get_actions() -> Array[InteractionAction]:
	return [drag_action]

func execute_action(_action: InteractionAction, agent: Node3D):
	if agent.has_meta("PlayerDraggingComponent"):
		var drag_component = agent.get_meta("PlayerDraggingComponent") as PlayerDraggingComponent
		drag_component.request_drag(body)
	return
