extends Area3D
class_name GridCell3D

var cellSize: Vector2 = Vector2.ZERO

func _ready() -> void:
	if Engine.is_editor_hint(): return
	
	$CollisionShape3D.disabled = false
			
func change_cell_color(newColor):
	$MeshInstance3D.mesh.surface_get_material(0).albedo_color = newColor
	
func change_border_color(newColor):
	$OutlineMesh.mesh.surface_get_material(0).albedo_color = newColor

func is_empty():
	return get_overlapping_bodies().is_empty()

func get_grid() -> Grid3D:
	return get_parent()

func get_objects_on_cell() -> Array:
	if not is_empty: return []
	
	return get_overlapping_bodies()

func get_rect() -> Rect2:
	return Rect2(Vector2(global_position.x, global_position.z), cellSize)
