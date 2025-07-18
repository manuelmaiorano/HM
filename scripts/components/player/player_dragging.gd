extends Node
class_name PlayerDraggingComponent



@export_category("Nodes")
@export var character: CharacterBody3D
@export var movement_component: CharacterMovementComponent
@export var camera: Camera3D
@export var yaw: Node3D
@export var node_to_follow: Node3D
@export var rigid_body_to_attach_ragdoll: RigidBody3D

@export_category("Parameters")
@export var stiffness: float = 0.1   # Spring strength
@export var damping: float = 5.0      # How much to slow down movement
@export var max_force: float = 3.0

@export_category("Debug")
@export var enabled: bool = false:
	set(value):
		enabled = value
		if value:
			set_physics_process(true)
			process_mode = Node.PROCESS_MODE_INHERIT
		else:
			bone_to_drag = null
			if current_joint:
				current_joint.queue_free()
				current_joint = null
			set_physics_process(false)
			process_mode = Node.PROCESS_MODE_DISABLED
		is_dragging_state_changed.emit(value)

@export var bone_to_drag: PhysicalBone3D = null

var current_joint: Joint3D = null

signal is_dragging_state_changed(is_dragging: bool)
signal drag_requested

func _enter_tree() -> void:
	character.set_meta("PlayerDraggingComponent", self)

func _physics_process(delta: float) -> void:
	var movement_direction = Input.get_vector("forward", "back", "right", "left")

	var camera_basis : Basis = camera.global_basis
	var camera_z := camera_basis.z
	var camera_x := camera_basis.x

	camera_z.y = 0
	camera_z = camera_z.normalized()
	camera_x.y = 0
	camera_x = camera_x.normalized()
	
	var direction = - camera_x * movement_direction.y + camera_z * movement_direction.x
	
	movement_component.move(delta, direction, movement_component.walk_speed)
	drag_bone(delta)

func request_drag(_bone_to_drag: PhysicalBone3D):
	drag_requested.emit()
	bone_to_drag = _bone_to_drag
	bone_to_drag.can_sleep = false
	#attach_joint(_bone_to_drag)

func attach_joint(_bone_to_drag):
	var joint = PinJoint3D.new()
	joint.node_a = rigid_body_to_attach_ragdoll.get_path()
	joint.node_b = _bone_to_drag.get_path()
	character.get_parent().add_child(joint)
	joint.global_position = rigid_body_to_attach_ragdoll.global_position
	current_joint = joint
	
func drag_bone(_delta: float):
	if not bone_to_drag:
		return
	var bone_pos = bone_to_drag.global_position
	var target_pos = node_to_follow.global_position

	var displacement = target_pos - bone_pos
	if displacement.is_zero_approx():
		return
	var direction = displacement.normalized()
	
	var spring_force = displacement.length() * stiffness
	var damping_force = - bone_to_drag.linear_velocity.length() * damping
	damping_force = clamp(damping_force, -spring_force, +spring_force)
	var total_force_length = clamp(spring_force + damping_force, -max_force, max_force )

	var total_force = displacement

	bone_to_drag.force_to_apply = total_force
	DebugDraw3D.draw_line(bone_pos, bone_pos + total_force, Color.ORANGE_RED)
	DebugDraw3D.draw_box(target_pos, Quaternion.IDENTITY, Vector3.ONE * 0.1)
	DebugDraw3D.draw_box(bone_pos, Quaternion.IDENTITY, Vector3.ONE * 0.1)
	# bone_to_drag.apply_central_force(total_force)
	# bone_to_drag._integrate_forces(state)
