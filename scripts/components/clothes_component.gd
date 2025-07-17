extends Node
class_name ClothesComponent

@export_category("Nodes")
@export var character: CharacterBody3D
@export var skeleton: Skeleton3D

@export_category("Parameters")
@export var initial_clothes: ClothesInfo

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
	current_clothes = clothes
	var instance = current_clothes.scene.instantiate()
	instance.set_skeleton(skeleton)
	skeleton.add_child(instance)
	current_clothes_mesh = instance