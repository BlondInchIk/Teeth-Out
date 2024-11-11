extends Node3D

func _on_area_3d_body_entered(body):
	if body.name == 'player':
		my_global.teeth = my_global.teeth + 1
		queue_free()
