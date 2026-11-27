
extends Node3D

@onready var dungeon_manager: HollowDungeonManager = (
	$"../DungeonManager"
)

var wall_material: StandardMaterial3D
var floor_material: StandardMaterial3D


func _ready() -> void:
	create_materials()
	build_dungeon()


func create_materials() -> void:
	wall_material = StandardMaterial3D.new()
	wall_material.albedo_color = Color(
		0.35, 0.39, 0.45
	)
	wall_material.roughness = 1.0

	floor_material = StandardMaterial3D.new()
	floor_material.albedo_color = Color(
		0.22, 0.24, 0.28
	)
	floor_material.roughness = 1.0


func build_dungeon() -> void:
	for z in range(dungeon_manager.get_map_height()):
		for x in range(dungeon_manager.get_map_width()):
			var cell := Vector2i(x, z)

			create_floor(cell)

			if dungeon_manager.get_tile(cell) == "#":
				create_wall(cell)

	print("3D dungeon geometry generated")


func create_floor(cell: Vector2i) -> void:
	var floor_mesh := MeshInstance3D.new()
	var box := BoxMesh.new()

	box.size = Vector3(
		HollowDungeonManager.CELL_SIZE,
		0.2,
		HollowDungeonManager.CELL_SIZE
	)

	floor_mesh.mesh = box
	floor_mesh.material_override = floor_material

	floor_mesh.position = (
		dungeon_manager.grid_to_world(cell)
		+ Vector3(0, -0.1, 0)
	)

	add_child(floor_mesh)


func create_wall(cell: Vector2i) -> void:
	var wall_mesh := MeshInstance3D.new()
	var box := BoxMesh.new()

	box.size = Vector3(
		HollowDungeonManager.CELL_SIZE,
		3.0,
		HollowDungeonManager.CELL_SIZE
	)

	wall_mesh.mesh = box
	wall_mesh.material_override = wall_material

	wall_mesh.position = (
		dungeon_manager.grid_to_world(cell)
		+ Vector3(0, 1.5, 0)
	)

	add_child(wall_mesh)
