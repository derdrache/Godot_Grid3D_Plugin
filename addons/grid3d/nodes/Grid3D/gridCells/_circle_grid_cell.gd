@tool
extends GridCell3D

func set_check_empty_height(value):
	$CollisionShape3D.shape.height = value
	$CollisionShape3D.position.y = value / 2.0

func set_size(size):
	%CellMesh.mesh.top_radius = size / 2.0
	%CellMesh.mesh.bottom_radius = size / 2.0
	$CollisionShape3D.shape.radius = size / 2.0
	
	_create_outline_mesh()

func _create_outline_mesh():
	%CellMesh.get_child(0).queue_free()
	
	var outlineMesh = MeshInstance3D.new()
	outlineMesh.mesh = %CellMesh.mesh.create_outline(0.05 * %CellMesh.mesh.top_radius)
	
	var material = StandardMaterial3D.new()
	material.albedo_color = Color(0,0,0)
	outlineMesh.set_surface_override_material(0, material)
	
	%CellMesh.add_child(outlineMesh)
