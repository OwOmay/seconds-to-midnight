extends Node2D

@export var pages: Array[Node2D] = []

var page := 0

func _ready() -> void:
	_show_page()

func _process(delta: float) -> void:
	Clock.time_remaining -= delta
	$Label.text = "time remaining: %s" % int(Clock.time_remaining) 

func _show_page() -> void:
	for page_sprite in pages:
		page_sprite.hide()
	pages[page].show()

func _on_next_button_pressed() -> void:
	page = clampi(page + 1, 0, pages.size() - 1)
	_show_page()

func _on_prev_button_pressed() -> void:
	page = clampi(page - 1, 0, pages.size() - 1)
	_show_page()
