extends BTAction

var detect_interactables_component: DetectInteractablesComponent
var character_movement_component: CharacterMovementComponent

func _setup() -> void:
	detect_interactables_component = agent.get_meta("DetectInteractablesComponent")
	character_movement_component = agent.get_meta("CharacterMovementComponent")

func _enter() -> void:
	character_movement_component.set_navigation_target(detect_interactables_component.current_interactable.get_parent().global_position)


func _tick(_delta: float) -> Status:
	var navigation_complete = character_movement_component.navigate(_delta, character_movement_component.walk_speed)
	if navigation_complete:
		return SUCCESS
	return RUNNING
