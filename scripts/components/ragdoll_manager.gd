extends Node
class_name RagdollManagerComponent

@export var character: CharacterBody3D
@export var animation_player: AnimationPlayer
@export var animation_tree: AnimationTree
@export var ragdoll: PhysicalBoneSimulator3D
@export var character_collision_shape: CollisionShape3D

var physical_bones: Array
var colliders: Array

func _enter_tree() -> void:
	character.set_meta("RagdollManagerComponent", self)
	physical_bones = ragdoll.find_children("*", "PhysicalBone3D")
	colliders = ragdoll.find_children("*", "Collider3D", true)

func _ready() -> void:
	physical_bones = ragdoll.find_children("*", "PhysicalBone3D")
	colliders = ragdoll.find_children("*", "CollisionShape3D", true)
	enable_animation()

func enable_ragdoll():
	character_collision_shape.disabled = true
	animation_tree.active = false
	animation_player.active = false
	for child in physical_bones:
		var child_ = child as PhysicalBone3D
		child_.linear_velocity = Vector3.ZERO
	for child in colliders:
		var child_ = child as CollisionShape3D
		child_.disabled = false

	ragdoll.active = true
	ragdoll.physical_bones_start_simulation()

	

func enable_animation():
	ragdoll.physical_bones_stop_simulation()
	ragdoll.active = false
	for child in colliders:
		var child_ = child as CollisionShape3D
		child_.disabled = true
	animation_player.active = true
	animation_tree.active = true
	character_collision_shape.disabled = false
