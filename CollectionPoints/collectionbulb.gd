extends Node3D

# Keeping track of the points the player has.
@export var points := 1 

func _ready():
	# Make sure collision detects area
	if has_node("CollisionShape3D"):
		$CollisionShape3D.disabled = false

# This is the function that Node gave to check if the area has been touched.
func _on_area_3d_body_entered(body: Node3D) -> void:
	# Check if it was a player that touched it.
	if body.is_in_group("player"):
		# Check if the player has stamina:
		if "current_stamina" in body:
			# Give the player full stamina for touching the sphere.
			body.current_stamina = body.max_stamina
		# Add to score +1
		var ui = get_node("/root/Main/UICanvas/UI")
		ui.elapsed_time = get_node("/root/Main").elapsed_time
		ui.add_collectible()
		# Play sound
		var sfx = get_node("/root/Main/SFX")
		sfx.play()
		# Remove the parent Node3D (the whole collectible)
		get_parent().get_parent().queue_free()
