extends Node3D

@onready var grid_3d: Grid3D = $Grid3D

var object: PhysicsBody3D
var isValid = false
var objectCells

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("left_mouse_click") and not object:
		var collider = _get_mouse_collider()

		if collider and collider.has_node("GridPlacementAgent3D"):
			object = collider
			object.get_node("CollisionShape3D").disabled = true
	elif Input.is_action_just_pressed("left_mouse_click") and isValid:
		_place_placement()

func _physics_process(delta: float) -> void:
	if not object: return
	
	var mouseCollider = _get_mouse_collider()

	if mouseCollider and mouseCollider.get_parent() is Grid3D:
		var mouseGridPosition = mouseCollider.global_position
		mouseGridPosition.y = object.find_child("GridPlacementAgent3D").size.y / 2
		object.global_position = mouseGridPosition
	
	
		_reset_highlight()
		objectCells = _get_object_cells()
		isValid = _check_and_hightlight_cells(objectCells)

func _reset_highlight():
	for child in grid_3d.get_children():
		child.change_cell_color(grid_3d.cellColor)

func _get_object_cells():
	var cells = []
	var objectRect = object.find_child("GridPlacementAgent3D").get_rect()
	
	for child in grid_3d.get_children():
		if child.get_rect().intersects(objectRect):
			cells.append(child)
	
	return cells

func _check_and_hightlight_cells(objectCells: Array):
	var isValid = true
	var objectRect = object.find_child("GridPlacementAgent3D").get_rect()
	var objectCellCount = (objectRect.size.x / grid_3d.cellSize) * (objectRect.size.y / grid_3d.cellSize)

	if objectCellCount != objectCells.size(): 
		isValid = false
	
	for cell in objectCells:
		if not cell.is_empty(): 
			isValid = false
			cell.change_cell_color(Color.RED)
		else:
			cell.change_cell_color(Color.GREEN)

	return isValid

func _get_mouse_collider():
	var mousePositionDepth = 100
	var mousePosition := get_viewport().get_mouse_position()
	var currentCamera := get_viewport().get_camera_3d()
	var params := PhysicsRayQueryParameters3D.new()
	
	params.from = currentCamera.project_ray_origin(mousePosition)
	params.to = currentCamera.project_position(mousePosition, mousePositionDepth)
	params.collide_with_areas = true
	
	var worldspace := get_world_3d().direct_space_state
	var intersect := worldspace.intersect_ray(params)

	if not intersect: return
	
	return intersect.collider

func _place_placement():
	object.get_node("CollisionShape3D").disabled = false
	
	object = null
	isValid = null
	
	_reset_highlight()
