extends Area2D

enum HAND_MODE { OPEN, POINT, GRAPPLE }

var hand_mode := HAND_MODE.OPEN

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN
	Clock.bust.connect(_on_pop)

func _on_pop() -> void:
	await get_tree().create_timer(2.5).timeout
	$AnimatedSprite2D.hide()
	$AnimatedSprite2D2.show()
	$AnimatedSprite2D2.play()

func _process(_delta: float) -> void:
	$AnimatedSprite2D.frame = floori(Clock.get_time() / 90.0 * 24.0) % 24
	
	position = get_viewport().get_mouse_position() - Vector2(320, 180)
	position.x = clampf(position.x, -280, 272)
	position.y = clampf(position.y, -129, 143)
	
	Coordination.mouse_pos = position + Vector2(320, 180)
	
	var p_hand_mode := hand_mode
	
	if MailManager.held_mail != null or MailManager.is_stamping:
		hand_mode = HAND_MODE.GRAPPLE
	elif MailManager.hovered_mails.size() > 0 or MailManager.use_stamp:
		hand_mode = HAND_MODE.POINT
	else:
		hand_mode = HAND_MODE.OPEN
	
	if hand_mode != p_hand_mode:
		match hand_mode:
			HAND_MODE.OPEN:
				$HandOpen.show()
				$HandPoint.hide()
				$HandGrapple.hide()
			HAND_MODE.POINT:
				$HandOpen.hide()
				$HandPoint.show()
				$HandGrapple.hide()
			HAND_MODE.GRAPPLE:
				$HandOpen.hide()
				$HandPoint.hide()
				$HandGrapple.show()
