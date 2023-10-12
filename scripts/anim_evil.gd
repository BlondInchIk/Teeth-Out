extends CharacterBody3D

var player = null
var state_machine

const SPEED = 4.0
const ATTACK_RANGE = 2.5

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@export var player_path := "/root/Main/player"

@onready var nav_agent = $NavigationAgent3D
@onready var anim_tree = $AnimationTree


func _ready():
	#player = get_parent().get_node('player')
	player = get_node(player_path)
	state_machine = anim_tree.get('parameters/playback')
	
	
func _process(delta):
	velocity = Vector3.ZERO
	
	match state_machine.get_current_node():
		"run":
			nav_agent.set_target_position(player.global_transform.origin)
			var next_nav_point = nav_agent.get_next_path_position()
			velocity = (next_nav_point - global_transform.origin).normalized() * SPEED
			
			look_at(Vector3(global_position.x + velocity.x, global_position.y - gravity * delta, global_position.z + velocity.z), Vector3.UP)		
		
		"attack":
			look_at(Vector3(player.global_position.x, global_position.y - gravity * delta, player.global_position.z), Vector3.UP)
			
	
	anim_tree.set("parameters/conditions/attack", _target_in_range())
	anim_tree.set("parameters/conditions/run", !_target_in_range())
	
	anim_tree.get("parameters/playback")
	
	move_and_slide()

func _target_in_range():
	return global_position.distance_to(player.global_position) < ATTACK_RANGE

