@tool
extends Node3D


func remove_wall_up():
	$wall_up.use_collision = true
	$wall_up.free()
func remove_wall_down():
	$wall_down.use_collision = true
	$wall_down.free()
func remove_wall_left():
	$wall_left.use_collision = true
	$wall_left.free()
func remove_wall_right():
	$wall_right.use_collision = true
	$wall_right.free()
func remove_door_up():
	#$door_up.free()
	pass
func remove_door_down():
	#$door_down.free()
	pass
func remove_door_left():
	#$door_left.free()
	pass
func remove_door_right():
	#$door_right.free()
	pass
	
