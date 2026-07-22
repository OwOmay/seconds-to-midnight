extends Control

@export var score := 0.0

var cancel_current := false
var hold_offset := Vector2.INF
var is_held := false
var is_moved := false

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
		is_moved = true
		Coordination.held_mail = self
		mouse_filter = Control.MOUSE_FILTER_IGNORE
		$TextureRect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	if not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and (is_held or cancel_current):
		cancel_current = false
		hold_offset = Vector2.INF
		is_held = false
		Coordination.held_mail = null
		mouse_filter = Control.MOUSE_FILTER_PASS
		$TextureRect.mouse_filter = Control.MOUSE_FILTER_PASS
	
	if is_held:
		position = hold_offset + get_viewport().get_mouse_position()
	
	if Coordination.stamping and not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and is_hovered:
		var stamp := TextureRect.new()
		stamp.texture = preload("res://assets/mini/yaystamp.png")
		stamp.mouse_filter = Control.MOUSE_FILTER_IGNORE
		add_child(stamp)
		stamp.global_position = Coordination.stamp_pos
		
		Clock.time_remaining += score
