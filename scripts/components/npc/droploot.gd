extends Node
class_name DropLootComponent


@export_category("Nodes")
@export var character: Node3D
@export var inventory: InventoryComponent
@export var health: HealthComponent
@export var clothes_component: ClothesComponent

@export_category("Parameters")
@export var loot_scene: PackedScene


func _ready() -> void:
	health.dead.connect(on_dead)


func on_dead():
	var instance = loot_scene.instantiate()
	character.get_parent().add_child(instance)
	instance.global_position = character.global_position
	var loot_interactable = instance.get_meta("LootInteractableComponent") as LootInteractableComponent
	inventory.transfer_all_inventory(loot_interactable.inventory)
	loot_interactable.clothes_component = clothes_component

