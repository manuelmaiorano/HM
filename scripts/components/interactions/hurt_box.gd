extends Node
class_name HurtBoxComponent

@export_category("Nodes")
@export var agent: Node3D
@export var detection_area: Area3D

@export_category("Parameters")
@export var damage: float
@export var exceptions: Array[Area3D]

signal has_hit()

func _enter_tree() -> void:
	agent.set_meta("HurtBoxComponent", self)

func _ready() -> void:
	detection_area.area_entered.connect(on_area_entered)

func on_area_entered(area: Area3D):
	if exceptions.has(area):
		return
	if area.has_meta("HitBoxComponent"):
		var hit_box = area.get_meta("HitBoxComponent") as HitBoxComponent
		hit_box.take_damage(damage, agent)
		has_hit.emit()