extends NavigationLinkCrossingComponent


@export var interactable: DoorInteractableComponent

var starting_position: Vector3
var ending_position: Vector3
var going_to_start: bool = true

func on_link_enter(character: Node3D):
	if character.global_position.distance_squared_to(navigation_link.get_global_end_position()) > \
		character.global_position.distance_squared_to(navigation_link.get_global_start_position()):
			ending_position = navigation_link.get_global_end_position()
			starting_position = navigation_link.get_global_start_position()
	else:
		ending_position = navigation_link.get_global_start_position()
		starting_position = navigation_link.get_global_end_position()
	interactable.open(character)
	return


func on_link_exit(_charater: Node3D):
	interactable.close()
	going_to_start = true


func move_through_link(delta: float, movement_comp: CharacterMovementComponent, next_path_position: Vector3, speed: float) -> bool:
	if going_to_start:
		movement_comp.move_to(delta, starting_position, speed)
		if movement_comp.character.global_position.distance_to(starting_position) < 0.5:
			going_to_start = false
	else:
		movement_comp.move_to(delta, ending_position, speed)
		if movement_comp.character.global_position.distance_to(ending_position) < 0.5:
			return true
	return false

func on_link_abort(_character: Node3D):
	interactable.open(_character)
	pass