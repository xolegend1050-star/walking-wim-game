extends OmniLight3D

@export var min_energy := 0.05
@export var max_energy := 0.15
@export var flicker_speed := 8.0
@export var off_chance := 0.02
@export var off_duration := 0.5

var base_energy := 0.1
var flicker_time := 0.0
var is_off := false
var off_timer := 0.0

func _ready():
	base_energy = light_energy
	randomize()

func _process(delta):
	if is_off:
		off_timer -= delta
		light_energy = 0.0
		if off_timer <= 0:
			is_off = false
		return
	
	if randf() < off_chance * delta * 60.0:
		is_off = true
		off_timer = randf_range(0.1, off_duration)
		return
	
	flicker_time += delta * flicker_speed
	var flicker = sin(flicker_time * 3.7) * 0.3 + sin(flicker_time * 7.1) * 0.2 + sin(flicker_time * 11.3) * 0.1
	light_energy = base_energy + flicker * base_energy * 0.5
	light_energy = clamp(light_energy, min_energy, max_energy)
