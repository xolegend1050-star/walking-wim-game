extends Area3D

@export var safe_zone := true

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("enemies"):
		if safe_zone:
			body.set_deferred("monitoring", false)
			if body.has_method("set_physics_process"):
				body.set_physics_process(false)

func _on_body_exited(body: Node3D) -> void:
	if body.is_in_group("enemies"):
		body.set_deferred("monitoring", true)
		if body.has_method("set_physics_process"):
			body.set_physics_process(true)
