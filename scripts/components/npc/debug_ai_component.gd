extends Node

@export_category("Nodes")
@export var character: CharacterBody3D
@export var behaviour_tree: BTPlayer
@export var overhead_label: Label
@export var debug_text_node_position: Node3D
@export var detect_player_component: DetectPlayerComponent
@export var detect_dead_body_component: DetectDeadBodyComponent
@export var detect_alarm_component: DetectAlarmedNpcComponent

@export_category("Parameters")
@export var enabled: bool = false
@export var interpolation_string: String = "player_visible: %s\ndead_body_detected: %s\n"
@export var distance_to_show: float = 10.0

@export_category("Debug")
var player: Node3D

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	if not enabled:
		overhead_label.hide()
	else:
		overhead_label.show()

func _physics_process(_delta: float) -> void:
	if not enabled:
		return
	if character.global_position.distance_squared_to(player.global_position) > distance_to_show**2:
		overhead_label.hide()
		return
	overhead_label.show()
	#overhead_label.text = "player_visible : %s" % detect_player_component.is_player_visible
	var text = interpolation_string % [detect_player_component.is_player_visible, \
		detect_dead_body_component.last_body]

	overhead_label.text = text

