extends Node
class_name HitBoxComponent

@export var health: HealthComponent
@export var detection_area: Area3D
@export var damage_multiplier: float = 1.0

signal took_damage(damage: float, agent: Node3D)

func _ready() -> void:
	detection_area.set_meta("HitBoxComponent", self)

func take_damage(damage: float, agent: Node3D=null):
	health.reduce_health(damage * damage_multiplier)
	took_damage.emit(damage, agent)

