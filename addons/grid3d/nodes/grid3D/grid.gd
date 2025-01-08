@tool
extends Node3D
class_name Grid3D

@export var refresh := false:
	set(value):
		if Engine.is_editor_hint() and is_inside_tree():
			_refresh_grid()
		
@export var gridSize := 5:
	set(value): 
		gridSize = value
		if Engine.is_editor_hint() and is_inside_tree():
			_refresh_grid()
			
@export var cellSize := 1:
	set(value): 
		cellSize = value
		if Engine.is_editor_hint() and is_inside_tree():
			_refresh_grid()
		
@export_range(0, 1, 0.05) var margin := 0.1:
	set(value):
		margin = value
		if Engine.is_editor_hint() and is_inside_tree():
			_refresh_grid()
		
@export var cellNode := preload("res://addons/grid3d/nodes/Grid3D/_grid_cell.tscn")

func _ready() -> void:
	add_to_group("Grid3D")

	_refresh_grid()

func _refresh_grid():
	_remove_grid()
	
	_generate_grid()

func _remove_grid():
	for node in get_children():
		node.queue_free()

func _generate_grid():
	for z in range(gridSize):
		for x in range(gridSize):
			var grid_cell_instance = cellNode.instantiate()
			grid_cell_instance.set_size(cellSize)
			
			add_child(grid_cell_instance)
			
			if Engine.is_editor_hint():
				grid_cell_instance.owner = get_tree().edited_scene_root
			grid_cell_instance.name = str(z + 1) +  "," + str(x+1)
			grid_cell_instance.global_position = global_position + Vector3(x * (cellSize + margin),0.1, z * (cellSize + margin))

func get_cell_space():
	return cellSize + margin
