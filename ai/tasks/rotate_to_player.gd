extends BTAction

var character_movement: CharacterMovementComponent
var player

func _setup() -> void:
	character_movement = agent.get_meta("CharacterMovementComponent")
	player = agent.get_tree().get_first_node_in_group("player")


func _tick(delta: float) -> Status:
	character_movement.rotateModelTowards(delta, agent.global_position.direction_to(player.global_position))
	return RUNNING