extends Node
class_name AnimationsManagerComponent

@export var animation_tree: AnimationTree
@export var player_shooting_component: PlayerShootingComponent


func _ready() -> void:
	player_shooting_component.is_shooting.connect(on_shooting)

func on_shooting():
	animation_tree["parameters/OneShot/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE
