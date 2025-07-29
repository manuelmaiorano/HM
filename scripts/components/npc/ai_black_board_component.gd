extends Node
class_name BlackboardComponent


@export_category("Debug")
@export var seen_player_holding_weapon: bool = false
@export var seen_player_in_restricted_area: bool = false
@export var seen_player_near_dead_body: bool = false

@export var seen_dead_body: bool = false
@export var suspicious_disguise: ClothesInfo

@export var investigating_position: bool = false
@export var investigate_position: Vector3
