
extends Node

var activated_beacons: Array[String] = []
var opened_doors: Array[String] = []


func _ready() -> void:
	GameState.beacon_activated.connect(
		_on_beacon_activated
	)

	GameState.door_opened.connect(
		_on_door_opened
	)

	print("InteractionManager initialized")


func _on_beacon_activated(beacon_id: String) -> void:
	if beacon_id not in activated_beacons:
		activated_beacons.append(beacon_id)

	print("Beacon activated: ", beacon_id)


func _on_door_opened(door_id: String) -> void:
	if door_id not in opened_doors:
		opened_doors.append(door_id)

	print("Door opened: ", door_id)
