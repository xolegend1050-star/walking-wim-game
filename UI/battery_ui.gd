extends Control

var torch_bar: ProgressBar
var label: Label

func _ready():
	torch_bar = ProgressBar.new()
	torch_bar.name = "TorchBar"
	torch_bar.custom_minimum_size = Vector2(150, 20)
	torch_bar.position = Vector2(10, 50)
	torch_bar.max_value = 100
	torch_bar.value = 100
	torch_bar.visible = false
	
	var style = StyleBoxFlat.new()
	style.bg_color = Color(0.2, 0.6, 0.2)
	style.corner_radius_top_left = 4
	style.corner_radius_top_right = 4
	style.corner_radius_bottom_left = 4
	style.corner_radius_bottom_right = 4
	torch_bar.add_theme_stylebox_override("fill", style)
	
	var bg_style = StyleBoxFlat.new()
	bg_style.bg_color = Color(0.1, 0.1, 0.1)
	bg_style.corner_radius_top_left = 4
	bg_style.corner_radius_top_right = 4
	bg_style.corner_radius_bottom_left = 4
	bg_style.corner_radius_bottom_right = 4
	torch_bar.add_theme_stylebox_override("background", bg_style)
	
	add_child(torch_bar)
	
	label = Label.new()
	label.name = "BatteryLabel"
	label.position = Vector2(10, 35)
	label.text = "Battery"
	label.add_theme_font_size_override("font_size", 14)
	label.visible = false
	add_child(label)

func _process(_delta):
	var player = get_tree().get_first_node_in_group("player")
	if player and player.has_torch_item:
		torch_bar.visible = true
		label.visible = true
		torch_bar.value = player.torch_battery
		
		if player.torch_battery > 50:
			torch_bar.modulate = Color(0.2, 0.8, 0.2)
		elif player.torch_battery > 20:
			torch_bar.modulate = Color(0.8, 0.8, 0.2)
		else:
			torch_bar.modulate = Color(0.8, 0.2, 0.2)
	else:
		torch_bar.visible = false
		label.visible = false
