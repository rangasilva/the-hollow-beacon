
extends Node

@onready var dungeon_manager: Node = $DungeonManager
@onready var combat_manager: Node = $CombatManager
@onready var party_manager: Node = $PartyManager
@onready var interaction_manager: Node = $InteractionManager


func _ready() -> void:
	print("")
	print("=== THE HOLLOW BEACON ===")
	print("Core architecture test starting")
	print("")

	# Defer the test until all child nodes are ready.
	call_deferred("_run_architecture_test")



func _run_architecture_test() -> void:
	print("Current dungeon: ",
		dungeon_manager.get("current_dungeon_id")
	)

	var party: Array = party_manager.get("party")
	print("Party size: ", party.size())

	GameState.start_combat()

	assert(combat_manager.get("is_combat_active") == true)
	print("Combat start test: PASS")

	GameState.end_combat()

	assert(combat_manager.get("is_combat_active") == false)
	print("Combat end test: PASS")

	GameState.activate_beacon("beacon_001")

	var beacons: Array = interaction_manager.get(
        "activated_beacons"
	)
	assert("beacon_001" in beacons)
	print("Beacon activation test: PASS")

	GameState.open_door("door_001")

	var doors: Array = interaction_manager.get(
        "opened_doors"
	)
	assert("door_001" in doors)
	print("Door interaction test: PASS")

	print("")
	print("=== ALL ARCHITECTURE TESTS PASSED ===")
