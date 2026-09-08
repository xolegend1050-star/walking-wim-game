extends CharacterBody3D
signal game_over

# Get the NavAgent.
@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D

# Speed of the zombie.
@export var move_speed: float = 3.0

# game over function.
func _on_state_gameover():
	# Emits the signal to call the actual function.
	emit_signal("game_over")
	
