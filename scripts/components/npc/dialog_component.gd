extends Node
class_name DialogueComponent

@export_category("Nodes")
@export var character: Node3D
@export var inventory: InventoryComponent

@export_category("Parameters")
@export var distance_to_stop_dialogue: float = 2.0

@export_category("Debug")
@export var timeline: DialogicTimeline

var player = null
var item_dropped = false

func _enter_tree() -> void:
	character.set_meta("DialogueComponent", self)
	Dialogic.timeline_ended.connect(on_timeline_ended)
	Dialogic.signal_event.connect(on_dialogic_signal)
	Globals.DialogueEndedByUi.connect(func(): stop())

func on_dialogic_signal(info: Dictionary):
	if not player:
		return
	var action_type = info["action"]
	var arguments = info["action_argument"]
	if action_type == "drop":
		inventory.equip_item(inventory.find_item_by_name(arguments))
		inventory.drop_item()
		item_dropped = true

func _ready() -> void:
	Dialogic.VAR.set('playerClothes', "")

func play(agent: Node3D):
	player = agent
	Dialogic.VAR.set('playerClothes', String(player.get_meta("ClothesComponent").current_clothes.name))
	Dialogic.VAR.set('itemDropped', item_dropped)

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