extends Control

# Function for pressing start
func _on_start_button_pressed() -> void:
	# Move to the main scene.
	get_tree().change_scene_to_file("res://main.tscn")

# Function for pressing quit
func _on_quit_button_pressed() -> void:
	get_tree().quit()
