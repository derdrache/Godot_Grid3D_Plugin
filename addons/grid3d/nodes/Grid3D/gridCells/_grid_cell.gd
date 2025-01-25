extends Area3D
class_name GridCell3D

@export var color: Color = Color.WHITE:
	set(value):
		if Engine.is_editor_hint():
			color = value
			change_cell_color(value)


func change_cell_color(newColor):
	%CellMesh.get_surface_override_material(0).albedo_color = newColor

func change_border_color(newColor):
	%CellMesh.get_child(0).get_surface_override_material(0).albedo_color = newColor

func is_empty():
	return get_overlapping_bodies().is_empty()
