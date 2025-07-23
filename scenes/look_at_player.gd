extends Node
class_name LookAtPlayerComponent

@export_category("Nodes")
@export var detect_player_component: DetectPlayerComponent
@export var look_at_modifier: LookAtModifier3D
@export var target_component: TargetLookAtComponent

@export_category("Debug")
@export var enabled = true:
	set(value):
		enabled = value
		if not enabled:
			look_at_modifier.active = false

func _ready() -> void:
	detect_player_component.player_close_changed.connect(on_player_close)

func on_player_close(is_close: bool):
	if not enabled:
		return
	if is_close:
		look_at_modifier.active = true
		target_component = detect_player_component.player.get_meta("TargetLookAtComponent")
		look_at_modifier.target_node = target_component.target.get_path()
	else:
		look_at_modifier.active = false
