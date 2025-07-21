extends InteractableComponent

@export_category("Nodes")
@export var detect_dead_body: DetectDeadBodyComponent
@export var node_to_move_body: Node3D

@export_category("Parameters")
@export var dump_action: InteractionAction

var stored_body = null

func get_actions() -> Array[InteractionAction]:
	if stored_body == null and detect_dead_body.last_body != null:
		return [dump_action]
	return []

func execute_action(_action: InteractionAction, _agent: Node3D):
	if stored_body == null:
		stored_body = detect_dead_body.last_body
		var ragdoll_comp = stored_body.get_meta("RagdollManagerComponent") as RagdollManagerComponent
		ragdoll_comp.move_ragdoll(node_to_move_body.global_transform)

