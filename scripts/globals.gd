extends Node
signal PlayerHealthChanged(value)

#from player interactions
signal CanInteract(is_interactable_colliding: bool)
signal Interactions(actions: Array[InteractionAction])
signal ExecuteAction(action: InteractionAction)

signal PickedItem(item: InventoryItem)
signal DroppedItem(item: InventoryItem)
signal SelectedItemToUse(idx: int)
signal AmmoChanged(item: InventoryItem, current_ammo: int, total_ammo: int)

signal InventoryChanged(itmes: Array[InventoryItem])

signal ExecutedAction(action: InteractionAction)


signal PlayerShootingAction()
signal SniperActivated()


signal DialogueStarted
signal DialogueEnded
signal DialogueEndedByUi

@export_category("Debug")
@export var debug_ai: bool = true
@export var places: Dictionary[StringName, PlaceInfo]:
	set(value):
		places = value
		for place in places.keys():
			if places[place].is_exit:
				exits.append(places[place])

@export var exits: Array[PlaceInfo] = []

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


func get_visible_areas(detect_area: Area3D, filter: Callable, ignore_raycast: bool, raycast: RayCast3D) -> Array[Area3D]:
	var visibles = [] as Array[Area3D]
	for area in detect_area.get_overlapping_areas():
		if filter.call(area):
			if ignore_raycast:
				visibles.append(area)
			else:
				raycast.target_position = raycast.to_local(area.global_position)
				raycast.force_raycast_update()
				if raycast.is_colliding():
					if raycast.get_collider() == area:
						visibles.append(area)

	return visibles