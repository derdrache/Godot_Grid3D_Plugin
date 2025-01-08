@tool
extends EditorPlugin


func _enter_tree() -> void:
	add_custom_type(
		"Grid3D", 
		"Node3D", 
		preload("res://addons/grid3d/nodes/Grid3D/grid.gd"), 
		preload("res://addons/grid3d/assets/Grid3D.png")
	)
	add_custom_type(
		"GridAgent3D", 
		"Node3D", 
		preload("res://addons/grid3d/nodes/gridAgent3D/grid_agent_3d.gd"), 
		preload("res://addons/grid3d/assets/Grid3D.png")
	)


func _exit_tree() -> void:
	remove_custom_type("Grid3D")
	remove_custom_type("GridAgent3D")
