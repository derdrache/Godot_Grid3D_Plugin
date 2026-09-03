extends Node3D

@onready var grid: StaticBody3D = $Grid

var object: PhysicsBody3D
var canPlace = false
var objectCells

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("left_mouse_click") and not object:
		var mouseIntersect = _get_mouse_intersect()

		if mouseIntersect and mouseIntersect.collider.has_node("GridPlacementAgent3D"):
			object = mouseIntersect.collider
			object.get_node("CollisionShape3D").disabled = true
	elif Input.is_action_just_pressed("left_mouse_click") and canPlace:
		_place_object()
		grid.reset_highlight()
		
func _place_object():
	object.get_node("CollisionShape3D").disabled = false
	
	object = null
	canPlace = false

func _physics_process(delta: float) -> void:
	if not object: return

	var mouseRaycastIntersect = _get_mouse_intersect()
	
	if not mouseRaycastIntersect:
		return
		
	var mouseCollider = mouseRaycastIntersect.collider	
	var mousePosition = mouseRaycastIntersect.position
	var mouseGridPosition = grid.local_to_map(mousePosition)
	var mouseCellPosition = grid.map_to_local(mouseGridPosition)
	
	if mouseCellPosition and mouseCollider is Grid3D_New:
		object.global_position = Vector3(mouseCellPosition.x,object.get_node("GridPlacementAgent3D").size.y / 2.0, mouseCellPosition.z)
		
	_check_and_set_highlight_node(mouseCellPosition)


func _get_mouse_intersect():
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
	
	return intersect

func _check_and_set_highlight_node(startPosition):
	var objectSize = object.get_node("GridPlacementAgent3D").size
	#grid_highligh_node.size = grid.cellSize
	startPosition.y += 0.001
		
	canPlace = true
	
	var positions: Array[Vector3] = []
	var colors: Array[Color]= []

	for x in objectSize.x / grid.cellSize.x:
		for y in objectSize.z / grid.cellSize.y:
			var highlightPosition = startPosition - Vector3(x, 0, y)
			var mouseGridPosition = grid.local_to_map(highlightPosition)
			
			if grid.local_to_map(highlightPosition) == null:
				colors.append(Color.RED)
				canPlace = false
			else:
				colors.append(Color.YELLOW)
				
			positions.append(highlightPosition)

	grid.set_highlight_cells(positions, colors)
	#grid_highligh_node.positions = positions
	#grid_highligh_node.colors = colors
	
