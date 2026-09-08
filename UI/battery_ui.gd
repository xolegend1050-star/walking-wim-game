extends ProgressBar

@onready var fill_rect: ColorRect = $BarFill
@onready var label: Label = $Label

func _ready():
	# Style the progress bar
	var bg_style = StyleBoxFlat.new()
	bg_style.bg_color = Color(0.1, 0.1, 0.1)
	bg_style.corner_radius_top_left = 4
	bg_style.corner_radius_top_right = 4
	bg_style.corner_radius_bottom_left = 4
	bg_style.corner_radius_bottom_right = 4
	add_theme_stylebox_override("background", bg_style)
	
	var fill_style = StyleBoxFlat.new()
	fill_style.bg_color = Color(0.2, 0.8, 0.2)
	fill_style.corner_radius_top_left = 4
	fill_style.corner_radius_top_right = 4
	fill_style.corner_radius_bottom_left = 4
	fill_style.corner_radius_bottom_right = 4
	add_theme_stylebox_override("fill", fill_style)
	
	# Hide until torch is picked up
	visible = false

func _process(_delta):
	var player = get_tree().get_first_node_in_group("player")
	if player and "has_torch_item" in player and player.has_torch_item:
		visible = true
		value = player.torch_battery
		
		# Update fill color based on charge level
		var fill_style = get_theme_stylebox("fill") as StyleBoxFlat
		if fill_style:
			if value > 50:
				fill_style.bg_color = Color(0.2, 0.8, 0.2)
			elif value > 20:
				fill_style.bg_color = Color(0.8, 0.8, 0.2)
			else:
				fill_style.bg_color = Color(0.8, 0.2, 0.2)
		
		# Update label
		if label:
			label.text = str(int(value)) + "%"
	else:
		visible = false
