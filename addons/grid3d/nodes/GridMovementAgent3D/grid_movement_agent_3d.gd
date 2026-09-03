extends Node3D

@export var grid: Node3D
@export var canMove := false


func _ready() -> void:
	await _set_grid()
	
	_set_start_position()

func _set_grid():
	if grid:
		return
	
	await get_tree().physics_frame
	
	grid = get_tree().get_first_node_in_group("Grid3D")
		
func _set_start_position():
	var cell = get_cell_on_position(global_position)

	if not cell: return
	get_parent().global_position.x = cell.global_position.x
	get_parent().global_position.z = cell.global_position.z

func _input(event: InputEvent) -> void:
	if not canMove or not event is InputEventKey or not event.is_pressed() or not grid: return
	
	var cellSize = grid.cellSize
	var targetPosition = get_parent().global_position
	
	if Input.is_action_just_pressed("ui_left"):
		targetPosition += Vector3.LEFT * Vector3(cellSize.x, 0, cellSize.y)
	elif Input.is_action_just_pressed("ui_right"):
		targetPosition += Vector3.RIGHT * Vector3(cellSize.x, 0, cellSize.y)
	elif Input.is_action_just_pressed("ui_up"):
		targetPosition += Vector3.FORWARD * Vector3(cellSize.x, 0, cellSize.y)
	elif Input.is_action_just_pressed("ui_down"):
		targetPosition += Vector3.BACK * Vector3(cellSize.x, 0, cellSize.y)
	
	var isPositionInGrid = grid.local_to_map(targetPosition) != null
	var isCellEmpty = _is_cell_empty(targetPosition)
	
	if isPositionInGrid and isCellEmpty:
		get_parent().global_position = targetPosition

func _is_position_in_grid(position: Vector3):
	var cellCollider = get_cell_on_position(position)
	
	return cellCollider != null

func _is_cell_empty(position):
	var collider = get_cell_on_position(position)
	
	if collider is Grid3D_New:
		return true
	else:
		return false

func set_move(boolean: bool) -> void:
	canMove = boolean

func get_cell_on_position(position):
	var query = PhysicsRayQueryParameters3D.create(position + Vector3.UP, position + Vector3.DOWN * 100)
	query.collide_with_areas = true
	query.collide_with_bodies = true
	query.hit_from_inside = true
	
	var space_state: PhysicsDirectSpaceState3D = get_world_3d().direct_space_state
	var result: Dictionary = space_state.intersect_ray(query)
	
	if result:
		return result.collider

func get_all_cells(selectedGrid = null) -> Array[GridCell3D]:
	var allCells: Array[GridCell3D]
	
	if selectedGrid: 
		allCells.assign(selectedGrid.get_children())
	else:
		for grid in get_tree().get_nodes_in_group("Grid3D"):
			var gridCells: Array[GridCell3D]
			gridCells.assign(grid.get_children())
			
			allCells += gridCells
	
	return allCells
