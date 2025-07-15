extends Node
class_name HitBoxComponent

@export var health: HealthComponent
@export var detection_area: Area3D
@export var damage_multiplier: float = 1.0

func _ready() -> void:
	detection_area.set_meta("HitBoxComponent", self)

func take_damage(damage: float):
	health.reduce_health(damage * damage_multiplier)

