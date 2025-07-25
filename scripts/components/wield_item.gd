extends Node
class_name WieldableComponent

@export_category("Nodes")
@export var character: CharacterBody3D
@export var bone_attachment_offset_node: Node3D
@export var inventory: InventoryComponent
@export var shoot_from: Node3D
@export var hit_box_exceptions_when_wielding_hurtbox: Array[Area3D]

@export_category("Parameters")
@export var ignore_ammo_check: bool = false

@export_category("Debug")
@export var current_item: Node3D

signal is_shooting()
signal is_silent_kill()

func _enter_tree() -> void:
	character.set_meta("WieldableComponent", self)
	inventory.item_in_use_changed.connect(on_item_changed)

func _ready() -> void:
	pass

func on_item_changed(item: InventoryItem):
	if bone_attachment_offset_node.get_child_count() >0:
		bone_attachment_offset_node.get_child(0).queue_free()
		current_item = null
	if item == null:
		return

	var instance = load(item.scene_path).instantiate()
	var attachment_transform = Transform3D(item.wield_transform_rotation, item.wield_transform_position)
	bone_attachment_offset_node.transform = attachment_transform
	bone_attachment_offset_node.add_child(instance)
	add_wieldable_exceptions(instance)
	instance.freeze = true
	current_item = instance

func add_wieldable_exceptions(instance):
	if instance.has_meta("HurtBoxComponent"):
		var hb = instance.get_meta("HurtBoxComponent") as HurtBoxComponent
		hb.exceptions = hit_box_exceptions_when_wielding_hurtbox

func try_shoot(target: Vector3, velocity: Vector3) -> bool:
	if current_item == null:
		return false
	if current_item.has_meta("Shootable"):
		if ignore_ammo_check:
			var shootable_component = current_item.get_meta("Shootable") as Shootable
			shootable_component.shoot(target, velocity, shoot_from)
			is_shooting.emit()
			return true
		
		if inventory.check_equipped_weapon_ammo():
			var shootable_component = current_item.get_meta("Shootable") as Shootable
			shootable_component.shoot(target, velocity, shoot_from)
			is_shooting.emit()
			inventory.reduce_ammo_equipped()
			return true
		else:
			inventory.reload_equipped()
			return false
	return false


func try_shoot_raycast(raycast: RayCast3D) -> bool:

	if current_item == null:
		return false
	if current_item.has_meta("Shootable"):
		var shootable_component = current_item.get_meta("Shootable") as Shootable
		if ignore_ammo_check:
			shootable_component.raycast_shoot(raycast)
			is_shooting.emit()
			return true

		if inventory.check_equipped_weapon_ammo():
			shootable_component.raycast_shoot(raycast)
			is_shooting.emit()
			inventory.reduce_ammo_equipped()
			return true
		else:
			inventory.reload_equipped()
			return false
	return false


func try_silent_kill(raycast: RayCast3D) -> bool:
	if current_item == null:
		return false
	if current_item.has_meta("Stabbable"):
		var stabbable_component = current_item.get_meta("Stabbable") as Stabbable
		stabbable_component.raycast_kill(raycast)
		is_silent_kill.emit()
	return false

	
