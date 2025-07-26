extends Node
class_name BreackableComponent

@export_category("Nodes")
@export var agent: Node3D
@export var health: HealthComponent
@export var hit_box: HitBoxComponent

@export_category("Parameters")
@export var broken_scene: PackedScene
@export var impulse_direction: Vector3

func _ready() -> void:
	health.dead.connect(on_dead)
	hit_box.took_damage.connect(on_damage_taken)

func on_dead():
	pass

func on_damage_taken(_damage: float, agent_from: Node3D):
	if agent_from != null:
		impulse_direction = agent_from.global_position.direction_to(agent.global_position)
	create_broken_instance()


func create_broken_instance():
	var instance = broken_scene.instantiate()
	instance.impulse_direction = impulse_direction
	agent.get_parent().add_child(instance)
	instance.global_transform = agent.global_transform
	agent.queue_free()