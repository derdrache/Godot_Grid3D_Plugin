@tool
extends Node3D
class_name Grid3D

@export var gridWidth := 5:
	set(value): 
		gridWidth = value
		if Engine.is_editor_hint() and is_inside_tree():
			_refresh_grid()

@export var gridHeight := 5:
	set(value): 
		gridHeight = value
		if Engine.is_editor_hint() and is_inside_tree():
			_refresh_grid()

@export_range(0, 1, 0.05) var margin := 0.1:
	set(value):
		margin = value
		if Engine.is_editor_hint() and is_inside_tree():
			_refresh_grid()
			
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

@export var cellCollisionHeight := 0.2:
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

const _RECT_GRID_CELL = preload("uid://ogk1xpracbf3")
const _CIRCLE_GRID_CELL = preload("uid://8v2v6lev7wy4")

var emptyCellPicks: Array[GridCell3D]

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
	var grid_cell_instance = _get_grid_cell_node()
	
	for z in range(gridHeight):
		for x in range(gridWidth):
			var gridCell = grid_cell_instance.duplicate()

			add_child(gridCell)
			
			gridCell.set_size(cellSize)
			gridCell.change_cell_color(cellColor)
			gridCell.change_border_color(cellBorderColor)			
			gridCell.set_collision_height(cellCollisionHeight)
			
			gridCell.global_position = global_position + Vector3(x * (cellSize + margin),0.1, z * (cellSize + margin))

func _get_grid_cell_node():
	match cellType:
		Cell_Types.RECT: return _RECT_GRID_CELL.instantiate()
		Cell_Types.CIRCLE: return _CIRCLE_GRID_CELL.instantiate()

func get_cell_space():
	return cellSize + margin

func get_empty_cells():
	var emptyCells = []

	for cell in get_children():
		if cell.is_empty(): emptyCells.append(cell)
		
	return emptyCells

func reset_all_cell_color():
	for cell: GridCell3D in get_children():
		cell.change_cell_color(cellColor)
		
func reset_all_cell_border_color():
	for cell: GridCell3D in get_children():
		cell.change_cell_color(cellBorderColor)

func get_random_empty_cell() -> GridCell3D:
	var emptyCells = get_empty_cells()

	emptyCells = emptyCells.filter(func(cell): return cell not in emptyCellPicks)
	var randomPick = emptyCells.pick_random()
	emptyCellPicks.append(randomPick)
	
	return randomPick

func get_tile_neighbors(selectedPosition):
	selectedPosition.y = global_position.y
	
	var id = get_id(selectedPosition)
	var neighbors = []
	var neighborIds = [
		id + 1, 
		id -1, 
		id - gridWidth, 
		id + gridWidth
	]

	for neighborId in neighborIds:
		if neighborId >= 0 and neighborId <= gridWidth * gridHeight:
			var tile = get_tile(neighborId)
			if tile: 
				neighbors.append(tile)

	return neighbors
	
func get_id(selectPosition: Vector3):
	var width = selectPosition.x / cellSize
	var height = selectPosition.z / cellSize

	return int(height) * gridWidth + int(width)

func get_tile(id: int):
	for tile in get_children():
		if tile.name == str(id):
			return tile
