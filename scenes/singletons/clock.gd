extends Node

var time_remaining := 90.0
var is_running := true

func _process(delta: float) -> void:
	time_remaining -= delta
