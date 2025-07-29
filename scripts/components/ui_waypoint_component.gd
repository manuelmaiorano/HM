extends Node

@export_category("Nodes")
@export var control: Control

@export_category("Parameters")
@export var sticky: bool = false

@export_category("Debug")
@export var camera: Camera3D = null

const MARGIN = 8


func _process(_delta: float) -> void:
	if not camera or not camera.current:
		# If the camera we have isn't the current one, get the current camera.
		camera = get_viewport().get_camera_3d()

	var parent_position: Vector3 = control.get_parent().global_transform.origin
	var camera_transform := camera.global_transform
	var camera_position := camera_transform.origin

	# We would use "camera.is_position_behind(parent_position)", except
	# that it also accounts for the near clip plane, which we don't want.
	var is_behind := camera_transform.basis.z.dot(parent_position - camera_position) > 0

	# Fade the waypoint when the camera gets close.
	var distance := camera_position.distance_to(parent_position)
	control.modulate.a = clamp(remap(distance, 0, 2, 0, 1), 0, 1 )

	var unprojected_position := camera.unproject_position(parent_position)
	# `get_size_override()` will return a valid size only if the stretch mode is `2d`.
	# Otherwise, the viewport size is used directly.
	var viewport_base_size: Vector2i = (
			get_viewport().content_scale_size if get_viewport().content_scale_size > Vector2i(0, 0)
			else get_viewport().size
	)

	if not sticky:
		# For non-sticky waypoints, we don't need to clamp and calculate
		# the position if the waypoint goes off screen.
		control.position = unprojected_position
		control.visible = not is_behind
		return

	# We need to handle the axes differently.
	# For the screen's X axis, the projected position is useful to us,
	# but we need to force it to the side if it's also behind.
	if is_behind:
		if unprojected_position.x < viewport_base_size.x / 2:
			unprojected_position.x = viewport_base_size.x - MARGIN
		else:
			unprojected_position.x = MARGIN

	# For the screen's Y axis, the projected position is NOT useful to us
	# because we don't want to indicate to the user that they need to look
	# up or down to see something behind them. Instead, here we approximate
	# the correct position using difference of the X axis Euler angles
	# (up/down rotation) and the ratio of that with the camera's FOV.
	# This will be slightly off from the theoretical "ideal" position.
	if is_behind or unprojected_position.x < MARGIN or \
			unprojected_position.x > viewport_base_size.x - MARGIN:
		var look := camera_transform.looking_at(parent_position, Vector3.UP)
		var diff := angle_difference(look.basis.get_euler().x, camera_transform.basis.get_euler().x)
		unprojected_position.y = viewport_base_size.y * (0.5 + (diff / deg_to_rad(camera.fov)))

	control.position = Vector2(
			clamp(unprojected_position.x, MARGIN, viewport_base_size.x - MARGIN),
			clamp(unprojected_position.y, MARGIN, viewport_base_size.y - MARGIN)
	)

	#label.visible = true
	control.rotation = 0
	# Used to display a diagonal arrow when the waypoint is displayed in
	# one of the screen corners.
	var overflow := 0

	if control.position.x <= MARGIN:
		# Left overflow.
		overflow = int(-TAU / 8.0)
		control.rotation = TAU / 4.0
	elif control.position.x >= viewport_base_size.x - MARGIN:
		# Right overflow.
		overflow = int(TAU / 8.0)
		control.rotation = TAU * 3.0 / 4.0

	if control.position.y <= MARGIN:
		# Top overflow.
		control.rotation = TAU / 2.0 + overflow
	elif control.position.y >= viewport_base_size.y - MARGIN:
		# Bottom overflow.
		control.rotation = -overflow
