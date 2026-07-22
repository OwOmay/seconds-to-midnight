@tool
extends Area2D

@onready var shape := RectangleShape2D.new()

@export var score := 0.0
@export var area := Vector2.ZERO:
	set(new_area):
		area = new_area
		if shape:
			shape.size = area
		if $CPUParticles2D:
			$CPUParticles2D.emission_rect_extents = area / 2

var is_clicked := false
var is_hovered := false

func _ready() -> void:
	shape.size = area
	$CollisionShape2D.shape = shape

func _mouse_enter() -> void:
	is_hovered = true

func _mouse_exit() -> void:
	is_hovered = false

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if is_hovered and not is_clicked:
				is_clicked = true
				Clock.time_remaining += score
				$CPUParticles2D.restart()
