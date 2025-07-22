extends Node


@export var places: Dictionary[StringName, PlaceInfo]

func _ready() -> void:
	Globals.places = places