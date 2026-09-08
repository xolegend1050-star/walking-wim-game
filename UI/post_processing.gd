extends CanvasLayer

@onready var vignette = $Vignette
@onready var damage_overlay = $DamageOverlay

var vignette_base := 0.3
var target_vignette := 0.3
var damage_alpha := 0.0

func _ready():
	if vignette:
		vignette.color = Color(0, 0, 0, vignette_base)
	if damage_overlay:
		damage_overlay.color = Color(0.8, 0, 0, 0)

func _process(delta):
	if vignette:
		vignette_base = lerp(vignette_base, target_vignette, delta * 3.0)
		vignette.color.a = vignette_base
	
	if damage_overlay and damage_alpha > 0:
		damage_alpha = lerp(damage_alpha, 0.0, delta * 4.0)
		damage_overlay.color.a = damage_alpha

func set_threat_level(level: float):
	target_vignette = lerp(0.2, 0.8, clamp(level, 0.0, 1.0))

func show_damage():
	damage_alpha = 0.6
