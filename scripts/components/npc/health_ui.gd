extends Node

@export var health: HealthComponent
@export var progress_bar: ProgressBar


func _ready() -> void:
	health.health_reduced.connect(on_health_reduced)

func on_health_reduced(value):
	progress_bar.value = value/health.max_health * 100
