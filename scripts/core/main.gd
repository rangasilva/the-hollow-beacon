
extends Node


func _ready() -> void:
	print("")
	print("=== THE HOLLOW BEACON ===")
	print("Step 4: Dungeon exploration")
	print("")

	GameState.game_mode_changed.connect(
		_on_game_mode_changed
	)


func _on_game_mode_changed(new_mode: int) -> void:
	print(
		"Main: Game mode is now ",
		GameState.GameMode.keys()[new_mode]
	)
