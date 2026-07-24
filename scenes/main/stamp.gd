extends Node2D

var cancel_current := false
var hold_offset := Vector2.INF
var original_offset := Vector2.INF
var is_held := false

var is_hovered := false

var offset_tween: Tween

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
		
		hold_offset = global_position - get_viewport().get_mouse_position()
		
		if original_offset.is_equal_approx(Vector2.INF):
			original_offset = hold_offset
		
		if offset_tween:
			if offset_tween.finished.is_connected(drop):
				offset_tween.finished.disconnect(drop)
			offset_tween.custom_step(1.0)
		offset_tween = create_tween()
		offset_tween.tween_property(self, "hold_offset", hold_offset + Vector2(0, -40), 0.1)
		
		is_held = true
	
	if not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and (is_held or cancel_current):
		if is_held:
			GlobalAudio.play_random("stamp")
			if offset_tween:
				if offset_tween.finished.is_connected(drop):
					offset_tween.finished.disconnect(drop)
				offset_tween.custom_step(1.0)
			offset_tween = create_tween()
			var dest := get_viewport().get_mouse_position() + original_offset
			
			dest.x = clampf(dest.x, -320, 320)
			dest.y = clampf(dest.y, -180, 180)
			
			offset_tween.tween_property(self, "global_position", dest, 0.1)
			offset_tween.finished.connect(drop.bind(dest))
		
		cancel_current = false
		hold_offset = Vector2.INF
		is_held = false
	
	if is_held:
		global_position = hold_offset + get_viewport().get_mouse_position()
		global_position.x = clampf(global_position.x, -320, 320)
		global_position.y = clampf(global_position.y, -180, 180)

func drop(dest: Vector2):
	original_offset = Vector2.INF
	MailManager.emit_signal("stamp", dest)
