extends Node

# This gets the initial state of the zombie
@export var initial_state : State

# This is the current state variable
var current_state : State
# Make an empty dictionary for the states
var states: Dictionary = {}

# Load in first.
func _ready():
	# loop through all the children of the StateMachine.
	for child in get_children():
		# check if it is a state.
		if child is State:
			# If so, add the name to the states dict.
			states[child.name.to_lower()] = child
			# Signal for changing state
			child.Transitioned.connect(on_child_transition)
	
	# Check if there is an initial state
	if initial_state:
		# if so, enter that state
		initial_state.Enter()
		# set the current_state to that state.
		current_state = initial_state		
			
func _process(delta):
	# Check if there is a current_state
	if current_state:
		# If there is, call the Update function
		current_state.Update(delta)

func _physics_process(delta):
	# Do the same for the Physics_update function.
	if current_state:
		current_state.Physics_Update(delta)

func on_child_transition(state, new_state_name):
	# Check if the state is the actual state, if not return
	if state != current_state:
		return
	
	# Get the new state
	var new_state = states.get(new_state_name.to_lower())
	# Check if it exists
	if !new_state:
		return
	
	# If there is a current_state:
	if current_state:
		# Exit that one
		current_state.Exit()
		
	# Enter the new one
	new_state.Enter()
	
	# Set the new as the current state.
	current_state = new_state
