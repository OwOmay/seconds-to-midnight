extends Control

var cancel_current := false
var hold_offset := Vector2.INF
var is_held := false

var is_hovered := false

func _on_mouse_entered() -> void:
	is_hovered = true

func _on_mouse_exited() -> void:
	is_hovered = false

func _process(_delta: float) -> void:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and not (is_held or cancel_current):
		if not is_hovered:
			cancel_current = true
			return
		hold_offset = position - get_viewport().get_mouse_position()
		is_held = true
		Coordination.stamping = true
		mouse_filter = Control.MOUSE_FILTER_IGNORE
		$TextureRect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	if not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and (is_held or cancel_current):
		cancel_current = false
		hold_offset = Vector2.INF
		is_held = false
		Coordination.stamping = false
		Coordination.stamp_pos = Vector2.INF
		mouse_filter = Control.MOUSE_FILTER_PASS
		$TextureRect.mouse_filter = Control.MOUSE_FILTER_PASS
	
	if is_held:
		position = hold_offset + get_viewport().get_mouse_position()
		Coordination.stamp_pos = global_position
