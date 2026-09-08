extends Node3D

@export var scare_type := 0
@export var cooldown := 30.0
@export var trigger_distance := 10.0

var triggered := false
var cooldown_timer := 0.0

func _ready():
	randomize()

func _process(delta):
	if triggered:
		cooldown_timer -= delta
		return
	
	var player = get_tree().get_first_node_in_group("player")
	if player:
		var dist = global_position.distance_to(player.global_position)
		if dist < trigger_distance and not triggered:
			if randf() < 0.005:
				trigger_scare()

func trigger_scare():
	triggered = true
	cooldown_timer = cooldown
	
	match scare_type:
		0:
			_lights_out()
		1:
			_object_fall()
		2:
			_camera_flick()
		3:
			_sound_scare()

func _lights_out():
	var lights = get_tree().get_nodes_in_group("flicker_lights")
	for light in lights:
		light.light_energy = 0.0
	await get_tree().create_timer(2.0).timeout
	for light in lights:
		if is_instance_valid(light):
			light.light_energy = light.base_energy

func _object_fall():
	var object = get_node_or_null("FallingObject")
	if object:
		object.gravity_scale = 1.0
		object.call_deferred("set_mode", 1)
	await get_tree().create_timer(5.0).timeout
	if is_instance_valid(self):
		triggered = false

func _camera_flick():
	var player = get_tree().get_first_node_in_group("player")
	if player:
		var cam = player.get_node_or_null("SpringArm3D/Camera3D")
		if cam:
			for i in 5:
				cam.visible = false
				await get_tree().create_timer(0.05).timeout
				cam.visible = true
				await get_tree().create_timer(0.08).timeout

func _sound_scare():
	var player = get_tree().get_first_node_in_group("player")
	if player:
		var audio = AudioStreamPlayer3D.new()
		player.add_child(audio)
		audio.stream = preload("res://Sound/effects/blood-splatter.mp3")
		audio.volume_db = 10.0
		audio.pitch_scale = randf_range(0.8, 1.5)
		audio.play()
		await get_tree().create_timer(3.0).timeout
		if is_instance_valid(audio):
			audio.queue_free()
