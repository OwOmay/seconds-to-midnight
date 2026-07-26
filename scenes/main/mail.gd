@tool
extends Area2D

#@onready var shape := RectangleShape2D.new()

@export var mail: Mail:
	set(value):
		mail = value
		if is_inside_tree() and mail:
			$Sprite2D.texture = [preload("res://assets/texture/News_Base_1.webp"), preload("res://assets/texture/News_Base_2.webp"), preload("res://assets/texture/News_Base_3.webp")][randi() % 3]
			$Sprite2D2.texture = mail.sprite

var velocity := Vector2.ZERO
var is_held := false
var is_hovered := false
var is_intro := false

var is_moved := false
var is_stamped := false

var bin_can_delete := true

func _ready() -> void:
	if mail and mail.sprite:
		$Sprite2D.texture = [preload("res://assets/texture/News_Base_1.webp"), preload("res://assets/texture/News_Base_2.webp"), preload("res://assets/texture/News_Base_3.webp")][randi() % 3]
		
		$Sprite2D2.texture = mail.sprite
		#shape.size = mail.sprite.get_size()
		#$CollisionShape2D.shape = shape
		
		$top_particles.emission_rect_extents = Vector2(mail.sprite.get_width() * 0.5, 1.0)
		$top_particles.position.y = -mail.sprite.get_height() * 0.5
		$right_particles.emission_rect_extents = Vector2(1.0, mail.sprite.get_height() * 0.5)
		$right_particles.position.x = mail.sprite.get_width() * 0.5
		$bottom_particles.emission_rect_extents = Vector2(mail.sprite.get_width() * 0.5, 1.0)
		$bottom_particles.position.y = mail.sprite.get_height() * 0.5
		$left_particles.emission_rect_extents = Vector2(1.0, mail.sprite.get_height() * 0.5)
		$left_particles.position.x = -mail.sprite.get_width() * 0.5

func stamp(pos: Vector2) -> void:
	if not is_stamped:
		var stamp_sprite := Sprite2D.new()
		stamp_sprite.texture = preload("res://assets/texture/Stamp_Mark.png")
		add_child(stamp_sprite)
		stamp_sprite.global_position = pos
		is_stamped = true
		Clock._add_time(mail.score)
		
		var fadeout_tween := create_tween()
		bin_can_delete = false
		if $"../../Bin".checking.has(self):
			$"../../Bin".checking.erase(self)
		if $"../../Bin".deleting_nodes.has(self):
			$"../../Bin".deleting_nodes[self].kill()
			$"../../Bin".deleting_nodes.erase(self)
		fadeout_tween.tween_interval(1.0)
		fadeout_tween.tween_property(self, "modulate", Color(1, 1, 1, 0), 1.5)
		fadeout_tween.tween_callback(func():
			if MailManager.held_mail == self:
				MailManager.held_mail = null
			if MailManager.hovered_mails.has(self):
				MailManager.hovered_mails.erase(self)
			if MailManager.stamping_mails.has(self):
				MailManager.stamping_mails.erase(self))
		fadeout_tween.tween_property(Clock, "is_running", true, 0)
		fadeout_tween.tween_callback($"../../Timer".start)
		fadeout_tween.tween_callback($"../..".mail_finished)
		fadeout_tween.tween_callback(queue_free)
		
		MailManager.stamp_success.emit()

func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		return
	
	if not is_held and not is_intro:
		position += velocity * 40
		velocity *= 0.8
		position.x = clampf(position.x, -320, 320)
		position.y = clampf(position.y, -20, 180)
	
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

func release_particles() -> void:
	$top_particles.restart()
	$right_particles.restart()
	$bottom_particles.restart()
	$left_particles.restart() 

func _on_area_entered(area: Area2D) -> void:
	if area.name == &"Hand":
		is_hovered = true
		if not MailManager.hovered_mails.has(self):
			MailManager.hovered_mails.append(self)

func _on_area_exited(area: Area2D) -> void:
	if area.name == &"Hand":
		is_hovered = false
		MailManager.hovered_mails.erase(self)
