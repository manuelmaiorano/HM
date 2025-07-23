extends Node


@export var health: HealthComponent
@export var bt_player: BTPlayer
@export var look_at_player: LookAtPlayerComponent
@export var ragdoll_component: RagdollManagerComponent
@export var talk_interactions_collision_shape: CollisionShape3D
@export var hurt_box_head_collision_shape: CollisionShape3D
@export var hurt_box_body_collision_shape: CollisionShape3D

func _ready() -> void:
	health.dead.connect(on_dead)

func on_dead():
	ragdoll_component.enable_ragdoll()
	bt_player.active = false
	look_at_player.enabled = false
	talk_interactions_collision_shape.disabled = true
	hurt_box_body_collision_shape.disabled = true
	hurt_box_head_collision_shape.disabled = true