extends Node
class_name HealthComponent

@export var max_health: float = 100
signal dead
signal health_reduced(health: float)

var current_health: float

func _ready() -> void: 
	current_health = max_health

func reduce_health(value: float):
	current_health = clamp(current_health - value, 0, max_health)
	health_reduced.emit(current_health)
	if current_health <= 0:
		dead.emit()
