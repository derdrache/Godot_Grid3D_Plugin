extends Node3D

@onready var grid: Grid3D = $Grid3D

func _on_grid_3d_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if Input.is_action_just_pressed("left_mouse_click"):
		var mousePosition = _get_mouse_position()
		
		if not mousePosition:
			return
			
		var highlightPositions: Array[Vector3]
		
		var mapPosition = grid.local_to_map(mousePosition)
		var cellPosition = grid.map_to_local(mapPosition)
		
		cellPosition.y = 0.001
		highlightPositions.append(cellPosition)
		
		grid.set_highlight_cells(highlightPositions, [Color.YELLOW])

func _get_mouse_position():
	var mousePositionDepth = 100
	var mousePosition := get_viewport().get_mouse_position()
	var currentCamera := get_viewport().get_camera_3d()
	var params := PhysicsRayQueryParameters3D.new()
	
	params.from = currentCamera.project_ray_origin(mousePosition)
	params.to = currentCamera.project_position(mousePosition, mousePositionDepth)

	var worldspace := get_world_3d().direct_space_state
	var intersect := worldspace.intersect_ray(params)

	if not intersect: return
	
	return intersect.position
