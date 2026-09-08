extends Control

# Get the main scene
@export var main_scene_path: String = "res://main.tscn"
# Get the second background.
@export var background_after_delay: Texture2D
@onready var background = $TextureRect
@onready var audio_player = $AudioStreamPlayer

func _ready():
	# Connect the retry function to the button on game over screen.
	$Retry.connect("pressed", Callable(self, "_on_Retry_pressed"))
	$Retry.visible = false 
	audio_player.stream = preload("res://Sound/effects/Wilhelm Scream - Sound Effect (HD).mp3")
	audio_player.play()
	change_background_after_delay()

# When retry is pressed
func _on_Retry_pressed():
	# Reset the scene.
	get_tree().change_scene_to_file(main_scene_path)

# Change the background after 2 seconds.
func change_background_after_delay():
	await get_tree().create_timer(2.0).timeout
	audio_player.stream = preload("res://Sound/effects/blood-splatter.mp3")
	audio_player.play()
	await get_tree().create_timer(1.2).timeout
	background.texture = background_after_delay
	$Retry.visible = true
