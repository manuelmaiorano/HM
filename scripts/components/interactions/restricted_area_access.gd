extends Node
class_name RestrictedAreaAccessComponent

@export var detect_area: Area3D
@export var disguises_required: Array[ClothesInfo]

signal player_in_restricted_area
signal player_exited_restricted_area
signal player_executed_suspicious_action


var player_close = false
var player = null


func _enter_tree() -> void:
	detect_area.set_meta("RestrictedAreaAccessComponent", self)

func _ready() -> void:
	detect_area.body_entered.connect(on_body_entered)
	Globals.ExecutedAction.connect(on_action_executed)


func on_body_entered(body: Node3D):
	if body.is_in_group("player"):
		player = body
		if not is_player_disguised():
			player_in_restricted_area.emit()
		player_close = true

func on_body_exited(body: Node3D):
	if body.is_in_group("player"):
		player_exited_restricted_area.emit()
		player_close = false

func on_action_executed(action: InteractionAction):
	if player_close:
		if action.is_suspicious_in_restricted_area and not is_player_disguised():
			player_executed_suspicious_action.emit()

func is_player_disguised():
	var clothes_component = player.get_meta("ClothesComponent") as ClothesComponent
	return disguises_required.has(clothes_component.current_clothes)
