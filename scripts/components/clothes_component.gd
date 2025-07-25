extends Node
class_name ClothesComponent

@export_category("Nodes")
@export var character: CharacterBody3D
@export var skeleton: Skeleton3D
@export var clothes_mesh: MeshInstance3D
@export var base_mesh: MeshInstance3D


@export_category("Parameters")
@export var initial_clothes: ClothesInfo
@export var changed_clothes_scene: PackedScene = preload("res://scenes/props/ClothesGround.tscn")

var current_clothes: ClothesInfo

func _enter_tree() -> void:
	character.set_meta("ClothesComponent", self)

func _ready() -> void:
	change_clothes(initial_clothes)


func change_clothes(clothes: ClothesInfo):
	if not clothes:
		current_clothes = null
		clothes_mesh.mesh = null
		return

	if current_clothes:
		add_changed_clothes_scene(current_clothes)

	current_clothes = clothes
	clothes_mesh.mesh = clothes.clothes_mesh
	clothes_mesh.material_override = clothes.clothes_material

func add_changed_clothes_scene(clothes_info):
	var instance = changed_clothes_scene.instantiate()
	character.get_parent().add_child(instance)
	var clothes_interactable = instance.get_meta("ClothesInteractable") as ClothesInteractable
	clothes_interactable.clothes_info = clothes_info
	if clothes_info.clothes_material_when_on_ground != null:
		instance.find_children("*", "MeshInstance3D", true)[0].material_override = clothes_info.clothes_material_when_on_ground
	instance.global_position = character.global_position


func set_base_mesh(mesh_info: BaseMeshInfo):
	base_mesh.mesh = mesh_info.mesh
	base_mesh.material_override = mesh_info.material