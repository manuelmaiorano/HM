extends Node
class_name  InventoryComponent

@export_category("Nodes")
@export var character: Node3D
@export var drop_node: Node3D

@export_category("Parameters")
@export var initial_items: Array[InventoryItem]
@export var infinite_ammo: bool = false

@export_category("Debug")
@export var item_in_use: InventoryItem = null
@export var current_idx: int = -1
@export var remaining_ammo: Dictionary[BulletInfo, int]

signal inventory_changed(items: Array[InventoryItem], idx_selected: int)
signal item_in_use_changed(item: InventoryItem)
signal item_added(item: InventoryItem)

var current_items: Array[InventoryItemInstance] = []

#ammo stuff
var ammo_in_magazine: Dictionary[InventoryItemInstance, int]

class InventoryItemInstance:
	var id: int
	var item_type: InventoryItem

	static var progressive_id = 0

	static func create_from_inventory_item(item: InventoryItem) -> InventoryItemInstance:
		var instance = InventoryItemInstance.new()
		instance.item_type = item
		instance.id = InventoryItemInstance.progressive_id
		InventoryItemInstance.progressive_id += 1
		return instance

func _enter_tree() -> void:
	character.set_meta("InventoryComponent", self)

func _ready() -> void:
	assign_current_items_at_startup()
	initial_weapon_load()
	if item_in_use:
		item_in_use_changed.emit(item_in_use)
		current_idx = current_items.find_custom(func(x): return x.item_type == item_in_use)

	if not current_items.is_empty():
		emit_inventory_changed()

func emit_inventory_changed():
	var items = [] as Array[InventoryItem]
	for instance in current_items:
		items.append(instance.item_type)
	inventory_changed.emit(items, current_idx)
	equipped_weapon()

func assign_current_items_at_startup():
	for item in initial_items.duplicate():
		current_items.append(InventoryItemInstance.create_from_inventory_item(item))

func equip_item(idx: int):
	if idx == -1:
		item_in_use = null
		current_idx = -1
		item_in_use_changed.emit(item_in_use)
		equipped_weapon()
		return

	if current_idx == idx:
		return

	item_in_use = current_items[idx].item_type
	current_idx = idx
	item_in_use_changed.emit(item_in_use)
	equipped_weapon()

func drop_item():
	if item_in_use == null:
		return null
	var item_dropped = item_in_use

	var instance = load(item_in_use.scene_path).instantiate()
	character.get_parent().add_child(instance)
	instance.global_position = drop_node.global_position
	item_in_use = null
	
	update_weapon_ammo_on_drop(current_items[current_idx], instance)
	current_items.remove_at(current_idx)
	
	current_idx = -1
	item_in_use_changed.emit(item_in_use)

	return item_dropped

func add_item(item: InventoryItem, instance):
	var inventory_instance = InventoryItemInstance.create_from_inventory_item(item)
	current_items.append(inventory_instance)
	item_added.emit(item)
	picked_up_weapon(inventory_instance, instance)

func transfer_all_inventory(other_inventory: InventoryComponent):
	other_inventory.current_items = current_items
	current_items = []
	item_in_use = null
	current_idx = -1
	emit_inventory_changed()
	item_in_use_changed.emit(item_in_use)
	other_inventory.emit_inventory_changed()


func transfer_item(item_instance: InventoryItemInstance, other_inventory: InventoryComponent):
	assert(current_items.has(item_instance))
	other_inventory.current_items.append(item_instance)
	current_items.erase(item_instance)
	if current_idx != -1 and current_items[current_idx] == item_instance:
		item_in_use = null
		current_idx = -1
		item_in_use_changed.emit(item_in_use)

	other_inventory.picked_up_weapon(item_instance, null)
	emit_inventory_changed()
	other_inventory.emit_inventory_changed()


func assign_initial_items(items: Array):
	initial_items = []
	item_in_use = null
	current_idx = -1

	for item in items:
		initial_items.append(item as InventoryItem)


func find_item_by_name(item_name: String):
	for idx in current_items.size():
		var item = current_items[idx].item_type
		if item.name == item_name:
			return idx
	return -1


#ammostuff
signal ammo_info_changed(remaining_in_magazine: int, remaining_total: int)

func picked_up_weapon(item_instance: InventoryItemInstance, instance):
	if item_instance.item_type.is_weapon and item_instance.item_type.weapon_info != null:
		if instance != null:
			var magazine = instance.get_meta("MagazineComponent") as MagazineComponent
			ammo_in_magazine[item_instance] = magazine.bullet_amount
		else:
			ammo_in_magazine[item_instance] = 0

func pick_up_ammo(bullet_info: BulletInfo, amount: int):
	if remaining_ammo.has(bullet_info):
		remaining_ammo[bullet_info] += amount
	else:
		remaining_ammo[bullet_info] = amount

	if  current_idx  == -1:
		return

	var item_instance = current_items[current_idx]
	if item_instance.item_type.is_weapon and item_instance.item_type.weapon_info != null:
		var bullet_type = item_instance.item_type.weapon_info.bullet_info
		ammo_info_changed.emit(ammo_in_magazine[item_instance], remaining_ammo.get(bullet_type, 0))

func reload_equipped():
	assert(current_idx != -1)
	var item_equipped = current_items[current_idx]
	var bullet_type = item_equipped.item_type.weapon_info.bullet_info
	reload(item_equipped)
	ammo_info_changed.emit(ammo_in_magazine[item_equipped], remaining_ammo.get(bullet_type, 0))

func reload(item_instace: InventoryItemInstance):
	var bullet_type = item_instace.item_type.weapon_info.bullet_info

	if infinite_ammo:
		ammo_in_magazine[item_instace] = item_instace.item_type.weapon_info.magazine_size
		return

	if remaining_ammo.has(bullet_type) and remaining_ammo[bullet_type] > 0:
		ammo_in_magazine[item_instace] = min(item_instace.item_type.weapon_info.magazine_size, remaining_ammo[bullet_type])
		remaining_ammo[bullet_type] -= ammo_in_magazine[item_instace]
	

func reduce_ammo_equipped():
	assert(current_idx != -1)
	var item_instace_equipped = current_items[current_idx]
	var bullet_type = item_instace_equipped.item_type.weapon_info.bullet_info

	if ammo_in_magazine[item_instace_equipped] > 0:
		ammo_in_magazine[item_instace_equipped] -= 1
	ammo_info_changed.emit(ammo_in_magazine[item_instace_equipped], remaining_ammo.get(bullet_type, 0))

func equipped_weapon():
	if current_idx == -1:
		ammo_info_changed.emit(-1, -1)
		return

	var item_instace_equipped = current_items[current_idx]
	if item_instace_equipped.item_type.is_weapon and item_instace_equipped.item_type.weapon_info != null:
		var bullet_type = item_instace_equipped.item_type.weapon_info.bullet_info
		ammo_info_changed.emit(ammo_in_magazine[item_instace_equipped], remaining_ammo.get(bullet_type, 0))
	else:
		ammo_info_changed.emit(-1, -1)

func check_equipped_weapon_ammo():
	assert(current_idx != -1)
	var item_instace_equipped = current_items[current_idx]
	return ammo_in_magazine[item_instace_equipped] > 0

func update_weapon_ammo_on_drop(item_dropped: InventoryItemInstance, instance):
	if not item_dropped.item_type.is_weapon:
		return
	var bullet_amount = ammo_in_magazine[item_dropped]
	ammo_in_magazine.erase(item_dropped)
	var magazine = instance.get_meta("MagazineComponent") as MagazineComponent
	magazine.bullet_amount = bullet_amount

func initial_weapon_load():
	for item in current_items:
		if item.item_type.is_weapon and item.item_type.weapon_info != null:
			reload(item)