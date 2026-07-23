extends Node2D

@onready var mail_container := $Mails
@onready var mail_first := $Mails/first

func _ready() -> void:
	_spawn_mail()

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
		var mail_node: Node2D = preload("res://scenes/main/mail.tscn").instantiate()
		
		mail_node.mail = mail
		mail_first.add_sibling(mail_node)
		mail_node.position = Vector2(-196, -22)
		
		for unit in _get_unmoved():
			unit.position.y += 32

func _process(_delta: float) -> void:
	$Label.text = "remaining time: %s" % Clock.time_remaining

func _on_timer_timeout() -> void:
	_spawn_mail()
