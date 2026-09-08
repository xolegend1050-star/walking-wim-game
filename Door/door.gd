extends StaticBody3D

@export var locked := true
@export var keycard_required := false

var is_open := false
var animation_progress := 0.0
var target_rotation := 0.0
var player_nearby := false
var door_speed := 2.0

func _ready():
	$PromptLabel.visible = false

func _process(delta):
	if is_open:
		animation_progress = move_toward(animation_progress, 1.0, delta * door_speed)
		rotation.y = lerp(0.0, target_rotation, _ease_out_cubic(animation_progress))
		if animation_progress >= 1.0:
			set_process(false)
	else:
		if animation_progress > 0:
			animation_progress = move_toward(animation_progress, 0.0, delta * door_speed)
			rotation.y = lerp(0.0, target_rotation, _ease_out_cubic(animation_progress))
			if animation_progress <= 0:
				set_process(false)
	
	if player_nearby and Input.is_action_just_pressed("interact"):
		toggle_door()

func toggle_door():
	if locked:
		if keycard_required:
			var player = get_tree().get_first_node_in_group("player")
			if player and player.has_method("has_keycard") and player.has_keycard():
				locked = false
			else:
				return
	is_open = !is_open
	target_rotation = -PI / 2.0 if is_open else 0.0
	set_process(true)

func _on_body_entered(body):
	if body.is_in_group("player"):
		player_nearby = true
		$PromptLabel.visible = true

func _on_body_exited(body):
	if body.is_in_group("player"):
		player_nearby = false
		$PromptLabel.visible = false

func _ease_out_cubic(t: float) -> float:
	return 1.0 - pow(1.0 - t, 3.0)
