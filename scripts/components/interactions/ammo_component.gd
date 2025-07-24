extends Node
class_name AmmoComponent

@export_category("Nodes")
@export var agent: Node3D

@export_category("Parameters")
@export var bullet_info: BulletInfo

var ammo_per_weapon: Dictionary[InventoryItem, int]
var remaining_ammo_amount: Dictionary[BulletInfo, int]


var current_ammo