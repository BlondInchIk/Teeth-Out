extends CharacterBody3D

#Player nodes
@onready var nek = $nek
@onready var head = $nek/head
@onready var eyes = $nek/head/eyes
@onready var standing_collusion_shape = $standing_collusion_shape
@onready var crouching_collusion_shape = $crouching_collusion_shape
@onready var ray_cast_3d = $RayCast3D
@onready var camera_3d = $nek/head/eyes/Camera3D
@onready var check_evil = $nek/head/eyes/Camera3D/check_evil
@onready var audio_stream_player_3d = $AudioStreamPlayer3D
@onready var inter = $nek/head/eyes2/Camera3D/light/inter

#Speed vars
var current_speed = 3.0
const walking_speed = 3.0
const sprinting_speed = 5.0
const crouching_speed = 1.5

var flag = 0

#States
var walking = false
var sprinting = false
var free_looking = false
var sliding = false
var crouching = false

#Slide vars
var slide_timer = 0.0
var slide_timer_max = 1.0
var slide_vector = Vector2.ZERO
var slide_speed = 10.0

#Head bobbings vars
const head_bobbing_sprinting_speed = 20.0
const head_bobbing_walking_speed = 11.0
const head_bobbing_crouching_speed = 10.0

const head_bobbing_sprinting_intensity = 0.1
const head_bobbing_walking_intensity = 0.08
const head_bobbing_crouching_intensity = 0.03

var head_bobbing_vector = Vector2.ZERO
var head_bobbing_index = 0.0
var head_bobbing_current_intensity = 0.0

#Movement vars
const jump_velocity = 4.5
var crouching_depth = -0.5
var lerp_speed = 10
var air_lerp_speed = 3
var free_look_tilt_amount = 8

#Input vars
var direction = Vector3.ZERO
const mouse_sens = 0.25

#Gravity
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

#Check mouse
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

#Move mouse
func _input(event):
	if event is InputEventMouseMotion:
		if free_looking:
			nek.rotate_y(deg_to_rad(-event.relative.x * mouse_sens))
			nek.rotation.y = clamp(nek.rotation.y, deg_to_rad(-120), deg_to_rad(120))
		else:
			rotate_y(deg_to_rad(-event.relative.x * mouse_sens))
			head.rotate_x(deg_to_rad(-event.relative.y * mouse_sens))
			head.rotation.x = clamp(head.rotation.x, deg_to_rad(-89), deg_to_rad(89))
	#elif event.is_action_pressed("ui_pause"):
		#$ColorRect.pause()
		

#Movement
func _physics_process(delta):
	
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	
	
	#Crouch
	if Input.is_action_pressed("crouch") || sliding:
		
		current_speed = lerp(current_speed, crouching_speed,delta*lerp_speed)
		head.position.y = lerp(head.position.y, crouching_depth, delta* lerp_speed)
		standing_collusion_shape.disabled = true 
		crouching_collusion_shape.disabled = false
		
		#slide
		if sprinting && input_dir != Vector2.ZERO:
			sliding = true
			slide_timer = slide_timer_max
			slide_vector = input_dir
			free_looking = true
			
		
		walking = false
		sprinting = false
		crouching = true
		
	#Walking
	elif !ray_cast_3d.is_colliding():
		
		standing_collusion_shape.disabled = false
		crouching_collusion_shape.disabled = true
		head.position.y = lerp(head.position.y, 0.0, delta* lerp_speed)
		
		#Sprint
		if Input.is_action_pressed('sprint'):
			current_speed = lerp(current_speed, sprinting_speed,delta*lerp_speed)
			walking = false
			sprinting = true
			crouching = false
		else:
			current_speed = lerp(current_speed, walking_speed,delta*lerp_speed)
			walking = true
			sprinting = false
			crouching = false
	
	#Handle free looking
	if Input.is_action_pressed("free_look") || sliding:
		free_looking = true
		
		if sliding:
			camera_3d.rotation.z = lerp(camera_3d.rotation.z, -deg_to_rad(7.0), delta*lerp_speed)
		else:
			camera_3d.rotation.z = -deg_to_rad(nek.rotation.y*free_look_tilt_amount)
	else:
		free_looking = false
		nek.rotation.y = lerp(nek.rotation.y, 0.0, delta*lerp_speed)
		camera_3d.rotation.z = lerp(camera_3d.rotation.y, 0.0, delta*lerp_speed)
	
	#Handle sliding
	if sliding:
		slide_timer -= delta
		if slide_timer <= 0:
			sliding = false
			free_looking = false
	
	#Handle haedbob
	if sprinting:
		head_bobbing_current_intensity = head_bobbing_sprinting_intensity
		head_bobbing_index += head_bobbing_sprinting_speed*delta
	elif walking:
		head_bobbing_current_intensity = head_bobbing_walking_intensity
		head_bobbing_index += head_bobbing_walking_speed*delta
	elif crouching:
		head_bobbing_current_intensity = head_bobbing_crouching_intensity
		head_bobbing_index += head_bobbing_crouching_speed*delta
	
	if is_on_floor() && !sliding && input_dir != Vector2.ZERO:
		head_bobbing_vector.y = sin(head_bobbing_index)
		head_bobbing_vector.x = sin(head_bobbing_index/2) + 0.5
		if head_bobbing_vector.y < 0 and flag == 0:
			audio_stream_player_3d.pitch_scale = randf_range(.9, 1.01)
			audio_stream_player_3d.volume_db = randf_range(-25,-20)
			audio_stream_player_3d.play()
			flag = 1
		elif head_bobbing_vector.y > 0:
			flag = 0
			
		eyes.position.y = lerp(eyes.position.y, head_bobbing_vector.y*(head_bobbing_current_intensity/2.0),delta*lerp_speed)
		eyes.position.x = lerp(eyes.position.x, head_bobbing_vector.x*head_bobbing_current_intensity,delta*lerp_speed)
	
	else:
		
		if flag == 1:
			audio_stream_player_3d.stop()
			flag = 0
			
		eyes.position.y = lerp(eyes.position.y, 0.0,delta*lerp_speed)
		eyes.position.x = lerp(eyes.position.x, 0.0,delta*lerp_speed)
		
	
	#Add the gravity
	if not is_on_floor():
		velocity.y -= gravity * delta

	#Handle Jump
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_velocity
		sliding = false

	#lerp
	if is_on_floor():
		direction = lerp(direction, (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized(), delta*lerp_speed)
	else:
		if input_dir != Vector2.ZERO:
			direction = lerp(direction, (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized(), delta*air_lerp_speed)
	
	
	if sliding:
		direction = (transform.basis * Vector3(slide_vector.x, 0, slide_vector.y)).normalized()
		current_speed = (slide_timer + 0.1) * slide_speed
	
	if direction:
		velocity.x = direction.x * current_speed
		velocity.z = direction.z * current_speed
	else:
		velocity.x = move_toward(velocity.x, 0, current_speed)
		velocity.z = move_toward(velocity.z, 0, current_speed)

	move_and_slide()


func attack_eff():
	inter.attack_eff()

func _process(delta):
	if my_global.health == 0:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		get_tree().change_scene_to_file("res://scenes/lose.tscn")
	if my_global.teeth == my_global.max_teeth:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		get_tree().change_scene_to_file("res://scenes/win.tscn")
