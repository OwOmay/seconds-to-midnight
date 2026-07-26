extends Node

var time_remaining := 30.0
var is_running := false
var difficulty := 0

signal bust

func _add_time(time: float) -> void:
	if not is_equal_approx(time, 999):
		if is_equal_approx(time, 123):
			time = randf() * 20 - 10
		
		var mult: float
		if time < 0:
			mult = [0.5, 1, 1.5][difficulty]
		else:
			mult = [2.2, 1.4, 0.8][difficulty]
		
		time_remaining += time * mult
	else:
		is_running = false
		var clock_tween := create_tween()
		clock_tween.tween_property(self, "time_remaining", 10000, 3.5)
		bust.emit()

func _process(delta: float) -> void:
	if is_running:
		time_remaining -= delta
