extends Control

var collected := 0
# Total spheres in the map
const TOTAL := 10 
@export var winner_scene: PackedScene
var elapsed_time := 0.0

# Update the counter when loaded in.
func _ready():
	update_counter()

# Call this whenever a sphere is collected
func add_collectible():
	collected += 1
	update_counter()
	# Check if 10 has been reached
	check_win()

func update_counter():
	$CollectCounter.text = str(collected, " / ", TOTAL)

# Win condition
func check_win():
	if collected >= TOTAL:
		var winner = winner_scene.instantiate()
		var main = get_node("/root/Main")
		winner.elapsed_time = main.elapsed_time
		get_tree().current_scene.queue_free()
		get_tree().root.add_child(winner)
		get_tree().current_scene = winner
