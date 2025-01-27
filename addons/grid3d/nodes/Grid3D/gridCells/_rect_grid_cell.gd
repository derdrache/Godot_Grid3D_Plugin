@tool
extends GridCell3D

func set_collision_height(value):
	$CollisionShape3D.shape.size.y = value
	#$CollisionShape3D.global_position.y = value / 2.0

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
