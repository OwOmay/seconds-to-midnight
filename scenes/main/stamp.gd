extends Area2D

var cancel_current := false
var hold_offset := Vector2.INF
var original_offset := Vector2.INF
var is_held := false

var ink := 2.0

var is_hovered := false

var offset_tween: Tween

func _ready() -> void:
	MailManager.stamp_success.connect(func(): ink -= 1.0)

func _on_mouse_entered() -> void:
	is_hovered = true
	MailManager.use_stamp = true

func _on_mouse_exited() -> void:
	is_hovered = false
	MailManager.use_stamp = false

func _process(_delta: float) -> void:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and not (is_held or cancel_current):
		if not is_hovered:
			cancel_current = true
			return
		GlobalAudio.play_random("stamp")
		
		is_held = true
		
		if offset_tween and offset_tween.is_running():
			offset_tween.custom_step(1.0)
		
		hold_offset = global_position - get_viewport().get_mouse_position()
		
		original_offset = hold_offset
		
		offset_tween = create_tween()
		offset_tween.tween_property($Stamp, "position", Vector2(0, -40), 0.1)
	
	if not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and (is_held or cancel_current):
		if is_held:
			GlobalAudio.play_random("stamp")
			
			if offset_tween and offset_tween.is_running():
				offset_tween.custom_step(1.0)
				
			offset_tween = create_tween()
			var dest := get_viewport().get_mouse_position() + original_offset
			
			dest.x = clampf(dest.x, -320, 320)
			dest.y = clampf(dest.y, -180, 180)
			
			offset_tween.tween_property($Stamp, "position", Vector2.ZERO, 0.1)
			
			offset_tween.finished.connect(func():
				for area in get_overlapping_areas():
					if area.name == &"Inkpad":
						ink = 2.0
				if ink > 0.1:
					MailManager.stamp.emit(dest + Vector2(0, 32))
				)
		
		cancel_current = false
		hold_offset = Vector2.INF
		original_offset = Vector2.INF
		is_held = false
	
	if is_held:
		global_position = hold_offset + get_viewport().get_mouse_position()
		global_position.x = clampf(global_position.x, -320, 320)
		global_position.y = clampf(global_position.y, -180, 180)
	
	$StampShadow.modulate.a = 0.8 - $Stamp.position.y / -80
