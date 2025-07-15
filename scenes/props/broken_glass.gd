extends Node3D

func _ready() -> void:
	for child in get_children():
		var rb = child as RigidBody3D
		rb.apply_central_impulse(-Vector3.FORWARD)
