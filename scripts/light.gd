extends Node3D

@onready var spot_light_3d_2 = $SpotLight3D2
@onready var spot_light_3d = $SpotLight3D
@onready var spot_light_3d_3 = $SpotLight3D3

var inter = null
const max_energy = 1000
var energy = max_energy

func _ready():
	var inter = get_parent().get_child_count(true)

func _physics_process(delta):
	if Input.is_action_just_pressed("light"):
		if (spot_light_3d.light_energy == 0.0):
			light_on()
		else:
			light_off()
		

func _process(delta):
	if (spot_light_3d.light_energy == 0.0):
		stop()
	else:
		start()
	if (energy < 2):
		light_off()
	
	print(inter)
	
func light_on():
	spot_light_3d.light_energy = 6
	spot_light_3d_2.light_energy = 2
	spot_light_3d_3.light_energy = 7
	
func light_off():
	spot_light_3d.light_energy = 0.0
	spot_light_3d_2.light_energy = 0.0
	spot_light_3d_3.light_energy = 0.0

func start():
	if (energy > 0):
		energy -= 1
	
func stop():
	if (energy < max_energy):
		energy += 0.5
