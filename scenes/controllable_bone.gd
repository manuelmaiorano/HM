extends PhysicalBone3D


@export var force_to_apply: Vector3 = Vector3.ZERO

func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	state.add_constant_central_force(force_to_apply)