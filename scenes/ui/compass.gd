extends Node

@export var compass_ui: Control

var player: Node3D
var character_movement: CharacterMovementComponent

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	character_movement = player.get_meta("CharacterMovementComponent") as CharacterMovementComponent


func _physics_process(_delta: float) -> void:
	compass_ui.rotation = character_movement.character_model.global_rotation.y