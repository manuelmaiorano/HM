extends Node
class_name ProjectileMovement


@export_category("Nodes")
@export var agent: CharacterBody3D
@export var hurt_box: HurtBoxComponent

@export_category("Parameters")
@export var speed: float = 100.0
@export var life: float = 5.0
@export var target: Vector3:
	set(target):
		agent.velocity = speed * agent.global_position.direction_to(target)

var time_passed = 0.0

func _ready() -> void:
	hurt_box.has_hit.connect(func(): agent.queue_free())
	agent.set_meta("ProjectileMovement", self)

func _physics_process(delta: float) -> void:
	var collision = agent.move_and_collide(agent.velocity * delta)
	if collision:
		agent.queue_free()
		return
	time_passed += delta
	if time_passed > life:
		agent.queue_free()
