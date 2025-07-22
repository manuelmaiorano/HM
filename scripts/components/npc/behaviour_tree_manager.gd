extends Node
class_name BehaviourTreeManagerComponent

@export var agent: Node3D
@export var bt_player: BTPlayer


func _enter_tree() -> void:
	agent.set_meta("BehaviourTreeManagerComponent", self)


func update_behaviour_tree(bt: BehaviorTree):
	bt_player.behavior_tree = bt