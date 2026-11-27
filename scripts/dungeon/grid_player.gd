
extends Node3D

const DIRECTIONS: Array[Vector2i] = [
	Vector2i(0, -1),  # North
	Vector2i(1, 0),   # East
	Vector2i(0, 1),   # South
	Vector2i(-1, 0)   # West
]

@export var move_duration: float = 0.20
@export var turn_duration: float = 0.15

@onready var dungeon_manager: HollowDungeonManager = (
	$"../DungeonManager"
)

var grid_position: Vector2i
var facing: int = 0
var is_moving: bool = false


func _ready() -> void:
	grid_position = dungeon_manager.player_grid_position
	facing = dungeon_manager.player_facing

	position = dungeon_manager.grid_to_world(
		grid_position
	)

	rotation.y = -float(facing) * PI / 2.0

	print("GridPlayer initialized")
	print("Starting position: ", grid_position)


func _unhandled_input(event: InputEvent) -> void:
	# Do not accept repeat events from held keys.
	if event is InputEventKey and event.echo:
		return

	# Allow C to toggle combat state
	if event.is_action_pressed("begin_combat"):
		if GameState.current_mode == GameState.GameMode.EXPLORATION:
			GameState.start_combat()
		elif GameState.current_mode == GameState.GameMode.COMBAT:
			GameState.end_combat()
		return

	# Only allow exploration controls during exploration.
	if GameState.current_mode != GameState.GameMode.EXPLORATION:
		return

	# Prevent overlapping movement animations.
	if is_moving:
		return

	if event.is_action_pressed("move_forward"):
		move_in_direction(DIRECTIONS[facing])

	elif event.is_action_pressed("move_backward"):
		move_in_direction(
			-DIRECTIONS[facing]
		)

	elif event.is_action_pressed("strafe_left"):
		var left_direction := (facing + 3) % 4
		move_in_direction(
			DIRECTIONS[left_direction]
		)

	elif event.is_action_pressed("strafe_right"):
		var right_direction := (facing + 1) % 4
		move_in_direction(
			DIRECTIONS[right_direction]
		)

	elif event.is_action_pressed("turn_left"):
		turn_player(-1)

	elif event.is_action_pressed("turn_right"):
		turn_player(1)


func move_in_direction(direction: Vector2i) -> void:
	var destination := grid_position + direction

	# Prevent entering walls or going outside the map.
	if not dungeon_manager.is_walkable(destination):
		print("Movement blocked at: ", destination)
		return

	is_moving = true

	grid_position = destination

	dungeon_manager.update_player_position(
		grid_position,
		facing
	)

	var target_position := dungeon_manager.grid_to_world(
		destination
	)

	var tween := create_tween()

	tween.tween_property(
		self,
		"position",
		target_position,
		move_duration
	).set_trans(Tween.TRANS_SINE).set_ease(
		Tween.EASE_IN_OUT
	)

	await tween.finished

	is_moving = false


func turn_player(direction: int) -> void:
	if is_moving:
		return

	is_moving = true

	facing = posmod(facing + direction, 4)

	dungeon_manager.update_player_position(
		grid_position,
		facing
	)

	var target_rotation := (
		rotation.y - float(direction) * PI / 2.0
	)

	var tween := create_tween()

	tween.tween_property(
		self,
		"rotation:y",
		target_rotation,
		turn_duration
	).set_trans(Tween.TRANS_SINE).set_ease(
		Tween.EASE_IN_OUT
	)

	await tween.finished

	is_moving = false
