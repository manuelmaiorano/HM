extends Node
class_name DetectPlayerComponent


@export_category("Nodes")
@export var detect_area: Area3D
@export var raycast: RayCast3D

@export_category("Debug")
@export var is_player_visible: bool = false

var player_close = false
var player = null
var vis_check_component: VisibilityCheckTargetComponent = null

func _ready() -> void:
	detect_area.body_entered.connect(on_body_entered)
	detect_area.body_exited.connect(on_body_exited)

func on_body_entered(body: Node3D):
	if body.is_in_group("player"):
		player_close = true
		player = body
		vis_check_component = player.get_meta("VisibilityCheckTargetComponent") as VisibilityCheckTargetComponent


func on_body_exited(body: Node3D):
	if body.is_in_group("player"):
		player_close = false
		player = null
		vis_check_component = null

func _physics_process(_delta: float) -> void:
	if player_close and vis_check_component:
		raycast.target_position = raycast.to_local(vis_check_component.target_node.global_position)
		if raycast.is_colliding():
			if raycast.get_collider().is_in_group("player"):
				is_player_visible = true
			else:
				is_player_visible = false
		else:
			is_player_visible = false
	else:
		is_player_visible = false
