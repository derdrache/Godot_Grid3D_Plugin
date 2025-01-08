@tool
extends Area3D

@onready var cell_mesh: MeshInstance3D = %CellMesh


@export var color: Color = Color.WHITE:
	set(value):
		if Engine.is_editor_hint():
			color = value
			_change_cell_color(value)

func _change_cell_color(newColor):
	if not cell_mesh: return
	cell_mesh.get_surface_override_material(0).albedo_color = newColor


func highlight_cell():
	_change_cell_color(Color(1,1,0,0.5))

func select_cell():
	_change_cell_color(Color(1,1,1, 0.5))

func deselect_cell():
	_change_cell_color(Color(0.5,0.5,0.5, 0.5))

func is_empty():
	var query = PhysicsRayQueryParameters3D.create(global_position, global_position + Vector3.UP * 100)
	var space_state: PhysicsDirectSpaceState3D = get_world_3d().direct_space_state
	var result: Dictionary = space_state.intersect_ray(query)
	return result.is_empty()

func set_size(size):
	%CellMesh.mesh.size.x = size
	%CellMesh.mesh.size.z = size
	$CollisionShape3D.shape.size.x = size
	$CollisionShape3D.shape.size.z = size
	
	_create_outline_mesh()

func _create_outline_mesh():
	%CellMesh.get_child(0).queue_free()
	
	var outlineMesh = MeshInstance3D.new()
	outlineMesh.mesh = %CellMesh.mesh.create_outline(0.05 * %CellMesh.mesh.size.x)
	
	var material = StandardMaterial3D.new()
	material.albedo_color = Color(0,0,0)
	outlineMesh.set_surface_override_material(0, material)
	
	%CellMesh.add_child(outlineMesh)
