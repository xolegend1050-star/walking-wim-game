extends CharacterBody3D

@onready var stamina_bar = $"/root/Main/UICanvas/MarginContainer/StaminaBar"

@export var walk_speed = 2.5
@export var sprint_speed = 5.0
@export var mouse_sensitivity = 0.1
@export var max_stamina = 4.0
@export var stamina_regen_rate = 1.0
@export var crouch_speed = 1.5

var current_stamina: float = max_stamina
var rotation_x := 0.0
var rotation_y := 0.0
var anim_player: AnimationPlayer

var is_crouching := false
var crouch_target := 0.0
var normal_camera_height := 1.5
var crouch_camera_height := 0.5
var crouch_scale := 1.0

var torch_battery := 100.0
var torch_drain_rate := 2.0
var has_torch_item := false
var torch_on := false
var has_keycard_item := false

var screen_shake_amount := 0.0
var screen_shake_decay := 5.0

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	anim_player = get_node("Pivot/Character/AnimationPlayer")

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		rotation_y -= event.relative.x * mouse_sensitivity
		rotation_x = clamp(rotation_x - event.relative.y * mouse_sensitivity, -30, 30)

func _physics_process(delta):
	rotation.y = deg_to_rad(rotation_y)
	
	# Crouch
	if Input.is_action_just_pressed("crouch"):
		is_crouching = !is_crouching
	
	# Toggle torch
	if Input.is_action_just_pressed("toggle_torch") and has_torch_item and torch_battery > 0:
		torch_on = !torch_on
		_update_torch_visuals()
	
	crouch_target = crouch_camera_height if is_crouching else normal_camera_height
	$SpringArm3D.position.y = lerp($SpringArm3D.position.y, crouch_target, delta * 10.0)
	
	# Crouch - scale model and collision (Y only so it looks like crouching)
	var target_scale = 0.5 if is_crouching else 1.0
	crouch_scale = lerp(crouch_scale, target_scale, delta * 12.0)
	$Pivot.scale.y = crouch_scale
	$CollisionShape3D.scale.y = crouch_scale
	
	# Screen shake
	if screen_shake_amount > 0:
		var shake_offset = Vector3(
			randf_range(-screen_shake_amount, screen_shake_amount),
			randf_range(-screen_shake_amount, screen_shake_amount),
			0
		) * 0.01
		$SpringArm3D.position.x = 0.5 + shake_offset.x
		$SpringArm3D.position.y += shake_offset.y
		screen_shake_amount = move_toward(screen_shake_amount, 0, screen_shake_decay * delta)
	else:
		$SpringArm3D.position.x = 0.5
	
	$SpringArm3D.rotation.x = deg_to_rad(rotation_x)
	
	# Torch battery drain (only when torch is on)
	if has_torch_item and torch_on:
		torch_battery -= torch_drain_rate * delta
		torch_battery = max(torch_battery, 0)
		if torch_battery <= 0:
			torch_on = false
			_update_torch_visuals()
	
	# Movement
	var direction = Vector3.ZERO
	if Input.is_action_pressed("move_forward"):
		direction -= transform.basis.z
	if Input.is_action_pressed("move_backward"):
		direction += transform.basis.z
	if Input.is_action_pressed("move_left"):
		direction -= transform.basis.x
	if Input.is_action_pressed("move_right"):
		direction += transform.basis.x
	
	if Input.is_action_pressed("quit"):
		get_tree().quit()
	
	var is_moving = direction != Vector3.ZERO
	var is_running_input = Input.is_action_pressed("run")
	var can_sprint = current_stamina > 0 and is_moving and is_running_input and not is_crouching
	var current_speed = crouch_speed if is_crouching else walk_speed
	
	if can_sprint:
		current_stamina -= delta
		current_stamina = max(current_stamina, 0)
		current_speed = sprint_speed
		if anim_player.current_animation != "CharacterArmature|Run":
			anim_player.play("CharacterArmature|Run")
	else:
		current_speed = crouch_speed if is_crouching else walk_speed
		if not is_running_input or not is_moving:
			current_stamina += stamina_regen_rate * delta
			current_stamina = min(current_stamina, max_stamina)
		
		if is_moving:
			if is_crouching:
				if anim_player.current_animation != "CharacterArmature|Walk":
					anim_player.play("CharacterArmature|Walk")
				anim_player.speed_scale = 0.5
			else:
				anim_player.speed_scale = 1.0
				if anim_player.current_animation != "CharacterArmature|Walk":
					anim_player.play("CharacterArmature|Walk")
		else:
			anim_player.speed_scale = 1.0
			if anim_player.current_animation != "CharacterArmature|Idle":
				anim_player.play("CharacterArmature|Idle")
		
		if is_moving:
			direction = direction.normalized()
	
	velocity.x = direction.x * current_speed
	velocity.z = direction.z * current_speed
	
	stamina_bar.update_stamina(current_stamina)
	move_and_slide()

func apply_screen_shake(amount: float):
	screen_shake_amount = max(screen_shake_amount, amount)

func _update_torch_visuals():
	var torch_hand = get_node_or_null("SpringArm3D/TorchHand")
	if not torch_hand:
		return
	var light = torch_hand.get_node_or_null("TorchLight")
	var flame_core = torch_hand.get_node_or_null("FlameCore")
	var flame_outer = torch_hand.get_node_or_null("FlameOuter")
	if torch_on:
		if light: light.visible = true
		if flame_core: flame_core.visible = true
		if flame_outer: flame_outer.visible = true
	else:
		if light: light.visible = false
		if flame_core: flame_core.visible = false
		if flame_outer: flame_outer.visible = false

func has_keycard() -> bool:
	return has_keycard_item

func add_keycard():
	has_keycard_item = true
