@tool
extends StaticBody3D
class_name Grid3D_New

@export var gridSize := Vector2(10,10):
	set(value):
		gridSize = value
		_refresh_grid()
@export var cellSize :Vector2 = Vector2(1, 1):
	set(value):
		cellSize = value
		_refresh_grid() 
@export var borderWidth := 0.01:
	set(value):
		borderWidth = value
		$GridMesh.material_override.set_shader_parameter("borderWidth", borderWidth)

@export var cellColor := Color.BLACK:
	set(value):
		cellColor = value
		if is_node_ready():
			$GridMesh.material_override.set_shader_parameter("cellColor", cellColor)
@export var borderColor := Color.WHITE:
	set(value):
		borderColor = value
		if is_node_ready():
			$GridMesh.material_override.set_shader_parameter("borderColor", borderColor)

@onready var grid_mesh: MeshInstance3D = $GridMesh
@onready var grid_highligh_node: Node3D = $GridHighlighNode

var highlightedCells: Dictionary[String, Array] = {
		"positions": [],
		"colors": []
	}
		

func _ready() -> void:
	add_to_group("Grid3D")
	_refresh_grid()

func _refresh_grid():
	if not is_node_ready():
		return
		
	$GridMesh.mesh.size = gridSize * cellSize
	$GridMesh.material_override.set_shader_parameter("gridSize", gridSize)
	var fullSize = gridSize * cellSize 
	$CollisionShape3D.shape.size = Vector3(fullSize.x, 0.01, fullSize.y)

func local_to_map(localPosition):
	localPosition += global_position
	
	var locPositionVec2 = Vector2(localPosition.x, localPosition.z)
	var adjustLocalPosition = locPositionVec2 + gridSize * cellSize / 2.0

	var mapPosition = floor(adjustLocalPosition / cellSize)

	var inGrid = mapPosition.x >= 0 and mapPosition.x <= gridSize.x - 1  and mapPosition.y >= 0 and mapPosition.y <= gridSize.y - 1 
	
	if not inGrid:
		return

	return mapPosition
	
func map_to_local(mapPosition):
	var localPosition = mapPosition * cellSize	
	
	var adjustLocalPosition = localPosition - gridSize * cellSize / 2.0 + cellSize / 2.0

	return Vector3(adjustLocalPosition.x, 0, adjustLocalPosition.y) + global_position

func height():
	return global_position.y

func set_highlight_cells(cellPositions: Array[Vector3], colors: Array[Color]):
	
	if cellPositions.size() != colors.size():
		return

	highlightedCells.positions = cellPositions
	highlightedCells.colors = colors
	
	_refresh_grid_highlight_node()

func _refresh_grid_highlight_node():
	if highlightedCells.positions.is_empty():
		grid_highligh_node.hide()
		return

	grid_highligh_node.positions = highlightedCells.positions
	grid_highligh_node.colors = highlightedCells.colors

func reset_highlight():
	highlightedCells.positions = []
	highlightedCells.colors = []
	
	_refresh_grid_highlight_node()
