extends Node
class_name ProjectileMovement


@export_category("Nodes")
@export var agent: CharacterBody3D
@export var hurt_box: HurtBoxComponent

@export_category("Parameters")
@export var speed: float = 100.0
@export var target: Node3D:
	set(target):
		var velocity = speed * agent.global_position.direction_to(target.global_position)
		agent.velocity = velocity


func _ready() -> void:
	hurt_box.has_hit.connect(func(): agent.queue_free())
	agent.set_meta("ProjectileMovement", self)

func _physics_process(_delta: float) -> void:
	agent.move_and_slide()
