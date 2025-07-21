extends Node
class_name RagdollManagerComponent

@export_category("Nodes")
@export var character: CharacterBody3D
@export var animation_player: AnimationPlayer
@export var animation_tree: AnimationTree
@export var ragdoll: PhysicalBoneSimulator3D
@export var character_collision_shape: CollisionShape3D

@export_category("Parameters")
@export var bone_to_move_ragdoll: PhysicalBone3D

var physical_bones: Array
var colliders: Array

enum State {Animation, Ragdoll}
var state: State = State.Animation

func _enter_tree() -> void:
	character.set_meta("RagdollManagerComponent", self)
	physical_bones = ragdoll.find_children("*", "PhysicalBone3D")
	colliders = ragdoll.find_children("*", "Collider3D", true)

func _ready() -> void:
	physical_bones = ragdoll.find_children("*", "PhysicalBone3D")
	colliders = ragdoll.find_children("*", "CollisionShape3D", true)
	enable_animation()

func enable_ragdoll():
	state = State.Ragdoll
	character_collision_shape.disabled = true
	animation_tree.active = false
	animation_player.active = false

	reset_bones_velocity()
	enable_colliders()

	ragdoll.active = true
	ragdoll.physical_bones_start_simulation()

	

func enable_animation():
	state = State.Ragdoll
	ragdoll.physical_bones_stop_simulation()
	ragdoll.active = false
	disable_colliders()
	animation_player.active = true
	animation_tree.active = true
	character_collision_shape.disabled = false

func move_ragdoll(final_transform: Transform3D):
	assert(state == State.Ragdoll)
	disable_colliders()
	var movement = final_transform.origin - bone_to_move_ragdoll.global_position
	for child in physical_bones:
		child.global_position += movement
	await get_tree().physics_frame
	reset_bones_velocity()
	enable_colliders()


func disable_colliders():
	for child in colliders:
		var child_ = child as CollisionShape3D
		child_.disabled = true

func enable_colliders():
	for child in colliders:
		var child_ = child as CollisionShape3D
		child_.disabled = false

func reset_bones_velocity():
	for child in physical_bones:
		var child_ = child as PhysicalBone3D
		child_.linear_velocity = Vector3.ZERO