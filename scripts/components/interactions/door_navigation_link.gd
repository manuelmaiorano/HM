extends NavigationLinkCrossingComponent


@export var interactable: DoorInteractableComponent

var ending_position: Vector3

func on_link_enter(charater: Node3D):
	if charater.global_position.distance_squared_to(navigation_link.get_global_end_position()) > \
		charater.global_position.distance_squared_to(navigation_link.get_global_start_position()):
			ending_position = navigation_link.get_global_end_position()
	else:
		ending_position = navigation_link.get_global_start_position()
	interactable.open()
	return


func on_link_exit(_charater: Node3D):
	interactable.close()


func move_through_link(delta: float, movement_comp: CharacterMovementComponent, next_path_position: Vector3, speed: float) -> bool:
	movement_comp.move_to(delta, next_path_position, speed)
	if movement_comp.character.global_position.distance_to(ending_position) < 0.5:
		return true
	return false
