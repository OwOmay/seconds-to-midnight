extends Control

var is_hovered := false

func _on_mouse_entered() -> void:
	is_hovered = true

func _on_mouse_exited() -> void:
	is_hovered = false

func _process(_delta: float) -> void:
	if Coordination.held_mail != null and not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and is_hovered:
		Coordination.held_mail.queue_free()
		Coordination.held_mail = null
