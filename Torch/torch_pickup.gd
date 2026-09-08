extends Area3D

var player_nearby: bool = false
var picked_up: bool = false
var prompt_label: Label3D

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	prompt_label = $PromptLabel
	prompt_label.visible = false

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		player_nearby = true
		if not picked_up:
			prompt_label.visible = true

func _on_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		player_nearby = false
		prompt_label.visible = false

func _process(_delta: float) -> void:
	if picked_up:
		return
	if player_nearby and Input.is_action_just_pressed("interact"):
		pick_up()

func pick_up() -> void:
	picked_up = true
	prompt_label.visible = false
	var player = get_tree().get_first_node_in_group("player")
	if player:
		player.has_torch_item = true
		player.torch_on = true
		player.torch_battery = 100.0
		var torch_hand = preload("res://Torch/torch_hand.tscn").instantiate()
		torch_hand.name = "TorchHand"
		torch_hand.position = Vector3(0.5, -0.3, 0.8)
		player.get_node("SpringArm3D").add_child(torch_hand)
	queue_free()
