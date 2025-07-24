extends Node
class_name NpcShoutsComponent

@export_category("Nodes")
@export var character: Node3D
@export var npc_events: NpcEventsComponent
@export var audio_player: AudioStreamPlayer3D

@export_category("Parameters")
@export var shouts: NpcShouts

@export_category("Debug")
@export var enabled: bool = true

func _enter_tree() -> void:
	character.set_meta("NpcShoutsComponent", self)

func _ready() -> void:
	npc_events.player_is_holding_weapon.connect(func(): play_random_stream(shouts.shouts_on_player_holding_weapon))
	npc_events.spotted_dead_body.connect(func(): play_random_stream(shouts.shouts_on_dead_body_found_near_player))
	npc_events.player_suspicious_action.connect(func(): play_random_stream(shouts.shouts_on_player_suspiciuos_action))


func play_random_stream(streams: Array[AudioStream]):
	if not enabled:
		return
	audio_player.stream = streams.pick_random()
	audio_player.play()


