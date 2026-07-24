extends Node

var hovered_mails: Array[Area2D] = []
var stamping_mails: Array[Area2D] = []
var held_mail: Node2D
var hold_offset := Vector2.ZERO

var use_stamp := false

@warning_ignore("unused_signal")
signal stamp(pos: Vector2)

@warning_ignore("unused_signal")
signal stamp_success

func _ready() -> void:
	stamp.connect(_on_stamp)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed and not use_stamp:
			_pickup_mail(event.position)
		else:
			_drop_mail()

func _pickup_mail(mouse_pos: Vector2) -> void:
	if hovered_mails.is_empty():
		return
	
	GlobalAudio.play_random("flip")
	
	hovered_mails.sort_custom(func(a: Node2D, b: Node2D) -> bool:
		if a.z_index != b.z_index:
			return a.z_index > b.z_index
		return a.get_index() > b.get_index()
	)
	
	held_mail = hovered_mails[0]
	hold_offset = held_mail.global_position - mouse_pos
	
	held_mail.is_held = true
	held_mail.is_moved = true
	
	held_mail.get_parent().move_child(held_mail, -1)
	
	Coordination.held_mail = held_mail

func _drop_mail() -> void:
	if held_mail:
		GlobalAudio.play_random("flip")
		
		held_mail.release_particles()
		
		held_mail.is_held = false
		held_mail.z_index = 0
		held_mail = null
		Coordination.held_mail = null

func _process(delta: float) -> void:
	if held_mail and is_instance_valid(held_mail):
		if held_mail.is_inside_tree():
			var mouse_pos := held_mail.get_viewport().get_mouse_position()
			var target_pos := mouse_pos + hold_offset
			
			held_mail.velocity = held_mail.velocity.lerp((target_pos - held_mail.global_position) * delta, 0.2)
			
			held_mail.global_position = target_pos
			held_mail.global_position.x = clampf(held_mail.global_position.x, -320, 320)
			held_mail.global_position.y = clampf(held_mail.global_position.y, -20, 180)

func _on_stamp(pos: Vector2):
	if not stamping_mails.is_empty():
		stamping_mails.sort_custom(func(a: Node2D, b: Node2D) -> bool:
			if a.z_index != b.z_index:
				return a.z_index > b.z_index
			return a.get_index() > b.get_index()
		)
		stamping_mails[0].stamp(pos)
