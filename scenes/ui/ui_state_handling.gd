extends Node


enum UiState {None, InUiInteractionsMenu, InInventoryMenu, InSniperView, InDialogueMenu}

@export var uistate: UiState = UiState.None:
	set(value):
		uistate = value
		hide_all()
		match uistate:
			UiState.None:
				crosshair_manager.change_visibility(true)

			UiState.InInventoryMenu:
				inventory_manager.change_visibility(true)

			UiState.InUiInteractionsMenu:
				interactions_manager.change_visibility(true)

			UiState.InDialogueMenu:
				pass
			
			UiState.InSniperView:
				pass

@export var crosshair_menu: Control
@export var interactions_menu: Control
@export var inventory_menu: Control
@export var dialogue_menu: Control

var crosshair_manager
var interactions_manager
var inventory_manager

func _ready() -> void:
	crosshair_manager = crosshair_menu.get_meta("CrossHairManager")
	interactions_manager = interactions_menu.get_meta("InteractionsManager")
	inventory_manager = inventory_menu.get_meta("InventoryManager")
	Globals.Interactions.connect(on_interactions_update)
	Globals.CanInteract.connect(on_can_interact)
	Globals.SniperActivated.connect(on_sniper_activated)
	Globals.DialogueStarted.connect(on_dialogue_started)
	Globals.DialogueEnded.connect(on_dialogue_ended)


func on_dialogue_started():
	uistate = UiState.InDialogueMenu


func on_dialogue_ended():
	if uistate == UiState.InDialogueMenu:
		uistate = UiState.None

func on_sniper_activated():
	if uistate == UiState.None:
		uistate = UiState.InSniperView

func on_interactions_update(_x):
	if uistate == UiState.None:
		uistate = UiState.InUiInteractionsMenu

func on_can_interact(can_interact: bool):
	crosshair_manager.toggle_cursor(can_interact)


func hide_all():
	crosshair_manager.change_visibility(false)
	interactions_manager.change_visibility(false)
	inventory_manager.change_visibility(false)
	#dialogue_menu.hide()

func _unhandled_input(event: InputEvent) -> void:
	match uistate:
		UiState.None:
			input_none(event)

		UiState.InInventoryMenu:
			input_inventory_menu(event)

		UiState.InUiInteractionsMenu:
			input_interactions_menu(event)

		UiState.InDialogueMenu:
			input_dialogue_menu(event)
		
		UiState.InSniperView:
			input_sniper_view(event)

func input_none(event: InputEvent):
	if Input.is_action_just_pressed("execute_action"):
		Globals.PlayerShootingAction.emit()

	if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_WHEEL_UP or event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				uistate = UiState.InInventoryMenu


func input_inventory_menu(event: InputEvent):
	if Input.is_action_just_pressed("execute_action"):
		inventory_manager.select_invetory_item()
		uistate = UiState.None

	if Input.is_action_just_pressed("interact"):
		uistate = UiState.None

	if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_WHEEL_UP or event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				inventory_manager.scroll(event)


func input_interactions_menu(event: InputEvent):
	if Input.is_action_just_pressed("execute_action"):
		interactions_manager.select_interaction()
		if uistate != UiState.InDialogueMenu:
			uistate = UiState.None

	if Input.is_action_just_pressed("interact"):
		uistate = UiState.None

	if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_WHEEL_UP or event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				interactions_manager.scroll(event)


func input_dialogue_menu(event: InputEvent):
	if Input.is_action_just_pressed("execute_action"):
		pass

	if Input.is_action_just_pressed("interact"):
		Globals.DialogueEndedByUi.emit()
		uistate = UiState.None

	if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_WHEEL_UP or event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				pass


func input_sniper_view(_event: InputEvent):
	if Input.is_action_just_pressed("execute_action"):
		pass

	if Input.is_action_just_pressed("interact"):
		uistate = UiState.None
