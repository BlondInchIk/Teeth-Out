extends Control

@onready var light = $".."
@onready var label = $MarginContainer/Label
@onready var label2 = $MarginContainer2/Label
@onready var label3 = $MarginContainer3/Label
@onready var max_teeth = my_global.max_teeth
@onready var string = ''
@onready var color_rect = $ColorRect
@onready var animation_player = $ColorRect/AnimationPlayer

func _process(delta):
	label.text = "🔦" + str(int(light.energy/10)) + "%"
	label2.text = str(my_global.teeth) + "/" + str(max_teeth)
	string = ''
	for i in range(my_global.health):
		string += "🦷"
	label3.text = string
	var color = Color.RED.lerp(Color.BLUE, light.energy / 1000.0)
	label.modulate = color
	if my_global.teeth == max_teeth:
		label2.modulate = Color.GREEN
	
func attack_eff():
	color_rect.show()
	animation_player.play("new_animation")
	print(1)
