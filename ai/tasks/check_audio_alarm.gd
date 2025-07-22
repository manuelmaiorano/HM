extends BTCondition


var hearing_component: AudioHearingComponent
var npc_events: NpcEventsComponent

var is_sound_heard: bool = false

func _setup() -> void:
	npc_events = agent.get_meta("NpcEventsComponent") as NpcEventsComponent
	hearing_component = agent.get_meta("AudioHearingComponent")
	hearing_component.is_sound_heard.connect(on_sound_heard)

func on_sound_heard():
	is_sound_heard = true
	npc_events.audio_heard.emit()
	blackboard.set_var("investigate_position", hearing_component.last_sound_location)


func _tick(_delta: float) -> Status:
	if is_sound_heard:
		return SUCCESS
	return FAILURE
