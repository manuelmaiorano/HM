extends Node
class_name HealthComponent

@export_category("Nodes")
@export var agent: Node3D

@export_category("Parameters")
@export var max_health: float = 100

@export_category("Debug")
@export var current_health: float
@export var enabled: bool = true

signal dead
signal health_reduced(health: float)

func _enter_tree() -> void:
	agent.set_meta("HealthComponent", self)

func _ready() -> void: 
	current_health = max_health

func reduce_health(value: float):
	if not enabled:
		return
	current_health = clamp(current_health - value, 0, max_health)
	health_reduced.emit(current_health)
	if current_health <= 0:
		dead.emit()
