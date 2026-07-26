class_name Pool
extends Resource

@export var mails: Array[Mail]

func num_good() -> int:
	return mails.reduce(func(accum, mail): return accum + (1 if mail.score > 0 else 0), 0)

func pick() -> Mail:
	randomize()
	if mails.size() == 0:
		return
	return mails[randi() % mails.size()]
