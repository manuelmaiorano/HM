extends BTAction

var detect_interactables_component: DetectInteractablesComponent


func _setup() -> void:
	detect_interactables_component = agent.get_meta("DetectInteractablesComponent")

func _enter() -> void:
	detect_interactables_component.current_interactable.on_action_enter_npc(detect_interactables_component.current_interactable_action, agent)

func _exit() -> void:
	detect_interactables_component.current_interactable.on_action_exit_npc(detect_interactables_component.current_interactable_action, agent)

func _tick(delta: float) -> Status:
	if detect_interactables_component.current_interactable.on_action_process_npc(delta, detect_interactables_component.current_interactable_action, agent):
		return SUCCESS
	return RUNNING