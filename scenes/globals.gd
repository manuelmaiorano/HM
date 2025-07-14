extends Node

signal CanInteract(is_interactable_colliding: bool)
signal Interactions(actions: Array[InteractionAction])
signal ExecuteAction(action: InteractionAction)

signal PickedItem(item: InventoryItem)
signal DroppedItem(item: InventoryItem)
signal SelectedItemToUse(item: InventoryItem)


func _ready() -> void:
    Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _unhandled_input(_event: InputEvent) -> void:
    if Input.is_action_just_pressed("ui_cancel"):
        if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
            Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
        else:
            Input.mouse_mode = Input.MOUSE_MODE_CAPTURED