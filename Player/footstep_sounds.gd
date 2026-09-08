extends Node3D

@onready var audio_player: AudioStreamPlayer3D = AudioStreamPlayer3D.new()

var walk_stream: AudioStream
var run_stream: AudioStream
var step_timer := 0.0
var is_moving := false
var is_sprinting := false
var last脚步 := false

const WALK_INTERVAL := 0.45
const RUN_INTERVAL := 0.3

func _ready():
	add_child(audio_player)
	audio_player.bus = "SFX"
	audio_player.max_distance = 8.0
	walk_stream = _generate_step_sound(0.6, 200.0)
	run_stream = _generate_step_sound(0.8, 300.0)

func _physics_process(delta):
	var player = get_parent()
	if not player or not player is CharacterBody3D:
		return
	
	is_moving = player.velocity.length() > 0.5
	is_sprinting = player.velocity.length() > 4.0
	
	if is_moving:
		var interval = RUN_INTERVAL if is_sprinting else WALK_INTERVAL
		step_timer += delta
		if step_timer >= interval:
			step_timer = 0.0
			_play_step()
	else:
		step_timer = 0.0

func _play_step():
	if is_sprinting:
		audio_player.stream = run_stream
	else:
		audio_player.stream = walk_stream
	audio_player.pitch_scale = randf_range(0.85, 1.15)
	audio_player.volume_db = randf_range(-6.0, -2.0)
	audio_player.play()

func _generate_step_sound(duration: float, freq: float) -> AudioStream:
	var sample_rate = 22050
	var sample_count = int(sample_rate * duration)
	var samples = PackedVector2Array()
	samples.resize(sample_count)
	
	for i in sample_count:
		var t = float(i) / sample_rate
		var envelope = exp(-t * 12.0) * (1.0 - exp(-t * 200.0))
		var noise = randf_range(-1.0, 1.0)
		var tone = sin(TAU * freq * t) * 0.3
		var sample = (noise * 0.7 + tone) * envelope * 0.4
		samples[i] = Vector2(sample, sample)
	
	var stream = AudioStreamPolyphonic.new()
	var bus_idx = AudioServer.get_bus_index("SFX")
	
	var generator = AudioStreamGenerator.new()
	generator.mix_rate = sample_rate
	generator.buffer_length = duration
	
	return _create_audio_stream(sample_rate, samples)

func _create_audio_stream(sample_rate: int, samples: PackedVector2Array) -> AudioStream:
	var stream = AudioStreamWAV.new()
	stream.format = AudioStreamWAV.FORMAT_16_BITS
	stream.mix_rate = sample_rate
	stream.stereo = false
	
	var data = PackedByteArray()
	data.resize(samples.size() * 2)
	for i in samples.size():
		var val = int(clamp(samples[i].x, -1.0, 1.0) * 32767)
		data[i * 2] = val & 0xFF
		data[i * 2 + 1] = (val >> 8) & 0xFF
	stream.data = data
	
	return stream
