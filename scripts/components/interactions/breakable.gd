extends Node
class_name BreackableComponent

@export_category("Nodes")
@export var agent: Node3D
@export var health: HealthComponent

@export_category("Parameters")
@export var broken_scene: PackedScene

func _ready() -> void:
	health.dead.connect(on_dead)

func on_dead():
	var instance = broken_scene.instantiate()
	agent.get_parent().add_child(instance)
	instance.global_transform = agent.global_transform
	agent.queue_free()
