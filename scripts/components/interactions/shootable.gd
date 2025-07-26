extends Node
class_name Shootable

@export_category("Nodes")
@export var agent: Node3D
@export var shoot_from: Node3D

@export_category("Parameters")
@export var bullet_info: BulletInfo
@export_flags_3d_physics var raycast_collision_mask: int


signal is_shooting

func _ready() -> void:
	agent.set_meta("Shootable", self)

func shoot(target: Vector3, velocity: Vector3, override_shoot_from: Node3D = null, use_velocity: bool = true, use_raycast: bool = true):
	if not use_raycast:
		var instance = bullet_info.scene.instantiate()
		agent.add_child(instance)
		instance.get_meta("HurtBoxComponent").damage = bullet_info.damage
		instance.top_level = true
		if override_shoot_from:
			instance.global_position = override_shoot_from.global_position
		else:
			instance.global_position = shoot_from.global_position

		if use_velocity:
			instance.get_meta("ProjectileMovement").target = target + velocity
		else:
			instance.get_meta("ProjectileMovement").target = target
		DebugDraw3D.draw_line(instance.global_position, target, Color.REBECCA_PURPLE, 2.0)
	else:
		var space_state = agent.get_world_3d().direct_space_state
		var query = PhysicsRayQueryParameters3D.create(shoot_from.global_position, target, raycast_collision_mask)
		query.collide_with_areas = true

		var result = space_state.intersect_ray(query)	
		var collider = result["collider"]	
		if collider.has_meta("HitBoxComponent"):
			var hitbox = collider.get_meta("HitBoxComponent", null) as HitBoxComponent
			hitbox.take_damage(bullet_info.damage, agent)
		
	is_shooting.emit()


func raycast_shoot(raycast: RayCast3D):
	var damage = bullet_info.damage
	
	if raycast.is_colliding():
		var collider = raycast.get_collider()
		if collider.has_meta("HitBoxComponent"):
			var hitbox = collider.get_meta("HitBoxComponent", null) as HitBoxComponent
			hitbox.take_damage(damage, agent)

	is_shooting.emit()
