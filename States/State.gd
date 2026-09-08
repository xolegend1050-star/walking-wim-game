extends Node
class_name State
# Every state has these functions, but does things differently in their respected file.
signal Transitioned

func Enter():
	pass
	
func Exit():
	pass
	
func Update(_delta: float):
	pass
	
func Physics_Update(_delta: float):
	pass
	
