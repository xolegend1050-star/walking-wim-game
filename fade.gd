extends ColorRect

# Called when the node enters the scene tree for the first time.
func _ready():
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	modulate = Color(0, 0, 0, 1.0)
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 3.0)	
