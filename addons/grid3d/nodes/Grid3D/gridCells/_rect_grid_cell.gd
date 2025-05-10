@tool
extends GridCell3D

func set_collision_height(value):
	$CollisionShape3D.shape.size.y = value
	#$CollisionShape3D.global_position.y = value / 2.0

func set_size(size):
	var mainSize = size * 0.9
	var outlineSize = size * 0.1
	
	cellSize = Vector2(size, size)
	
	%CellMesh.mesh.size.x = mainSize
	%CellMesh.mesh.size.z = mainSize
	$CollisionShape3D.shape.size.x = size
	$CollisionShape3D.shape.size.z = size
	
	_create_outline_mesh(outlineSize)

func _create_outline_mesh(size):
	%CellMesh.get_child(0).queue_free()
	
	var outlineMesh = MeshInstance3D.new()
	outlineMesh.mesh = %CellMesh.mesh.create_outline(size)
	
	var material = StandardMaterial3D.new()
	material.albedo_color = Color(0,0,0)
	outlineMesh.set_surface_override_material(0, material)
	
	%CellMesh.add_child(outlineMesh)
