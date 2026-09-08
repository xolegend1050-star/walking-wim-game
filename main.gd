extends Node

# Get the player
@onready var player = $Player
var elapsed_time := 0.0 

func _process(delta):
	elapsed_time += delta

func _physics_process(_delta):
	# Get the player position and give it to all nodes in the group enemies.
	get_tree().call_group("enemies", "update_target_location", player.global_transform.origin)
	
func _ready():
	# Play normal music to start
	MusicManager.play_normal()
	
	# Loop through each enemy and connect the gameover function as a callable.
	for enemy in get_tree().get_nodes_in_group("enemies"):
		enemy.connect("game_over", Callable(self, "_on_game_over"))

# This triggers if the zombie gets too close.
func _on_game_over():
	# Mouse back visible for menu
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	# Stop the music
	MusicManager.stop_all()
	# Change to the game over scene.
	get_tree().change_scene_to_file("res://UI/game_over.tscn")
