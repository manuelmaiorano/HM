extends InteractableComponent

@export var pickable_component: PickableComponent
@export var pickup_action: InteractionAction

func _ready() -> void:
    super._ready()

func get_actions() -> Array[InteractionAction]:
    return [pickup_action]

func execute_action(_action: InteractionAction):
    pickable_component.pick()

