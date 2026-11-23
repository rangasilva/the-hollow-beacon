
extends Node

var current_dungeon_id: String = "forgotten_watch_01"
var player_grid_position: Vector2i = Vector2i(1, 1)
var player_facing: int = 0


func _ready() -> void:
	GameState.game_mode_changed.connect(
		_on_game_mode_changed
	)

	print("DungeonManager initialized")


func _on_game_mode_changed(new_mode: int) -> void:
	if new_mode == GameState.GameMode.COMBAT:
		print("DungeonManager: Exploration disabled")

	elif new_mode == GameState.GameMode.EXPLORATION:
		print("DungeonManager: Exploration enabled")
