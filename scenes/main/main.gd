extends Control

@onready var mail_container := $Mails
@onready var mail_first := $Mails/first

func _ready() -> void:
	for i in 5:
		_spawn_mail(randi() % 2 == 0)

func _get_unmoved() -> Array[Control]:
	var unmoved: Array[Control] = []
	for mail in mail_container.get_children():
		if mail != mail_first:
			if not mail.is_moved:
				unmoved.append(mail)
	return unmoved

func _spawn_mail(is_good: bool) -> void:
	var mail: Control = preload("res://scenes/main/mail.tscn").instantiate()
	mail.get_child(0).texture = [preload("res://assets/mini/bad.png"), preload("res://assets/mini/good.png")][1 if is_good else 0]
	mail.score = [-5, 5][1 if is_good else 0]
	mail_first.add_sibling(mail)
	mail.position = Vector2(34, 12)
	
	for unit in _get_unmoved():
		unit.position.y += 32

func _process(_delta: float) -> void:
	$Label.text = "remaining time: %s" % Clock.time_remaining
