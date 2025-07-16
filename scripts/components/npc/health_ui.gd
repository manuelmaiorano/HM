extends Node

@export var health: HealthComponent
@export var ui: OverheadUi


func _ready() -> void:
	health.health_reduced.connect(on_health_reduced)

func on_health_reduced(value):
	ui.value_perc = value/health.max_health
