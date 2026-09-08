extends Node

@onready var player = $Player
var elapsed_time := 0.0

var heartbeat_manager: Node
var post_processing: CanvasLayer
var zombie_near := false
var scare_timer := 0.0

func _process(delta):
	elapsed_time += delta
	
	# Check zombie distance for heartbeat and screen shake
	var zombie_dist := 999.0
	for enemy in get_tree().get_nodes_in_group("enemies"):
		if is_instance_valid(enemy):
			zombie_dist = min(zombie_dist, enemy.global_position.distance_to(player.global_position))
	
	var threat_level = clamp(1.0 - (zombie_dist / 20.0), 0.0, 1.0)
	
	if heartbeat_manager:
		heartbeat_manager.set_chasing(threat_level > 0.5)
	
	if post_processing and post_processing.has_method("set_threat_level"):
		post_processing.set_threat_level(threat_level)
	
	# Screen shake only when zombie is VERY close
	if zombie_dist < 8.0:
		player.apply_screen_shake((1.0 - zombie_dist / 8.0) * 3.0)
	
	# Random jump scares
	scare_timer -= delta
	if scare_timer <= 0 and threat_level < 0.3:
		if randf() < 0.001:
			_trigger_random_scare()
			scare_timer = randf_range(20.0, 60.0)

func _physics_process(_delta):
	# Enemy detection is handled by their own state scripts
	pass

func _ready():
	MusicManager.play_normal()
	
	for enemy in get_tree().get_nodes_in_group("enemies"):
		enemy.connect("game_over", Callable(self, "_on_game_over"))
	
	# Setup heartbeat
	heartbeat_manager = Node.new()
	heartbeat_manager.set_script(load("res://Sound/heartbeat_manager.gd"))
	heartbeat_manager.name = "HeartbeatManager"
	add_child(heartbeat_manager)
	
	# Setup post processing
	post_processing = CanvasLayer.new()
	post_processing.name = "PostProcessing"
	post_processing.layer = 10
	add_child(post_processing)
	
	var vignette = ColorRect.new()
	vignette.name = "Vignette"
	vignette.anchors_preset = Control.PRESET_FULL_RECT
	vignette.mouse_filter = Control.MOUSE_FILTER_IGNORE
	vignette.color = Color(0, 0, 0, 0.3)
	post_processing.add_child(vignette)
	
	var damage_overlay = ColorRect.new()
	damage_overlay.name = "DamageOverlay"
	damage_overlay.anchors_preset = Control.PRESET_FULL_RECT
	damage_overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
	damage_overlay.color = Color(0.8, 0, 0, 0)
	post_processing.add_child(damage_overlay)
	
	post_processing.set_script(load("res://UI/post_processing.gd"))
	
	# Apply flicker script to ceiling lights
	for light in get_tree().get_nodes_in_group("flicker_lights"):
		if light is OmniLight3D:
			light.set_script(load("res://light_flicker.gd"))

func _trigger_random_scare():
	var scare_types = ["lights_flicker", "sound"]
	var type = scare_types[randi() % scare_types.size()]
	
	match type:
		"lights_flicker":
			var lights = get_tree().get_nodes_in_group("flicker_lights")
			for light in lights:
				if light is OmniLight3D:
					light.light_energy = 0.0
			await get_tree().create_timer(1.5).timeout
			for light in lights:
				if is_instance_valid(light) and light is OmniLight3D:
					light.light_energy = light.base_energy if "base_energy" in light else 0.1
		"sound":
			var scream = AudioStreamPlayer.new()
			add_child(scream)
			scream.stream = preload("res://Sound/effects/Wilhelm Scream - Sound Effect (HD).mp3")
			scream.volume_db = -5.0
			scream.pitch_scale = randf_range(0.7, 1.3)
			scream.play()
			await get_tree().create_timer(3.0).timeout
			if is_instance_valid(scream):
				scream.queue_free()

func _on_game_over():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	MusicManager.stop_all()
	get_tree().change_scene_to_file("res://UI/game_over.tscn")
