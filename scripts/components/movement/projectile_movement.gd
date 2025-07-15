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
		var velocity = speed * agent.global_position.direction_to(target)
		agent.velocity = velocity

var time_passed = 0.0

func _ready() -> void:
	hurt_box.has_hit.connect(func(): agent.queue_free())
	agent.set_meta("ProjectileMovement", self)


func _physics_process(delta: float) -> void:
	agent.move_and_slide()
	time_passed += delta
	if time_passed > life:
		agent.queue_free()
