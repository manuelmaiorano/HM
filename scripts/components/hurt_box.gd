extends Node
class_name HurtBoxComponent

@export var detection_area: Area3D
@export var damage: float

signal has_hit()

func _ready() -> void:
	detection_area.area_entered.connect(on_area_entered)

func on_area_entered(area: Area3D):
	if area.has_meta("HitBoxComponent"):
		var hit_box = area.get_meta("HitBoxComponent") as HitBoxComponent
		hit_box.take_damage(damage)
		has_hit.emit()
		print("hit")