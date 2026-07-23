@tool
extends Area2D

@onready var shape := RectangleShape2D.new()

@export var mail: Mail:
	set(value):
		mail = value
		if is_inside_tree():
			$Sprite2D.texture = mail.sprite

var velocity := Vector2.ZERO
var is_held := false
var is_hovered := false

var is_moved := false
var is_stamped := false

var can_stamp := false

func _ready() -> void:
	if mail and mail.sprite:
		$Sprite2D.texture = mail.sprite
		shape.size = mail.sprite.get_size()
		$CollisionShape2D.shape = shape
	
	MailManager.stamp.connect(_stamp)

func _stamp(pos: Vector2) -> void:
	if not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and can_stamp and not is_stamped:
		var stamp := Sprite2D.new()
		stamp.texture = preload("res://assets/texture/yaystamp.png")
		add_child(stamp)
		stamp.global_position = pos
		is_stamped = true
		Clock.time_remaining += mail.score

func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		return
	
	if not is_held:
		position += velocity / delta
		velocity *= 0.5
		position.x = clampf(position.x, -320, 320)
		position.y = clampf(position.y, -180, 180)
	
	if MailManager.use_stamp:
		if _is_stamping() and not MailManager.stamping_mails.has(self):
			MailManager.stamping_mails.append(self)
		if not _is_stamping():
			MailManager.stamping_mails.erase(self)

func _is_stamping() -> bool:
	return get_overlapping_areas().any(
		func(a: Area2D) -> bool: 
			return a.name == &"Stamp"
			)

func _on_mouse_entered() -> void:
	is_hovered = true
	if MailManager and not MailManager.hovered_mails.has(self):
		MailManager.hovered_mails.append(self)

func _on_mouse_exited() -> void:
	is_hovered = false
	if MailManager:
		MailManager.hovered_mails.erase(self)
