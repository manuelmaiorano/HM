extends Node
class_name Stabbable

@export_category("Nodes")
@export var agent: Node3D


@export_category("Parameters")
@export var distance_to_kill: float = 1.5

func _ready() -> void:
	agent.set_meta("Stabbable", self)

func raycast_kill(raycast: RayCast3D):
	if raycast.is_colliding():
		var collider = raycast.get_collider()
		if agent.global_position.distance_to(collider.global_position) > distance_to_kill:
			return false
		if collider.has_meta("HitBoxComponent"):
			var hitbox = collider.get_meta("HitBoxComponent", null) as HitBoxComponent
			hitbox.take_damage(100000, agent)
			return true

	return false
