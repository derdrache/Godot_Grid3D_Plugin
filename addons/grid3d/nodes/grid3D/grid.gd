@tool
extends Node3D
class_name Grid3D

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
			
@export var cellType : Cell_Types:
	set(value):
		cellType = value
		if Engine.is_editor_hint() and is_inside_tree():
			_refresh_grid()

@export var debug_refresh := false:
	set(value):
		if Engine.is_editor_hint() and is_inside_tree():
			_refresh_grid()

enum Cell_Types{RECT, CIRCLE}

const _RECT_GRID_CELL = preload("res://addons/grid3d/nodes/Grid3D/gridCells/_rect_grid_cell.tscn")
const _CIRCLE_GRID_CELL = preload("res://addons/grid3d/nodes/Grid3D/gridCells/_circle_grid_cell.tscn")

func _ready() -> void:
	add_to_group("Grid3D")
	
	_remove_grid()
	
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
			var grid_cell_instance = _get_grid_cell_node()
			grid_cell_instance.set_size(cellSize)
			
			add_child(grid_cell_instance)
			
			if Engine.is_editor_hint():
				grid_cell_instance.owner = get_tree().edited_scene_root
			grid_cell_instance.name = str(z + 1) +  "," + str(x+1)
			grid_cell_instance.global_position = global_position + Vector3(x * (cellSize + margin),0.1, z * (cellSize + margin))

func _get_grid_cell_node():
	match cellType:
		Cell_Types.RECT: return _RECT_GRID_CELL.instantiate()
		Cell_Types.CIRCLE: return _CIRCLE_GRID_CELL.instantiate()

func get_cell_space():
	return cellSize + margin
