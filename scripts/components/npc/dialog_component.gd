extends Node
class_name DialogueComponent

@export_category("Nodes")
@export var character: Node3D

@export_category("Parameters")
@export var distance_to_stop_dialogue: float = 2.0

@export_category("Debug")
@export var timeline: DialogicTimeline

var player = null

func _enter_tree() -> void:
	character.set_meta("DialogueComponent", self)
	Dialogic.timeline_ended.connect(on_timeline_ended)
	Globals.DialogueEndedByUi.connect(func(): stop())

func _ready() -> void:
	Dialogic.VAR.set('playerClothes', "")

func play(agent: Node3D):
	player = agent
	Dialogic.VAR.set('playerClothes', player.get_meta("ClothesComponent").current_clothes.name)
	Dialogic.start(timeline)
	Globals.DialogueStarted.emit()

func stop():
	Dialogic.end_timeline()
	Globals.DialogueEnded.emit()

func on_timeline_ended():
	Globals.DialogueEnded.emit()

func _physics_process(_delta):
	if player == null:
		return

	if player.global_position.distance_to(character.global_position) > distance_to_stop_dialogue:
		stop()