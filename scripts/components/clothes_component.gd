extends Node
class_name ClothesComponent

@export_category("Nodes")
@export var character: CharacterBody3D
@export var skeleton: Skeleton3D

@export_category("Parameters")
@export var initial_clothes: ClothesInfo
@export var changed_clothes_scene: PackedScene = preload("res://scenes/props/ClothesGround.tscn")

var current_clothes: ClothesInfo
var current_clothes_mesh: Node3D

func _enter_tree() -> void:
	character.set_meta("ClothesComponent", self)

func _ready() -> void:
	change_clothes(initial_clothes)


func change_clothes(clothes: ClothesInfo):
	if not clothes:
		current_clothes = null
		skeleton.remove_child(current_clothes_mesh)
		return

	if current_clothes_mesh:
		skeleton.remove_child(current_clothes_mesh)

	if current_clothes:
		add_changed_clothes_scene(current_clothes)

	current_clothes = clothes
	var instance = current_clothes.scene.instantiate()
	instance.set_skeleton(skeleton)
	skeleton.add_child(instance)
	current_clothes_mesh = instance

func add_changed_clothes_scene(clothes_info):
	var instance = changed_clothes_scene.instantiate()
	character.get_parent().add_child(instance)
	var clothes_interactable = instance.get_meta("ClothesInteractable") as ClothesInteractable
	clothes_interactable.clothes_info = clothes_info
	instance.global_position = character.global_position
