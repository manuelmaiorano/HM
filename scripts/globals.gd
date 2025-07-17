extends Node
signal PlayerHealthChanged(value)

signal CanInteract(is_interactable_colliding: bool)
signal Interactions(actions: Array[InteractionAction])
signal ExecuteAction(action: InteractionAction)

signal PickedItem(item: InventoryItem)
signal DroppedItem(item: InventoryItem)
signal SelectedItemToUse(item: InventoryItem)

signal InventoryChanged(itmes: Array[InventoryItem])

signal ExecutedAction(action: InteractionAction)

signal UiElementActiveChanged()
enum UiElementActive {None, InteractionsMenu, InventoryMenu}
@export var current_ui_element_active: UiElementActive = UiElementActive.None:
	set(x):
		current_ui_element_active = x
		UiElementActiveChanged.emit()


@export var patrol_points: Dictionary[StringName, Array]

@export_category("Debug")
@export var debug_ai: bool = true

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func get_timestamp_seconds():
	return float(Time.get_ticks_msec())/1000

func get_elapsed_seconds(timestamp: float):
	return get_timestamp_seconds() - timestamp

# Checks if position is within distance from target with hysteresis
# `state` is whether it was inside the range in the previous frame
func is_within_distance_with_hysteresis(position: Vector3, target: Vector3, enter_distance: float, exit_distance: float, is_close: bool) -> bool:
	var distance = position.distance_to(target)

	if is_close:
		# Currently inside — only exit if distance exceeds exit_distance
		if distance > exit_distance:
			return false
		else:
			return true
	else:
		# Currently outside — only enter if distance is less than enter_distance
		if distance < enter_distance:
			return true
		else:
			return false


func call_with_cooldown(delta: float, cool_down: float, callable: Callable, time_passed: float):
	time_passed += delta
	if time_passed >= cool_down:
		callable.call()
		time_passed = 0.0

	return time_passed
