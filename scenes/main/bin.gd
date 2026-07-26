extends Area2D

var deleting_nodes: Dictionary[Area2D, Tween] = {}
var checking: Array[Area2D] = []

func has_antibin(a: Area2D):
	return a.name == &"Antibin"

func _process(_delta: float) -> void:
	for area in checking:
		if not area.get_overlapping_areas().any(has_antibin):
			_check_area(area)

func _on_area_entered(area: Area2D) -> void:
	if area.get_overlapping_areas().any(has_antibin):
		checking.append(area)
		return
	_check_area(area)

func _check_area(area: Area2D) -> void:
	if "mail" in area and not deleting_nodes.has(area):
		if area.bin_can_delete and not is_equal_approx(area.mail.score, 999):
			var tween := create_tween()
			tween.set_trans(Tween.TRANS_CUBIC)
			deleting_nodes[area] = tween
			
			tween.tween_property(area, "modulate", Color(1, 1, 1, 0), 0.75)
			
			tween.finished.connect(_on_deletion_finished.bind(area))

func _on_area_exited(area: Area2D) -> void:
	if checking.has(area):
		checking.erase(area)
	
	if deleting_nodes.has(area):
		var tween: Tween = deleting_nodes[area]
		deleting_nodes.erase(area)
		
		if tween and tween.is_running():
			tween.kill()
		
		if is_instance_valid(area):
			area.modulate = Color(1, 1, 1, 1)

func _on_deletion_finished(area: Area2D) -> void:
	if deleting_nodes.has(area):
		Clock.is_running = true
		$"../Timer".start()
		$"..".mail_finished()
		deleting_nodes.erase(area)
		
		GlobalAudio.play_random("crumple")
		
		MailManager.hovered_mails.erase(area)
		MailManager.stamping_mails.erase(area)
		if MailManager.held_mail == area:
			MailManager.held_mail = null
			
		if is_instance_valid(area):
			area.queue_free()
