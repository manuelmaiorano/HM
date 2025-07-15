extends Node
class_name WieldableComponent

@export var bone_attachment_offset_node: Node3D
@export var inventory: InventoryComponent
@export var current_item: Node3D

func _ready() -> void:
	inventory.item_in_use_changed.connect(on_item_changed)

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
	instance.freeze = true
	current_item = instance

func try_shoot(target) -> bool:
	if current_item == null:
		return false
	if current_item.has_meta("Shootable"):
		var shootable_component = current_item.get_meta("Shootable") as Shootable
		shootable_component.shoot(target)
		return true
	return false

	
