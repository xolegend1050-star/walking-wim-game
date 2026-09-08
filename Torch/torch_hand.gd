extends Node3D

var torch_light: OmniLight3D
var flame_core: MeshInstance3D
var flame_outer: MeshInstance3D
var flicker_time := 0.0

func _ready():
	torch_light = $TorchLight
	flame_core = $FlameCore
	flame_outer = $FlameOuter

func _process(delta: float) -> void:
	flicker_time += delta * 10.0
	if torch_light:
		torch_light.light_energy = 2.0 + sin(flicker_time) * 0.3 + sin(flicker_time * 3.1) * 0.15
	if flame_core:
		var s = 1.0 + sin(flicker_time * 2.5) * 0.15 + sin(flicker_time * 4.7) * 0.08
		flame_core.scale = Vector3(s, 1.0 + sin(flicker_time * 3.3) * 0.2, s)
	if flame_outer:
		var s2 = 1.0 + sin(flicker_time * 1.8 + 0.5) * 0.2 + sin(flicker_time * 5.1) * 0.1
		flame_outer.scale = Vector3(s2, 1.0 + sin(flicker_time * 2.9 + 1.0) * 0.25, s2)
