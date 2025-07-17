extends InteractableComponent
class_name ClothesInteractable

@export_category("Nodes")
@export var agent: Node3D

@export_category("Parameters")
@export var interpolation_string_clothes = "Take %s's clothes"

@export_category("Debug")
@export var clothes_info: ClothesInfo

var take_clothes_action: InteractionAction

func _enter_tree() -> void:
	agent.set_meta("ClothesInteractable", self)

func _ready() -> void:
	super._ready()

func get_actions() -> Array[InteractionAction]:
	if not take_clothes_action:
		var action = InteractionAction.new()
		action.id = 0
		action.desc = interpolation_string_clothes % clothes_info.name
		take_clothes_action = action
	return [take_clothes_action]

func execute_action(_action: InteractionAction, _agent: Node3D):
	var agent_clothes = _agent.get_meta("ClothesComponent") as ClothesComponent
	agent_clothes.change_clothes(clothes_info)
	agent.queue_free()

	

