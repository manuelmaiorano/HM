extends Label



func _physics_process(delta: float) -> void:
	text = "Time: %.3f" % Globals.get_timestamp_seconds()