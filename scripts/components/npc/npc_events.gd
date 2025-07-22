extends Node
class_name NpcEventsComponent

@export var character: CharacterBody3D

signal audio_heard
signal player_is_holding_weapon
signal player_near_dead_body
signal player_suspicious_action
signal spotted_alarmed_npc
signal spotted_dead_body

func _enter_tree() -> void:
	character.set_meta("NpcEventsComponent", self)