extends Control

func _ready() -> void:
	if OS.get_name() == "Web":
		$CenterContainer/VBoxContainer/quit.hide()

func _on_play_pressed() -> void:
	$play.show()

func _on_play_back_pressed() -> void:
	$play.hide()

func _on_settings_pressed() -> void:
	$settings.show()

func _on_settings_back_pressed() -> void:
	$settings.hide()

func _on_credits_pressed() -> void:
	$credits.show()

func _on_credits_back_pressed() -> void:
	$credits.hide()

func _on_quit_pressed() -> void:
	await get_tree().create_timer(0.5).timeout
	get_tree().quit()

func _on_easy_mouse_entered() -> void:
	$play/Label.text = "the clock gives you more time, and good news is more effective."

func _on_easy_mouse_exited() -> void:
	$play/Label.text = ""

func _on_normal_mouse_entered() -> void:
	$play/Label.text = "the intended level of difficulty."

func _on_normal_mouse_exited() -> void:
	$play/Label.text = ""

func _on_hard_mouse_entered() -> void:
	$play/Label.text = "the clock has less time, with penalties increased and rewards decreased."

func _on_hard_mouse_exited() -> void:
	$play/Label.text = ""

func _load_game(difficulty: int) -> void:
	Clock.time_remaining = [60, 45, 30][difficulty]
	Clock.difficulty = difficulty
	
	get_tree().change_scene_to_file("res://scenes/main/main.tscn")

func _on_credits_meta_clicked(meta: Variant) -> void:
	OS.shell_open(str(meta))
