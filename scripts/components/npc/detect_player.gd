extends Node
class_name DetectPlayerComponent


@export_category("Nodes")
@export var character: CharacterBody3D
@export var detect_area: Area3D
@export var raycast: RayCast3D

@export_category("Debug")
@export var is_player_visible: bool = false:
	set(value):
		if value != is_player_visible:
			player_visibility_changed.emit(value)
		is_player_visible = value

@export var last_seen_position: Vector3 = Vector3.ZERO
@export var last_seen_time: float = 0.0

signal player_close_changed(value: bool)
signal player_visibility_changed(value: bool)

var player_close = false
var player = null
var vis_check_component: VisibilityCheckTargetComponent = null

var initialized_player_variables = false

func _ready() -> void:
	character.set_meta("DetectPlayerComponent", self)
	detect_area.body_entered.connect(on_body_entered)
	detect_area.body_exited.connect(on_body_exited)

func on_body_entered(body: Node3D):
	if body.is_in_group("player"):
		if not initialized_player_variables:
			player = body
			vis_check_component = player.get_meta("VisibilityCheckTargetComponent") as VisibilityCheckTargetComponent
			initialized_player_variables = true
		player_close = true
		player_close_changed.emit(player_close)


func on_body_exited(body: Node3D):
	if body.is_in_group("player"):
		player_close = false
		player_close_changed.emit(player_close)

func _physics_process(_delta: float) -> void:
	if player_close and vis_check_component:
		raycast.target_position = raycast.to_local(vis_check_component.target_node.global_position)
		if raycast.is_colliding():
			if raycast.get_collider().is_in_group("player"):
				is_player_visible = true
			else:
				update_player_last_known_position()
				is_player_visible = false
		else:
			update_player_last_known_position()
			is_player_visible = false
	else:
		update_player_last_known_position()
		is_player_visible = false

func update_player_last_known_position():
	var was_visible_prev_frame = is_player_visible
	if player and was_visible_prev_frame:
		last_seen_position = player.global_position
		last_seen_time = Globals.get_timestamp_seconds()
