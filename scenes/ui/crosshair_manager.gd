extends Node


@export var no_interact_tex: TextureRect
@export var can_interact_tex: TextureRect

func _enter_tree() -> void:
	get_parent().set_meta("CrossHairManager", self)

func _ready() -> void:
	no_interact_tex.show()
	can_interact_tex.hide()

func toggle_cursor(can_interact):
	if can_interact:
		no_interact_tex.hide()
		can_interact_tex.show()
	else:
		no_interact_tex.show()
		can_interact_tex.hide()


func change_visibility(visibile):
	if visibile:
		get_parent().show()
	else:
		get_parent().hide()