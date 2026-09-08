extends TextureProgressBar

# Max stamina for the bar
var max_stamina := 4.0

# Update the stamina with the current stamina.
func update_stamina(current_stamina: float):
	value = (current_stamina / max_stamina) * 100
