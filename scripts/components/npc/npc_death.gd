extends Node


@export var health: HealthComponent
@export var bt_player: BTPlayer
@export var look_at_player: LookAtPlayerComponent

func _ready() -> void:
	health.dead.connect(on_dead)

func on_dead():
	bt_player.active = false
	look_at_player.enabled = false