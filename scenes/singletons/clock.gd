extends Node

var time_remaining := 90.0
var is_running := false
var difficulty := 0

func _process(delta: float) -> void:
	if is_running:
		time_remaining -= delta
