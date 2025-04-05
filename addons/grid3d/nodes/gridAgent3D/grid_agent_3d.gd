extends Node3D

var canMove := false
var ownGrid: Grid3D

func _ready() -> void:
	await _set_grid()
	
	_set_start_position()

func _set_grid():
	await get_tree().physics_frame
	
	var collider = get_cell_on_position(global_position)
	
	if collider:
		ownGrid = collider.get_parent()
	else:
		push_warning(name + " from " + get_parent().name + " doesn't found a Grid")
		
func _set_start_position():
	var cell = get_cell_on_position(global_position)

	if not cell: return
	get_parent().global_position.x = cell.global_position.x
	get_parent().global_position.z = cell.global_position.z

func _input(event: InputEvent) -> void:
	if not canMove or not event is InputEventKey or not event.is_pressed() or not ownGrid: return
	
	var gridCellSize = ownGrid.get_cell_space()
	var targetPosition = get_parent().global_position
	
	if Input.is_action_just_pressed("ui_left"):
		targetPosition += Vector3.LEFT * gridCellSize
	elif Input.is_action_just_pressed("ui_right"):
		targetPosition += Vector3.RIGHT * gridCellSize
	elif Input.is_action_just_pressed("ui_up"):
		targetPosition += Vector3.FORWARD * gridCellSize
	elif Input.is_action_just_pressed("ui_down"):
		targetPosition += Vector3.BACK * gridCellSize
	
	var isPositionInGrid = _is_position_in_grid(targetPosition)
	var isCellEmpty = _is_cell_empty(targetPosition)
	
	if isPositionInGrid and isCellEmpty:
		get_parent().global_position = targetPosition

func _is_position_in_grid(position: Vector3):
	var cellCollider = get_cell_on_position(position)
	
	return cellCollider != null

func _is_cell_empty(position):
	var collider = get_cell_on_position(position)
	
	if collider:
		return collider.is_empty()

func set_move(boolean: bool) -> void:
	canMove = boolean

func get_cell_on_position(position):
	var query = PhysicsRayQueryParameters3D.create(position + Vector3.UP, position + Vector3.DOWN * 100)
	query.collide_with_areas = true
	query.collide_with_bodies = false
	query.hit_from_inside = true
	
	var space_state: PhysicsDirectSpaceState3D = get_world_3d().direct_space_state
	var result: Dictionary = space_state.intersect_ray(query)
	
	if result:
		return result.collider

func get_all_cells() -> Array[GridCell3D]:
	var allCells: Array[GridCell3D]
	allCells.assign(ownGrid.get_children())
	return allCells
