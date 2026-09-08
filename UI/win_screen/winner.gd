extends Control

@export var main_scene_path: String = "res://Main.tscn"
var elapsed_time := 0.0

func _ready():
	# Mouse back visible for menu
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	MusicManager.stop_all()
	$Retry.pressed.connect(_on_retry_pressed)
	$Quit.pressed.connect(_on_quit_pressed)
	$TimeLabel.text = "Time: " + format_time(elapsed_time)

func _on_retry_pressed():
	get_tree().change_scene_to_file(main_scene_path)

func _on_quit_pressed():
	get_tree().quit()

func format_time(t):
	var minutes = int(t / 60)
	var seconds = int(t) % 60
	return str(minutes).pad_zeros(2) + ":" + str(seconds).pad_zeros(2)
