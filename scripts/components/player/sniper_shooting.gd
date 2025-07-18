extends Node
class_name SniperShootingComponent

@export var wieldable: WieldableComponent
@export var raycast: RayCast3D
@export var overlay: Control
@export var character: CharacterBody3D

@export_category("Debug")
@export var enabled: bool = true:
	set(value):
		enabled = value
		if value:
			set_process_unhandled_input(true)
			character.hide()
			overlay.show()
		else:
			set_process_unhandled_input(false)
			overlay.hide()
			character.show()

signal is_sniper_disabled

func _ready() -> void:
	overlay.hide()


func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("execute_action") and \
		Globals.current_ui_element_active == Globals.UiElementActive.Sniper:
		# var target
		# if raycast.is_colliding():
		# 	target = raycast.get_collision_point()
		# else:
		# 	target = raycast.to_global(raycast.target_position)

		if wieldable.current_item.has_meta("SniperComponent"):
			wieldable.try_shoot_raycast(raycast)

	if Input.is_action_just_pressed("interact"):
		is_sniper_disabled.emit()
		Globals.current_ui_element_active = Globals.UiElementActive.None