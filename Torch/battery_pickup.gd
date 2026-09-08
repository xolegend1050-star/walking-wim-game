extends Area3D

@export var battery_amount := 30.0

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		if "torch_battery" in body:
			body.torch_battery = min(body.torch_battery + battery_amount, 100.0)
		queue_free()
