extends ScheduleAction
class_name GoToPlaceScheduleAction

@export var place_name: StringName
@export var position: Vector3

var movement_comp: CharacterMovementComponent
 

func _enter(agent: CharacterBody3D):
	movement_comp = agent.get_meta("CharacterMovementComponent")
	movement_comp.set_navigation_target(position)


func _execute(delta: float):
	movement_comp.navigate(delta, movement_comp.walk_speed)
