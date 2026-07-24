extends Node2D

@onready var mail_container := $Mails
@onready var mail_first := $Mails/first

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

func _spawn_mail() -> void:
	var mail: Mail = preload("res://data/main.tres").pick(0)
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

func _process(_delta: float) -> void:
	$Label.text = "remaining time: %s" % Clock.time_remaining
	
	if Clock.time_remaining < 30 and GlobalAudio.is_music_normal:
		GlobalAudio.music_frantic()
	elif Clock.time_remaining > 30 and not GlobalAudio.is_music_normal:
		GlobalAudio.music_normal()

func _on_timer_timeout() -> void:
	_spawn_mail()
