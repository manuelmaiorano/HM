extends BTAction

var character_movement: CharacterMovementComponent
var detect_player_component: DetectPlayerComponent
var wieldable_component: WieldableComponent

@export var shoot_cooldown_time: float = 2.0
@export var reset_navigation_target_cooldown_time: float = 2.0
var time_passed = 0.0
var was_visible_prev_frame: bool = false

func _setup() -> void:
	character_movement = agent.get_meta("CharacterMovementComponent")
	detect_player_component = agent.get_meta("DetectPlayerComponent")
	wieldable_component = agent.get_meta("WieldableComponent")

func _enter() -> void:
	pass

func _exit() -> void:
	pass

func _tick(delta: float) -> Status:
	if detect_player_component.is_player_visible:
		was_visible_prev_frame = true
		character_movement.rotateModelTowards(delta, agent.global_position.direction_to(detect_player_component.player.global_position))
		call_with_cooldown(delta, shoot_cooldown_time, func(): wieldable_component.try_shoot(detect_player_component.player.global_position))
	else:
		call_with_cooldown(delta, reset_navigation_target_cooldown_time, func(): character_movement.set_navigation_target(detect_player_component.last_seen_position))
		var navigation_finished = character_movement.navigate(delta, character_movement.run_speed)
		if navigation_finished:
			return FAILURE
	return RUNNING


func call_with_cooldown(delta: float, cool_down: float, callable: Callable):
	time_passed += delta
	if time_passed >= cool_down:
		callable.call()
		time_passed = 0.0
