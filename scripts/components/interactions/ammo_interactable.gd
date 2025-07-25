extends InteractableComponent
class_name AmmoInteractable

@export_category("Nodes")
@export var agent: Node3D

@export_category("Parameters")
@export var bullet_info: BulletInfo
@export var amount: int = 100
@export var interpolation_string: StringName


var pickup_action: InteractionAction

func _ready() -> void:
	super._ready()
	pickup_action = InteractionAction.new()
	pickup_action.id = 0
	pickup_action.desc = interpolation_string % bullet_info.name

func get_actions() -> Array[InteractionAction]:
	return [pickup_action]

func execute_action(_action: InteractionAction, _agent: Node3D):
	var inventory = _agent.get_meta("InventoryComponent") as InventoryComponent
	inventory.pick_up_ammo(bullet_info, amount)
	agent.queue_free()
	