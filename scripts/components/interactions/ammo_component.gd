extends Node
class_name AmmoComponent

@export_category("Nodes")
@export var agent: Node3D
@export var inventory: InventoryComponent


var ammo_per_weapon: Dictionary[InventoryItem, int]
var remaining_ammo_amount: Dictionary[BulletInfo, int]


var current_ammo

func _ready() -> void:
	inventory.item_added.connect(on_item_added)

func on_item_added(item: InventoryItem):
	if item.is_weapon and item.weapon_info != null:
		pass

func add_magazine_ammo_to_weapon(item: InventoryItem, ammo: int):
	if ammo_per_weapon.has(item):
		ammo_per_weapon[item] += ammo
	else:
		ammo_per_weapon[item] = ammo

func reduce_magazine_ammo_per_weapon(item: InventoryItem, amount: int):
	if ammo_per_weapon.has(item):
		ammo_per_weapon[item] -= amount

func add_bullets(bullet_info: BulletInfo, amount: int):
	if remaining_ammo_amount.has(bullet_info):
		remaining_ammo_amount[bullet_info] += amount
	else:
		remaining_ammo_amount[bullet_info] = amount