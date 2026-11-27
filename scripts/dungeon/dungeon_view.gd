
extends Node3D

@onready var dungeon_manager: HollowDungeonManager = (
	$"../DungeonManager"
)

@onready var interaction_manager: HollowInteractionManager = (
	$"../InteractionManager"
)

var wall_material: StandardMaterial3D
var floor_material: StandardMaterial3D

var lever_mesh: MeshInstance3D
var door_mesh: MeshInstance3D
var beacon_mesh: MeshInstance3D
var exit_mesh: MeshInstance3D


func _ready() -> void:
	create_materials()
	build_dungeon()
	create_interactive_objects()

	interaction_manager.state_changed.connect(
		refresh_interactive_objects
	)

	refresh_interactive_objects()

	print("Interactive dungeon generated")


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


func create_floor(cell: Vector2i) -> void:
	var mesh := MeshInstance3D.new()
	var box := BoxMesh.new()

	box.size = Vector3(
		HollowDungeonManager.CELL_SIZE,
		0.2,
		HollowDungeonManager.CELL_SIZE
	)

	mesh.mesh = box
	mesh.material_override = floor_material

	mesh.position = (
		dungeon_manager.grid_to_world(cell)
		+ Vector3(0, -0.1, 0)
	)

	add_child(mesh)


func create_wall(cell: Vector2i) -> void:
	var mesh := MeshInstance3D.new()
	var box := BoxMesh.new()

	box.size = Vector3(
		HollowDungeonManager.CELL_SIZE,
		3.0,
		HollowDungeonManager.CELL_SIZE
	)

	mesh.mesh = box
	mesh.material_override = wall_material

	mesh.position = (
		dungeon_manager.grid_to_world(cell)
		+ Vector3(0, 1.5, 0)
	)

	add_child(mesh)


func create_interactive_objects() -> void:
	lever_mesh = create_marker(
		HollowInteractionManager.LEVER_CELL,
		Vector3(0.4, 0.8, 0.4),
		0.4,
		Color(0.9, 0.6, 0.1)
	)

	door_mesh = create_marker(
		HollowInteractionManager.DOOR_CELL,
		Vector3(0.25, 2.5, 1.8),
		1.25,
		Color(0.55, 0.2, 0.15)
	)

	beacon_mesh = create_marker(
		HollowInteractionManager.BEACON_CELL,
		Vector3(0.6, 1.2, 0.6),
		0.6,
		Color(0.1, 0.35, 0.5)
	)

	exit_mesh = create_marker(
		HollowInteractionManager.EXIT_CELL,
		Vector3(1.5, 0.08, 1.5),
		0.05,
		Color(0.4, 0.1, 0.1)
	)


func create_marker(
	cell: Vector2i,
	mesh_size: Vector3,
	height: float,
	color: Color
) -> MeshInstance3D:
	var marker := MeshInstance3D.new()
	var box := BoxMesh.new()

	box.size = mesh_size
	marker.mesh = box

	var material := StandardMaterial3D.new()
	material.albedo_color = color
	material.shading_mode = (
		BaseMaterial3D.SHADING_MODE_UNSHADED
	)

	marker.material_override = material

	marker.position = (
		dungeon_manager.grid_to_world(cell)
		+ Vector3(0, height, 0)
	)

	add_child(marker)

	return marker


func refresh_interactive_objects() -> void:
	door_mesh.visible = (
		HollowInteractionManager.DOOR_ID
		not in interaction_manager.opened_doors
	)

	if interaction_manager.lever_pulled:
		set_marker_color(
			lever_mesh,
			Color(0.3, 0.8, 0.2)
		)

	if (
		HollowInteractionManager.BEACON_ID
		in interaction_manager.activated_beacons
	):
		set_marker_color(
			beacon_mesh,
			Color(0.1, 0.95, 1.0)
		)

	if interaction_manager.exit_unlocked:
		set_marker_color(
			exit_mesh,
			Color(0.1, 0.9, 0.3)
		)


func set_marker_color(
	marker: MeshInstance3D,
	color: Color
) -> void:
	var material := (
		marker.material_override as StandardMaterial3D
	)

	material.albedo_color = color
