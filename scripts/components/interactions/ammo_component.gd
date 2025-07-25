extends Node
class_name AmmoComponent

@export_category("Nodes")
@export var agent: Node3D
@export var inventory: InventoryComponent

@export_category("Debug")
@export var remaining_ammo_amount: Dictionary[BulletInfo, int]

var ammo_per_weapon: Dictionary[InventoryComponent.InventoryItemInstance, int]

signal total_bullet_amount_changed(amount: int)


func _ready() -> void:
	inventory.item_added.connect(on_item_added)
	inventory.item_in_use_changed.connect(on_item_in_use_changed)

func on_item_in_use_changed(item: InventoryItem):
	if not item.is_weapon or item.weapon_info == null:
		total_bullet_amount_changed.emit(-1)
		pass

	total_bullet_amount_changed.emit(remaining_ammo_amount[item.weapon_info.bullet_info])
		

func on_item_added(item: InventoryItem):
	if item.is_weapon and item.weapon_info != null:
		pass


func reduce_magazine_ammo_per_weapon(item: InventoryItem, amount: int):

	total_bullet_amount_changed.emit(remaining_ammo_amount[item.weapon_info.bullet_info])

func add_bullets(bullet_info: BulletInfo, amount: int):
	if remaining_ammo_amount.has(bullet_info):
		remaining_ammo_amount[bullet_info] += amount
	else:
		remaining_ammo_amount[bullet_info] = amount

