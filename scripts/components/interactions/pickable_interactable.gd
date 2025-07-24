extends InteractableComponent

@export var pickable_component: PickableComponent
@export var intrerpolation_string: String = "Pick Up %s"

var pickup_action: InteractionAction

func _ready() -> void:
	super._ready()
	pickup_action = InteractionAction.new()
	pickup_action.id = 0
	pickup_action.desc = intrerpolation_string % pickable_component.inventory_item.name

func get_actions() -> Array[InteractionAction]:
	return [pickup_action]

func execute_action(_action: InteractionAction, _agent: Node3D):
	var inventory = _agent.get_meta("InventoryComponent") as InventoryComponent
	inventory.add_item(pickable_component.pick())

