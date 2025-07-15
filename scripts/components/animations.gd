extends Node
class_name AnimationsManagerComponent

@export var character_movement: CharacterMovementComponent
@export var animation_tree: AnimationTree
@export var wieldable_component: WieldableComponent


func _ready() -> void:
	wieldable_component.is_shooting.connect(on_shooting)

func on_shooting():
	animation_tree["parameters/shoot/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE

func _physics_process(_delta: float) -> void:
	animation_tree["parameters/movement_blend/blend_position"] = character_movement.character.velocity.length() /character_movement.run_speed
