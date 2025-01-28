extends Area3D
class_name GridCell3D
			
func change_cell_color(newColor):
	%CellMesh.get_surface_override_material(0).albedo_color = newColor

func change_border_color(newColor):
	%CellMesh.get_child(0).get_surface_override_material(0).albedo_color = newColor

func is_empty():
	return get_overlapping_bodies().is_empty()

func get_grid() -> Grid3D:
	return get_parent()

func get_objects_on_cell() -> Array:
	if not is_empty: return []
	
	return get_overlapping_bodies()
