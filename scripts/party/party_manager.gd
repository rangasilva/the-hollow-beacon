
extends Node

var party: Array[Dictionary] = [
	{
		"name": "Garrick",
		"class": "Guardian",
		"hp": 100,
		"max_hp": 100,
		"mp": 10
	},
	{
		"name": "Lyra",
		"class": "Ranger",
		"hp": 80,
		"max_hp": 80,
		"mp": 20
	},
	{
		"name": "Serin",
		"class": "Arcanist",
		"hp": 60,
		"max_hp": 60,
		"mp": 100
	},
	{
		"name": "Mara",
		"class": "Warden",
		"hp": 75,
		"max_hp": 75,
		"mp": 80
	}
]


func _ready() -> void:
	print("PartyManager initialized")
	print("Party contains ", party.size(), " heroes")


func get_party_member(index: int) -> Dictionary:
	if index < 0 or index >= party.size():
		return {}

	return party[index].duplicate(true)
