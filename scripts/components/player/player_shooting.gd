extends Node
class_name PlayerShootingComponent

@export var wieldable: WieldableComponent
@export var raycast: RayCast3D

@export_category("Debug")
@export var enabled: bool = true:
	set(value):
		enabled = value
		if value:
			set_process_unhandled_input(true)
		else:
			set_process_unhandled_input(false)

signal is_sniper_enabled

func _ready() -> void:
	Globals.PlayerShootingAction.connect(on_shooting)


func on_shooting() -> void:

	if wieldable.current_item == null:
		return
	if wieldable.current_item.has_meta("SniperComponent"):
		is_sniper_enabled.emit()
		Globals.SniperActivated.emit()
		return
	wieldable.try_shoot_raycast(raycast)
	wieldable.try_silent_kill(raycast)
