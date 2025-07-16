extends Node

@export var shootable_component: Shootable
@export var audio_player: AudioStreamPlayer3D
@export var audio_area: AudioAreaComponent


func _ready() -> void:
	shootable_component.is_shooting.connect(on_shooting)

func on_shooting():
	audio_player.play()
	audio_area.activate()