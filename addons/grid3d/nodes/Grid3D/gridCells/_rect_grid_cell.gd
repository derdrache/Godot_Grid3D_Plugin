@tool
extends GridCell3D

@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D
@onready var mesh_instance_3d: MeshInstance3D = %MeshInstance3D

func set_collision_height(value):
	collision_shape_3d.shape.size.y = value
	#$CollisionShape3D.global_position.y = value / 2.0

func set_size(size):
	var mainSize = size * 0.9
	var outlineSize = size * 0.1
	
	cellSize = Vector2(size, size)
	
	mesh_instance_3d.mesh.size.x = mainSize
	mesh_instance_3d.mesh.size.z = mainSize
	collision_shape_3d.shape.size.x = size
	collision_shape_3d.shape.size.z = size
	
	_create_outline_mesh(outlineSize)

func _create_outline_mesh(size):
	mesh_instance_3d.get_child(0).queue_free()
	
	var outlineMesh = MeshInstance3D.new()
	outlineMesh.mesh = mesh_instance_3d.mesh.create_outline(size)
	
	var material = StandardMaterial3D.new()
	material.albedo_color = Color(0,0,0)
	outlineMesh.set_surface_override_material(0, material)
	
	mesh_instance_3d.add_child(outlineMesh)
