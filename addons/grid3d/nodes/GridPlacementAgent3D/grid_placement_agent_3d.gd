extends Node3D

@export var size: Vector3 = Vector3(1,1,1)	
@export var offset: Vector3 = Vector3.ZERO

func _ready() -> void:
	for child in get_parent().get_children():
		if child is not Node3D: return
		
		child.position -= offset

func get_rect() -> Rect2:
	var objectPosition = Vector2(
		get_parent().global_position.x - int(size.x /2), 
		get_parent().global_position.z - int(size.y /2)
		)
	
	var size2D = Vector2(size.x, size.z)
	return Rect2(objectPosition, size2D)
