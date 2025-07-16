extends Node
class_name WorldInteractionComponent

@export var raycast: RayCast3D 


@export_category("Debug")
@export var enabled: bool:
	set(value):
		enabled = value
		if value:
			set_physics_process(true)
		else:
			set_physics_process(false)

var was_colliding_previous_frame = false
var current_interactable: InteractableComponent = null

func _ready() -> void:
	Globals.ExecuteAction.connect(on_execute_action)

func on_execute_action(action: InteractionAction):
	if current_interactable:
		current_interactable.execute_action(action)

func _physics_process(_delta: float) -> void:
	if raycast.is_colliding():
		if was_colliding_previous_frame:
			if Input.is_action_just_pressed("interact"):
				var collider = raycast.get_collider()
				if collider.has_meta("InteractableComponent"):
					var interactions = raycast.get_collider().get_meta("InteractableComponent") as InteractableComponent
					current_interactable = interactions
					Globals.Interactions.emit(interactions.get_actions())
			return
		else:
			var collider = raycast.get_collider()
			if collider.has_meta("InteractableComponent"):
				Globals.CanInteract.emit(true)
				was_colliding_previous_frame = true
	else:
		if was_colliding_previous_frame:
			Globals.CanInteract.emit(false)
			#Globals.Interactions.emit([] as Array[InteractionAction])
			current_interactable = null
			was_colliding_previous_frame = false
