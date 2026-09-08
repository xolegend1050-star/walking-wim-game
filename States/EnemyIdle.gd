extends State
class_name EnemyIdle

# Get the audioplayer
@onready var audio_player = $"../../AudioStreamPlayer3D"
# Make an array to put the sounds in.
var sounds: Array[AudioStream] = []
# Variable to keep track if there is a sound playing.
var playing_sounds := false

# Get the Zombie
@export var enemy: CharacterBody3D
# set the move speed
@export var move_speed := 1.0

# Get the player
var player: CharacterBody3D

# Variables for direction and time.
var move_direction : Vector3
var wander_time : float

# Function to load sounds list with mp3s
func _ready():
	sounds = [
		preload("res://Sound/Zombie_moans/cogniam_mild_1.mp3"),
		preload("res://Sound/Zombie_moans/cogniam_mild_2.mp3"),
		preload("res://Sound/Zombie_moans/cogniam_mild_3.mp3"),
		preload("res://Sound/Zombie_moans/cogniam_mild_4.mp3"),
		preload("res://Sound/Zombie_moans/cogniam_mild_5.mp3"),
		preload("res://Sound/Zombie_moans/cogniam_mild_6.mp3"),
		preload("res://Sound/Zombie_moans/cogniam_mild_7.mp3"),
	]

# Function to randomize direction to walk to
func randomize_wander():
	# Vector3 takes XYZ cords.
	move_direction = Vector3(randf_range(-1, 1), 0, randf_range(-1, 1)).normalized()
	# Randomize the time as well
	wander_time = randf_range(1, 3)
	
# STATE LIFECYCLE:
# When first wandering, randomize wander
func Enter():
	player = get_tree().get_first_node_in_group("player")
	randomize_wander()
	await get_tree().create_timer(5.0).timeout
	# And play a random sound.
	playing_sounds = true
	play_random_sound()

func Exit():
	# Stop playing sounds if the Idle state stops
	playing_sounds = false
	audio_player.stop()
	
func Update(delta: float):
	# If the wander time is more than 0,
	if wander_time > 0:
		# Decrease wander_time.
		wander_time -= delta
		
	else:
		# If it is 0, than randomize again.
		randomize_wander()
		
func Physics_Update(_delta: float):
	# If enemy exists
	if enemy: 
		# Setting path.
		enemy.velocity = move_direction * move_speed
	
	# Get the distance
	var direction = player.global_position - enemy.global_position
	
	# Check if distance is shorter than 30
	if direction.length() < 20:
		# Go to the follow state.
		Transitioned.emit(self, "follow")
	
	# If not, play the walk animation.
	enemy.get_node("AnimationPlayer").play("Armature|Walk")
	
	# Check if zombie is moving
	if move_direction.length() > 0.1:
		# Face the zombie the way it is moving.
		var look_pos = enemy.global_position - move_direction
		enemy.look_at(look_pos, Vector3.UP)

	# Actually move the zombie.
	enemy.move_and_slide()
	
# SOUND LOGIC:
func play_random_sound():
	# Check if sounds is empty or there already is a sound playing.
	if not playing_sounds or sounds.is_empty():
		return
	
	# Random sound takes a sound out of the list of sounds.
	var random_sound = sounds[randi() % sounds.size()]
	# Set the audioplayer with the sound.
	audio_player.stream = random_sound
	# Play it.
	audio_player.play()
	
	# Wait until the clip is finished
	await audio_player.finished
	
	# Make a random delay between 2 and 8 seconds.
	# This delay is to make sure the zombie doesn't spam voicelines.
	var next_delay = randf_range(2.0, 8.0)
	# Wait until the delay is finished.
	await get_tree().create_timer(next_delay).timeout
	
	# As long as the variable is playing sounds, play sounds.
	if playing_sounds:
		play_random_sound()
