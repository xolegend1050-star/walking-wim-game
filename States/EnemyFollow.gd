extends State
class_name EnemyFollow

# Get the zombie and speed
@export var enemy: CharacterBody3D
@export var move_speed := 4.0

# Variables for the player and NavigationAgent
var player: CharacterBody3D
var nav_agent: NavigationAgent3D

# Variable to keep track if the chase has started, so we don't constantly check.
var chase_started := false

# When first changed into state
func Enter():
	# Get the player and NavigationAgent3D
	player = get_tree().get_first_node_in_group("player")
	nav_agent = enemy.get_node("NavigationAgent3D")
	# Change the target_position to the player's global position
	nav_agent.target_position = player.global_position
	
	# If chase has not started, play the music and set the variable.
	if not chase_started:
		MusicManager.play_chase()
		chase_started = true

func Physics_Update(_delta: float):
	# If player is somehow null, return
	if player == null:
		return
	
	# Set the target position again
	nav_agent.target_position = player.global_position
	
	# Get the next path position
	var next_pos = nav_agent.get_next_path_position()
	
	# Get the distance from the next pos to the zombie position.
	var direction = (next_pos - enemy.global_position)
	
	# Check if zombie is outside of range
	if enemy.global_position.distance_to(player.global_position) > 30: 
		# Go to idle mode.
		Transitioned.emit(self, "idle")
	
	var distance_to_player = enemy.global_position.distance_to(player.global_position)
	# If that length is less than 1.4, meaning the zombie is next to the player
	if distance_to_player < 1.4:
		# Set the velocity to 0.
		enemy.velocity = Vector3.ZERO
		# Get the game over screen.
		enemy._on_state_gameover()
		return
	
	# other wise, set the velocity to the distance * speed.
	enemy.velocity = direction.normalized() * move_speed
	
	# If the zombie is moving
	if enemy.velocity.length() > 0.1:
		# Reverse the direction, because the model loaded in backwards.
		var facing_direction = -enemy.velocity.normalized()
		# Look at the direction.
		enemy.look_at(enemy.global_position + facing_direction, Vector3.UP)
		# Play the running animation
		enemy.get_node("AnimationPlayer").play("Armature|Running_Crawl")
	
	# Move it!
	enemy.move_and_slide()

func Exit():
	# If Follow state is not in range, play normal music, and switch the chase var.
	MusicManager.play_normal()
	chase_started = false
