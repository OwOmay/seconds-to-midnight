extends Node2D

@onready var mail_container := $Mails
@onready var mail_first := $Mails/first

var phase := 0

func _ready() -> void:
	_spawn_mail()
	Clock.is_running = true
	
	GlobalAudio.music_normal()

func _get_unmoved() -> Array[Node2D]:
	var unmoved: Array[Node2D] = []
	for mail in mail_container.get_children():
		if mail != mail_first:
			if not mail.is_moved:
				unmoved.append(mail)
	return unmoved

func _spawn_mail(is_retry := false) -> void:
	var mail: Mail = preload("res://data/main.tres").pick(phase)
	if mail:
		GlobalAudio.play_random("drop")
		
		var mail_node: Node2D = preload("res://scenes/main/mail.tscn").instantiate()
		
		mail_node.mail = mail
		mail_first.add_sibling(mail_node)
		mail_node.position = Vector2(-194, -276)
		
		var pos_tween = mail_node.create_tween()
		pos_tween.set_ease(Tween.EASE_OUT)
		pos_tween.set_trans(Tween.TRANS_CIRC)
		pos_tween.tween_property(mail_node, "position", Vector2(-194, -4), 0.75)
		pos_tween.tween_property(mail_node, "is_intro", false, 0)
		
		for unit in _get_unmoved():
			unit.position.y += 32
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
	_spawn_mail()
