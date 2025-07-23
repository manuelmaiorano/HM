extends Node


@export var npc_dialogue: Dictionary[CharacterBody3D, DialogicTimeline]


func _ready() -> void:
	for npc in npc_dialogue.keys():
		var dialogue_component = npc.get_meta("DialogueComponent") as DialogueComponent
		dialogue_component.timeline = npc_dialogue[npc]

		var talk_interaction = npc.get_meta("TalkInteractable") as TalkInteractable
		talk_interaction.enabled = true