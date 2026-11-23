
extends Node

# Possible game modes
enum GameMode {
	EXPLORATION,
	COMBAT,
	PAUSED,
	GAME_OVER
}

# Current game mode
var current_mode: GameMode = GameMode.EXPLORATION

# Global signals
signal game_mode_changed(new_mode: GameMode)
signal combat_started
signal combat_ended
signal beacon_activated(beacon_id: String)
signal door_opened(door_id: String)


func _ready() -> void:
	print("GameState initialized")


func change_mode(new_mode: GameMode) -> void:
	if current_mode == new_mode:
		return

	current_mode = new_mode
	game_mode_changed.emit(new_mode)

	print("Game mode changed to: ", GameMode.keys()[new_mode])


func start_combat() -> void:
	if current_mode != GameMode.EXPLORATION:
		return

	change_mode(GameMode.COMBAT)
	combat_started.emit()


func end_combat() -> void:
	if current_mode != GameMode.COMBAT:
		return

	change_mode(GameMode.EXPLORATION)
	combat_ended.emit()


func activate_beacon(beacon_id: String) -> void:
	beacon_activated.emit(beacon_id)


func open_door(door_id: String) -> void:
	door_opened.emit(door_id)
