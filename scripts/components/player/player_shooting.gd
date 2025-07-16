extends Node
class_name PlayerShootingComponent

@export var wieldable: WieldableComponent
@export var raycast: RayCast3D

@export_category("Debug")
@export var enabled: bool:
	set(value):
		enabled = value
		if value:
			set_process_unhandled_input(true)
		else:
			set_process_unhandled_input(false)

func _ready() -> void:
	return


func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("execute_action") and \
		Globals.current_ui_element_active == Globals.UiElementActive.None:
		var target
		if raycast.is_colliding():
			target = raycast.get_collision_point()
		else:
			target = raycast.to_global(raycast.target_position)

		wieldable.try_shoot(target)
