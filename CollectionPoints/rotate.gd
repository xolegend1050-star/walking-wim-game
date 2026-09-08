extends Node3D

@export var spin_speed: float = 0.2 # rotations per second

func _process(delta):
	# TAU spins 360 degrees
	rotate_y(TAU * spin_speed * delta)
