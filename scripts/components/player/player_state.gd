extends Node

@export var health: HealthComponent
@export var player_input: PlayerInputComponent
@export var player_shooting: PlayerShootingComponent
@export var player_inventory: InventoryInteractionComponent
@export var player_interactions: WorldInteractionComponent

@export var state: State

enum State {Dead, Alive}

func  _ready() -> void:
	health.dead.connect(on_dead)

func on_dead():
	player_input.enabled = false
	player_shooting.enabled = false
	player_inventory.enabled = false
	player_interactions.enabled = false