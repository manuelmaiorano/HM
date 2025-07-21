extends Node


@export var schedules: Dictionary[CharacterBody3D, Schedule]


func _ready() -> void:
	for character in schedules.keys():
		var schedule_component = character.get_meta("FollowScheduleComponent") as FollowScheduleComponent
		schedule_component.schedule = schedules[character]