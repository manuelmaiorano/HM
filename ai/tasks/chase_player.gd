extends BTAction

var character_movement: CharacterMovementComponent
var detect_player_component: DetectPlayerComponent
var wieldable_component: WieldableComponent


@export var shoot_cooldown_time: float = 2.0
@export var reset_navigation_target_cooldown_time: float = 2.0
@export var distance_to_shoot: float = 15.0
@export var distance_to_shoot_tolerance: float = 3.0
@export var time_to_stop_chasing_after_spotted: float = 10.0

var time_passed = 0.0

var is_close_to_player = false

func _setup() -> void:
	character_movement = agent.get_meta("CharacterMovementComponent")
	detect_player_component = agent.get_meta("DetectPlayerComponent")
	wieldable_component = agent.get_meta("WieldableComponent")


func _enter() -> void:
	pass

func _exit() -> void:
	return

func _tick(delta: float) -> Status:
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
