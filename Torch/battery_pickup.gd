extends Area3D

@export var battery_amount := 30.0

var spawn_positions: Array[Vector3] = []
var respawn_timer: Timer

func _ready():
	body_entered.connect(_on_body_entered)
	
	# Store all battery spawn positions for respawning
	call_deferred("_collect_spawn_positions")
	
	respawn_timer = Timer.new()
	respawn_timer.one_shot = true
	respawn_timer.timeout.connect(_respawn)
	add_child(respawn_timer)

func _collect_spawn_positions():
	# Get all battery siblings and store their positions
	var batteries = get_parent().get_children()
	for b in batteries:
		if b.is_in_group("battery") or b.name.begins_with("Battery"):
			spawn_positions.append(b.global_position)
	if spawn_positions.is_empty():
		spawn_positions.append(global_position)

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		if "torch_battery" in body:
			body.torch_battery = min(body.torch_battery + battery_amount, 100.0)
		
		# Hide and respawn at random position after random delay
		visible = false
		$CollisionShape3D.set_deferred("disabled", true)
		$BatteryGlow.visible = false
		
		# Random respawn between 5-10 seconds so player never waits long
		respawn_timer.wait_time = randf_range(5.0, 10.0)
		respawn_timer.start()

func _respawn():
	# Pick a random position from all battery locations
	if spawn_positions.size() > 0:
		var random_pos = spawn_positions[randi() % spawn_positions.size()]
		# Add small random offset so they don't stack
		global_position = random_pos + Vector3(randf_range(-1.5, 1.5), 0, randf_range(-1.5, 1.5))
	
	visible = true
	$CollisionShape3D.set_deferred("disabled", false)
	$BatteryGlow.visible = true
