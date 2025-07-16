extends BTAction

var character_movement: CharacterMovementComponent
var detect_player_component: DetectPlayerComponent
var wieldable_component: WieldableComponent
var player_inventory: InventoryComponent

@export var shoot_cooldown_time: float = 2.0
@export var reset_navigation_target_cooldown_time: float = 2.0
@export var distance_to_shoot: float = 15.0
@export var distance_to_shoot_tolerance: float = 3.0
@export var time_to_stop_chasing_after_spotted: float = 10.0

var time_passed = 0.0

var is_chasing_player: bool = false
var is_player_spotted_with_weapon: bool = false
var is_close_to_player: bool = false

func _setup() -> void:
	character_movement = agent.get_meta("CharacterMovementComponent")
	detect_player_component = agent.get_meta("DetectPlayerComponent")
	wieldable_component = agent.get_meta("WieldableComponent")
	player_inventory = agent.get_tree().get_first_node_in_group("player").get_meta("InventoryComponent") as InventoryComponent

	detect_player_component.player_visibility_changed.connect(on_visibility_changed)

func on_visibility_changed(is_visible: bool):
	if is_visible:
		if player_inventory.item_in_use.is_weapon:
			is_chasing_player = true
			is_player_spotted_with_weapon = true

func _enter() -> void:
	pass

func _exit() -> void:
	is_chasing_player = false
	is_close_to_player = false

func _tick(delta: float) -> Status:
	if Globals.debug_ai:
		DebugDraw2D.set_text("is_chasing_player", is_chasing_player)
		DebugDraw2D.set_text("is_player_spotted_with_weapon", is_player_spotted_with_weapon)
		DebugDraw2D.set_text("is_close_to_player", is_close_to_player)
		DebugDraw2D.set_text("is_player_visible", detect_player_component.is_player_visible)
		if detect_player_component.player:
			DebugDraw2D.set_text("distance", agent.global_position.distance_to(detect_player_component.player.global_position))

	if not is_player_spotted_with_weapon:
		return FAILURE

	if not is_chasing_player:
		return FAILURE

	if not detect_player_component.is_player_visible and Globals.get_elapsed_seconds(detect_player_component.last_seen_time) > time_to_stop_chasing_after_spotted:
		is_chasing_player = false
		return FAILURE

	if not detect_player_component.is_player_visible:
		character_movement.set_navigation_target(detect_player_component.last_seen_position)
		var navigation_finished = character_movement.navigate(delta, character_movement.run_speed)
		if navigation_finished:
			return FAILURE
		return RUNNING

	is_close_to_player = Globals.is_within_distance_with_hysteresis(agent.global_position, detect_player_component.player.global_position, \
		distance_to_shoot, distance_to_shoot + distance_to_shoot_tolerance, is_close_to_player)
	
	if not is_close_to_player:
		time_passed = Globals.call_with_cooldown(delta, reset_navigation_target_cooldown_time, \
			func(): character_movement.set_navigation_target(detect_player_component.player.global_position), time_passed)
		var navigation_finished = character_movement.navigate(delta, character_movement.run_speed)
		return RUNNING
	
	character_movement.stand_idle(delta)
	character_movement.rotateModelTowards(delta, agent.global_position.direction_to(detect_player_component.player.global_position))
	time_passed = Globals.call_with_cooldown(delta, shoot_cooldown_time, shoot_player, time_passed)
	

	return RUNNING




func shoot_player():
	wieldable_component.try_shoot(detect_player_component.player.get_meta("VisibilityCheckTargetComponent").target_node.global_position)
