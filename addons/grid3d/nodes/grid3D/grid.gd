@tool
extends Node3D
class_name Grid3D

@export var gridWidth := 5:
	set(value): 
		gridWidth = value
		if Engine.is_editor_hint() and is_inside_tree():
			_ready()

@export var gridHeight := 5:
	set(value): 
		gridHeight = value
		if Engine.is_editor_hint() and is_inside_tree():
			_ready()

@export_range(0, 1, 0.05) var margin := 0.1:
	set(value):
		margin = value
		if Engine.is_editor_hint() and is_inside_tree():
			_ready()
			
@export_group("Cell")

@export var cellSize := 1:
	set(value): 
		cellSize = value
		if Engine.is_editor_hint() and is_inside_tree():
			_refresh_grid()
		
@export var cellType : Cell_Types:
	set(value):
		cellType = value
		if Engine.is_editor_hint() and is_inside_tree():
			_refresh_grid()

@export var cellCollisionHeight := 1:
	set(value): 
		cellCollisionHeight = value
		if Engine.is_editor_hint() and is_inside_tree():
			_refresh_grid()

@export var cellColor: Color = Color("ffffff"):
	set(value):
		cellColor = value
		if Engine.is_editor_hint() and is_inside_tree():
			for child in get_children():
				child.change_cell_color(value)
			
@export var cellBorderColor: Color:
	set(value):
		cellBorderColor = value
		if Engine.is_editor_hint() and is_inside_tree():
			for child in get_children():
				child.change_border_color(value)

enum Cell_Types{RECT, CIRCLE}

const _RECT_GRID_CELL = preload("res://addons/grid3d/nodes/Grid3D/gridCells/_rect_grid_cell.tscn")
const _CIRCLE_GRID_CELL = preload("res://addons/grid3d/nodes/Grid3D/gridCells/_circle_grid_cell.tscn")

func _ready() -> void:
	add_to_group("Grid3D")
	
	_refresh_grid()
	
func _refresh_grid():
	_remove_grid()
	
	_generate_grid()
	
	get_empty_cells()

func _remove_grid():
	for node in get_children():
		node.queue_free()

func _generate_grid():
	for z in range(gridHeight):
		for x in range(gridWidth):
			var grid_cell_instance = _get_grid_cell_node()
			grid_cell_instance.set_size(cellSize)
			grid_cell_instance.change_cell_color(cellColor)
			grid_cell_instance.change_border_color(cellBorderColor)
			add_child(grid_cell_instance)
			
			grid_cell_instance.set_collision_height(cellCollisionHeight)
			
			grid_cell_instance.name = str(z + 1) +  "," + str(x+1)
			grid_cell_instance.global_position = global_position + Vector3(x * (cellSize + margin),0.1, z * (cellSize + margin))

func _get_grid_cell_node():
	match cellType:
		Cell_Types.RECT: return _RECT_GRID_CELL.instantiate()
		Cell_Types.CIRCLE: return _CIRCLE_GRID_CELL.instantiate()

func get_cell_space():
	return cellSize + margin

func get_empty_cells():
	var emptyCells = []
	print(get_child_count())
	for cell in get_children():
		if cell.is_empty(): emptyCells.append(cell)
		
	return emptyCells
