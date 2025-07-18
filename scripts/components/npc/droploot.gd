extends Node
class_name DropLootComponent


@export_category("Nodes")
@export var character: Node3D
@export var character_attachment: BoneAttachment3D
@export var inventory: InventoryComponent
@export var health: HealthComponent
@export var clothes_component: ClothesComponent
@export var bone_to_drag: PhysicalBone3D

@export_category("Parameters")
@export var loot_scene: PackedScene


func _ready() -> void:
	health.dead.connect(on_dead)


func on_dead():
	var instance = loot_scene.instantiate()
	character_attachment.add_child(instance)
	var loot_interactable = instance.get_meta("LootInteractableComponent") as LootInteractableComponent
	inventory.transfer_all_inventory(loot_interactable.inventory)
	loot_interactable.clothes_component = clothes_component
	loot_interactable.bone_to_drag = bone_to_drag

