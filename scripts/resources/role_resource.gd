extends Resource
class_name NpcRole

@export var role_name: StringName
@export var behaviour_tree: BehaviorTree
@export var shouts: NpcShouts
@export var initial_inventory: Array[InventoryItem]
@export var item_in_use: InventoryItem
@export var initial_clothes: ClothesInfo