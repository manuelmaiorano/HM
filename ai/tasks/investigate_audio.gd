extends BTAction

var hearing_component: AudioHearingComponent
var character_movement: CharacterMovementComponent


@export var time_to_stop_investigating_after_heard_sound: float = 10.0

var is_sound_heard: bool = false
var is_waiting_on_sound_heard_position = false

func _enter() -> void:
	pass

func _exit() -> void:
	is_waiting_on_sound_heard_position = false

func _setup() -> void:
	hearing_component = agent.get_meta("AudioHearingComponent")
	character_movement = agent.get_meta("CharacterMovementComponent")
	hearing_component.is_sound_heard.connect(func(): is_sound_heard = true)


func _tick(delta: float) -> Status:
	if Globals.debug_ai:
		DebugDraw2D.set_text("is_sound_heard", is_sound_heard)
		DebugDraw2D.set_text("is_waiting_on_sound_heard_position", is_waiting_on_sound_heard_position)

	if not is_sound_heard:
		return FAILURE

	
	if Globals.get_elapsed_seconds(hearing_component.last_time_heard) > time_to_stop_investigating_after_heard_sound:
		is_sound_heard = false
		return FAILURE

	if is_waiting_on_sound_heard_position:
		return RUNNING
	
	character_movement.set_navigation_target(hearing_component.last_sound_location)
	var navigation_finished = character_movement.navigate(delta, character_movement.run_speed)
	if navigation_finished:
		is_waiting_on_sound_heard_position = true
	return RUNNING

