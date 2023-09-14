extends ColorRect

@onready var animator: AnimationPlayer = $AnimationPlayer
@onready var play_button = $CenterContainer/PanelContainer/MarginContainer/VBoxContainer/Resume
@onready var quit_button = $CenterContainer/PanelContainer/MarginContainer/VBoxContainer/Quit

func _ready():
	play_button.pressed.connect(unpause)
	quit_button.pressed.connect(get_tree().quit)

func unpause():
	animator.play("new_animation_2")
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func pause():
	animator.play("new_animation")
	get_tree().paused = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
