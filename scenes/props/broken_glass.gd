extends Node3D

@export var impulse_direction: Vector3
@export var impulse_strenght: float = 10.0

func _ready() -> void:
	for child in get_children():
		var rb = child as RigidBody3D
		rb.apply_central_impulse(impulse_direction * impulse_strenght)
