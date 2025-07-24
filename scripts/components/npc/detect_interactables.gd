extends Node
class_name DetectInteractablesComponent


@export_category("Nodes")
@export var character: Node3D
@export var detect_area: Area3D
@export var raycast: RayCast3D

@export_category("Parameters")
@export var ignore_raycast: bool = true

@export_category("Debug")
@export var current_interactable: InteractableComponent
@export var current_interactable_action: InteractionAction

func _enter_tree() -> void:
	character.set_meta("DetectInteractablesComponent", self)

func pick_random_interactable(tag: StringName):
	var visible_areas = Globals.get_visible_areas(detect_area, func(x): return filter_interactables(x, tag), ignore_raycast, raycast)
	if visible_areas.is_empty():
		current_interactable = null
		current_interactable_action = null
		return
	current_interactable = visible_areas.pick_random().get_meta("InteractableComponent") 
	current_interactable_action = current_interactable.get_action_by_tag(tag)

func filter_interactables(area: Node3D, tag):
	if not area.has_meta("InteractableComponent"):
		return false

	var npc_interactions = area.get_meta("InteractableComponent") as InteractableComponent
	if not npc_interactions.is_reserved() and npc_interactions.get_tags().has(tag):
		return true

	return false
