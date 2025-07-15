extends Node
class_name LookAtPlayerComponent

@export var detect_player_component: DetectPlayerComponent
@export var look_at_modifier: LookAtModifier3D

func _ready() -> void:
	detect_player_component.player_close_changed.connect(on_player_close)

func on_player_close(is_close: bool):
	if is_close:
		look_at_modifier.active = true
		look_at_modifier.target_node = detect_player_component.player.get_path()
	else:
		look_at_modifier.active = false
