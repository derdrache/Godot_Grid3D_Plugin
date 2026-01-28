@tool
extends GridCell3D

@onready var mesh_instance_3d: MeshInstance3D = $MeshInstance3D
@onready var outline_mesh: MeshInstance3D = $OutlineMesh
@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D

func set_collision_height(value):
	if Engine.is_editor_hint(): return
	
	collision_shape_3d.shape.height = value

func set_size(size):
	var mainSize = size * 0.9
	var outlineSize = size
	
	cellSize = Vector2(size, size)
	
	mesh_instance_3d.mesh.top_radius = mainSize / 2.0
	mesh_instance_3d.mesh.bottom_radius = mainSize / 2.0
	outline_mesh.mesh.top_radius = size / 2.0
	outline_mesh.mesh.top_radius = size / 2.0
	
	if not Engine.is_editor_hint():
		collision_shape_3d.shape.radius = size / 2.0
		
