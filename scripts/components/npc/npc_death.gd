extends Node


@export var health: HealthComponent
@export var bt_player: BTPlayer
@export var look_at_player: LookAtPlayerComponent
@export var ragdoll_component: RagdollManagerComponent

func _ready() -> void:
	health.dead.connect(on_dead)

func on_dead():
	ragdoll_component.enable_ragdoll()
	bt_player.active = false
	look_at_player.enabled = false