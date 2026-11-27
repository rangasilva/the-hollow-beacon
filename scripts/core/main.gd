
extends Node

@onready var interaction_manager: HollowInteractionManager = (
	$InteractionManager
)

@onready var objective_label: Label = (
	$HUD/MarginContainer/VBoxContainer/ObjectiveLabel
)

@onready var feedback_label: Label = (
	$HUD/MarginContainer/VBoxContainer/FeedbackLabel
)


func _ready() -> void:
	print("")
	print("=== THE HOLLOW BEACON ===")
	print("Step 5: Interactive dungeon")
	print("")

	GameState.game_mode_changed.connect(
		_on_game_mode_changed
	)

	interaction_manager.interaction_message.connect(
		_on_interaction_message
	)

	interaction_manager.state_changed.connect(
		_update_objective
	)

	interaction_manager.level_completed.connect(
		_on_level_completed
	)

	_update_objective()


func _on_game_mode_changed(new_mode: int) -> void:
	print(
		"Main: Game mode is now ",
		GameState.GameMode.keys()[new_mode]
	)


func _on_interaction_message(message: String) -> void:
	feedback_label.text = message
	print("EVENT: ", message)


func _update_objective() -> void:
	if interaction_manager.is_level_complete:
		objective_label.text = (
            "Objective complete!"
		)

	elif interaction_manager.exit_unlocked:
		objective_label.text = (
            "Objective: Reach the glowing exit."
		)

	elif (
		HollowInteractionManager.DOOR_ID
		in interaction_manager.opened_doors
	):
		objective_label.text = (
            "Objective: Activate the magical beacon."
		)

	elif interaction_manager.lever_pulled:
		objective_label.text = (
            "Objective: Open the unlocked door."
		)

	else:
		objective_label.text = (
            "Objective: Find and pull the lever."
		)

func _on_level_completed() -> void:
	_update_objective()

	feedback_label.text = (
        "THE HOLLOW BEACON - DUNGEON COMPLETE!"
	)

	print("")
	print("=== DUNGEON COMPLETED ===")
	print("All Step 5 objectives completed.")
