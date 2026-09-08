extends Node

# Get both musicplayers
@onready var normal_music: AudioStreamPlayer = $NormalMusic
@onready var chase_music: AudioStreamPlayer = $ChaseMusic

# When normal music is needed, stop chase.
func play_normal():
	chase_music.stop()
	normal_music.play()

# Vise versa
func play_chase():
	normal_music.stop()
	chase_music.play()

# Stop all music
func stop_all():
	normal_music.stop()
	chase_music.stop()
