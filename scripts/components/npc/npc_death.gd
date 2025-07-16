extends Node


@export var health: HealthComponent
@export var bt_player: BTPlayer

func _ready() -> void:
	health.dead.connect(on_dead)

func on_dead():
	bt_player.active = false