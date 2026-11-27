
class_name HollowInteractionManager
extends Node

# Object positions in the logical grid.
const LEVER_CELL := Vector2i(2, 1)
const DOOR_CELL := Vector2i(3, 1)
const BEACON_CELL := Vector2i(4, 1)
const EXIT_CELL := Vector2i(5, 1)
const EVENT_CELL := Vector2i(1, 2)

const LEVER_ID := "lever_001"
const DOOR_ID := "door_001"
const BEACON_ID := "beacon_001"

# State.
var lever_pulled: bool = false
var exit_unlocked: bool = false
var is_level_complete: bool = false

var activated_beacons: Array[String] = []
var opened_doors: Array[String] = []
var triggered_events: Array[String] = []

# Signals used by the HUD and renderer.
signal state_changed
signal interaction_message(message: String)
signal level_completed


func _ready() -> void:
	GameState.beacon_activated.connect(
		_on_beacon_activated
	)

	GameState.door_opened.connect(
		_on_door_opened
	)

	print("InteractionManager initialized")


func try_interact(target_cell: Vector2i) -> void:
	if is_level_complete:
		return

	if target_cell == LEVER_CELL:
		interact_with_lever()
		return

	if target_cell == DOOR_CELL:
		interact_with_door()
		return

	if target_cell == BEACON_CELL:
		interact_with_beacon()
		return

	interaction_message.emit(
        "There is nothing to interact with."
	)


func interact_with_lever() -> void:
	if lever_pulled:
		interaction_message.emit(
            "The lever has already been pulled."
		)
		return

	lever_pulled = true

	interaction_message.emit(
        "You pull the lever. A door unlocks!"
	)

	state_changed.emit()


func interact_with_door() -> void:
	if DOOR_ID in opened_doors:
		interaction_message.emit(
            "The door is already open."
		)
		return

	if not lever_pulled:
		interaction_message.emit(
            "The door is locked. Find a mechanism."
		)
		return

	GameState.open_door(DOOR_ID)

	interaction_message.emit(
        "The iron door swings open."
	)


func interact_with_beacon() -> void:
	if BEACON_ID in activated_beacons:
		interaction_message.emit(
            "The beacon is already active."
		)
		return

	GameState.activate_beacon(BEACON_ID)

	interaction_message.emit(
        "The beacon shines! The exit is unlocked."
	)


func is_cell_blocked(cell: Vector2i) -> bool:
	if cell == DOOR_CELL:
		return DOOR_ID not in opened_doors

	if cell == EXIT_CELL:
		return not exit_unlocked

	return false


func on_player_entered_cell(cell: Vector2i) -> void:
	if is_level_complete:
		return

	# One-time environmental event.
	if cell == EVENT_CELL:
		if "cold_draft_001" not in triggered_events:
			triggered_events.append("cold_draft_001")

			interaction_message.emit(
                "A cold draft passes through the corridor."
			)

	# Exit trigger.
	if cell == EXIT_CELL and exit_unlocked:
		is_level_complete = true
		level_completed.emit()


func _on_beacon_activated(beacon_id: String) -> void:
	if beacon_id not in activated_beacons:
		activated_beacons.append(beacon_id)

	if beacon_id == BEACON_ID:
		exit_unlocked = true

	print("Beacon activated: ", beacon_id)
	state_changed.emit()


func _on_door_opened(door_id: String) -> void:
	if door_id not in opened_doors:
		opened_doors.append(door_id)

	print("Door opened: ", door_id)
	state_changed.emit()
