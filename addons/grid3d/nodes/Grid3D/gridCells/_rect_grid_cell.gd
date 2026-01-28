@tool
extends GridCell3D

@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D
@onready var mesh_instance_3d: MeshInstance3D = $MeshInstance3D
@onready var outline_mesh: MeshInstance3D = $OutlineMesh


func set_collision_height(value):
	if Engine.is_editor_hint(): return

	collision_shape_3d.shape.size.y = value

func set_size(size):
	var mainSize = size * 0.9
	var outlineSize = size
	
	cellSize = Vector2(size, size)
	
	mesh_instance_3d.mesh.size.x = mainSize
	mesh_instance_3d.mesh.size.z = mainSize
	outline_mesh.mesh.size.x = outlineSize
	outline_mesh.mesh.size.z = outlineSize

	
	if not Engine.is_editor_hint():
		collision_shape_3d.shape.size.x = size
		collision_shape_3d.shape.size.z = size
