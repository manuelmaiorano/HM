extends Node

@export var health: HealthComponent

func _ready() -> void:
	health.health_reduced.connect(func (x): Globals.PlayerHealthChanged.emit(x/health.max_health))
	
