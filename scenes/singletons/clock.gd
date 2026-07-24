extends Node

var time_remaining := 90.0
var is_running := false
var difficulty := 0

func _add_time(time: float) -> void:
	var mult: float
	if time < 0:
		mult = [0.5, 1, 1.5][difficulty]
	else:
		mult = [2, 1.2, 0.8][difficulty]
	
	time_remaining += time * mult

func _process(delta: float) -> void:
	if is_running:
		time_remaining -= delta
