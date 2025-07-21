extends ScheduleAction

var movement_comp: CharacterMovementComponent
 

func _enter(agent: CharacterBody3D):
	movement_comp = agent.get_meta("CharacterMovementComponent")



