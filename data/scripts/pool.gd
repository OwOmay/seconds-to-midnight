class_name Pool
extends Resource

@export var mails: Array[Mail]

func pick() -> Mail:
	if mails.size() == 0:
		return
	return mails[randi() % mails.size()]
