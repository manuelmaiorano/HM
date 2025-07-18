extends Node

@export var health: HealthComponent

@export var player_input: PlayerInputComponent
@export var player_shooting: PlayerShootingComponent
@export var player_inventory: PlayerInventoryInteractionComponent
@export var player_interactions: PlayerInteractionsComponent
@export var camera_control_normal: CameraControl
@export var camera_control_sniper: CameraControl
@export var camera_zoom_sniper: SniperZoomControl
@export var sniper_shooting: SniperShootingComponent

@export var camera_normal: Camera3D
@export var camera_sniper: Camera3D

@export var state: State

enum State {Dead, Alive, Sniper}

func  _ready() -> void:
	on_alive()
	health.dead.connect(on_dead)
	player_shooting.is_sniper_enabled.connect(on_sniper)
	sniper_shooting.is_sniper_disabled.connect(on_alive)

func on_alive():
	state = State.Alive
	disable_all()
	camera_control_normal.enabled = true
	camera_normal.current = true
	player_input.enabled = true
	player_shooting.enabled = true
	player_inventory.enabled = true
	player_interactions.enabled = true

func on_dead():
	state = State.Dead
	disable_all()
	camera_control_normal.enabled = true
	camera_normal.current = true


func on_sniper():
	state = State.Sniper
	disable_all()
	camera_control_sniper.enabled = true
	camera_zoom_sniper.enabled = true
	camera_sniper.current = true
	sniper_shooting.enabled = true


func disable_all():
	player_input.enabled = false
	player_shooting.enabled = false
	player_inventory.enabled = false
	player_interactions.enabled = false
	camera_control_normal.enabled = false
	camera_control_sniper.enabled = false
	camera_zoom_sniper.enabled = false
	sniper_shooting.enabled = false