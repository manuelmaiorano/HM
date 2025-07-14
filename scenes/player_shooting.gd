extends Node
class_name PlayerShootingComponent

@export var wieldable: WieldableComponent
@export var target: Node3D

signal is_shooting

func _ready() -> void:
	return
	#Globals.Interactions.connect(on_interactions)


func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("execute_action"):
		if wieldable.current_item == null:
			return
		if wieldable.current_item.has_meta("Shootable"):
			var shootable_component = wieldable.current_item.get_meta("Shootable") as Shootable
			shootable_component.shoot(target)
			is_shooting.emit()
