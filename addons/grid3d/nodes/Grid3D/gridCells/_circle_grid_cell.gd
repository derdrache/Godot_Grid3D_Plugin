@tool
extends GridCell3D

func set_collision_height(value):
	var collision_shape_3d: CollisionShape3D = $CollisionShape3D
	
	collision_shape_3d.shape.height = value

func set_size(size):
	var mesh_instance_3d: MeshInstance3D = %MeshInstance3D
	var collision_shape_3d: CollisionShape3D = $CollisionShape3D
	var mainSize = size * 0.9
	var outlineSize = size * 0.1
	
	cellSize = Vector2(size, size)
	
	mesh_instance_3d.mesh.top_radius = mainSize / 2.0
	mesh_instance_3d.mesh.bottom_radius = mainSize / 2.0
	collision_shape_3d.shape.radius = size / 2.0
	
	_create_outline_mesh(outlineSize)

func _create_outline_mesh(size):
	var mesh_instance_3d: MeshInstance3D = %MeshInstance3D
	mesh_instance_3d.get_child(0).queue_free()
	
	var outlineMesh = MeshInstance3D.new()
	outlineMesh.mesh = mesh_instance_3d.mesh.create_outline(size)
	
	var material = StandardMaterial3D.new()
	material.albedo_color = Color(0,0,0)
	outlineMesh.set_surface_override_material(0, material)
	
	mesh_instance_3d.add_child(outlineMesh)
