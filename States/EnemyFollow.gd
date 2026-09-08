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
	if player == null:
		return
	
	nav_agent.target_position = player.global_position
	var next_pos = nav_agent.get_next_path_position()
	var direction = (next_pos - enemy.global_position)
	
	var dist_to_player = enemy.global_position.distance_to(player.global_position)
	
	# Check if player is making noise
	var player_vel = player.velocity.length()
	var has_torch = player.has_torch_item if "has_torch_item" in player else false
	var player_noisy = player_vel > 3.0 or has_torch
	
	# Lose the player if they are far AND quiet
	if dist_to_player > 25.0 and not player_noisy:
		Transitioned.emit(self, "idle")
		return
	
	# Also lose if very far regardless
	if dist_to_player > 35.0:
		Transitioned.emit(self, "idle")
		return
	
	# Kill range
	if dist_to_player < 1.4:
		enemy.velocity = Vector3.ZERO
		enemy._on_state_gameover()
		return
	
	enemy.velocity = direction.normalized() * move_speed
	
	if enemy.velocity.length() > 0.1:
		var facing_direction = -enemy.velocity.normalized()
		enemy.look_at(enemy.global_position + facing_direction, Vector3.UP)
		enemy.get_node("AnimationPlayer").play("Armature|Running_Crawl")
	
	enemy.move_and_slide()

func Exit():
	# If Follow state is not in range, play normal music, and switch the chase var.
	MusicManager.play_normal()
	chase_started = false
