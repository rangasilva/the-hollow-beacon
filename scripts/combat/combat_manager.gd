
extends Node

var is_combat_active: bool = false


func _ready() -> void:
	GameState.combat_started.connect(
		_on_combat_started
	)

	GameState.combat_ended.connect(
		_on_combat_ended
	)

	print("CombatManager initialized")


func _on_combat_started() -> void:
	is_combat_active = true
	print("CombatManager: Combat has started")


func _on_combat_ended() -> void:
	is_combat_active = false
	print("CombatManager: Combat has ended")
