@tool
extends StaticBody3D
class_name Grid3D

@export var gridType:GRID_TYPES = GRID_TYPES.RECTANGLE:
	set(value):
		gridType = value
		_change_grid_type()
		notify_property_list_changed()
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
@export var circleRadius := 0.5:
	set(value):
		circleRadius = value
		$GridMesh.material_override.set_shader_parameter("circleRadius", circleRadius)
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

enum GRID_TYPES {RECTANGLE, CIRCLE}

const RECTANGLE_GRID = preload("uid://cigab7eamjibn")
const CIRCLE_GRID = preload("uid://dpvc02h58ghi2")
const GRID_HIGHLIGHT_NODE = preload("uid://vk2rvfufxguu")

var highlightedCells: Dictionary[String, Array] = {
		"positions": [],
		"colors": []
	}

func _change_grid_type():
	var shader: Resource
	match gridType:
		GRID_TYPES.RECTANGLE: shader = RECTANGLE_GRID
		GRID_TYPES.CIRCLE: shader = CIRCLE_GRID
	
	$GridMesh.get_active_material(0).shader = shader

func _ready() -> void:
	add_to_group("Grid3D")
	
	_setup_grid()
	
	_refresh_grid()

func _setup_grid():
	if get_child_count() > 0:
		return
		
	var meshInstance = MeshInstance3D.new()
	meshInstance.name = "GridMesh"
	meshInstance.mesh = PlaneMesh.new()
	add_child(meshInstance)
	
	meshInstance.set_surface_override_material(0, ShaderMaterial.new())
	_change_grid_type()
	
	var collisionShape = CollisionShape3D.new()
	collisionShape.shape = BoxShape3D.new()
	collisionShape.shape.size = Vector3(10, 0.01, 10)
	add_child(collisionShape)
	
	var highlightNode = GRID_HIGHLIGHT_NODE.instantiate()
	add_child(highlightNode)
	highlightNode.hide()

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

func _validate_property(property: Dictionary) -> void:
	var hideList = []
	
	match gridType:
		GRID_TYPES.RECTANGLE:
			hideList.append("circleRadius")
		GRID_TYPES.CIRCLE:
			hideList.append("borderWidth")
		
	if property.name in hideList: 
		property.usage = PROPERTY_USAGE_NO_EDITOR
