extends Node


@export var switch_to_switchables: Dictionary[Node3D, Array]

func _ready() -> void:
	for switch in switch_to_switchables:
		var switch_component = switch.get_meta("SwitchComponent") as SwitchComponent

		for switchable in switch_to_switchables[switch]:
			var switchable_comp = get_node(switchable).get_meta("SwitchableComponent") as SwitchableComponent
			switch_component.swhitchables.append(switchable_comp)