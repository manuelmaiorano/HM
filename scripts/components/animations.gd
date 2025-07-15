extends Node
class_name AnimationsManagerComponent

@export var animation_tree: AnimationTree
@export var wieldable_component: WieldableComponent


func _ready() -> void:
	wieldable_component.is_shooting.connect(on_shooting)

func on_shooting():
	animation_tree["parameters/OneShot/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE
