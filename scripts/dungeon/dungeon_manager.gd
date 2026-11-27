
class_name HollowDungeonManager
extends Node

# Each grid cell occupies 2 meters.
const CELL_SIZE: float = 2.0

# Dungeon layout:
# # = wall
# . = walkable floor
const DUNGEON_MAP: Array[String] = [
	"#######",
	"#.....#",
	"#.###.#",
	"#...#.#",
	"###.#.#",
	"#.....#",
    "#######"
]

var current_dungeon_id: String = "forgotten_watch_01"

var player_grid_position: Vector2i = Vector2i(1, 1)
var player_facing: int = 0


func _ready() -> void:
	GameState.game_mode_changed.connect(
		_on_game_mode_changed
	)

	print("DungeonManager initialized")
	print("Current dungeon: ", current_dungeon_id)


func get_map_width() -> int:
	return DUNGEON_MAP[0].length()


func get_map_height() -> int:
	return DUNGEON_MAP.size()


func is_inside_map(cell: Vector2i) -> bool:
	return (
		cell.x >= 0
		and cell.y >= 0
		and cell.x < get_map_width()
		and cell.y < get_map_height()
	)


func get_tile(cell: Vector2i) -> String:
	if not is_inside_map(cell):
		return "#"

	return DUNGEON_MAP[cell.y].substr(cell.x, 1)



func is_walkable(cell: Vector2i) -> bool:
	# First check the static dungeon layout.
	if get_tile(cell) != ".":
		return false

	# Next check interactive objects.
	
	var interaction_manager := (
		get_node("../InteractionManager")
		as HollowInteractionManager
	)

	if interaction_manager.is_cell_blocked(cell):
		return false

	return true



func grid_to_world(cell: Vector2i) -> Vector3:
	return Vector3(
		cell.x * CELL_SIZE,
		0.0,
		cell.y * CELL_SIZE
	)


func update_player_position(
	new_position: Vector2i,
	new_facing: int
) -> void:
	player_grid_position = new_position
	player_facing = new_facing

	print(
		"Player grid position: ",
		player_grid_position,
		" | Facing: ",
		player_facing
	)


func _on_game_mode_changed(new_mode: int) -> void:
	if new_mode == GameState.GameMode.COMBAT:
		print("DungeonManager: Exploration disabled")

	elif new_mode == GameState.GameMode.EXPLORATION:
		print("DungeonManager: Exploration enabled")
