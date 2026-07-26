extends Node

var time_remaining := 30.0
var temp_time := 0.0
var is_running := false
var difficulty := 0

signal bust

func get_time() -> float:
	return time_remaining + temp_time

func _add_time(time: float) -> void:
	if not is_equal_approx(time, 999):
		if is_equal_approx(time, 123):
			time = randf() * 20 - 10
		
		var mult: float
		if time < 0:
			mult = [0.5, 1, 1.5][difficulty]
		else:
			mult = [3, 2, 1][difficulty]
		
		var temp_tween := create_tween()
		temp_tween.set_ease(Tween.EASE_OUT)
		temp_tween.set_trans(Tween.TRANS_CIRC)
		temp_tween.tween_property(self, "temp_time", clampf(time_remaining + time * mult, -1, 80) - time_remaining, 1.0)
		temp_tween.tween_callback(func():
			time_remaining += temp_time
			temp_time = 0
			if is_running:
				time_remaining = clampf(time_remaining, -1, 80)
			)
	else:
		is_running = false
		var clock_tween := create_tween()
		clock_tween.set_ease(Tween.EASE_IN)
		clock_tween.set_trans(Tween.TRANS_CIRC)
		clock_tween.tween_property(self, "time_remaining", 900, 2.5)
		bust.emit()

func _process(delta: float) -> void:
	if is_running:
		time_remaining -= delta
