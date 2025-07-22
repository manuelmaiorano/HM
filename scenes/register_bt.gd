extends Node

@export var npc_behaviour_trees: Dictionary[CharacterBody3D, BehaviorTree]


func _ready() -> void:
	for npc in npc_behaviour_trees.keys():
		var bt_component = npc.get_meta("BehaviourTreeManagerComponent") as BehaviourTreeManagerComponent
		bt_component.update_behaviour_tree(npc_behaviour_trees[npc])