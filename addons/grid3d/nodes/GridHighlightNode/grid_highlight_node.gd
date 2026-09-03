extends Node3D

@export var size := Vector2(1,1):
	set(value):
		size = value
		_change_size()
@export var colors: Array[Color] = [Color.YELLOW]:
	set(value):
		colors = value
		_set_color_value()
@export var positions : Array[Vector3]= []:
	set(value):
		positions = value
		_set_count_and_position()
@export var isCircle := false:
	set(value):
		isCircle = value
		if not isCircle:
			$MeshInstance3D.get_active_material(0).set_shader_parameter("radius", 1.0)

@export var circleRadius := 0.5:
	set(value):
		circleRadius = value
		$MeshInstance3D.get_active_material(0).set_shader_parameter("radius", circleRadius)

func _ready() -> void:
	hide()

func _set_count_and_position():
	show()
	
	var meshCountDifferent = get_child_count() - positions.size()
	if meshCountDifferent < 0:
		_add_new_mesh(abs(meshCountDifferent))
	elif meshCountDifferent > 0:
		_remove_mesh(meshCountDifferent)
		
	for i in range(get_child_count()):
		get_child(i).global_position = positions[i]
	
func _add_new_mesh(count):	
	for i in count:
		var duplicateNode = get_child(0).duplicate()
		duplicateNode.mesh = get_child(0).mesh.duplicate(true)
		add_child(duplicateNode)

func _remove_mesh(count):
	for i in count:
		var lastChild = get_children()[-1]
		remove_child(lastChild)

func _set_color_value():
	for i in range(get_child_count()):
		get_child(i).get_active_material(0).set_shader_parameter("color", colors[i])

func _change_size():
	for child in get_children():
		child.mesh.size = size
