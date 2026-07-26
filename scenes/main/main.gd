extends Node2D

@onready var mail_container := $Mails
@onready var mail_first := $Mails/first

@export var use_submit_drop := false

var phase := 0

var mail_picker: Sequence

func _ready() -> void:
	mail_picker = load("res://data/main.tres")
	_spawn_mail()
	
	GlobalAudio.music_normal()
	
	$Timer.wait_time = [15, 10, 8][Clock.difficulty]
	$Timer.stop()

func _get_unmoved() -> Array[Node2D]:
	var unmoved: Array[Node2D] = []
	for mail in mail_container.get_children():
		if mail != mail_first:
			if not mail.is_moved:
				unmoved.append(mail)
	return unmoved

func _spawn_mail(is_retry := false) -> void:
	var mail := mail_picker.pick(phase)
	if mail:
		GlobalAudio.play_random("drop")
		
		for unit in _get_unmoved():
			var pos_tween_mini := unit.create_tween()
			pos_tween_mini.set_ease(Tween.EASE_OUT)
			pos_tween_mini.set_trans(Tween.TRANS_CIRC)
			pos_tween_mini.tween_property(unit, "position", unit.position + Vector2(0, 32), 0.75)
		
		var mail_node: Node2D = preload("res://scenes/main/mail.tscn").instantiate()
		
		mail_node.mail = mail
		mail_first.add_sibling(mail_node)
		mail_node.position = Vector2(-194, -276)
		
		var pos_tween := mail_node.create_tween()
		pos_tween.set_ease(Tween.EASE_OUT)
		pos_tween.set_trans(Tween.TRANS_CIRC)
		pos_tween.tween_property(mail_node, "position", Vector2(-194, -4), 0.75)
		pos_tween.tween_property(mail_node, "is_intro", false, 0)
	elif not is_retry:
		phase += 1
		_spawn_mail(true)

func _process(_delta: float) -> void:
	$Label.text = "remaining time: %s" % Clock.time_remaining
	
	if Clock.time_remaining < 15 and GlobalAudio.is_music_normal:
		GlobalAudio.music_frantic()
	elif Clock.time_remaining > 15 and not GlobalAudio.is_music_normal:
		GlobalAudio.music_normal()
	
	if Clock.time_remaining < 0:
		get_tree().paused = true
		GlobalAudio.music_stop()
		GlobalAudio.play("boom")
		await get_tree().create_timer(5.5).timeout
		get_tree().paused = false
		get_tree().change_scene_to_file("res://scenes/menu/end.tscn")

func _on_timer_timeout() -> void:
	if not use_submit_drop:
		_spawn_mail()

func mail_finished() -> void:
	if use_submit_drop:
		_spawn_mail()
