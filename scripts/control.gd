extends Control

@onready var audio_stream_player = $AudioStreamPlayer
@onready var audio_stream_player_2 = $AudioStreamPlayer2

# Called when the node enters the scene tree for the first time.
func _ready():
	audio_stream_player.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_pressed():
	audio_stream_player_2.play()
	get_tree().change_scene_to_file("res://scenes/main/main.tscn")


func _on_button_2_pressed():
	audio_stream_player_2.play()
	pass # Replace with function body.


func _on_button_3_pressed():
	audio_stream_player_2.play()
	await get_tree().create_timer(0.2).timeout
	get_tree().quit()
