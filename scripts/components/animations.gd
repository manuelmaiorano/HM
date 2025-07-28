extends Node
class_name AnimationsManagerComponent

@export_category("Nodes")
@export var character_movement: CharacterMovementComponent
@export var animation_tree: AnimationTree
@export var wieldable_component: WieldableComponent
@export var health: HealthComponent
@export var dragging_component: PlayerDraggingComponent
@export var sitting_component: CharacterSittingComponent


@export_category("Parameters")
@export var blend_to_shooting_duration: float = 0.1
@export var blend_from_shooting_duration: float = 0.5

var shooting_tween: Tween

func _ready() -> void:
	shooting_tween = create_tween()

	wieldable_component.is_shooting.connect(on_shooting)
	wieldable_component.is_silent_kill.connect(on_silent_kill)
	health.dead.connect(on_dead)
	sitting_component.is_sitting_state_changed.connect(on_sitting_state_changed)
	if dragging_component:
		dragging_component.is_dragging_state_changed.connect(on_drag_state_changed)

	animation_tree["parameters/Transition/transition_request"] = "alive"
	animation_tree["parameters/crouch_blend/blend_position"] = 0.0
	animation_tree["parameters/movement_blend/blend_position"] = 0.0
	animation_tree["parameters/blend_shoot/blend_amount"] = 0.0
	animation_tree["parameters/stab_kill/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_ABORT

func on_sitting_state_changed(is_sitting):
	if is_sitting:
		animation_tree["parameters/Transition/transition_request"] = "sit"
	else:
		animation_tree["parameters/Transition/transition_request"] = "alive"

func on_drag_state_changed(is_dragging: bool):
	if is_dragging:
		animation_tree["parameters/Transition/transition_request"] = "drag"
	else:
		animation_tree["parameters/Transition/transition_request"] = "alive"

func on_shooting():
	if shooting_tween.is_running():
		shooting_tween.kill()

	shooting_tween = create_tween()
	shooting_tween.tween_property(animation_tree, "parameters/blend_shoot/blend_amount", 1.0, blend_to_shooting_duration)
	shooting_tween.tween_property(animation_tree, "parameters/blend_shoot/blend_amount", 0.0, blend_from_shooting_duration).set_delay(2.0)

func on_silent_kill():
	animation_tree["parameters/stab_kill/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE

func on_dead():
	animation_tree["parameters/Transition/transition_request"] = "dead"

func _physics_process(_delta: float) -> void:
	animation_tree["parameters/movement_blend/blend_position"] = character_movement.character.velocity.length() /character_movement.run_speed
	if dragging_component:
		if dragging_component.enabled:
			animation_tree["parameters/crouch_blend/blend_position"] = character_movement.character.velocity.length() /character_movement.walk_speed

