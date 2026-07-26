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
		# employee number four-two-seven
		if is_equal_approx(time, 427):
			$"../Main".win_game.emit()
		
		var mult: float
		if time < 0:
			mult = [0.5, 1, 1.5][difficulty]
		else:
			mult = [2.2, 1.4, 0.8][difficulty]
		
		var temp_tween := create_tween()
		temp_tween.tween_property(self, "temp_time", time * mult, 1.0)
		temp_tween.tween_callback(func():
			time_remaining += temp_time
			temp_time = 0
			if is_running:
				time_remaining = clampf(time_remaining, -1, 80)
			)
	else:
		is_running = false
		var clock_tween := create_tween()
		clock_tween.tween_property(self, "time_remaining", 900, 2.5)
		bust.emit()

func _process(delta: float) -> void:
	if is_running:
		time_remaining -= delta
