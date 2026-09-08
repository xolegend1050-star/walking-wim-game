extends Node

var heartbeat_player: AudioStreamPlayer
var heartbeat_normal: AudioStream
var heartbeat_fast: AudioStream
var is_chasing := false
var current_bpm := 60.0

func _ready():
	heartbeat_player = AudioStreamPlayer.new()
	add_child(heartbeat_player)
	heartbeat_player.bus = "SFX"
	heartbeat_player.volume_db = -10.0
	heartbeat_normal = _generate_heartbeat(60.0)
	heartbeat_fast = _generate_heartbeat(140.0)
	heartbeat_player.stream = heartbeat_normal

func _process(delta):
	if is_chasing:
		current_bpm = lerp(current_bpm, 140.0, delta * 3.0)
	else:
		current_bpm = lerp(current_bpm, 60.0, delta * 1.0)
	
	if current_bpm > 80.0 and heartbeat_player.stream != heartbeat_fast:
		heartbeat_player.stream = heartbeat_fast
	elif current_bpm <= 80.0 and heartbeat_player.stream != heartbeat_normal:
		heartbeat_player.stream = heartbeat_normal

func set_chasing(value: bool):
	is_chasing = value
	if is_chasing and not heartbeat_player.playing:
		heartbeat_player.play()

func _generate_heartbeat(bpm: float) -> AudioStream:
	var sample_rate = 22050
	var beat_duration = 60.0 / bpm
	var total_duration = beat_duration * 2.0
	var sample_count = int(sample_rate * total_duration)
	var samples = PackedByteArray()
	samples.resize(sample_count * 2)
	
	for i in sample_count:
		var t = float(i) / sample_rate
		var beat_pos = fmod(t, beat_duration) / beat_duration
		
		var val := 0.0
		if beat_pos < 0.1:
			val = sin(beat_pos / 0.1 * PI) * 0.8
		elif beat_pos > 0.15 and beat_pos < 0.2:
			val = sin((beat_pos - 0.15) / 0.05 * PI) * 0.5
		
		val *= 0.4
		var sample = int(clamp(val, -1.0, 1.0) * 32767)
		samples[i * 2] = sample & 0xFF
		samples[i * 2 + 1] = (sample >> 8) & 0xFF
	
	var stream = AudioStreamWAV.new()
	stream.format = AudioStreamWAV.FORMAT_16_BITS
	stream.mix_rate = sample_rate
	stream.stereo = false
	stream.data = samples
	return stream
